#! /usr/bin/lua

tar = 1000

sq = {}
-- generate squares
for i=1, tar,1 do
  table.insert(sq, i^2)
end

for i=#sq, 1,-1 do
  for j=i-1, 1,-1 do
    k = tar-i-j
    if(sq[k] and sq[j]+sq[k]==sq[i]) then
       print(i.." "..j.." "..k) 
       print(sq[i].." "..sq[j].." "..sq[k]) 
       print(i*j*k)
       return nil
    end
  end
end
