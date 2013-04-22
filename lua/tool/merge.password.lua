
function file2table(filename)
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  local ret = {}
  
  local i = 1
  for value in string.gfind(t, "([^\n]+)\n") do
    ret[i] = value
    i = i+1
  end
  return ret
end

function merge(tables)
  local ret = {}

  -- 合并并去除重复项
  for _,atable in ipairs(tables) do
    for i,value in ipairs(atable) do
      ret[value] = i
    end
  end
  
  return ret
end

argTable = {}
for _,fileName in ipairs(arg) do
  table.insert(argTable, file2table(fileName))
end
local t3 = merge(argTable)

out = assert(io.open("_result_", "w"))
for index,value in pairs(t3) do
    out:write(index.."\n")
end
io.close(out)
