#! /usr/bin/lua
target = 600851475143
divisor = 2
while (target>1) do
  if(0 == (target%divisor)) then
    target = target/divisor
    divisor = divisor - 1
  end
  divisor = divisor + 1
end
print(divisor)
