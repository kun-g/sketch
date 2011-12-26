#! /usr/bin/lua

local nstart = 1
local ncount = 0
local answer = 1
for i=3, 1001,2 do
  ncount = ncount+8
  nstart = nstart+ncount
  answer = answer + nstart*4-(i-1)*6
end

print(nstart,answer)
