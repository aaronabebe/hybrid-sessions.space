# Build step
FROM node:16 as builder
WORKDIR /builder

# Copy everything else
COPY . .

# Install dependencies
RUN npm ci

# Build project
RUN npm run build
RUN npm prune --production


# App step
FROM joseluisq/static-web-server:2.6 as server
WORKDIR /server

# Copy the static files
COPY --from=builder /builder/dist /server

# Start server
CMD [ "--root", "/server" ,"--page404", "/server/index.html", "--security-headers", "true" ]