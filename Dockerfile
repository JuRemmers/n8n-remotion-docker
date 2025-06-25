FROM node:22-bookworm-slim

# Install Chrome dependencies
RUN apt-get update && apt-get install -y \
    libnss3 \
    libdbus-1-3 \
    libatk1.0-0 \
    libgbm-dev \
    libasound2 \
    libxrandr2 \
    libxkbcommon-dev \
    libxfixes3 \
    libxcomposite1 \
    libxdamage1 \
    libatk-bridge2.0-0 \
    libpango-1.0-0 \
    libcairo2 \
    libcups2 \
    python3 \
    python3-pip \
    ffmpeg \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp
RUN pip3 install --no-cache-dir -U yt-dlp

# Install n8n and Remotion CLI globally
RUN npm install -g n8n@latest @remotion/cli@latest

# Set environment variables for n8n
ENV N8N_HOST="0.0.0.0"

WORKDIR /app

# Copy Remotion template files
COPY remotion-projects/remotion-template/package.json remotion-projects/remotion-template/package*.json remotion-projects/remotion-template/yarn.lock* remotion-projects/remotion-template/pnpm-lock.yaml* remotion-projects/remotion-template/bun.lockb* remotion-projects/remotion-template/bun.lock* remotion-projects/remotion-template/tsconfig.json* remotion-projects/remotion-template/remotion.config.* ./remotion-projects/my-template/

# Copy Remotion template source
COPY remotion-projects/remotion-template/src ./remotion-projects/my-template/src

# Copy public folder if it exists (optional)
COPY remotion-projects/remotion-template/public* ./remotion-projects/my-template/ || true

# Install Remotion dependencies
WORKDIR /app/remotion-projects/my-template
RUN npm install

# Install Chrome through Remotion
RUN npx remotion browser ensure

# Add additional Remotion packages
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions @remotion/google-fonts framer-motion styled-components

# Return to main directory
WORKDIR /app

# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5678 3000

ENTRYPOINT ["/start.sh"]
