#!/bin/sh
set -euo pipefail

TEMPLATE=/usr/share/nginx/html/index.html
if [ -n "${DATA_API_URL:-}" ]; then
  envsubst '${DATA_API_URL}' < "$TEMPLATE" > "$TEMPLATE.tmp"
  mv "$TEMPLATE.tmp" "$TEMPLATE"
fi
exec nginx -g 'daemon off;'
