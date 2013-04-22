function forindex(table, key)
  print("forIndex")
  return nil
end
function fornewindex(table, key)
  print("fornewindex")
  return nil
end
function forunaryMinus(table)
  local tbl = {}
  for key, val in ipairs(table) do
    tbl[#table-key+1] = val
  end
  return tbl
end
mt = {}
mt.__unm = forunaryMinus
mt.__index = forindex
mt.__newindex = fornewindex

proxy = {}
function protectIndex(tbl, k, v)
  if(v == nil) then
    return proxy[tbl][k]
  else
    error("attempt to assign to a protected table")
  end
end
function protectNewIndex(tbl, k, v)
  error("attempt to assign to a protected table")
end
function Protect(tbl)
  proxy[tbl] = tbl
  setmetatable(tbl, {__index = protectIndex, __newindex = protectNewIndex})
  tbl = {}
end
table = {"a", "b", "c"}
setmetatable(table, mt)
Protect(table)
print(table[1])
table[1] = 'x'
for i, val in ipairs(-table) do
  print(i, val)
end
table[4] = 'd'
