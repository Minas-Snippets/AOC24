#!/usr/bin/env python3

import sys

sum = 0
f = open(sys.argv[1],'r')

a = [ ]
b = [ ]

for line in f:
    l = line.strip().split("   ")
    a.append(int(l[0]))
    b.append(int(l[1]))

a.sort()
b.sort()

for x in a:
    sum += abs(x - b.pop(0))

print(sum)

