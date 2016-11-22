// Generated by CoffeeScript 1.11.1
(function() {
  var Router, app, cors, fs, koa, logger, path, route, subscribe;

  koa = require('koa');

  fs = require('fs');

  path = require('path');

  Router = require('koa-router');

  logger = require('koa-logger');

  cors = require('koa-cors');

  subscribe = require('redis-subscribe-sse');

  app = new koa();

  app.use(cors());

  app.use(logger());

  route = new Router();

  route.get('/', function*() {
    this.type = 'text/html; charset=utf-8';
    this.body = fs.createReadStream(__dirname + "/index.html");
  });

  route.get('/rewardhandle', function*() {
    console.log('hahha00000');
    this.req.setTimeout(Number.MAX_VALUE);
    this.type = 'text/event-stream; charset=utf-8';
    this.set('Cache-Control', 'no-cache');
    this.set('Connection', 'keep-alive');
    this.body = subscribe({
      channels: ['rewardlist'],
      retry: 10000,
      ioredis: {
        host: '10.170.168.191',
        port: 19736,
        db: 15
      },
      channelsAsEvents: true
    });
  });

  app.use(route.routes());

  app.listen(9000, function() {
    return console.log('Koa listening on port 9000');
  });

}).call(this);