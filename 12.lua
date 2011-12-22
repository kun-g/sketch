#! /usr/bin/lua

function file2table(filename)
  local f = assert(io.open(filename,"r"), "open file fail")
  local t = f:read("*all")
  local ret = {}

  local i = 1
  for value in string.gfind(t, "([^\n]+)\n") do
    ret[i] = tonumber(value)
    i = i+1
  end
  return ret
end

prime = file2table("prime.list")

t = 1
n = 2

repeat
  count = 1
  t = t+n
  n = n+1
  tt = t
  for i=1,#prime do
    if prime[i]^2 > tt then
      count = count * 2
      break
    end
    exp = 1
    while (tt%prime[i] == 0) do
      exp = exp+1
      tt = tt/prime[i]
    end
    if exp > 1 then count = count*exp end
    if tt == 1 then break end
  end
until (count>500)

print(t)
