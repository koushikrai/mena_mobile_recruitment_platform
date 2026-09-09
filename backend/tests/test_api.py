import pytest
from httpx import AsyncClient, ASGITransport
from app.main import app

@pytest.mark.asyncio
async def test_health_endpoints():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        res = await client.get("/")
        assert res.status_code == 200
        data = res.json()
        assert data["status"] == "online"
        assert "MENA" in data["platform"]

        res_health = await client.get("/health")
        assert res_health.status_code == 200
        assert res_health.json()["status"] == "healthy"

@pytest.mark.asyncio
async def test_mrz_verify_api():
    transport = ASGITransport(app=app)
    async with AsyncClient(transport=transport, base_url="http://test") as client:
        payload = {
            "mrz_raw_line1": "P<EGYMANSOOR<<AHMED<<<<<<<<<<<<<<<<<<<<<<<<<",
            "mrz_raw_line2": "N8492014<8EGY9104225M2903091<<<<<<<<<<<<<<<2"
        }
        res = await client.post("/api/v1/vault/mrz/verify", json=payload)
        assert res.status_code == 200
        data = res.json()
        assert data["is_valid"] is True
        assert data["passport_number"] == "N8492014"
        assert data["surname"] == "MANSOOR"
        assert data["given_names"] == "AHMED"
        assert data["issuing_country"] == "EGY"
        assert data["has_six_months_validity"] is True
