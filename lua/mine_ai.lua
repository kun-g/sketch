require "mine_core"

mine_tile = {}
sandBox={}
-- sensor:all tile that is tagged with number
function all_tagged_tile()
  local ix = 1
  local iy = 1
  return function ()
    while (iy<=#mine) do
      while (ix<=#mine[1]) do
        if(sandBox[iy][ix]~=MINEFIELD.UNKNOWN and 
	   sandBox[iy][ix]~=MINEFIELD.MINE and
	   sandBox[iy][ix]~=MINEFIELD.SAFE) then
	  local tx = ix
	  ix = ix + 1
          return tx,iy
        end
	ix = ix + 1
      end
      iy = iy+1
      ix = 1
    end
  end
end

-- sensor:all untagged tile around (x,y)
function untagged_around(x, y)
  direction={-1,0,1}
  local i = 1
  local j = 1
  return function ()
    while (i<=3) do
      while (j<=3) do
        local bj=j
        j=j+1
        if(mine[y+direction[bj]] ~= nil and
          mine[y+direction[bj]][x+direction[i]]  ~= nil and
          mine[y+direction[bj]][x+direction[i]] == MINEFIELD.UNKNOWN) then
          return x+direction[i],y+direction[bj]
        end
      end
      i=i+1
      j=1
    end
  end
end

-- find a tile that is not a mine
function think()
  for i,v in all_tagged_tile() do
    print(i..v)
    local mcount = 0
    for _,_ in untagged_around(i,v) do
      mcount = mcount+1
    end
    -- if the number matches,all tile around is a mine
    if(mcount == sandBox[v][i]) then
      for ix,iy in untagged_around(i,v) do
        sandBox[iy][ix] = MINEFIELD.MINE
      end
      sandBox[v][i]=MINEFIELD.SAFE
    end
  end
  return nil,nil
end

function mainLoop()
  while (inputx ~= nil and inputy ~= nil) do
    showMineField()
    if(testMineField(inputx,inputy) == GAME_STATUES.LOSE) then
      print('You Lose')
      break
    elseif (winningTest()) then
      print('You Win')
      break
    end
    inputx,inputy=think()
    showMineField()
  end
end

function initAI(x, y, count)
  initMineField(x, y, count)
  for i=1, y,1 do
    sandBox[i]={}
    for j=1, x,1 do
      sandBox[i][j]=MINEFIELD.UNKNOWN
    end
  end
end

initAI(10, 5, 5)
initMineField(10, 5, 5)
inputx=1
inputy=1
mainLoop()
