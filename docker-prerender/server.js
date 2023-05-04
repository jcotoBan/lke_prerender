#!/usr/bin/env node
var prerender = require('prerender');

var server = prerender({
  chromeFlags: ['--no-sandbox','--headless', '--disable-gpu', '--remote-debugging-port=9222', '--hide-scrollbars'],
  chromeLocation: '/usr/bin/chromium-browser',
  port: 8080 
});

server.use(prerender.sendPrerenderHeader());
server.use(prerender.browserForceRestart());
// server.use(prerender.blockResources());
server.use(prerender.addMetaTags());
server.use(prerender.removeScriptTags());
server.use(prerender.httpHeaders());

server.use(require('prerender-memory-cache'));

server.start();
