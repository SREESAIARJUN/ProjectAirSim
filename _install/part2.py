#!/usr/bin/env python
import ast

existing_path = r'C:\Projects\GarudaOS\ProjectAirSim\sim\pas_link.py'
with open(existing_path) as f:
 existing = f.read()

lines = []
def li(i, c): lines.append(' ' * (i * 4) + c)

li(0, '')
li(1, 'def connect(self, timeout_s=15.0):')
li(2, 't0 = time.monotonic()')
li(2, 'self.state = LinkState.CONNECTING')
li(2, 'while time.monotonic() - t0 < timeout_s:')
li(3, 'try:')
li(4, 'self._client = pas.ProjectAirSimClient(')
li(5, 'address=self.address,')
li(5, 'port_topics=self.port_topics,')
li(5, 'port_services=self.port_services,')
li(4, ')')
li(4, 'self._client.connect()')
li(4, 'break')
li(3, 'except Exception:')
li(4, 'time.sleep(0.5)')
li(2, 'else:')
li(3, 'self.state = LinkState.ERROR')
li(3, 'return False')
li(2, 'cfg = self.scene_config')
li(2, 'if self.config_dir:')
li(3, 'cfg = os.path.join(self.config_dir, self.scene_config)')
li(2, 'self._world = pas.World(self._client, cfg, 1)')
li(2, 'self._drone = pas.Drone(self._client, self._world, self.drone_name)')
li(2, 't_pose = time.monotonic()')
li(2, 'while time.monotonic() - t_pose < 10.0:')
li(3, 'try:')
li(4, 'pose = self._drone.get_ground_truth_pose("NED")')
li(4, 'if pose:')
li(5, 'self._home_pos = pose["position"]')
li(5, 'self._last_pos = pose["position"]')
li(5, 'self.telemetry.position_valid = True')
li(5, 'self.telemetry.landed_valid = True')
li(5, 'self.telemetry.ekf_degraded = False')
li(5, 'break')
li(4, 'except Exception:')
li(5, 'pass')
li(4, 'time.sleep(0.2)')
li(2, 'self.state = LinkState.CONNECTED')
li(2, 'return True')

with open(existing_path, 'w') as f:
 f.write(existing + chr(10).join(lines) + chr(10))
ast.parse(open(existing_path).read())
print('Part 2 OK')
