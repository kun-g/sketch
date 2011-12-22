#! /usr/bin/python

a,b,i = 1,1,1
while len(str(a)) < 1000:
  a,b = b,a+b
  i = i + 1
print (i)
