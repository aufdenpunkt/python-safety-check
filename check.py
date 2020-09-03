import os
import sys
import json

FILE = '/output.json'

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

