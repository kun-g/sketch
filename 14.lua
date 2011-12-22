#! /usr/bin/lua

chainLog = {}
function sequence(num)
  local count = 1
  while (num>1) do
    if(chainLog[num]) then
      count = count + chainLog[num]
      break;
    end
    if(num%2==0) then
      num = num/2
    else
      num = 3*num+1
    end
    count = count + 1
  end

  return count
end

max = 0
num = 0
for i=1, 1000000,1 do
  chainLog[i] = sequence(i)
  if(chainLog[i] > max) then
    max = chainLog[i]
    num = i
  end
end
print(num)
