# ----------- BUILD STAGE ----------- #
FROM node:20-alpine AS builder

WORKDIR /app

# Copy only package files first (better caching)
COPY app/frontend/package.json app/frontend/package-lock.json* ./

RUN npm ci

# Copy rest of the source
COPY app/frontend/ ./

RUN npm run build


# ----------- RUNTIME STAGE ----------- #
FROM nginx:1.26-alpine AS runtime

RUN apk add --no-cache gettext

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx + entrypoint
COPY docker/frontend/nginx.conf /etc/nginx/nginx.conf
COPY docker/frontend/entrypoint.sh /usr/local/bin/frontend-entrypoint.sh

RUN chmod +x /usr/local/bin/frontend-entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/frontend-entrypoint.sh"]
