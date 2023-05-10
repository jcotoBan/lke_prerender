FROM alpine:3.14

WORKDIR /app

# Install chromium and node/npm
RUN apk add --no-cache chromium
RUN apk add --update nodejs npm
RUN npm i prerender
RUN npm i prerender-redis-cache
RUN npm i jsonwebtoken
RUN npm i express-jwt
RUN npm i basic-auth
RUN npm i express


# Copy server.js to container
COPY server.js /app/server.js

RUN sed -i "s/process\.env\.REDIS_URL/\"redis:\/\/\" \+ process.env.REDIS_URL \+ \":6379\"/" ./node_modules/prerender-redis-cache/lib/prerenderRedisCache.js

#Expose required port
EXPOSE 8080
EXPOSE 3000

# Run prerender
ENTRYPOINT ["node", "server.js"]
