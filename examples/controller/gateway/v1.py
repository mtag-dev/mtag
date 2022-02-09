import asyncio
from squall import Router, WebSocket
import orjson


class FanOut:
    def __init__(self):
        self.clients = set()

    def join(self, ws):
        self.clients.add(ws)

    def left(self, ws):
        self.clients.discard(ws)

    async def send(self, message):
        await asyncio.gather(*[ws.send_text(message) for ws in self.clients])


fanout = FanOut()
router = Router(prefix="/v1", tags=["Gateway"])


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    fanout.join(websocket)

    commands = []
    with open("/app/config.example.json") as fh:
        data = orjson.loads(fh.read())
        for service in data.get('services', []):
            commands.append({
                "type": "service",
                "command": "add",
                "data": service
            })

        if authentication := data.get('authentication', {}):
            commands.append({
                "type": "authentication",
                "command": "add",
                "data": authentication
            })

    await websocket.send_text(
        orjson.dumps({
            "data": commands
        }).decode('utf-8')
    )

    try:
        while True:
            data = await websocket.receive_text()
            await websocket.send_text(f"Message text was: {data}")
    except Exception:
        fanout.left(websocket)
