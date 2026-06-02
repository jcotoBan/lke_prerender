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

# Pin vulnerable transitive deps to safe versions (Sysdig CVE remediation)
RUN npm i qs@6.14.2 ws@7.5.10 body-parser@1.20.3 path-to-regexp@0.1.13 jws@3.2.3 uuid@11.1.1 redis@3.1.1

#Trigger rules for sysdig agent scan
ADD https://archive.apache.org/dist/logging/log4j/2.25.4/apache-log4j-2.25.4-bin.tar.gz /root
RUN tar xzvf /root/apache-log4j-2.25.4-bin.tar.gz

# Copy server.js to container
COPY ./docker-prerender/server.js /app/server.js

RUN sed -i "s/process\.env\.REDIS_URL/\"redis:\/\/\" \+ process.env.REDIS_URL \+ \":6379\"/" ./node_modules/prerender-redis-cache/lib/prerenderRedisCache.js

#Expose required port
EXPOSE 8080
EXPOSE 3000

# Run prerender
ENTRYPOINT ["node", "server.js"]

#Test #16
