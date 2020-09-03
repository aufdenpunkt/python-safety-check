import os
import sys
import json

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
FILE = os.path.join(CURRENT_DIR, 'output.json')

try:
    with open(FILE, 'r') as d:
        data = json.load(d)
        found_security_vulnerabilities = len(data)
    if found_security_vulnerabilities > 0:
        sys.exit(1)
    else:
        sys.exit(0)
except FileNotFoundError:
    print('File output.json not found')
    pass

