#! /usr/bin/python

def cycle_length(n):
  i = 1
  if n % 2 == 0:
    return cycle_length(n / 2)
  if n % 5 == 0:
    return cycle_length(n / 5)
  if n == 1:
    return 0
  while True:
    if (pow(10, i) - 1) % n == 0:
      return i
    else:
      i=i+1

m, n=0, 0
for i in xrange(2, 1000):
  c = cycle_length(i)
  if c > m:
    m, n = c, i
print n,m
