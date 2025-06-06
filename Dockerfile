# use the official Bun image
FROM oven/bun:1 AS base
WORKDIR /app

# install dependencies
FROM base AS install
COPY diplomacy/web/package.json diplomacy/web/bun.lock diplomacy/web/
RUN cd diplomacy/web && bun install --frozen-lockfile

# build the app
FROM base AS build
COPY --from=install /app/diplomacy/web/node_modules ./diplomacy/web/node_modules
COPY diplomacy ./diplomacy
WORKDIR /app/diplomacy/web
ENV NODE_OPTIONS="--openssl-legacy-provider"
RUN bun run --bun build

# serve the static files
FROM oven/bun:1-alpine AS release
WORKDIR /app
RUN bun add serve
COPY --from=build /app/diplomacy/web/build ./build
EXPOSE 3000
CMD ["bun", "run", "serve", "-s", "build", "-l", "3000"]