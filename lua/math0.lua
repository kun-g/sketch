tar = 13

ten = 10

while ten%tar ~= 1 do
  if math.abs(ten%tar - tar) > ten%tar then
    print((ten%tar).." ")
  else
    print((ten%tar-tar).." ")
  end
  ten = ten*10
end

print((12345%13))
print((-18%13))
