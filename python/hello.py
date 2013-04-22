#! /usr/bin/python
# coding: utf8

for cnt in range(0,10):
  print cnt
print '中文'

a = "show me the money"
print(a[:a.find(" ")])
b = a.split()
print(b)

import re
print(re.findall(r"[0-9]", "=="))
print(re.findall(r"[0-9]|=", "1+2==3"))
print("Substitution %s " % "a")
print("Substitution 1%s 2%s" % ("a","b"))
print("Advanced Substitution %(str)s %(dsc)s %(str)s" % {"str":"Cool", "dsc":"re"})


print("======================== XML ======================")
from xml.dom import minidom

xmlStr="<note><to>George</to><from>John</from><heading>Reminder</heading><body>Don'tforgetthemeeting!</body></note>"
x = minidom.parseString(xmlStr)
print(x.toprettyxml())

import urllib2

#r = urllib2.urlopen("http://www.nytimes.com/services/xml/rss/nyt/GlobalHome.xml")
#p = r.read()
#item = minidom.parseString(p).getElementsByTagName("item")
#print(len(item))

print("======================== Json ======================")
import json
j = '{"one": 1, "numbers": [1,2,3,5]}'
d = json.loads(j)
print(type(d))
d['numbers'].insert(7, 1)
print(d['numbers'])
print(json.dumps(d))

r = urllib2.urlopen("http://localhost:8080/blog/5.json")
p = r.read()
d = json.loads(p)
print(type(d))
print(d)
