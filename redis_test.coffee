co = require('co')
redisClient = require('redis').createClient(19736, '10.170.168.191')
wrapper = require('co-redis')
redisCo = wrapper(redisClient)
co ->
  select_result= yield redisCo.select(15)
  publish_result= yield redisCo.publish('test', 33)
  console.log(yield redisCo.subscribe('test'), 'but')
  console.log select_result, publish_result
