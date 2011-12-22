#! /usr/bin/lua

function file2table(filename)
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  local ret = {}

  local i = 1
  for value in string.gfind(t, "([^\n]+)\n") do
    ret[i] = tonumber(value)
    i = i+1
  end
  return ret
end
                        

target = 2000000
res = 0
prime = file2table("prime.list")
index = 1
while (prime[index] and prime[index]<target) do
  res = res+prime[index]
  index = index+1
end
print(res)
