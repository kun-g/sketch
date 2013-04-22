print("========= Exercise 1 ===========")
A = {}
B = "C"
C = "B"
D = {
  [A] = {B = C},
  [B] = {[C] = B},
  [C] = {[A] = A}}
print(D.C["B"])

print("========= Exercise 2 ===========")
-- 将不同的类型分开
function supperCmp(arg0, arg1)
  typeOrder={[type(false)] = 1, 
	[type(1)] = 2,
	[type(1.0)] = 3,
	[type("string")] = 4,
	[type({})] = 5,
	[type(function () end)] = 6,}
  if type(arg0) == type(arg1) then
    if type(arg0) == type(true) then
      return arg0
    else
      return arg0 < arg1
    end
  else
    return typeOrder[type(arg0)] < typeOrder[type(arg1)]
  end
end
tarTable = { "", "a", "b", "c", 1, 2, 3, -100, 1.1, false, false, true}
table.sort(tarTable, supperCmp)
for _, var in ipairs(tarTable) do
  print(var)
end
print("========= Exercise 3 ===========")
function Sprint(...)
  ret = ""
  for _, var in ipairs(arg) do
    ret = ret..tostring(var).."\t"
  end
  return ret
end
print(Sprint("Hi", {}, nil))
print("========= Exercise 4 ===========")
print("========= Exercise 5 ===========")
