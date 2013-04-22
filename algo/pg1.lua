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

function bsearch(tbl, num)
  local l, r = 1, #tbl
  local m = math.floor((l+r)/2)

  while r > l do
    if tbl[m] < num then
      l = m+1
    elseif tbl[m] > num then
      r = m-1
    else
      return m+1
    end
    m = math.floor((l+r)/2)
  end

  return m+1
end

--tar = {5, 4, 3, 2, 1}
tar = file2table('IntegerArray.txt')
print(#tar)

function mergeCount(tabA, tabB)
  local i, j, k = 1, 1, 1
  local tabC = {}
  local count = 0

  while tabA[i]~=nil or tabB[j]~=nil do
    if tabA[i]~=nil and (tabB[j]==nil or tabA[i] < tabB[j]) then
      tabC[k] = tabA[i]
      i = i+1
    else
      tabC[k] = tabB[j]
      j = j+1
      count = count + #tabA-i+1
    end
    k = k+1
  end

  table.concat

  return count, tabC
end

function invertCount(tab, from, to)
  if from == to then return 0,{tab[from]} end

  local countA,tabA = invertCount(tab, from, math.floor((from+to)/2))
  local countB,tabB = invertCount(tab, math.floor((from+to)/2)+1, to)
  local countC,tabC = mergeCount(tabA, tabB)
  print(from..":"..to.." "..countA.." "..countB.." "..countC)
  return countA+countB+countC, tabC
end

result = invertCount(tar, 1, #tar)
print(result)
