_,_,x,y = string.find(io.read('*line'),'(%d+) (%d+\.%d+)')
withdraw = tonumber(x)
balance = tonumber(y)
if(withdraw%5==0 and  withdraw+0.5 < balance) then
  balance = balance - withdraw - 0.5
end
print(string.format('%.2f', balance))
