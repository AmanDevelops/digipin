# Stage 1: Build
FROM node:20.9.0-bullseye-slim AS builder

# Set working directory
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy application source
COPY . .

# Stage 2: Production
FROM node:20.9.0-bullseye-slim

# Set working directory
WORKDIR /app

# Create a non-root user
RUN useradd --user-group --create-home --shell /bin/false appuser

# Copy dependencies and source from builder
COPY --from=builder /app /app

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 5000

# Define environment variables
ENV NODE_ENV=production
ENV PORT=5000

# Start the application
CMD ["node", "server.js"]
