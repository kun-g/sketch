require "mine_core"

function mainLoop()
  while (true) do
    showMineField()
    inputx=io.read("*number")
    inputy=io.read("*number")
    if(testMineField(inputx,inputy) == GAME_STATUES.LOSE) then
      print('You Lose')
      break
    elseif (winningTest()) then
      print('You Win')
      break
    end
  end
end
initMineField(10, 5, 5)
mainLoop()
