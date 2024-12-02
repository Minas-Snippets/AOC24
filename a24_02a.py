#!/usr/bin/env python3

import sys

sum = 0
max_chg = 3

f = open(sys.argv[1],'r')

for line in f:
    line.strip()
    l = list(map(int, line.split()))
    x = l.pop(0)
    d = 1 if x < l[0] else -1
    for y in l:
        if(y == x or abs(y - x) > max_chg or (y-x)/abs(y-x) != d):
            d = 0
            break
        x = y
    sum += abs(d)
print(sum)

f.close()
