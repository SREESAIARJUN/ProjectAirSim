"""
DroneOS (GarudaOne) - unified drone control framework.

Backends:
 PX4-Primary -> real hardware (PX4 + pymavlink)
 ProjectAirSim -> simulated flight (projectairsim)
"""
from __future__ import annotations
from typing import Any, Protocol
from dataclasses import dataclass
import time

# Optional real-hw backend
try:
 from pymavlink import mavutil # type: ignore
 PYMAVLINK_AVAILABLE = True
except ImportError:
 PYMAVLINK_AVAILABLE = False

# Sim backend (installed alongside this package)
from sim.pas_link import ProjectAirSimLink, LinkState, Setpoint, TelemetryState


class DroneOS:
 """Unified DroneOS flight controller with pluggable link backend."""

 def __init__(self, backend: str = "sim", link: Any | None = None):
  self.backend = backend
  self._link = link
  self._armed = False
  self._offboard = False
  self._setpoint_thread_running = False

 @staticmethod
 def _detect_backend() -> str:
  """Return the default backend based on environment."""
  import os
  if os.environ.get("DRONEOS_BACKEND"):
   return os.environ["DRONEOS_BACKEND"].lower()
  # If pymavlink is installed and MAVLink router reachable, prefer real HW
  if PYMAVLINK_AVAILABLE:
   return "px4"
  return "sim"

 @classmethod
 def connect(cls, backend: str = "auto") -> "DroneOS":
  """Factory: auto-detect or honour explicit backend, then connect."""
  if backend == "auto":
   backend = cls._detect_backend()
  print(f"[DroneOS] Using backend: {backend}")
  return cls(backend=backend)

 def arm(self, timeout: float = 2.0) -> bool:
  """Arm the drone (idempotent in sim)."""
  self._link.request_arm(timeout)
  self._armed = True
  print("[DroneOS] Armed")
  return True

 def disarm(self, timeout: float = 2.0) -> bool:
  self._link.request_disarm(timeout)
  self._armed = False
  print("[DroneOS] Disarmed")
  return True

 def start_offboard(self) -> bool:
  self._link.start_offboard()
  self._offboard = True
  self._link.start_setpoint_stream()
  print("[DroneOS] Offboard mode ENGAGED")
  return True

 def stop_offboard(self) -> None:
  self._link.stop_offboard()
  self._link.stop_setpoint_stream()
  self._offboard = False
  print("[DroneOS] Offboard mode DISENGAGED")

 def send_velocity(self, vx: float, vy: float, vz: float, yaw_rate: float = 0.0):
  sp = Setpoint(vx=vx, vy=vy, vz=vz, yaw_rate=yaw_rate)
  self._link.send_setpoint(sp)

 def land(self, timeout: float = 4.0) -> bool:
  self.stop_offboard()
  return self._link.request_land(timeout)

 def rtl(self, timeout: float = 4.0) -> bool:
  self.stop_offboard()
  return self._link.request_rtl(timeout)

 def disconnect(self) -> None:
  self.stop_offboard()
  self._link.disconnect()
  print("[DroneOS] Disconnected")

 def poll(self) -> dict:
  self._link.poll_telemetry()
  return {
   "armed": self._link.telemetry.armed,
   "landed": self._link.telemetry.landed,
   "position_valid": self._link.telemetry.position_valid,
   "horiz_distance_m": self._link.telemetry.horiz_distance_m,
   "alt_m": self._link.telemetry.alt_m,
   "ekf_degraded": self._link.telemetry.ekf_degraded,
   "stream_healthy": self._link.stream_healthy(),
   "state": self._link.state,
  }
