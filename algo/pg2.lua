#! /usr/bin/lua
function file2table(filename)
  local f = assert(io.open(filename,"r"))
  local t = f:read("*all")
  local ret = {}

  local i = 1
  for value in string.gfind(t, "([^\n]+)\n") do
    ret[i] = tonumber(value)
    --mask[tonumber(value)]=1
    i = i+1
  end
  return ret
end

function quick_sort(tar, head, tail)
  local pivotIndex = get_pivot(tar, head, tail) -- 哨元
  local pivot = tar[pivotIndex]
  local rangeStart = head -- 与哨元相等的数据的起始位置
  local rangeLen = 0 -- 与哨元相等的数据的数量
  local range = {}

  if head == tail then return tar end
  count = count + tail - head

  tar[head], tar[pivotIndex] = tar[pivotIndex], tar[head]
 
  pivotIndex = head
  for i=head+1, tail,1 do
    if pivot > tar[i] then
      pivotIndex = pivotIndex+1
      tar[i], tar[pivotIndex] = tar[pivotIndex], tar[i]
    end
  end
  tar[pivotIndex], tar[head] = tar[head], tar[pivotIndex]
  if head < pivotIndex -1 then quick_sort(tar, head, pivotIndex-1) end
  if tail > pivotIndex +1 then quick_sort(tar, pivotIndex+1, tail) end

--  for i=head, tail,1 do
--    if pivot > tar[i] then
--      tar[rangeStart], tar[i] = tar[i], tar[rangeStart]
--      rangeStart = rangeStart+1
--    elseif pivot == tar[i] then
--      rangeLen = rangeLen + 1 -- 计数，但是不移动
--      range[rangeLen] = i
--    end
--  end
--  -- 移动与哨元相等的数据
--  for i=1,rangeLen do
--    tar[rangeStart+i-1] = pivot
--  end
--  if rangeStart-1 > head then tar = quick_sort(tar, head, rangeStart-1) end
--  if rangeStart+rangeLen < tail then tar = quick_sort(tar, rangeStart+rangeLen, tail) end 

  return tar
end


function check(tar)
  for i=1, #tar-1 do
    if tar[i] > tar[i+1] then
      return false
    end
  end
  return true
end

get_pivot_t = {}
get_pivot_t[1] = function (tar, head, tail)
-- first element as pivot
  return head
end
get_pivot_t[2] = function (tar, head, tail)
  return tail
end
get_pivot_t[3] = function (tar, head, tail)
  local ih, im, it = head, head+math.floor((tail-head)/2), tail
  local h, m, t = tar[ih], tar[im], tar[it]
  local ret = ih
  if (h >= m and h <= t) or (h <= m and h >= t) then
    ret = ih
  elseif (m >= h and m <= t) or (m <= h and m >= t)then
    ret = im
  else
    ret = it
  end
  return ret
end

for i=1,3 do
  tab = {9, 8, 7, 6, 5, 4, 3, 2, 1, 0}
  tab = file2table("QuickSort.txt")
  count = 0
  get_pivot = get_pivot_t[i]
  quick_sort(tab, 1, #tab)
  --for j=1, 10 do print(tab[j]) end
  if (check(tab)) then
    print(count)
  else
    print("fail")
  end
end
