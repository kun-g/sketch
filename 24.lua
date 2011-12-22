#! /usr/bin/lua

count = {1}
index = {}
for i=1,10 do index[i]=0 end
for i=2,9 do count[i]=count[i-1]*i end
sum = 1000000-1
while sum > 0 do
  for i=9,1,-1 do
    if sum>=count[i] then
      index[i+1]=math.floor(sum/count[i])
      sum = sum%count[i]
    end
  end
end

num = {0,1,2,3,4,5,6,7,8,9}
for i=10,1,-1 do
  local j=0
  local k=0
  while j<=index[i] do
    k = k+1
    if num[k] ~= nil then 
      j = j+1 
    end
  end
  io.write(num[k])
  num[k]=nil
end
print(" ")
