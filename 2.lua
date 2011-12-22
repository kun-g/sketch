#! /usr/bin/lua
-- Solution 1
res = 2
i=1
j=2
k=i+j
while (k<4000000) do
  if(k%2==0) then
    res = res+k
  end
  i = j
  j = k
  k = i+j
end
print(res)
-- Solution 2
-- Fibonacci sequence:
-- A(1)=A(2)=1
-- A(n)=A(n-1)+A(n-2)
-- 1 1 2 3 5 8 13 21 34 55 89 144 ...
-- x x o x x o x  x  o  x  x  o
-- New sequence:
-- 2 8 34 144 ...
-- B(n)=A(3n)=A(3n-1)+A(3n-2)=A(3n-2)*2+A(3n-3)
-- = A(3n-3)*3+A(3n-4)*2
-- = A(3n-3)*3+A(3n-4)+A(3n-5)+A(3n-6)
-- = A(3(n-1))*4+A(3(n-2))
-- = B(n-1)*4+B(n-2)
res = 10
i=2
j=8
k=i+4*j
while (k<4000000) do
  res = res+k
  i = j
  j = k
  k = i+4*j
end
print(res)
