#!/usr/bin/env python3
import ipaddress
import subprocess
import sys

def main(ip_network="10.0.16.0/20"):
    first = True
    ips = []
    for ip in ipaddress.IPv4Network(ip_network):
        if first:
            first = False
            continue
        res = subprocess.run(["ping","-c1","-W1","-q",ip.exploded], capture_output=True)
        if res.returncode == 0:
            ips = []
        else:
            ips.append(ip.exploded)
        if len(ips) >= 5:
            print("metallb:%s-%s" % (ips[0], ips[-1]))
            break

if __name__ == "__main__":
    main(sys.argv[1])
