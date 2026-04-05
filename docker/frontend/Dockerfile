FROM node:20-alpine AS builder
WORKDIR /app
COPY app/frontend/package.json app/frontend/package-lock.json* ./
COPY app/frontend ./
RUN npm install && npm run build

FROM nginx:1.26-alpine AS runtime
RUN apk add --no-cache gettext
COPY --from=builder /app/dist /usr/share/nginx/html
COPY docker/frontend/nginx.conf /etc/nginx/nginx.conf
COPY docker/frontend/entrypoint.sh /usr/local/bin/frontend-entrypoint.sh
RUN chmod +x /usr/local/bin/frontend-entrypoint.sh
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/frontend-entrypoint.sh"]
