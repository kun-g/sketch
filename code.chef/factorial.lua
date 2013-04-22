T = tonumber(io.read('*line'))
for i=1, T,1 do
  N = tonumber(io.read('*line'))
  count = 0
  while (5<=N) do
    N = N-N%5
    N = N/5
    count = count+N
  end
  print(count)
end
