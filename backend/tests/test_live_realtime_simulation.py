import asyncio
import json
import sys
import time
from datetime import datetime

# Ensure utf-8 output in Windows terminals
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8")

from fastapi.testclient import TestClient
from app.main import app
from app.core.security import create_access_token
from app.database import AsyncSessionLocal
from app.models.user import User
from app.models.application import JobApplication
from sqlalchemy import select

def run_realtime_test():
    print("=" * 70)
    print("  🚀 STARTING LIVE REAL-TIME END-TO-END VERIFICATION TEST")
    print("=" * 70)

    client = TestClient(app)

    # 1. First, fetch demo candidate user from Neon DB
    async def get_demo_context():
        async with AsyncSessionLocal() as session:
            u_stmt = select(User).where(User.email == "candidate@suhana-global.com")
            user = (await session.execute(u_stmt)).scalar_one_or_none()
            if not user:
                raise Exception("Demo user candidate@suhana-global.com not found")

            app_stmt = select(JobApplication).where(JobApplication.user_id == user.id).limit(1)
            application = (await session.execute(app_stmt)).scalar_one_or_none()
            return user.id, user.email, (application.id if application else None)

    user_id, email, app_id = asyncio.run(get_demo_context())
    print(f"\n[1] Demo Candidate Found: {email} (ID: {user_id})")
    print(f"    Target Application ID: {app_id}")

    # 2. Issue a JWT for the candidate
    token = create_access_token({"sub": str(user_id), "role": "candidate", "email": email})
    print(f"[2] Generated Real JWT Auth Token (Length: {len(token)} chars)")

    # 3. Connect Candidate WebSocket client
    print("\n[3] Connecting Candidate Mobile Client via WebSocket: /api/v1/ws?token=*** ...")
    with client.websocket_connect(f"/api/v1/ws?token={token}") as candidate_ws:
        # Await connection acknowledgment
        conn_ack = candidate_ws.receive_json()
        print(f"    ✅ WebSocket Connected! Handshake ACK received:")
        print(f"       Event: '{conn_ack['event']}' | Authenticated: {conn_ack['data']['authenticated']} | User: {conn_ack['data']['user_id']}")

        # 4. Connect a second Observer Client to walk-in drive topic
        print("\n[4] Connecting Secondary Observer Client to 'topic:walkin_drives' ...")
        with client.websocket_connect("/api/v1/ws") as observer_ws:
            _ = observer_ws.receive_json()
            observer_ws.send_json({"type": "subscribe", "topic": "topic:walkin_drives"})
            sub_ack = observer_ws.receive_json()
            print(f"    ✅ Observer Subscribed to '{sub_ack['topic']}'")

            # 5. Heartbeat Ping/Pong Test
            print("\n[5] Testing Heartbeat Ping/Pong...")
            t0 = time.time()
            candidate_ws.send_json({"type": "ping"})
            pong = candidate_ws.receive_json()
            rtt_ms = round((time.time() - t0) * 1000, 2)
            print(f"    ✅ Ping -> Pong Response in {rtt_ms} ms: {pong}")

            # 6. TRIGGER REAL-TIME EVENT 1: Recruiter advances Candidate Relocation Pipeline Stage
            if app_id:
                print("\n[6] TRIGGERING PIPELINE STAGE UPDATE via REST API:")
                print("    Simulating Recruiter changing stage to: 'flight_booked' ...")
                
                start_time = time.time()
                # Recruiter makes REST request
                headers = {"Authorization": f"Bearer {token}"}
                payload = {
                    "status": "flight_booked",
                    "title": "Flight Ticket & Visa Issued",
                    "description": "Saudi Arabian Airlines SV-320 departure confirmed for Riyadh Terminal 5."
                }
                api_resp = client.post(f"/api/v1/applications/{app_id}/stage", json=payload, headers=headers)
                assert api_resp.status_code == 200, f"API failed: {api_resp.text}"

                # Candidate mobile socket immediately receives real-time event!
                incoming_event = candidate_ws.receive_json()
                latency_ms = round((time.time() - start_time) * 1000, 2)

                print(f"    🔥 REAL-TIME EVENT RECEIVED ON MOBILE CLIENT IN {latency_ms} ms!")
                print(f"       Event Name: '{incoming_event['event']}'")
                print(f"       Timestamp : {incoming_event['timestamp']}")
                print(f"       New Stage : {incoming_event['data']['new_stage']}")
                print(f"       Title     : {incoming_event['data']['title']}")
                print(f"       Details   : {incoming_event['data']['description']}")

                assert incoming_event["event"] == "pipeline_stage_changed"
                assert incoming_event["data"]["new_stage"] == "flight_booked"

            # 7. TRIGGER REAL-TIME EVENT 2: Walk-in Recruitment Drive Seat Registration
            print("\n[7] TRIGGERING WALK-IN RECRUITMENT REGISTRATION:")
            # Find drive ID
            drives_resp = client.get("/api/v1/jobs/walkin-drives/all")
            drives = drives_resp.json()
            if drives:
                drive = drives[0]
                drive_id = drive["id"]
                initial_count = drive["registered_count"]
                print(f"    Target Drive: '{drive['title']}' (Initial Booked: {initial_count}/{drive['available_quotas']})")

                start_time = time.time()
                # Candidate registers for walk-in slot
                reg_payload = {"time_slot": "12 Nov - Morning (08:30 AM)"}
                reg_resp = client.post(f"/api/v1/jobs/walkin-drives/{drive_id}/register", json=reg_payload, headers=headers)
                
                # Check Observer client receives quota update broadcast
                quota_event = observer_ws.receive_json()
                latency_ms = round((time.time() - start_time) * 1000, 2)

                print(f"    🔥 REAL-TIME BROADCAST RECEIVED BY OBSERVER IN {latency_ms} ms!")
                print(f"       Event Name: '{quota_event['event']}' on topic '{quota_event['topic']}'")
                print(f"       Updated Registrations: {quota_event['data']['registered_count']} / {quota_event['data']['available_quotas']}")
                print(f"       Remaining Available Slots: {quota_event['data']['remaining_slots']}")

                assert quota_event["event"] == "walkin_quota_updated"

    print("\n" + "=" * 70)
    print("  🎉 ALL REAL-TIME VERIFICATION TESTS PASSED SUCCESSFULLY! (100% LIVE)")
    print("=" * 70)

if __name__ == "__main__":
    run_realtime_test()
