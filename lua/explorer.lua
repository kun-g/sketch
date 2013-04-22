require("ai")

Map = {}
Map.x = -1
Map.y = -1
-- 更新地图的大小
-- 会多加一层，用于放墙
function updateMapSize(x,y)
  x = x+1
  y = y+1
  if(x>Map.x) then
    for i=Map.x+1, x,1 do
      Map[i] = {}
      for j=0, Map.y,1 do
        Map[i][j] = {}
      end
    end
    Map.x = x
  end
  if(y>Map.y) then
    for j=Map.y+1, y,1 do
      for i=0, Map.x,1 do
        Map[i][j] = {}
      end
    end
    Map.y = y
  end
end
-- 更新地图的玩家信息
function updateMap()
  -- Clean
  for i=1, Map.x,1 do
    for j=1, Map.y,1 do
      if(Map[i][j].type == "Player") then
        Map[i][j].type = "Floor"
        Map[i][j].id = " "
      end
    end
  end
  -- Players
  for i,v in pairs(Players) do
    updateMapSize(v.x,v.y)
    if(Map[v.x]==nil)then print(v.x.."X"..v.y) end
    if(Map[v.x][v.y]) then
      Map[v.x][v.y].type = "Player"
      Map[v.x][v.y].id = i
    end
  end
end
-- 显示地图
function drawMap()
  for i=0, Map.y,1 do
    for j=0, Map.x,1 do
      if(Map[j][i] and Map[j][i].id~=nil) then
        io.write(Map[j][i].id.." ")
      else
        io.write("  ")
      end
    end
    io.write("\n");
  end
end

function onPing()
  
end

old_onID = onID
function onID(id)
  old_onID(id)
end
old_onSet = onSet
function onSet(x,y,dir)
  old_onSet(x,y,dir)
  if(move.x and (x ~= move.x or y ~= move.y)) then
  print(x.." "..y.." "..dir)
  print(move.x.." "..move.y)
    if(Map[move.x] and Map[move.x][move.y]) then
      Map[move.x][move.y].type = "Wall"
      Map[move.x][move.y].id = "*"
    end
  end
end

function think()
  -- 查看周围还没到过的地方
  x = Players[ID].x
  y = Players[ID].y
  local index = #move
  local moves={{},{},{},{}}
  local rmoves={{},{},{},{}}
  moves[1].x=0
  moves[2].x=0
  moves[3].x=1
  moves[4].x=-1
  moves[1].y=1
  moves[2].y=-1
  moves[3].y=0
  moves[4].y=0
  rmoves[1].x=0
  rmoves[2].x=0
  rmoves[3].x=-1
  rmoves[4].x=1
  rmoves[1].y=-1
  rmoves[2].y=1
  rmoves[3].y=0
  rmoves[4].y=0

  if(index == 0 or Map[x][y].dfs==nil) then
    -- 初始化移动选择
    Map[x][y].dfs = 1
    move[index+1]=1
  elseif Map[x+moves[move[index]].x][y+moves[move[index]].y].dfs==nil then
    Map[x+moves[move[index]].x][y+moves[move[index]].y].type = "Wall"
    Map[x+moves[move[index]].x][y+moves[move[index]].y].dfs = 0
    Map[x+moves[move[index]].x][y+moves[move[index]].y].id = "*"
  end

  repeat
    index = #move
    if(Map[x+moves[move[index]].x][y+moves[move[index]].y].dfs==nil) then
      postMove(moves[move[index]].x,moves[move[index]].y,Players[ID].dir)
      return nil
    elseif move[index]<4 then
      move[index] = move[index]+1
    else
      move[index]=nil
      index = index-1
      if(index > 0) then
        postMove(rmoves[move[index]].x,rmoves[move[index]].y,Players[ID].dir)
      end
      return nil
    end
  until index==0
end

function onStart(round)
  print("Round:"..round.."\tPos:("..Players[ID].x..","..Players[ID].y..")")
  updateMap()
  drawMap()
  think()
end

move = {}
aiMain()
