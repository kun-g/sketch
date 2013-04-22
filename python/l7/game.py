# coding:utf-8
girl = {'name':'Alice',
    'characteristic':{
      '智':1,
      '勇':1,
      '仁':1,
      '义':1,
      '灵':2,
      }
    }
boy = { 'name':'Bob',
    '技巧':2,
    'characteristic':{
      '智':1,
      '勇':1,
      '仁':1,
      '义':1,
      '灵':1,
      }
    }

def valueCheck(girl, boy):
  for c in girl['characteristic']:
    if girl['characteristic'][c] > boy['characteristic'][c]+boy['技巧']:
      return False
  return True

def persuit(boy, girl):
  print boy['name']+' is persuiting '+girl['name']
  if valueCheck(girl, boy):
    return boy['name']+' and '+girl['name']+' sit under a tree, KISSING'
  else:
    return boy['name']+' is forever alone'


print persuit(boy, girl)
