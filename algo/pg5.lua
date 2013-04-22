#! /usr/bin/lua
function file2table(filename)
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  local ret = {}

  for value in string.gfind(t, "([^\n]+)\n") do
    ret[tonumber(value)]=1
  end
  return ret
end

local tar = file2table("HashInt.txt")
local res = {231552, 234756, 596873, 648219,726312, 981237, 988331, 1277361, 1283379}
local mask = {}
for i=1,#res do
  mask[i] = 0
end


for index,value in pairs(tar) do
  for i, v in pairs(res) do
    if tar[v-index] ~= nil then
      mask[i] = 1
      res[i] = nil
    end
  end
end

for i=1,#mask do
  io.write(mask[i])
end
