print("===== 1 =====")
function retriveChar(str)
  local cur = 0
  local stringLen = #str
  return function()
	if(cur ==  stringLen) then
	  return nil
  	end
  	cur = cur+1
  	return cur, string.sub(str, cur, cur)
	end
end
function dissect(str)
  local tbl = {}
  for key, var in retriveChar(str) do
    tbl[key] = var
  end
  return tbl
end
function printTable(tbl)
  for key, var in ipairs(tbl) do
    print(key, var)
  end 
end
printTable(dissect("I'm a programmer"))
print("===== 2 =====")
Frmt = "%6s\n"
for _, Name in ipairs({"Lynn", "Jeremy", "Sally"}) do
  io.write(string.format(Frmt, Name))
end
print("===== 3 =====")
function DictCmp(str0, str1)
  local cur = 1
  while(true) do
    if(string.byte(str0, cur, cur) < string.byte(str1, cur, cur)) then
      return true
    elseif (string.byte(str0, cur, cur) > string.byte(str1, cur, cur)) then
      return false
    end
    cur = cur+1
  end
end
Names = {"Defoe", "Deforest", "Degas", "de Forest"}
table.sort(Names, DictCmp)
for _, Name in ipairs(Names) do
  print(Name)
end
print("===== 4 =====")
function doInterpret(str)
  local theFunc = loadstring("return "..str)
  return theFunc()
end
theCMD = io.read
while not(theCMD == "quit") do   
  theCMD = io.read()
  print(doInterpret(theCMD))
end
print("===== 5 =====")
function TrimRight(str)
  return (string.gsub(str, "%s+$", ""))
end
function TrimLeft(str)
  return (string.gsub(str, "^%s", ""))
end
tarString = "  a  b  c  "
print(tarString)
print("TrimRight:"..TrimRight(tarString))
print("TrimLeft:"..TrimLeft(tarString))
print("===== 6 =====")
print("===== 7 =====")
function Interpolate(str)
  -- retrive the global variables
  Ret = str
  for key, var in string.gmatch(str, "%$(%a+)") do
    Ret = string.gsub(Ret, "%$"..key, string.tostring(doInterpret(key)))
  end
  return Ret
end
Where, Who, What = "in xanadu", "kubla khan", "a stately pleasure-dome"
print(Interpolate("$Where did $Who\n$What decree"))
print(Interpolate("string = $string, asdf = $asdf"))
