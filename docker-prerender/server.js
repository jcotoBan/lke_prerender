#!/usr/bin/env node
var prerender = require('prerender');
const redis = require('redis');
const MemoryCachePlugin = require('prerender-redis-cache');
const jwt = require('jsonwebtoken');
const { expressjwt: expressJwt } = require('express-jwt');
const basicAuth = require('basic-auth');
const express = require('express');


const redisClient = redis.createClient({
  host: process.env.REDIS_URL,
  port: 6379
});



const app = express();

var server = prerender({
  chromeFlags: ['--no-sandbox','--headless', '--disable-gpu', '--remote-debugging-port=9222', '--hide-scrollbars'],
  chromeLocation: '/usr/bin/chromium-browser', //remove -browser to test local
  port: 8080
});

//all env vars
const jwtSecret = process.env.JWT_TOKEN;
const user = process.env.ADMIN_USERNAME;
const password = process.env.ADMIN_PASSWORD;

const authenticateJwt = expressJwt({
  secret: jwtSecret,
  algorithms: ["HS256"],
});

server.use(MemoryCachePlugin);
server.use(prerender.sendPrerenderHeader());
server.use(prerender.browserForceRestart());
server.use(prerender.blockResources());
server.use(prerender.addMetaTags());
server.use(prerender.removeScriptTags());
server.use(prerender.httpHeaders());

app.get('/generate-jwt', (req, res) => {
  const credentials = basicAuth(req);
  if (!credentials || credentials.name !== user || credentials.pass !== password) {
    res.status(401).send('Unauthorized');
    return;
  }
  const token = jwt.sign({}, jwtSecret, { expiresIn: '3d' });
  res.json({ token });
});

//Clear cache
app.get('/clear-cache', authenticateJwt, (req, res) => {
  const key = req.headers['key'];
  redisClient.del(key, (err, response) => {
    if (err) {
      console.log(err);
      res.status(500).send('Error clearing cache');
      return;
    }
    if (response === 0) {
      res.status(404).send('Key not found in cache');
      return;
    }
    res.status(204).send('Cache for the respective key cleared');
  });
});


//Get keys
app.get('/get-keys', authenticateJwt, (req, res) => {
  redisClient.keys('*', (err, keys) => {
    if (err) {
      console.error('Redis error:', err);
      return res.status(500).json({ error: 'Internal server error' });
    }
    return res.json({ keys });
  });
});

server.use(prerender.basicAuth());

server.start();

app.listen(3000, () => {
  console.log('Server started on port 3000');
});

