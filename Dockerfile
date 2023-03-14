# Build stage
FROM node:16 AS builder

WORKDIR /usr/src/app

# Copy admin package.json and lockfile
COPY package.json ./
COPY yarn.lock ./

RUN yarn install --frozen-lockfile

# Copy app source
COPY src ./src
COPY next.config.js .
COPY tsconfig.json .

RUN yarn build

# Final stage
FROM node:16

WORKDIR /usr/src/app

# Copy built artifacts from the builder stage
COPY --from=builder /usr/src/app/.next ./.next

# Copy admin package.json and lockfile
COPY package.json ./
COPY yarn.lock ./

RUN yarn install --frozen-lockfile --production

EXPOSE 8000

CMD [ "yarn", "start" ]
