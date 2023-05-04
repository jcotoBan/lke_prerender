FROM alpine:3.14

WORKDIR /app

# Install chromium and node/npm
RUN apk add --no-cache chromium
RUN apk add --update nodejs npm
RUN npm i prerender
RUN npm i prerender-memory-cache --save


# Copy server.js to container
COPY server.js /app/server.js

#Expose required port
EXPOSE 8080

# Run prerender
ENTRYPOINT ["node", "server.js"]
