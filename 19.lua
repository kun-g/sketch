#! /usr/bin/lua

function isLeapYear(year)
  if(0==year%4 and (0~=year%100 or 0==year%400)) then
    return true
  end
  return false
end

lastMatch={year=1900,month=1,day=7}
count = 0
monthDay = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

function isMonday(date)
  dis = 1-lastMatch.day
 -- print(date.year,date.month)
  for i=lastMatch.year,date.year do
    beginMonth = 1
    endMonth = date.month-1
    if i==lastMatch.year then beginMonth=lastMatch.month end
    if i~=date.year then endMonth=12 end
    for j=beginMonth,endMonth do
      if 2==j and isLeapYear(i) then
        dis = dis+29
      else
        dis = dis+monthDay[j]
      end
--      io.write(dis, "\t")
    end
  end
--  io.write("\n")
  if 0==dis%7 then
    print(date.year,date.month,dis)
    lastMatch=date
    return true
  end
  return false
end

for year=1901, 2000,1 do
  for month=1, 12,1 do
    if(isMonday{year=year,month=month,day=1}) then
      count = count+1
    end
  end
end
print(count)
