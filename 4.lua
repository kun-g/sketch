#! /usr/bin/lua

function isPalindrome(num)
  str = tostring(num)
  rstr = string.reverse(str)
  if(str==rstr) then
    return true
  else
    return false
  end
end

num1 = 999
num2 = 999
max=0
for num1=999, 1,-1 do
  for num2=999, 1,-1 do
    if(num1*num2 < max) then
      break;
    elseif(isPalindrome(num1*num2)) then
      max = num1*num2
    end
  end
end
print(max)
