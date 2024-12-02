#!/usr/bin/env python3

import sys

def is_fine(l):
    max_chg = 3
    x = l[0]
    d = 1 if x < l[1] else -1
    k = len(l)
    for i in range(1,k):
        y = l[i]
        if(y == x or abs(y - x) > max_chg or (y-x)/abs(y-x) != d):
            return False
        x = y
    return True

sum = 0

f = open(sys.argv[1],'r')

for line in f:
    line.strip()
    l = list(map(int, line.split()))
    if(is_fine(l)):
        sum += 1
        continue

# The list is not OK
# Check if can be cured by removing one item
# This is totally inefficient, but for such a small puzzle, it should be OK

    fine = False
    n = len(l)
    for i in range(n):
        if(fine):
            continue
        m = l[1:] if i == 0 else (l[:-1] if i == (n-1) else (l[0:i] + l[(i + 1):]))
        fine = is_fine(m)
    if(fine):
        sum += 1
print(sum)

f.close()

