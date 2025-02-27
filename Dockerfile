### Stage 1: Build the Next.js App
FROM node:20.18.3-alpine3.21 AS builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY . .
RUN npm run build && npm prune --production

### Stage 2: Create a minimal runtime image
FROM node:20.18.3-alpine3.21 AS runner

WORKDIR /app

COPY --from=builder /app/.next/standalone . 
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000
CMD ["node", "server.js"]
