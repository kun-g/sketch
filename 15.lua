#! /usr/bin/lua

-- 通过观察可以发现，矩阵每个点到终点走法可以生成下图：
-- 6 3 1
-- 3 2 1
-- 1 1 0
-- 即一个点到终点的走法，等于其右边、下边的点的走法之和
-- 照此算法填图(因为是点，所以比边多1)：
map = {}
for i=1, 21,1 do
  map[i] = {}
end
for i=1, 21,1 do
  map[i][21] = 1
  map[21][i] = 1
end
for i=20, 1,-1 do
  for j=20, 1,-1 do
    map[i][j] = map[i+1][j]+map[i][j+1]
  end
end
print(map[1][1])
