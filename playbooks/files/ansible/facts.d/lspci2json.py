#!/usr/bin/env python3
import subprocess
import json

lspci={}
slot=''

try:
    for line in subprocess.run(['lspci','-vmm'],capture_output=True,encoding='utf-8',universal_newlines=True).stdout.split('\n'):
        if line.strip():
            key,value = list(map(str.strip, line.split(':',1)))
            if key == "Slot":
                lspci[value] = {}
                slot = value
            lspci[slot][key] = value
    print(json.dumps(lspci,sort_keys=True))
except:
    print('{}')
