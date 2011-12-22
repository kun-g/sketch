#! /usr/bin/lua
data = io.read("*all")
line = 0
col = 1
tar = {}
for value in string.gfind(data,"(%d+)") do
  if col > line then
    col = 1
    line = line + 1
    tar[line] = {}
  end
  table.insert(tar[line], tonumber(value))
  col = col+1
end

print(line.." lines readed")
for i=line-1,1,-1 do
  for j=1,i do
    if tar[i+1][j] > tar[i+1][j+1] then
      tar[i][j] = tar[i][j] + tar[i+1][j]
    else
      tar[i][j] = tar[i][j] + tar[i+1][j+1]
    end
  end
end

--for i=1, line,1 do
--  for j=1, i,1 do
--    io.write(tar[i][j], "\t")
--  end
--  io.write("\n")
--end
print(tar[1][1])
