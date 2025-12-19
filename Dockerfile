# ===============================
# Omada-Webhook-to-Discord
# Non-root Production Dockerfile
# ===============================

# Use official Node.js LTS image
FROM node:20-alpine

# Environment
ENV NODE_ENV=production
ENV PORT=8080

# Create app directory
WORKDIR /app

# Copy package files first (better caching)
COPY package*.json ./

# Install dependencies (as root)
RUN npm ci --omit=dev

# Copy application source
COPY . .

# Ensure .env exists but does not override runtime env vars
# Create empty .env to satisfy process.loadEnvFile()
RUN if [ ! -f .env ]; then touch .env; fi

# Change ownership of app files to node user
RUN chown -R node:node /app

# Switch to non-root user
USER node

# Expose webhook port
EXPOSE 8080

# Healthcheck: verify app is listening
# Depends on port 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD nc -z 127.0.0.1 8080 || exit 1
# Alternative
#HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
#  CMD sh -c 'nc -z 127.0.0.1 "$PORT" || exit 1'

# Start application
CMD ["npm", "start"]