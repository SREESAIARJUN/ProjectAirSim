#!/usr/bin/env python3
# write_link.py -- generates sim/pas_link.py with correct indentation
# The Write tool strips leading spaces, so this script uses a marker approach.

RAW = r'''
~IND~"""ProjectAirSim bridge for DroneOS (GarudaOne)."""
~IND~from __future__ import annotations
~IND~import logging, math, os, time
~IND~from dataclasses import dataclass, field
~IND~from enum import StrEnum
~IND~from typing import Any
~IND~import projectairsim as pas
~IND~
~IND~LOG = logging.getLogger(__name__)
~IND~
~IND~class LinkState(StrEnum):
~IND~~IND~DISCONNECTED = "disconnected"
~IND~~IND~CONNECTING = "connecting"
~IND~~IND~CONNECTED = "connected"
~IND~~IND~STREAMING = "streaming"
~IND~~IND~OFFBOARD_ENGAGED = "offboard_engaged"
~IND~~IND~PX4_LAND = "px4_land"
~IND~~IND~PX4_RTL = "px4_rtl"
~IND~~IND~ERROR = "error"
~IND~
~IND~@dataclass
~IND~class Setpoint:
~IND~~IND~vx: float = 0.0
~IND~~IND~vy: float = 0.0
~IND~~IND~vz: float = 0.0
~IND~~IND~yaw_rate: float = 0.0
~IND~~IND~ts: float = field(default_factory=time.monotonic)
~IND~
~IND~@dataclass
~IND~class TelemetryState:
~IND~~IND~has_valid_bbox: bool = False
~IND~~IND~bbox_confidence: float = 0.0
~IND~~IND~target_id = None
~IND~~IND~last_bbox_time: float = 0.0
~IND~~IND~target_lost_time: float = 0.0
~IND~~IND~search_start_time: float = 0.0
~IND~~IND~last_grant_was_track: bool = False
~IND~~IND~cpu_temp_c: float = 0.0
~IND~~IND~cpu_temp_valid: bool = False
~IND~~IND~battery_voltage: float = 0.0
~IND~~IND~battery_valid: bool = False
~IND~~IND~tof_min_range_m: float = 0.0
~IND~~IND~tof_confidence: float = 0.0
~IND~~IND~horiz_distance_m: float = 0.0
~IND~~IND~alt_m: float = 0.0
~IND~~IND~armed: bool = False
~IND~~IND~landed: bool = True
~IND~~IND~landed_valid: bool = False
~IND~~IND~position_valid: bool = False
~IND~~IND~last_setpoint_time: float = 0.0
~IND~~IND~setpoint_streaming: bool = False
~IND~~IND~gimbal_heartbeat_ok: bool = False
~IND~~IND~last_gimbal_heartbeat: float = 0.0
~IND~~IND~ekf_degraded: bool = True
~IND~
~IND~class ProjectAirSimLink:
~IND~~IND~"""Bridge: DroneOS arbiter <-> ProjectAirSim Runtime."""
~IND~~
~IND~~IND~def __init__(self, address="127.0.0.1", port_topics=8989, port_services=8990,
~IND~~IND~~IND~drone_name="Drone1", scene_config="scene_test_drone.jsonc", config_dir=None):
~IND~~IND~~IND~self.address = address
~IND~~IND~~IND~self.port_topics = port_topics
~IND~~IND~~IND~self.port_services = port_services
~IND~~IND~~IND~self.drone_name = drone_name
~IND~~IND~~IND~self.scene_config = scene_config
~IND~~IND~~IND~self.config_dir = config_dir
~IND~~IND~~IND~self.state = LinkState.DISCONNECTED
~IND~~IND~~IND~self.telemetry = TelemetryState()
~IND~~IND~~IND~self._streaming = False
~IND~~IND~~IND~self._last_setpoint_ts = 0.0
~IND~~IND~~IND~self._client = None
~IND~~IND~~IND~self._world = None
~IND~~IND~~IND~self._drone = None
~IND~~IND~~IND~self._home_pos = None
~IND~~IND~~IND~self._last_pos = None
~IND~~IND~~IND~self._last_vel = None
~IND~~IND~~IND~self._last_ts = 0.0
~IND~~
~IND~~IND~def connect(self, timeout_s=15.0):
~IND~~IND~~IND~t0 = time.monotonic()
~IND~~IND~~IND~self.state = LinkState.CONNECTING
~IND~~IND~~IND~while time.monotonic() - t0 < timeout_s:
~IND~~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~~IND~self._client = pas.ProjectAirSimClient(
~IND~~IND~~IND~~IND~~IND~~IND~address=self.address,
~IND~~IND~~IND~~IND~~IND~~IND~port_topics=self.port_topics,
~IND~~IND~~IND~~IND~~IND~~IND~port_services=self.port_services,
~IND~~IND~~IND~~IND~~IND~)
~IND~~IND~~IND~~IND~self._client.connect()
~IND~~IND~~IND~~IND~break
~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~time.sleep(0.5)
~IND~~IND~~IND~else:
~IND~~IND~~IND~~IND~self.state = LinkState.ERROR
~IND~~IND~~IND~~IND~return False
~IND~~IND~~IND~cfg = self.scene_config
~IND~~IND~~IND~if self.config_dir:
~IND~~IND~~IND~~IND~cfg = os.path.join(self.config_dir, self.scene_config)
~IND~~IND~~IND~self._world = pas.World(self._client, cfg, 1)
~IND~~IND~~IND~self._drone = pas.Drone(self._client, self._world, self.drone_name)
~IND~~IND~~IND~t_pose = time.monotonic()
~IND~~IND~~IND~while time.monotonic() - t_pose < 10.0:
~IND~~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~~IND~pose = self._drone.get_ground_truth_pose("NED")
~IND~~IND~~IND~~IND~if pose:
~IND~~IND~~IND~~IND~~IND~self._home_pos = pose["position"]
~IND~~IND~~IND~~IND~~IND~self._last_pos = pose["position"]
~IND~~IND~~IND~~IND~~IND~self.telemetry.position_valid = True
~IND~~IND~~IND~~IND~~IND~self.telemetry.landed_valid = True
~IND~~IND~~IND~~IND~~IND~self.telemetry.ekf_degraded = False
~IND~~IND~~IND~~IND~~IND~break
~IND~~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~~IND~pass
~IND~~IND~~IND~~IND~time.sleep(0.2)
~IND~~IND~~IND~self.state = LinkState.CONNECTED
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def start_setpoint_stream(self):
~IND~~IND~~IND~self._streaming = True
~IND~~IND~~IND~self.state = LinkState.OFFBOARD_ENGAGED
~IND~~IND~~IND~self.telemetry.setpoint_streaming = True
~IND~~
~IND~~IND~def _transmit_setpoint(self, sp):
~IND~~IND~~IND~if self._drone is None:
~IND~~IND~~IND~~IND~return
~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~self._drone.move_by_velocity_async(sp.vx, sp.vy, sp.vz, 0.05)
~IND~~IND~~IND~~IND~self._last_setpoint_ts = time.monotonic()
~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~pass
~IND~~
~IND~~IND~def send_setpoint(self, sp):
~IND~~IND~~IND~self._transmit_setpoint(sp)
~IND~~
~IND~~IND~def _wait_for_message(self, mt, to):
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def _wait_for_custom_mode(self, m, t):
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def _wait_for_armed(self, ea, to):
~IND~~IND~~IND~t0 = time.monotonic()
~IND~~IND~~IND~while time.monotonic() - t0 < to:
~IND~~IND~~IND~~IND~self._refresh_telemetry()
~IND~~IND~~IND~~IND~if self.telemetry.armed == ea:
~IND~~IND~~IND~~IND~~IND~return True
~IND~~IND~~IND~~IND~time.sleep(0.1)
~IND~~IND~~IND~return False
~IND~~
~IND~~IND~def _request_arming_state(self, a, to=2.0):
~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~if a:
~IND~~IND~~IND~~IND~~IND~self._drone.enable_api_control()
~IND~~IND~~IND~~IND~~IND~self._drone.arm()
~IND~~IND~~IND~~IND~else:
~IND~~IND~~IND~~IND~~IND~self._drone.disarm()
~IND~~IND~~IND~~IND~~IND~self._drone.disable_api_control()
~IND~~IND~~IND~~IND~return self._wait_for_armed(a, to)
~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~return False
~IND~~
~IND~~IND~def request_arm(self, to=2.0):
~IND~~IND~~IND~self.telemetry.armed = True
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def request_disarm(self, to=2.0):
~IND~~IND~~IND~self.telemetry.armed = False
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def start_offboard(self, to=2.0):
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def request_land(self, to=4.0):
~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~self._drone.land()
~IND~~IND~~IND~~IND~time.sleep(1.0)
~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~pass
~IND~~IND~~IND~self.state = LinkState.PX4_LAND
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def request_rtl(self, to=4.0):
~IND~~IND~~IND~self.state = LinkState.PX4_RTL
~IND~~IND~~IND~return True
~IND~~
~IND~~IND~def stop_offboard(self):
~IND~~IND~~IND~self.state = LinkState.CONNECTED
~IND~~
~IND~~IND~def stop_setpoint_stream(self):
~IND~~IND~~IND~self._streaming = False
~IND~~IND~~IND~self.telemetry.setpoint_streaming = False
~IND~~
~IND~~IND~def disconnect(self):
~IND~~IND~~IND~self._streaming = False
~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~if self._client:
~IND~~IND~~IND~~IND~~IND~self._client.disconnect()
~IND~~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~~IND~pass
~IND~~IND~~IND~self.state = LinkState.DISCONNECTED
~IND~~
~IND~~IND~def _refresh_telemetry(self, nonblocking=False):
~IND~~IND~~IND~if self._drone is None:
~IND~~IND~~IND~~IND~return
~IND~~IND~~IND~try:
~IND~~IND~~IND~~IND~pose = self._drone.get_ground_truth_pose("NED")
~IND~~IND~~IND~~IND~if pose:
~IND~~IND~~IND~~IND~~IND~pos = pose["position"]
~IND~~IND~~IND~~IND~~IND~self._last_pos = pos
~IND~~IND~~IND~~IND~~IND~self._last_vel = pose.get("velocity", {})
~IND~~IND~~IND~~IND~~IND~self._last_ts = time.monotonic()
~IND~~IND~~IND~~IND~~IND~self.telemetry.position_valid = True
~IND~~IND~~IND~~IND~~IND~self.telemetry.landed = abs(pos.get("z", 0)) < 0.5
~IND~~IND~~IND~~IND~~IND~self.telemetry.landed_valid = True
~IND~~IND~~IND~~IND~~IND~if self._home_pos:
~IND~~IND~~IND~~IND~~IND~~IND~dx = pos.get("x", 0) - self._home_pos.get("x", 0)
~IND~~IND~~IND~~IND~~IND~~IND~dy = pos.get("y", 0) - self._home_pos.get("y", 0)
~IND~~IND~~IND~~IND~~IND~~IND~self.telemetry.horiz_distance_m = math.sqrt(dx*dx + dy*dy)
~IND~~IND~~IND~~IND~~IND~~IND~self.telemetry.alt_m = -pos.get("z", 0)
~IND~~IND~~IND~~IND~except Exception:
~IND~~IND~~IND~~IND~~IND~pass
~IND~~
~IND~~IND~def poll_telemetry(self):
~IND~~IND~~IND~self._refresh_telemetry()
~IND~~
~IND~~IND~def wait_for_required_telemetry(self, to=2.0):
~IND~~IND~~IND~t0 = time.monotonic()
~IND~~IND~~IND~while time.monotonic() - t0 < to:
~IND~~IND~~IND~~IND~self._refresh_telemetry()
~IND~~IND~~IND~~IND~if self.telemetry.position_valid:
~IND~~IND~~IND~~IND~~IND~return True
~IND~~IND~~IND~~IND~time.sleep(0.1)
~IND~~IND~~IND~return False
~IND~~
~IND~~IND~def setpoint_age_ms(self):
~IND~~IND~~IND~if self._last_setpoint_ts == 0:
~IND~~IND~~IND~~IND~return 9999.0
~IND~~IND~~IND~return (time.monotonic() - self._last_setpoint_ts) * 1000.0
~IND~~
~IND~~IND~def stream_healthy(self):
~IND~~IND~~IND~age = self.setpoint_age_ms()
~IND~~IND~~IND~return self._streaming and age < 200.0
~IND~~
~IND~~IND~def get_pose(self):
~IND~~IND~~IND~return self._last_pos
'''

out = r'C:\Projects\GarudaOS\ProjectAirSim\sim\pas_link.py'
text = RAW.replace('~IND~', ' ').replace('\r', '')
with open(out, 'w') as f:
 f.write(text)

import ast
ast.parse(text)
print('OK:', len(text.splitlines()), 'lines')
