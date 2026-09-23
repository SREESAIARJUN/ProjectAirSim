"""End-to-end test of Project AirSim Runtime."""
from __future__ import annotations

import logging
import sys
import time
import traceback

import projectairsim as pas
from projectairsim.types import Pose, Quaternion, Vector3

LOG = logging.getLogger("e2e")
results: list = []


def step(name: str):
 def wrap(fn):
 def run(*args, **kw):
 print(f"\n--- {name} ---", flush=True)
 try:
 t0 = time.perf_counter()
 out = fn(*args, **kw)
 dt = (time.perf_counter() - t0) * 1000
 msg = f"OK ({dt:.1f} ms)"
 print(msg, flush=True)
 if out is not None:
 print(str(out)[:1500], flush=True)
 results.append((name, True, msg))
 return out
 except Exception as e:
 msg = f"FAIL: {type(e).__name__}: {e}"
 print(msg, flush=True)
 traceback.print_exc()
 results.append((name, False, msg))
 return None
 return run
 return wrap


def main():
 logging.basicConfig(level=logging.WARNING,
 format="%(asctime)s %(name)s %(levelname)s %(message)s")
 pas.utils.projectairsim_log().setLevel(logging.WARNING)

 client = pas.ProjectAirSimClient(address="127.0.0.1",
 port_topics=18989, port_services=18990)

 @step("connect")
 def _connect():
 client.connect()
 return "connected"
 _connect()

 world = pas.World(client)

 @step("list_scenes")
 def _list_scenes():
 return world.list_scenes()
 scenes = _list_scenes()

 @step("list_robots")
 def _list_robots():
 return world.list_robots()
 robots = _list_robots()

 @step("get_scene_state")
 def _scene_state():
 return world.get_scene_state()
 state = _scene_state()

 @step("enable_weather_visualization")
 def _enable_weather():
 try:
 world.enable_weather_visualization = True
 return "set"
 except Exception:
 return None
 _enable_weather()

 @step("load_robots")
 def _load_robots():
 if robots and isinstance(robots, dict):
 for name in list(robots.keys()):
 try:
 world.load_robot(name)
 print(f" loaded {name}", flush=True)
 except Exception as e:
 print(f" {name}: {e}", flush=True)
 return list(robots.keys())
 return None
 loaded = _load_robots()

 @step("drone_takeoff")
 def _drone_takeoff():
 try:
 drone = pas.Drone(client, "Drone1")
 drone.arm()
 time.sleep(0.3)
 drone.takeoff_async()
 time.sleep(2.0)
 drone.move_to_position_async(0, 0, -10, 5)
 time.sleep(5.0)
 pos = drone.get_ground_truth_pose("NED")
 drone.move_to_position_async(0, 0, -5, 5)
 time.sleep(4.0)
 drone.land()
 time.sleep(2.0)
 drone.disarm()
 return f"final_pose={pos}"
 except Exception as e:
 return f"drone_e2e_failed={e}"
 _drone_takeoff()

 @step("rover_drive")
 def _rover_drive():
 try:
 rover = pas.Rover(client, "Rover1")
 rover.arm()
 rover.set_rover_controls(0.5, 0.0)
 time.sleep(2.0)
 rover.set_rover_controls(0.0, 0.0)
 rover.disarm()
 return "drove"
 except Exception as e:
 return f"rover_e2e_failed={e}"
 _rover_drive()

 @step("subscribe_clock")
 def _subscribe_clock():
 try:
 sub = client.subscribe_topic(
 pas.ProjectAirSimTopic.TOPIC_CLOCK,
 callback=lambda _, data: None,
 )
 time.sleep(0.5)
 client.unsubscribe(sub)
 return "sub_ok"
 except Exception as e:
 return f"sub_failed={e}"
 _subscribe_clock()

 @step("server_version")
 def _version():
 try:
 return world.get_server_version()
 except Exception as e:
 return f"v_failed={e}"
 _version()

 @step("disconnect")
 def _disconnect():
 client.disconnect()
 return "bye"
 _disconnect()

 print("\n========== E2E SUMMARY ==========", flush=True)
 passes = sum(1 for _, ok, _ in results if ok)
 fails = sum(1 for _, ok, _ in results if not ok)
 print(f"Passed: {passes}/{len(results)}", flush=True)
 for name, ok, msg in results:
 marker = "PASS" if ok else "FAIL"
 print(f" [{marker}] {name}: {msg}", flush=True)
 return 0 if fails == 0 else 1


if __name__ == "__main__":
 sys.exit(main())
