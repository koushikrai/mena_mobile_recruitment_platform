import json
import logging
from datetime import datetime
from typing import Optional
from uuid import UUID
from fastapi import APIRouter, WebSocket, WebSocketDisconnect, Query
from jose import JWTError, jwt

from app.config import settings
from app.core.realtime import manager

logger = logging.getLogger("ws")
router = APIRouter(tags=["Realtime WebSockets"])


def get_user_id_from_token(token: Optional[str]) -> Optional[str]:
    if not token:
        return None
    try:
        # Strip 'Bearer ' if passed in query param
        clean_token = token.replace("Bearer ", "").strip()
        payload = jwt.decode(clean_token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        user_id = payload.get("sub")
        return str(user_id) if user_id else None
    except (JWTError, Exception) as e:
        logger.debug(f"Invalid token for WebSocket connection: {e}")
        return None


@router.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket,
    token: Optional[str] = Query(None)
):
    user_id = get_user_id_from_token(token)
    await manager.connect(websocket, user_id=user_id)

    # Send initial welcome / connection ack
    await manager.send_personal_message(
        {
            "event": "connection_established",
            "timestamp": datetime.utcnow().isoformat(),
            "data": {
                "status": "connected",
                "authenticated": user_id is not None,
                "user_id": user_id,
                "server_time": datetime.utcnow().isoformat(),
            }
        },
        websocket
    )

    try:
        while True:
            text = await websocket.receive_text()
            try:
                msg = json.loads(text)
                msg_type = msg.get("type")

                if msg_type == "ping":
                    await manager.send_personal_message(
                        {
                            "type": "pong",
                            "timestamp": datetime.utcnow().isoformat()
                        },
                        websocket
                    )

                elif msg_type == "subscribe":
                    topic = msg.get("topic")
                    if topic:
                        manager.subscribe(topic, websocket)
                        await manager.send_personal_message(
                            {
                                "event": "subscribed",
                                "topic": topic,
                                "timestamp": datetime.utcnow().isoformat()
                            },
                            websocket
                        )

                elif msg_type == "unsubscribe":
                    topic = msg.get("topic")
                    if topic:
                        manager.unsubscribe(topic, websocket)
                        await manager.send_personal_message(
                            {
                                "event": "unsubscribed",
                                "topic": topic,
                                "timestamp": datetime.utcnow().isoformat()
                            },
                            websocket
                        )

            except json.JSONDecodeError:
                # Non-JSON heartbeat or text
                if text == "ping":
                    await websocket.send_text("pong")

    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id=user_id)
        logger.info(f"WebSocket cleanly closed for user: {user_id or 'anonymous'}")
    except Exception as e:
        logger.error(f"WebSocket error: {e}")
        manager.disconnect(websocket, user_id=user_id)
