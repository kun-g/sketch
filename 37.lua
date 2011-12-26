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

function shl(num)
  local tab = {}
  local len = 0
  while num > 0 do
    len = len+1
    tab[len] = num%10
    num = math.floor(num/10)
  end
  local index = len-1
  return function ()
    if index==0 then return nil end
    local res = tab[index]
    for i=index-1,1,-1 do res = res*10+tab[i] end
    index = index-1
    return res
  end
end

function shr(num)
  local tab = {}
  local len = 0
  while num > 0 do
    len = len+1
    tab[len] = num%10
    num = math.floor(num/10)
  end
  local index = 1
  return function ()
    if index==len+1 then return nil end
    local res = tab[len]
    for i=len-1,index,-1 do res = res*10+tab[i] end
    index = index+1
    return res
  end
end
count = 0
sum = 0
for index,value in ipairs(prime) do
  if count == 11 then break end
  if not(value==2 or value==3 or value==5 or value==7) then
    local flag = true
    for v in shl(value) do
      if mask[v]==nil then
        flag = false
        break
      end
    end
    if flag then
      for v in shr(value) do
        if mask[v]==nil then
          flag = false
          break
        end
      end
    end
    if flag then
      print(value,":")
      count = count + 1
      sum = sum+value
    end
  end
end
print(sum)
