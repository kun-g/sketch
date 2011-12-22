#! /usr/bin/lua

function d(num)
  count = 1
  for i=2,math.sqrt(num) do
    if num%i == 0 then
      count = count+i+num/i
    end
  end
  return count
end

t = {}
for i=2,10000 do
  t[i] = d(i)
end

res = 0
for i=2,10000 do
  if t[t[i]]==i and i~=t[i] then
    res = res+i
    print(i,t[i])
  end
end

print(res)
