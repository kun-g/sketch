#! /usr/bin/lua

co = coroutine.create(function ()
  print('hi')
end)
print(co,coroutine.status(co))
coroutine.resume(co)
print(co,coroutine.status(co))
