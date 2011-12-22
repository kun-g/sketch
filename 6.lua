#! /usr/bin/lua

square_of_sum = 0
sum_of_square = 0

for i=1, 100,1 do
  sum_of_square = sum_of_square + i*i
  square_of_sum  = square_of_sum + i
end
square_of_sum = square_of_sum^2

print(square_of_sum)
print(sum_of_square)
print(square_of_sum-sum_of_square)
