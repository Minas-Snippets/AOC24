#!/usr/bin/env python3

import sys

sum = 0
f = open(sys.argv[1],'r')

a = [ ]
b = { }

for line in f:
    l = line.strip().split("   ")
    a.append(int(l[0]))
    if(l[1] in b):
        b[l[1]] += 1
    else:
        b[l[1]] = 1

for x in a:
    if(str(x) in b):
        sum += x * b[str(x)]

print(sum)

