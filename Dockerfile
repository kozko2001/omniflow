FROM node:19-alpine as build


RUN npm install -g pnpm

WORKDIR /app
COPY --chown=node:node server/pnpm-lock.yaml server/package*.json ./

RUN pnpm install --frozen-lockfile

COPY --chown=node:node ./server/ .

ENV NODE_ENV production
RUN pnpm run build


FROM node:19-alpine as final

COPY --chown=node:node --from=build /app/node_modules ./node_modules
COPY --chown=node:node --from=build /app/dist ./dist

# Start the server using the production build
USER node
CMD [ "node", "dist/main.js" ]
