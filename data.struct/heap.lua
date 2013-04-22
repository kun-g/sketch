#! /usr/bin/lua

function PARENT(i) return math.floor(i/2) end
function LEFT(i) return i*2 end
function RIGHT(i) return i*2+1 end
function heap_size(A) return A[0] end
function max_heapify(A,i)
  local l = LEFT(i)
  local r = RIGHT(i)
  local max = i
  if l<=heap_size(A) and A[max]<A[l] then max = l end
  if r<=heap_size(A) and A[max]<A[r] then max = r end
  if max ~= i then
    A[i],A[max] = A[max],A[i]
    max_heapify(A, max)
  end
end
function build_max_heap(A, length)
  A[0] = length
  for i=math.floor(length/2),1,-1 do
    max_heapify(A,i)
  end
end
function heap_sort(A, length)
  build_max_heap(A, length)
  for i=heap_size(A),1,-1 do
    A[heap_size(A)],A[1] = A[1],A[heap_size(A)]
    A[0] = A[0]-1
    max_heapify(A,1)
  end
end

tar = {2,5,3,1,4,9,8,0,7,6}
heap_sort(tar,#tar)
for i = 1,10 do io.write(tar[i].." ") end
print(" ")
