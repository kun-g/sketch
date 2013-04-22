#! /usr/bin/lua
id_ACode = 0 
id_BDate = 0 
id_ONum = 0 
id_CheckSum = 0

-- 地址码
id_ACode = 110102
id_BDate = 19870410
id_ONum = 159

id = {3, 4, 2, 2, 2, 4, 1, 9, 8, 7, 0, 4, 1, 0, 1, 5, 9, 'x'}

-- CheckSum
checkSumTable = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1}
local s = 0
for i = 1, 17 do
  s = s+id[i]*checkSumTable[i]
end
id[18] = (12-(s%11))%11

-- Output
for i = 1, 18 do
  print(id[i])
end
