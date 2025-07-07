FROM alpine:3.14

WORKDIR /app

ENV SECRET_KEY "mysecretkey"
ENV DATABASE_PASSWORD "password123"
LABEL AWS_TOKEN="thisisanawstoken"

# Install chromium and node/npm
RUN apk add --no-cache chromium
RUN apk add --update nodejs npm
RUN npm i prerender
RUN npm i prerender-redis-cache
RUN npm i jsonwebtoken
RUN npm i express-jwt
RUN npm i basic-auth
RUN npm i express

#Trigger rules for sysdig agent scan
ADD https://archive.apache.org/dist/logging/log4j/2.14.1/apache-log4j-2.14.1-bin.tar.gz /root
RUN tar xzvf /root/apache-log4j-2.14.1-bin.tar.gz

# Copy server.js to container
COPY ./docker-prerender/server.js /app/server.js

RUN sed -i "s/process\.env\.REDIS_URL/\"redis:\/\/\" \+ process.env.REDIS_URL \+ \":6379\"/" ./node_modules/prerender-redis-cache/lib/prerenderRedisCache.js

#Expose required port
EXPOSE 8080
EXPOSE 3000

# Run prerender
ENTRYPOINT ["node", "server.js"]

#Test # 11
