#! /usr/bin/python

arrTable = {1:1}
for i in range(2,101):
  arrTable[i] = arrTable[i-1]*i

print(eval('+'.join(str(arrTable[100]))))
