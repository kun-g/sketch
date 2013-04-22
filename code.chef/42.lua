history={}
while (true) do
  input = io.read('*line')
  if('42' == input) then
    for _,value in ipairs(history) do
      print(value)
    end
    return nil
  end
  history[#history+1]=input
end
