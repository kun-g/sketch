#! /usr/bin/lua
uplimit = 200000
mask = {}
function file2table(filename)
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  local ret = {}

  local i = 1
  for value in string.gfind(t, "([^\n]+)\n") do
    if tonumber(value) > uplimit then break end
    ret[i] = tonumber(value)
    mask[tonumber(value)]=1
    i = i+1
  end
  return ret
end

prime = file2table("prime.list")
coefficients = {}
len = 0
-- n^2+an+b
-- n==0:b
-- n==1:1+a+b
for index,value in ipairs(prime) do
  b = value
  if value >= 1000 then break end
  for _,v in ipairs(prime) do
    a = v-b-1
    if math.abs(a) >= 1000 then break end
    len = len+1
    coefficients[len] = {a=a,b=b}
  end
end

n=2
n2=n^2
count = len
while count > 1 do
  n2=n^2
  print(n,count)
  for i=1,len do
    if coefficients[i].a~=nil then
      value = coefficients[i]
      sum = n2+n*value.a+value.b
      if sum>uplimit then
        print("fail:"..sum)
        return nil
      end
      if mask[sum]==nil then
        coefficients[i].a = nil
        count = count-1
      end
    end
  end
  n=n+1
end
for i=1,len do
  if coefficients[i].a ~= nil then print(coefficients[i].a,coefficients[i].b,coefficients[i].a*coefficients[i].b) end
end
