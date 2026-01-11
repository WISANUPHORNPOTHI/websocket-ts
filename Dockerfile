# 1. Install dependencies
FROM node:18 AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

# 2. Build TypeScript (NO tsc binary)
FROM node:18 AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# เรียก tsc ผ่าน node ตรง ๆ (ไม่โดน permission)
RUN node node_modules/typescript/lib/tsc.js

# 3. Run server
FROM node:18 AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD ["node", "dist/server.js"]
