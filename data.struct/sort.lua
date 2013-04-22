#! /usr/bin/lua

-- insertion sort
function insertion_sort(tar, head, tail)
  local len = 0
  local sorted = {}
  for i=head, tail,1 do
    local loc=len+1
    for j=1, len,1 do
      if sorted[j] > tar[i] then 
        loc = j 
        break
      end
    end
    for j=len, loc,-1 do sorted[j+1] = sorted[j] end
    sorted[loc] = tar[i]
    len = len+1
  end
  tar = sorted
  return sorted
end
-- selection sort
function selection_sort(tar,head,tail)
  local min = 0

  for i=head,tail do
    min = i
    for j=i+1,tail do
      if tar[min]>tar[j] then min=j end
    end
    tar[min],tar[i] = tar[i],tar[min]
  end
  return tar
end
-- merge sort
function merge_sort(tar, head, tail)
  if head==tail then return {tar[head]} end
  local left = merge_sort(tar,head,head+math.floor((tail-head)/2))
  local right = merge_sort(tar,head+math.floor((tail-head)/2)+1,tail)
  -- merget
  local res = {}
  local i,j = 1,1
  while i<=#left or j<=#right do
    if i>#left or (j<=#right and left[i]>right[j]) then
      res[#res+1] = right[j]
      j = j+1
    elseif j>#right or (i<=#left and left[i]<right[j]) then
      res[#res+1] = left[i]
      i = i+1
    end
  end
  return res
end
-- quick sort
function quick_sort(tar, head, tail)
  local flag = head
  local flag_val = tar[head]

  if head == tail then return tar end

  for i=flag+1, tail,1 do
    if flag_val > tar[i] then
      flag = flag+1
      tar[flag], tar[i] = tar[i], tar[flag]
    end
  end
  tar[head],tar[flag] = tar[flag],tar[head]

  if flag > head then tar = quick_sort(tar, head, flag-1) end
  if flag < tail then tar = quick_sort(tar, flag+1, tail) end 

  return tar
end


data = {3, 4, 9, 2, 1, 5, 6, 8, 7, 0}

res = merge_sort(data, 1, 10)
print("Sorted")
for i=1, 10,1 do
  io.write(res[i],' ')
end
io.write('\n')
