#!/usr/bin/env python
"""sim/__init__.py - DroneOS simulation package."""
import sys
import os

# Ensure sim/ is importable when running from repo root
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))
