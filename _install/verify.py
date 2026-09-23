#!/usr/bin/env python
import ast, os

files = [
 r'C:\Projects\GarudaOS\GarudaOne\drone\drone_os.py',
 r'C:\Projects\GarudaOS\ProjectAirSim\sim\pas_link.py',
]

for p in files:
 if not os.path.exists(p):
  print(p, "MISSING")
  continue
 with open(p) as f:
  src = f.read()
 ast.parse(src)
 t = ast.parse(src)
 classes = [n.name for n in ast.walk(t) if isinstance(n, ast.ClassDef)]
 methods = [n.name for n in ast.walk(t) if isinstance(n, ast.FunctionDef)]
 print(p)
 print(" Classes:", classes)
 print(" Methods:", len(methods))
 print(" Lines:", len(src.splitlines()))
 print()
