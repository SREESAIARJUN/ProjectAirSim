import ast
content = open(r'C:\Projects\GarudaOS\ProjectAirSim\sim\pas_link.py', 'rb').read()
try:
 ast.parse(content)
 print('OK')
except SyntaxError as e:
 lines = content.decode().splitlines()
 print('Error at line', e.lineno, ':', e.msg)
 for i in range(max(0, e.lineno-3), min(len(lines), e.lineno+2)):
 print(' ', i+1, repr(lines[i]))
