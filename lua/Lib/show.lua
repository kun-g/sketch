-- This function conditions a key or value for display
show = show or {}

local function LclRenderStr(obj, truncLen)
  local tpStr = type(obj)
  if(tpStr == "string") then
    obj = string.gsub(obj, "[^%w%p ]", function (ch)
      return "\\" .. string.format("%03d", string.byte(ch))
    end)
    if(truncLen and truncLen > 0 and string.len(obj) > truncLen+3) then
      -- This could misleadingly truncate numeric escape value
      obj = string.sub(obj, 1, truncLen) .. "..."
    end
    obj = '"' .. obj .. '"'
  elseif (tpStr == "boolean") then
    obj = "boolean:" .. tostring(obj)
  else
    obj = tostring(obj)
  end
  return obj
end

-- This function replaces ["x"]["y"] stubble with x.y. Keys are assumed
-- to be identifier-compatible.
local function LclShave(str)
  local count
  str, count = string.gsub(str, '^%[%"(.+)%"%]$', '%1')
  if(count == 1) then
    str = string.gsub(str, '%"%]%[%"', '.')
  end
  return str
end

local function LclRender(tbl, val, keyStr, truncLen, lvl, visited, keyPathStr)
  local vtpStr, valStr
  vtpStr = type(val)
  if(visited[val]) then
    valStr = "same as " .. visited[val]
  else
    valStr = LclRenderStr(val, truncLen)
    if(vtpStr == "function") then
      local env = getfenv(val)
      env = visited[env] or env
      valStr = string.gsub(valStr, "(function:%s*.*)$", "%1 (env " ..
      	string.gsub(tostring(env), "table: ", "") .. ")")
    elseif (vtpStr == "table") then
      valStr = valStr .. string.format(" (n = %d)", #val)
    end
  end
  keyPathStr = keyPathStr .. "[" .. keyStr .. "]"
  table.insert(tbl, { lvl, string.format('[%s] %s', keyStr, valStr) })
  if(vtpStr == "table" and not visited[val]) then
    visited[val] = LclShave(keyPathStr)
    local srtTbl = {}
    for k, v in pairs(val) do
      table.insert(srtTbl, { LclRenderStr(k, truncLen), v, k, type(k) } )
    end
    local function LclCmp(a, b)
      local cmp
      local ta, tb = a[4], b[4]
      if(ta == "number") then
	if(tb == "number") then
          cmp = a[3] < b[3]
	else
	  cmp = true -- numbers appear first
	end
      else
        if(tb == number) then
          cmp = false
	else
	  cmp = a[1] < b[1]
        end
      end
      return cmp
    end
    table.sort(srtTbl, LclCmp)
    for j, rec in ipairs(srtTbl) do
      LclRender(tbl, rec[2], rec[1], truncLen, lvl + 1, visited, keyPathStr)
    end
  end
end

-- This function appends a series of records of the form { level, 
-- description_string } to the indexed table specified by tbl. When this
-- function returns, tbl can be used to inspect the Lua object specified by 
-- val. key specifies the name of the object. truncLen specifies the maximum
-- lenth of each description string; if this value is zero, no truncation will
-- take place. keys are sorted natively (that is, numbers are sorted numerically
-- and everything else lexically). String values are displayed with quotes, 
-- numbers are unadorned, and all orhter values have an identifying prefix such
-- as "boolean". comsequently, all keys are displayed within their type
-- patition. This function returns nothing; its only effect is to augment tbl
function show.ObjectDescribe(tbl, val, key, truncLen)
  LclRender(tbl, val, LclRenderStr(key, truncLen), truncLen or 0, 1, {}, "")
end

-- this function prints a hierarchical summary of the object specified by val
-- to standard out. See ObjectDescribe for more details.
function show.ObjectShow(val, key, truncLen)
  local tbl = {}
  show.ObjectDescribe(tbl, val, key, truncLen)
  for j, rec in ipairs(tbl) do
    io.write(string.rep("  ", rec[1] - 1), rec[2], "\n")
  end
end
show.ObjectShow(table, "table")
--print(LclRenderStr(_G, 0))
