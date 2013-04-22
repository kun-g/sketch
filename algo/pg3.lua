-- Applications of Min-Cut
-- 1.identify network bottlenecks/weakness
-- 2.community detection in social networks
-- 3.image segmentation
--  input=graph of pixels
--  use edge weights:[(u,v) has large weight <=> "expect" uv to come
--  from same object

filename = "kargerAdj.txt"

testData = {
  {data = [[
      1   2   3   4
      2   1   3   4   5
      3   1   2   4   8
      4   1   2   3
      5   6   7   8   2
      6   5   6   8
      7   5   6   8
      8   5   6   7   3
    ]],
    result = 3},
  {data = [[
      1   2   3   4
      2   1   4
      3   1   4
      4   1   2   3
    ]],
    result = 2},
  {data = [[
      1   2   3   
      2   1   4
      3   1   4
      4   1   2   3
    ]],
    result = 2},
}
local f = assert(io.open(filename,"r"))
local t = f:read("*all")
testData[#testData+1] = {data = t}

function genGraphByAdj(adj)
  local g = {}
  for index,value in string.gmatch(adj, "[^%d]*(%d+)[^%d]*([^\n]*)") do -- Node
    g[index] = {}
  end
  for index,value in string.gmatch(adj, "[^%d]*(%d+)[^%d]*([^\n]*)") do -- Adjacent
    for a in string.gmatch(value, "(%d+)") do
      g[index][a] = 1
    end
  end
  return g
end

function contract(g, u, v)
  if u ~= v then
    local tmp = {}
    local istr = u.."_"..v
    -- contract
    for index,value in pairs(g[u]) do
      tmp[index] = value
    end
    for index,value in pairs(g[v]) do
      if tmp[index] then
        tmp[index] = tmp[index]+value
      else
        tmp[index] = value
      end
    end
    -- delete
    g[u] = nil
    g[v] = nil
    tmp[u] = nil
    tmp[v] = nil
    for index,value in pairs(g) do
      if value[v] or value[u] then
        value[istr] = 0
      end
      if value[v]~=nil then
        value[istr] = value[istr] + value[v]
        value[v] = nil
      end
      if value[u]~=nil then
        value[istr] = value[istr] + value[u]
        value[u] = nil
      end
    end
    g[istr] = tmp
  end
  return g
end

function count_cut(g)
  return g
end

function printGraph(g)
  for index,value in pairs(g) do
    io.write(index..":")
    for i,v in pairs(value) do
      io.write(i.."("..tostring(v)..")".." ")
    end
    print("")
  end
end

function selectTar(g)
  local tmp = {}
  for index,value in pairs(g) do
    tmp[#tmp+1] = index
  end
  local i1, i2
  if #tmp > 2 then
    i1 = math.random(#tmp)
    i2 = i1
    while i2 == i1 do
      i2 = math.random(#tmp)
    end
  else
    return false, tmp[1], tmp[2]
  end
  return true, tmp[i1], tmp[i2]
end

times = 40*40*10 -- n^2*logn
for index,value in ipairs(testData) do
  print("=============================")
  print("Initial TestData:"..index)
  print("=============================")

  local mincut = nil
  for i=1,times do -- 多次尝试
    local g = genGraphByAdj(value.data);
    --printGraph(g)
    while true do -- 当前解
      math.randomseed(os.time()+i)
      local flag, i1, i2 = selectTar(g)
      if not flag then
        --print(flag, i2, i1, mincut, g[i2][i1])
        --printGraph(g)
        --print('\n')
        if mincut == nil or mincut > g[i2][i1] then
          mincut = g[i2][i1]
        end
        --print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^")
        break
      end
      --print("\ncontract "..i1..","..i2)
      g = contract(g, i1, i2)
      --printGraph(g)
    end
  end
  print(mincut)
end
