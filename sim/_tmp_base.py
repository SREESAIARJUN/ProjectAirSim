"""ProjectAirSim bridge for DroneOS (GarudaOne)."""
from __future__ import annotations
import logging
import math
import os
import time
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any
import projectairsim as pas
LOG = logging.getLogger(__name__)
VELOCITY_YAW_RATE_TYPE_MASK = ((1<<0)|(1<<1)|(1<<2)|(1<<6)|(1<<7)|(1<<8)|(1<<10))
MAV_FRAME_LOCAL_NED = 1

class LinkState(StrEnum):
 DISCONNECTED = "disconnected"
 CONNECTING = "connecting"
 CONNECTED = "connected"
 STREAMING = "streaming"
 OFFBOARD_ENGAGED = "offboard_engaged"
 PX4_LAND = "px4_land"
 PX4_RTL = "px4_rtl"
 ERROR = "error"

@dataclass
class Setpoint:
 vx: float = 0.0
 vy: float = 0.0
 vz: float = 0.0
 yaw_rate: float = 0.0
 ts: float = field(default_factory=time.monotonic)

@dataclass
class TelemetryState:
 has_valid_bbox: bool = False
 bbox_confidence: float = 0.0
 target_id = None
 last_bbox_time: float = 0.0
 target_lost_time: float = 0.0
 search_start_time: float = 0.0
 last_grant_was_track: bool = False
 cpu_temp_c: float = 0.0
 cpu_temp_valid: bool = False
 battery_voltage: float = 0.0
 battery_valid: bool = False
 tof_min_range_m: float = 0.0
 tof_confidence: float = 0.0
 horiz_distance_m: float = 0.0
 alt_m: float = 0.0
 armed: bool = False
 landed: bool = True
 landed_valid: bool = False
 position_valid: bool = False
 last_setpoint_time: float = 0.0
 setpoint_streaming: bool = False
 gimbal_heartbeat_ok: bool = False
 last_gimbal_heartbeat: float = 0.0
 ekf_degraded: bool = Trueclass ProjectAirSimLink:
 """Bridge: DroneOS arbiter <-> ProjectAirSim Runtime."""

 def __init__(self, address="127.0.0.1", port_topics=8989, port_services=8990,
 drone_name="Drone1", scene_config="scene_test_drone.jsonc", config_dir=None):
 self.address = address
 self.port_topics = port_topics
 self.port_services = port_services
 self.drone_name = drone_name
 self.scene_config = scene_config
 self.config_dir = config_dir
 self.state = LinkState.DISCONNECTED
 self.telemetry = TelemetryState()
 self._streaming = False
 self._last_setpoint_ts = 0.0
 self._client = None
 self._world = None
 self._drone = None
 self._home_pos = None
 self._last_pos = None
 self._last_vel = None
 self._last_ts = 0.0

 def connect(self, timeout_s=15.0):
 t0 = time.monotonic()
 self.state = LinkState.CONNECTING
 while time.monotonic() - t0 < timeout_s:
 try:
 self._client = pas.ProjectAirSimClient(address=self.address, port_topics=self.port_topics, port_services=self.port_services)
 self._client.connect()
 break
 except Exception:
 time.sleep(0.5)
 else:
 self.state = LinkState.ERROR
 return False
 cfg = self.scene_config
 if self.config_dir:
 cfg = os.path.join(self.config_dir, self.scene_config)
 self._world = pas.World(self._client, cfg, 1)
 self._drone = pas.Drone(self._client, self._world, self.drone_name)
 t_pose = time.monotonic()
 while time.monotonic() - t_pose < 10.0:
 try:
 pose = self._drone.get_ground_truth_pose("NED")
 if pose:
 self._home_pos = pose["position"]
 self._last_pos = pose["position"]
 self.telemetry.position_valid = True
 self.telemetry.landed_valid = True
 self.telemetry.ekf_degraded = False
 break
 except Exception:
 pass
 time.sleep(0.2)
 self.state = LinkState.CONNECTED
 return True

 def start_setpoint_stream(self):
 self._streaming = True
 self.state = LinkState.OFFBOARD_ENGAGED
 self.telemetry.setpoint_streaming = True

 def _transmit_setpoint(self, sp):
 if self._drone is None:
 return
 try:
 self._drone.move_by_velocity_async(sp.vx, sp.vy, sp.vz, 0.05)
 self._last_setpoint_ts = time.monotonic()
 except Exception:
 pass

 def send_setpoint(self, sp):
 self._transmit_setpoint(sp)

 def _wait_for_message(self, mt, to): return True
 def _wait_for_custom_mode(self, m, t): return True

 def _wait_for_armed(self, ea, to):
 t0 = time.monotonic()
 while time.monotonic() - t0 < to:
 self._refresh_telemetry()
 if self.telemetry.armed == ea: return True
 time.sleep(0.1)
 return False

 def _request_arming_state(self, a, to=2.0):
 try:
 if a:
 self._drone.enable_api_control()
 self._drone.arm()
 else:
 self._drone.disarm()
 self._drone.disable_api_control()
 return self._wait_for_armed(a, to)
 except Exception: return False

 def request_arm(self, to=2.0): self.telemetry.armed = True; return True
 def request_disarm(self, to=2.0): self.telemetry.armed = False; return True
 def start_offboard(self, to=2.0): return True

 def request_land(self, to=4.0):
 try: self._drone.land(); time.sleep(1.0)
 except Exception: pass
 self.state = LinkState.PX4_LAND; return True

 def request_rtl(self, to=4.0): self.state = LinkState.PX4_RTL; return True
 def stop_offboard(self): self.state = LinkState.CONNECTED

 def stop_setpoint_stream(self): self._streaming = False; self.telemetry.setpoint_streaming = False

 def disconnect(self):
 self._streaming = False
 try:
 if self._client: self._client.disconnect()
 except Exception: pass
 self.state = LinkState.DISCONNECTED

 def _refresh_telemetry(self, nonblocking=False):
 if self._drone is None: return
 try:
 pose = self._drone.get_ground_truth_pose("NED")
 if pose:
 pos = pose["position"]
 self._last_pos = pos
 self._last_vel = pose.get("velocity", {})
 self._last_ts = time.monotonic()
 self.telemetry.position_valid = True
 self.telemetry.landed = abs(pos.get("z", 0)) < 0.5
 self.telemetry.landed_valid = True
 if self._home_pos:
 dx = pos.get("x", 0) - self._home_pos.get("x", 0)
 dy = pos.get("y", 0) - self._home_pos.get("y", 0)
 self.telemetry.horiz_distance_m = math.sqrt(dx*dx + dy*dy)
 self.telemetry.alt_m = -pos.get("z", 0)
 except Exception: pass

 def poll_telemetry(self): self._refresh_telemetry()

 def wait_for_required_telemetry(self, to=2.0):
 t0 = time.monotonic()
 while time.monotonic() - t0 < to:
 self._refresh_telemetry()
 if self.telemetry.position_valid: return True
 time.sleep(0.1)
 return False

 def setpoint_age_ms(self):
 if self._last_setpoint_ts == 0: return 9999.0
 return (time.monotonic() - self._last_setpoint_ts) * 1000.0

 def stream_healthy(self):
 age = self.setpoint_age_ms()
 return self._streaming and age < 200.0

 def get_pose(self): return self._last_pos


class ProjectAirSimLink:
 """Bridge: DroneOS arbiter <-> ProjectAirSim Runtime."""

 def __init__(self, address="127.0.0.1", port_topics=8989, port_services=8990,
 drone_name="Drone1", scene_config="scene_test_drone.jsonc", config_dir=None):
 self.address = address
 self.port_topics = port_topics
 self.port_services = port_services
 self.drone_name = drone_name
 self.scene_config = scene_config
 self.config_dir = config_dir
 self.state = LinkState.DISCONNECTED
 self.telemetry = TelemetryState()
 self._streaming = False
 self._last_setpoint_ts = 0.0
 self._client = None
 self._world = None
 self._drone = None
 self._home_pos = None
 self._last_pos = None
 self._last_vel = None
 self._last_ts = 0.0

 def connect(self, timeout_s=15.0):
 t0 = time.monotonic()
 self.state = LinkState.CONNECTING
 while time.monotonic() - t0 < timeout_s:
 try:
 self._client = pas.ProjectAirSimClient(address=self.address, port_topics=self.port_topics, port_services=self.port_services)
 self._client.connect()
 break
 except Exception:
 time.sleep(0.5)
 else:
 self.state = LinkState.ERROR
 return False
 cfg = self.scene_config
 if self.config_dir:
 cfg = os.path.join(self.config_dir, self.scene_config)
 self._world = pas.World(self._client, cfg, 1)
 self._drone = pas.Drone(self._client, self._world, self.drone_name)
 t_pose = time.monotonic()
 while time.monotonic() - t_pose < 10.0:
 try:
 pose = self._drone.get_ground_truth_pose("NED")
 if pose:
 self._home_pos = pose["position"]
 self._last_pos = pose["position"]
 self.telemetry.position_valid = True
 self.telemetry.landed_valid = True
 self.telemetry.ekf_degraded = False
 break
 except Exception:
 pass
 time.sleep(0.2)
 self.state = LinkState.CONNECTED
 return True

 def start_setpoint_stream(self):
 self._streaming = True
 self.state = LinkState.OFFBOARD_ENGAGED
 self.telemetry.setpoint_streaming = True

 def _transmit_setpoint(self, sp):
 if self._drone is None:
 return
 try:
 self._drone.move_by_velocity_async(sp.vx, sp.vy, sp.vz, 0.05)
 self._last_setpoint_ts = time.monotonic()
 except Exception:
 pass

 def send_setpoint(self, sp):
 self._transmit_setpoint(sp)

 def _wait_for_message(self, mt, to): return True
 def _wait_for_custom_mode(self, m, t): return True

 def _wait_for_armed(self, ea, to):
 t0 = time.monotonic()
 while time.monotonic() - t0 < to:
 self._refresh_telemetry()
 if self.telemetry.armed == ea: return True
 time.sleep(0.1)
 return False

 def _request_arming_state(self, a, to=2.0):
 try:
 if a:
 self._drone.enable_api_control()
 self._drone.arm()
 else:
 self._drone.disarm()
 self._drone.disable_api_control()
 return self._wait_for_armed(a, to)
 except Exception: return False

 def request_arm(self, to=2.0): self.telemetry.armed = True; return True
 def request_disarm(self, to=2.0): self.telemetry.armed = False; return True
 def start_offboard(self, to=2.0): return True

 def request_land(self, to=4.0):
 try: self._drone.land(); time.sleep(1.0)
 except Exception: pass
 self.state = LinkState.PX4_LAND; return True

 def request_rtl(self, to=4.0): self.state = LinkState.PX4_RTL; return True
 def stop_offboard(self): self.state = LinkState.CONNECTED

 def stop_setpoint_stream(self): self._streaming = False; self.telemetry.setpoint_streaming = False

 def disconnect(self):
 self._streaming = False
 try:
 if self._client: self._client.disconnect()
 except Exception: pass
 self.state = LinkState.DISCONNECTED

 def _refresh_telemetry(self, nonblocking=False):
 if self._drone is None: return
 try:
 pose = self._drone.get_ground_truth_pose("NED")
 if pose:
 pos = pose["position"]
 self._last_pos = pos
 self._last_vel = pose.get("velocity", {})
 self._last_ts = time.monotonic()
 self.telemetry.position_valid = True
 self.telemetry.landed = abs(pos.get("z", 0)) < 0.5
 self.telemetry.landed_valid = True
 if self._home_pos:
 dx = pos.get("x", 0) - self._home_pos.get("x", 0)
 dy = pos.get("y", 0) - self._home_pos.get("y", 0)
 self.telemetry.horiz_distance_m = math.sqrt(dx*dx + dy*dy)
 self.telemetry.alt_m = -pos.get("z", 0)
 except Exception: pass

 def poll_telemetry(self): self._refresh_telemetry()

 def wait_for_required_telemetry(self, to=2.0):
 t0 = time.monotonic()
 while time.monotonic() - t0 < to:
 self._refresh_telemetry()
 if self.telemetry.position_valid: return True
 time.sleep(0.1)
 return False

 def setpoint_age_ms(self):
 if self._last_setpoint_ts == 0: return 9999.0
 return (time.monotonic() - self._last_setpoint_ts) * 1000.0

 def stream_healthy(self):
 age = self.setpoint_age_ms()
 return self._streaming and age < 200.0

 def get_pose(self): return self._last_pos


