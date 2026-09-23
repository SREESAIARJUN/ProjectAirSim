import websockets, asyncio, json
async def main():
 ws = await websockets.connect('ws://localhost:24563/launcher/api/v2/websocket', ping_timeout=2, close_timeout=2)
 print('Connected to Epic Launcher WebSocket')
 req = json.dumps({'type': 'INSTALL_APPLICATION', 'appName': 'UE', 'buildId': '5.5.0-0+ue.5.5.Windows'})
 await ws.send(req)
 resp = await asyncio.wait_for(ws.recv(), timeout=5)
 print('Response:', resp)
 await ws.close()
asyncio.run(main())
