
dataset = {
  [[
  7 1
  4 7
  1 4
  9 7
  6 9
  3 6
  8 6
  9 3
  2 8
  5 2
  8 5
  ]],
}

filename = "SCC.txt"
maxlabel = 875714


function genGraphByAdj(adj, reverse)
  local g = {}
  for i=1,maxlabel do g[i] = {} end
  for from,to in string.gmatch(adj, "[^%d]*(%d+)[^%d]*(%d*)") do -- Node
    local head = tonumber(to)
    local tail = tonumber(from)
    if reverse then
      head, tail = tail, head
    end
    if g[tail] == nil then
      g[tail] = {head}
    else
      table.insert(g[tail], head)
    end
  end
  return g
end

function printGraph(g)
  for i=1, maxlabel do
    if g[i] == nil then break end
    io.write(i..":")
    for j=1, maxlabel do
      if g[i][j] == nil then break end
      io.write(g[i][j].." ")
    end
    io.write("\n")
  end
end

function dfs_loop(g, time, mask, leader, order)
  t = 0
  s = nil

  for i=#order,1,-1 do
    if mask[order[i]] == nil then
      mask[order[i]] = 1
      s = order[i]
      local tmp = {order[i]}
      dfs(g, time, tmp, mask, leader)
    end
  end
end

count = {}
function dfs(g, time, trace, mask, leader)
  if nil==trace or 0==#trace then return end
  local i = trace[#trace]
  mask[i] = 1

  local j=1
  while nil~=g[i] and nil~=g[i][j] and mask[g[i][j]] do -- next unvisited node
    j = j+1
  end
  if nil == g[i] or nil == g[i][j] then -- done
    leader[i] = s
    if count[s] == nil then count[s] = 0 end
    count[s] = count[s] + 1
    time[#time+1] = i
    trace[#trace] = nil
  else
    trace[#trace+1] = g[i][j]
  end
  return dfs(g, time, trace, mask, leader)
end

local f = assert(io.open(filename,"r"))
local t = f:read("*all")
dataset[#dataset+1] = t
print("Load Graph")
local g = genGraphByAdj(dataset[2])
print("Load Reverse Graph")
local g_r = genGraphByAdj(dataset[2], true)
local time = {}
local mask = {}
local leader = {}
local order = {}
print("Label")
for i=1, maxlabel do order[i] = i end
print("DFS on reverse graph")
dfs_loop(g_r, time, mask, leader, order)
--for i=1, #g do print(i, leader[i]) end
--for i=1, #g do print(i, time[i]) end
print("==========================")
order = time
time = {}
mask = {}
count = {}
leader = {}
print("DFS on graph by order")
dfs_loop(g, time, mask, leader, order)
--for i=1, #g do print(i, leader[i]) end
--for i=1, #g do print(i, time[i]) end
for index,value in pairs(count) do
  print(value, index) --index, value)
end
