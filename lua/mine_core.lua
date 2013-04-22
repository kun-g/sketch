MINEFIELD = {UNKNOWN='*',SAFE=0,MINE=9}
GAME_STATUES = {ON=1,LOSE=2,WIN=3}
mine = {}

function initMineField(x, y, count)
	-- Init minefield
	for var=1, y,1 do
	  mine[var]={}
	  local tmp=mine[var] 
	  for j=1, x,1 do
	    tmp[j]=MINEFIELD.UNKNOWN
	  end
	end
	-- Plant mines
	math.randomseed(os.time())
	local mx, my
	for var=1, count,1 do
	  repeat
	    mx = math.random(x)
	    my = math.random(y)
	  until(mine[my][mx]==MINEFIELD.UNKNOWN)
	  mine[my][mx]=MINEFIELD.MINE
	end
end

debugging=false
function showMineField()
  for index,value in ipairs(mine) do
    for i2,v2 in ipairs(value) do
      if(debugging~=true and (v2==MINEFIELD.UNKNOWN or v2==MINEFIELD.MINE)) then
        io.write('*'..'   ')
      else
        io.write(v2..'   ')
      end
    end
    print('\n')
  end
end


function near(x, y)
  direction={-1,0,1}
  local i = 1
  local j = 1
  return function ()
    while (i<=3) do
      while (j<=3) do
        local bj=j
        j=j+1
        if(mine[y+direction[bj]] ~= nil and
	(mine[y+direction[bj]][x+direction[i]] == MINEFIELD.MINE or mine[y+direction[bj]][x+direction[i]] == MINEFIELD.UNKNOWN)) then
          return x+direction[i],y+direction[bj]
        end
      end
      i=i+1
      j=1
    end
  end
end

-- count how many mines near (x,y)
function countMine(x, y)
  mine[y][x]=0
  for nx,ny in near(x,y) do
    if(mine[ny][nx]==MINEFIELD.MINE) then
      mine[y][x]=mine[y][x]+1
    end
  end
end

function testMineField(x, y)
  if(mine[y] == nil) then
    return GAME_STATUES.ON
  end
  -- Are U Alive?
  if(mine[y][x]==MINEFIELD.MINE) then
    return GAME_STATUES.LOSE
  -- Don't retest
  elseif (mine[y][x]~=MINEFIELD.UNKNOWN) then
    return GAME_STATUES.ON
  end
  countMine(x,y)
  -- tag them
  for nx,ny in near(x,y) do
    if(mine[ny][nx]~=MINEFIELD.MINE) then
      countMine(x,y)
      testMineField(nx,ny)
    else
      break
    end
  end
  return GAME_STATUES.ON
end

-- Winning check
-- if all untagged tails are mines,you win
function winningTest()
  for index,value in ipairs(mine) do
    for i2,v2 in ipairs(value) do
      if(v2==MINEFIELD.UNKNOWN) then
        return false
      end
    end
  end
  return true
end
