import pytest
from httpx import AsyncClient, ASGITransport
from fastapi.testclient import TestClient
from app.main import app
from app.core.realtime import manager
from app.core.security import create_access_token

def test_health_db():
    client = TestClient(app)
    response = client.get("/health/db")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] in ["healthy", "degraded"]
    assert "latency_ms" in data

def test_websocket_ping_pong():
    client = TestClient(app)
    with client.websocket_connect("/api/v1/ws") as websocket:
        # Check welcome connection_established
        welcome = websocket.receive_json()
        assert welcome["event"] == "connection_established"
        assert welcome["data"]["status"] == "connected"

        # Send ping
        websocket.send_json({"type": "ping"})
        response = websocket.receive_json()
        assert response["type"] == "pong"

def test_websocket_topic_subscription():
    client = TestClient(app)
    with client.websocket_connect("/api/v1/ws") as websocket:
        _ = websocket.receive_json()

        # Subscribe to topic:walkin_drives
        websocket.send_json({"type": "subscribe", "topic": "topic:walkin_drives"})
        sub_ack = websocket.receive_json()
        assert sub_ack["event"] == "subscribed"
        assert sub_ack["topic"] == "topic:walkin_drives"

def test_websocket_auth_handshake():
    token = create_access_token({"sub": "d3b07384-d113-4567-b89a-1234567890ab", "role": "candidate"})
    client = TestClient(app)
    with client.websocket_connect(f"/api/v1/ws?token={token}") as websocket:
        welcome = websocket.receive_json()
        assert welcome["event"] == "connection_established"
        assert welcome["data"]["authenticated"] is True
        assert welcome["data"]["user_id"] == "d3b07384-d113-4567-b89a-1234567890ab"
