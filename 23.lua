#! /usr/bin/lua

abundant = {}
function isAbundant(num)
  local sum = 1
  local i

  for i=2, math.sqrt(num),1 do
    if num%i==0 then
      sum = sum + i
      if num/i ~= i then sum = sum+num/i end
    end
  end
  if num < sum then 
    return true
  else 
    return false
  end
end
sum = 0
tar = {}
for i=1,20161 do tar[i] = 1 end
for i=1, 20161,1 do
  if isAbundant(i) then
    abundant[#abundant+1] = i
    for j=1,#abundant do
      tar[i+abundant[j]]=0
    end
  end

  if tar[i]==1 then
    sum = sum+i
  end
end
print(sum)
