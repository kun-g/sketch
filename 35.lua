#! /usr/bin/lua
uplimit = 1000000
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

function numRol(num)
  local len = 0
  local tab = {}
  local index = 1
  while (num > 0) do
    len = len+1
    tab[len] = num%10
    num = math.floor(num/10)
  end
  index = len-1
  return function ()
    if index==0 then return nil end
    local res = tab[index]
    for i=index-1,1,-1 do res = res*10 + tab[i] end
    for i=len,index+1,-1 do res = res*10 + tab[i] end
    
    index = index-1
    return res
  end
end

function isCircular(num)
  if mask[num]==nil then return false end

  for v in numRol(num) do
    if mask[v]==nil then return false end
  end
  
  return true
end

count=0
for index,value in ipairs(prime) do
  if isCircular(value) then
    count = count+1
  end
end
print(count)
