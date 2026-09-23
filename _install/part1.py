#!/usr/bin/env python
import ast

existing_path = r'C:\Projects\GarudaOS\ProjectAirSim\sim\pas_link.py'
with open(existing_path) as f:
 existing = f.read()

lines = []
def li(indent, content):
 lines.append(' ' * (indent * 4) + content)

li(0, '')
li(0, 'class ProjectAirSimLink:')
li(1, '"""Bridge: DroneOS arbiter <-> ProjectAirSim Runtime."""')
li(0, '')
li(1, 'def __init__(self, address="127.0.0.1", port_topics=8989, port_services=8990,')
li(2, 'drone_name="Drone1", scene_config="scene_test_drone.jsonc", config_dir=None):')
for s in ['self.address = address', 'self.port_topics = port_topics',
 'self.port_services = port_services', 'self.drone_name = drone_name',
 'self.scene_config = scene_config', 'self.config_dir = config_dir',
 'self.state = LinkState.DISCONNECTED', 'self.telemetry = TelemetryState()',
 'self._streaming = False', 'self._last_setpoint_ts = 0.0',
 'self._client = None', 'self._world = None', 'self._drone = None',
 'self._home_pos = None', 'self._last_pos = None',
 'self._last_vel = None', 'self._last_ts = 0.0']:
 li(2, s)

with open(existing_path, 'w') as f:
 f.write(existing + chr(10).join(lines) + chr(10))
print('Part 1 appended')
