directions={
	[-1]={[-1]="NORTH_WEST",[0]="WEST",[1]="SOUTH_WEST"},
	[ 0]={[-1]="NORTH",     [0]="NONE",[1]="SOUTH"},
	[ 1]={[-1]="NORTH_EAST",[0]="EAST",[1]="SOUTH_EAST"}
}
stream = ""
streamIndex = 1

ID = nil
Players = {}
Toxic = {}
Key = {}

-- AI指令
-- MOVE <DIR> <VIEW>
function postMove(dx, dy, view)
  if(directions[dx]==nil or directions[dx][dy]==nil) then
    print("Invalid Instruction")
    return nil
  end
  print(directions[dx][dy].." "..view)
  sckHnd:send("MOVE "..directions[dx][dy].." "..view.."|")
end
-- 服务器分配的id
function onID(id)
  ID = id
  Players[id] = {}
  Players[id].x = -1
  Players[id].y = -1
  Players[id].dir = -1
  Players[id].life = 100
  Players[id].team = "BLUE"
  sckHnd:send("ID_OKAY|")
end
-- 服务器心跳
function onPing()
  
end
-- 新玩家
function onConnect(id)
  Players[id] = {}
  Players[id].x = -1
  Players[id].y = -1
  Players[id].dir = -1
  Players[id].life = 100
  Players[id].team = "BLUE"
end
-- 无用的命令
function onMap(map)
  
end
-- 位置改变的通知
function onSet(x,y,dir)
  Players[ID].x = tonumber(x)
  Players[ID].y = tonumber(y)
  Players[ID].dir = dir
end
-- 看到其他玩家
function onSeePlayer(x,y,dir,id)
  Players[id].x = tonumber(x)
  Players[id].y = tonumber(y)
  Players[id].dir = dir
end
-- 生命值
function onLife(val, id)
  Players[id].life = tonumber(val)
end
-- 其它玩家离线
function onDisconnected(id)
  Players[id] = nil
end
-- 主机的断线通知
function onDisconnect(id)
  
end
-- 看到钥匙
function onSeeKey(x,y,key)
  if(Key[x]==nil) then
    Key[x]={}
  end
  Key[x][y] = key
end
-- 得到钥匙
function onGetKey(key)
  
end
-- 毒气
function onToxic(x,y,val)
  if(Toxic[x]==nil) then
    Toxic[x]={}
  end
  Toxic[x][y] = tonumber(val)
end
-- 队伍改变
function onTeamChange(team,id)
  Players[id].team = team
end
-- 回合开始通知，需发操作指令给主机
function onStart(round)
  
end

-- 解析服务器发的数据
function desectStream()
  local pos = string.find(stream, "|", streamIndex)
  local tmp,x,y,tmp1
  if pos == nil then return nil end
  repeat
    local cmdLine = string.sub(stream, streamIndex, pos-1)
    streamIndex = pos+1
    if(string.find(cmdLine,"ID (%d+)")) then
      _,_,tmp = string.find(cmdLine, "ID (%d+)")
      onID(tmp)
    elseif(string.find(cmdLine,"CONNECTED (%d+)")) then
      _,_,tmp = string.find(cmdLine, "CONNECTED (%d+)")
      onConnect(tmp)
    elseif(string.find(cmdLine,"DISCONNECTED (%d+)")) then
      _,_,tmp = string.find(cmdLine, "DISCONNECTED (%d+)")
      onDisconnected(tmp)
    elseif(string.find(cmdLine,"DISCONNECT")) then
      _,_ = string.find(cmdLine, "DISCONNECT")
      onDisconnect()
    elseif(string.find(cmdLine,"MAP (.+)")) then
	    print(cmdLine)
      _,_,tmp = string.find(cmdLine, "MAP (.+)")
      onMap(tmp)
    elseif(string.find(cmdLine,"SET (%d+),(%d+) (%a+)")) then
      _,_,x,y,tmp = string.find(cmdLine, "SET (%d+),(%d+) (%a+)")
      onSet(x,y,tmp)
    elseif(string.find(cmdLine,"SEE_PLAYER (%d+),(%d+) (%a+) (%d+)")) then
      _,_,x,y,tmp,tmp1 = string.find(cmdLine, "SEE_PLAYER (%d+),(%d+) (%a+) (%d+)")
      onSeePlayer(x,y,tmp,tmp1)
    elseif(string.find(cmdLine,"SEE_KEY (%d+),(%d+) (%a+)")) then
      _,_,x,y,tmp = string.find(cmdLine, "SEE_PLAYER (%d+),(%d+) (%a+)")
      onSeeKey(x,y,tmp)
    elseif(string.find(cmdLine,"GET_KEY (%a+)")) then
      _,_,tmp = string.find(cmdLine, "GET_KEY (%a+)")
      onGetKey(tmp)
    elseif(string.find(cmdLine,"TOXIC (%d+),(%d+) (.+)")) then
      _,_,x,y,tmp = string.find(cmdLine, "TOXIC (%d+),(%d+) (.+)")
      onToxic(x,y,tmp)
    elseif(string.find(cmdLine,"LIFE (.+) (%d+)")) then
      _,_,tmp,tmp1 = string.find(cmdLine, "LIFE (.+) (%d+)")
      onLife(tmp,tmp1)
    elseif(string.find(cmdLine,"TEAMCHANGE (%a+) (%d+)")) then
      _,_,tmp,tmp1 = string.find(cmdLine, "TEAMCHANGE (%a+) (%d+)")
      onTeamChange(tmp,tmp1)
    elseif(string.find(cmdLine,"START (%d+)")) then
      _,_,tmp = string.find(cmdLine, "START (%d+)")
      onStart(tmp)
    elseif (cmdLine=="PING") then
      onPing()
    else
      print(":"..cmdLine) 
    end
    pos = string.find(stream, "|", streamIndex)
  until (pos == nil)  
end



function aiMain()
  local socket = require("socket")
  local addr = "127.0.0.1"
  local port = 15000
  local errStr,str
  sckHnd = socket.tcp()
  local ret,errStr = sckHnd:connect(addr, port, addr, 0)
  
  if(ret) then
    local clAddr,clPort = sckHnd:getsockname()
    local srvAddr,srvPort = sckHnd:getpeername()
    print("Connected with "..srvAddr.." on "..port)
    str, errStr = sckHnd:receive(20)
    while (str) do
      stream = stream..str
      desectStream()
      str, errStr = sckHnd:receive(20)
    end
  else
    print("Error:"..errStr)
  end
end
