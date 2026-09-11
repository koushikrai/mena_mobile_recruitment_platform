import json
import logging
from datetime import datetime
from typing import Dict, List, Set, Optional, Any
from uuid import UUID
from fastapi import WebSocket

logger = logging.getLogger("realtime")


class ConnectionManager:
    def __init__(self):
        # Map user_id -> set of active WebSockets
        self.user_connections: Dict[str, Set[WebSocket]] = {}
        # Map topic -> set of subscribed WebSockets
        self.topic_subscriptions: Dict[str, Set[WebSocket]] = {}
        # All active WebSockets
        self.all_connections: Set[WebSocket] = set()

    async def connect(self, websocket: WebSocket, user_id: Optional[str] = None):
        await websocket.accept()
        self.all_connections.add(websocket)

        if user_id:
            uid_str = str(user_id)
            if uid_str not in self.user_connections:
                self.user_connections[uid_str] = set()
            self.user_connections[uid_str].add(websocket)
            logger.info(f"User {uid_str} connected via WebSocket. Active sessions: {len(self.user_connections[uid_str])}")

        # Automatically subscribe to global broadcast topic
        self.subscribe("broadcast", websocket)
        logger.info(f"Total active WebSocket connections: {len(self.all_connections)}")

    def disconnect(self, websocket: WebSocket, user_id: Optional[str] = None):
        self.all_connections.discard(websocket)

        if user_id:
            uid_str = str(user_id)
            if uid_str in self.user_connections:
                self.user_connections[uid_str].discard(websocket)
                if not self.user_connections[uid_str]:
                    del self.user_connections[uid_str]

        # Remove from all topics
        for topic, subs in list(self.topic_subscriptions.items()):
            subs.discard(websocket)
            if not subs:
                del self.topic_subscriptions[topic]

        logger.info(f"WebSocket disconnected. Remaining total: {len(self.all_connections)}")

    def subscribe(self, topic: str, websocket: WebSocket):
        if topic not in self.topic_subscriptions:
            self.topic_subscriptions[topic] = set()
        self.topic_subscriptions[topic].add(websocket)

    def unsubscribe(self, topic: str, websocket: WebSocket):
        if topic in self.topic_subscriptions:
            self.topic_subscriptions[topic].discard(websocket)
            if not self.topic_subscriptions[topic]:
                del self.topic_subscriptions[topic]

    async def send_personal_message(self, message: dict, websocket: WebSocket):
        try:
            await websocket.send_text(json.dumps(message))
        except Exception as e:
            logger.warning(f"Error sending message to client: {e}")
            self.all_connections.discard(websocket)

    async def broadcast_to_user(self, user_id: Any, event: str, data: dict):
        uid_str = str(user_id)
        if uid_str in self.user_connections:
            payload = {
                "event": event,
                "timestamp": datetime.utcnow().isoformat(),
                "data": data,
            }
            dead_sockets = set()
            for ws in list(self.user_connections[uid_str]):
                try:
                    await ws.send_text(json.dumps(payload))
                except Exception as e:
                    logger.warning(f"Failed sending to user {uid_str} socket: {e}")
                    dead_sockets.add(ws)

            for dead in dead_sockets:
                self.disconnect(dead, uid_str)

    async def broadcast_to_topic(self, topic: str, event: str, data: dict):
        if topic in self.topic_subscriptions:
            payload = {
                "event": event,
                "topic": topic,
                "timestamp": datetime.utcnow().isoformat(),
                "data": data,
            }
            dead_sockets = set()
            for ws in list(self.topic_subscriptions[topic]):
                try:
                    await ws.send_text(json.dumps(payload))
                except Exception as e:
                    logger.warning(f"Failed sending to topic {topic} socket: {e}")
                    dead_sockets.add(ws)

            for dead in dead_sockets:
                self.disconnect(dead)

    async def broadcast_global(self, event: str, data: dict):
        await self.broadcast_to_topic("broadcast", event, data)


# Global singleton instance
manager = ConnectionManager()
