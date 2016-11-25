koa= require 'koa'
fs= require 'fs'
path= require 'path'
Router= require 'koa-router'
logger= require 'koa-logger'
cors= require 'koa-cors'

subscribe= require 'redis-subscribe-sse'

app= new koa()

app.use cors()
app.use logger()

route= new Router()

route.get '/sse', ->
    @type= 'text/html; charset=utf-8'
    @body= fs.createReadStream "#{__dirname}/index.html"
    yield return

route.get '/sse/rewardhandle', ->
    @req.setTimeout Number.MAX_VALUE
    @type= 'text/event-stream; charset=utf-8'

    @set 'Cache-Control', 'no-cache'
    @set 'Connection', 'keep-alive'
    @set 'X-Accel-Buffering', 'no'

    # local config
    #@body= subscribe {
    #    channels: ['rewardlist']
    #    retry: 10000
    #    host: '10.171.131.37'
    #    port: 16379
    #    redisdb: 15
    #    channelsAsEvents: true
    #}
    @body= subscribe {
        channels: ['rewardlist']
        retry: 10000
        ioredis: {
          host: '10.171.131.37'
          port: 16379
          db: 15
        }
        channelsAsEvents: true
    }
    # production config
    #@body= subscribe {
    #    channels: ['test']
    #    retry: 10000
    #    host: '127.0.0.1'
    #    port: 6379
    #    #host: '10.170.168.191'
    #    #port: 19736
    #    #clientOptions: { db: 15 }
    #    channelsAsEvents: true
    #}
    yield return
app.use route.routes()

app.listen 9000, -> console.log 'Koa listening on port 9000'

