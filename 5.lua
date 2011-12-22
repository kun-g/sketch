#! /usr/bin/lua

function lcm(tab)
  local res = 1
  local divisor = 2
  local flag = false

  while (#tab>0) do
    flag = false
    for index,value in ipairs(tab) do
      if(value%divisor == 0) then
        tab[index] = tab[index]/divisor
        flag = true
      end
    end
    if(not flag) then
      divisor = divisor + 1
    else
      res = res*divisor
      print(divisor)
    end
    for index,value in ipairs(tab) do
      if(value == 1) then
        table.remove(tab, index)
      end
    end
  end
  return res
end

tar = {}
for i=1, 20,1 do
  tar[i] = i
end

print(lcm(tar))
