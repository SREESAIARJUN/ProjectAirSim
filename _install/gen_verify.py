#!/usr/bin/env python
import ast
import os

SP = b' '
V = []

def add(n, s):
 V.append(SP * n + s.encode())

add(0, '#!/usr/bin/env python')
add(0, 'import ast, os')
add(0, '')
add(0, 'files = [')
add(1, "r'C:\\Projects\\GarudaOS\\GarudaOne\\drone\\drone_os.py',")
add(1, "r'C:\\Projects\\GarudaOS\\ProjectAirSim\\sim\\pas_link.py',")
add(0, ']')
add(0, '')
add(0, 'for p in files:')
add(1, 'if not os.path.exists(p):')
add(2, 'print(p, "MISSING")')
add(2, 'continue')
add(1, 'with open(p) as f:')
add(2, 'src = f.read()')
add(1, 'ast.parse(src)')
add(1, 't = ast.parse(src)')
add(1, 'classes = [n.name for n in ast.walk(t) if isinstance(n, ast.ClassDef)]')
add(1, 'methods = [n.name for n in ast.walk(t) if isinstance(n, ast.FunctionDef)]')
add(1, 'print(p)')
add(1, 'print(" Classes:", classes)')
add(1, 'print(" Methods:", len(methods))')
add(1, 'print(" Lines:", len(src.splitlines()))')
add(1, 'print()')

data = b'\n'.join(V) + b'\n'
with open(r'C:\Projects\GarudaOS\ProjectAirSim\_install\verify.py', 'wb') as f:
 f.write(data)
print('verify.py written')
