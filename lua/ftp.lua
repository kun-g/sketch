require("sqlite3")
local ftp = require("socket.ftp")
local ltn12 = require("ltn12")
local url = require("socket.url")

function list(u)
  local t = {}
  local p = url.parse(u)
  p.command = "LIST"
  p.sink = ltn12.sink.table(t)
  local r, e = ftp.get(p)
  return r and table.concat(t), e
end

function directoryTree(server, user, pass)
  u = "ftp://"..user..":"..pass.."@"..server
  return function (dir, level)
    if dir == '/' then dir = "" end
    local url = u..dir
    local r, e = list(url)
    local property,size,month,day,time,name,year
    if level==nil then level = 0 end
    local prestr = ""

    for i=0,level do prestr = prestr.."  " end

    for property,_,_,_,size,month,day,time,name in string.gfind(r, "(%S+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%a+)%s+(%d+)%s+(%S+)%s+(%C+)") do
      if string.find(time,":") then 
        year = os.date("%Y") 
      else
        year = time
      end
      if string.sub(property,1,1) ~= 'd' then
        store(dir,name,size,year,month,day)
      else
        dirTree(dir.."/"..name, level+1)
      end
    end
  end
end

function db_close(db)
  return function()
    store()
    db:close()
  end
end

function db_addRecord(db)
  local sql = ""
  return function(path, name, size, year, mon, day)
    if path==nil or string.len(sql) > 1024*64 then 
      db:exec(sql) 
      sql = ""
      return nil
    end
    local cur = "insert into  file values('"..path.."','"..name.."',"..size..","..year..",'"..mon.."',"..day..");"
    sql = sql.."\n"..cur
  end
end

function connect(server, user, pass)
  dirTree = directoryTree(server, user, pass)

  -- DB
  local dbName = os.date("%y%m%d")..".db"
  local db = sqlite3.open(dbName)
  db:exec[[
  create table file (path, name, size, year, month, day);
  ]]

  close = db_close(db)
  store = db_addRecord(db)
end

connect("127.0.0.1", "ken", "trace")
dirTree("/Download")
close()
