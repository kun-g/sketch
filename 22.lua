#! /usr/bin/lua

data = io.read('*all')

tar = {}
for value in string.gfind(data,"\"(%a*)\"") do
  table.insert(tar,value)
end

asc={A=1,B=2,C=3,D=4,E=5,F=6,G=7,H=8,I=9,J=10,K=11,L=12, 
M=13,N=14,O=15,P=16,Q=17,R=18,S=19,T=20,U=21,V=22,W=23,X=24,Y=25,Z=26}

function string2num(str)
  local len = #str
  local res = 0
  str = string.upper(str)

  for i=1, len,1 do
    res = res + asc[string.sub(str,i,i)]
  end

  return res
end

function qsort(tab,head,tail)
  flag=head
  for i=flag+1,tail do
    if tab[i] < tab[head] then
      flag = flag+1
      tab[i],tab[flag] = tab[flag],tab[i]
    end
  end
  tab[flag],tab[head] = tab[head],tab[flag]

  if flag > head then qsort(tab,head,flag-1) end
  if flag < tail then qsort(tab,flag+1,tail) end
end

function test(count)
  if count > 1 then
    print(count)
    coroutine.resume(coroutine.create(test),count-1)
  end
end
--qsort(tar,1,#tar)
table.sort(tar, function(a,b)
  return string.lower(a) < string.lower(b)
end)
res = 0
for i=1, #tar,1 do
  res = res + string2num(tar[i])*i
end
print(res)
