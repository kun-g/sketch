#! /usr/bin/lua

number1 = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten",
"eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
-- 1~9
length1 = 0
for i=1,9 do length1 = length1 + string.len(number1[i]) end
-- 1~19
length2 = 0
for i=1,19 do length2 = length2 + string.len(number1[i]) end
-- 20~99
number2 = {"twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
length3 = 0
for i=1,8 do length3 = length3 + string.len(number2[i])*10 + length1 end
-- 1~99
lengthxx = length2+length3
print(length1, length2, length3, lengthxx)
-- x hundred and xx
lengthxxx = length1*100+string.len("hundred")*900+lengthxx*9+string.len("and")*891
count = lengthxxx+lengthxx+string.len("onethousand")
print(count)
