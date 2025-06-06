# use the official Bun image
FROM oven/bun:1 AS base
WORKDIR /app

# install dependencies
FROM base AS install
COPY web/package.json web/bun.lock web/
RUN cd web && bun install --frozen-lockfile

# build the app
FROM base AS build
COPY --from=install /app/web/node_modules ./web/node_modules
COPY . ./
WORKDIR /app/web
ENV NODE_OPTIONS="--openssl-legacy-provider"
RUN bun run --bun build

# serve the static files
FROM oven/bun:1-alpine AS release
WORKDIR /app
RUN bun add serve
COPY --from=build /app/web/build ./build
EXPOSE 3000
CMD ["bun", "run", "serve", "-s", "build", "-l", "3000"]