FROM node:22-bookworm-slim

# Install system packages + Python + pip + Chrome dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    ca-certificates \
    fonts-liberation \
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
    libxss1 \
    libgtk-3-0 \
    libx11-xcb1 \
    libgbm1 \
    curl \
    && pip3 install --no-cache-dir -U yt-dlp \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer and n8n
ENV REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer"
ENV N8N_HOST="0.0.0.0"

WORKDIR /app

# Install n8n and Remotion CLI globally
RUN npm install -g n8n@latest @remotion/cli@3.3.100

# Copy remotion project files
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

WORKDIR /app/remotion-projects/my-template

# Copy package files for dependency installation
COPY package.json package*.json yarn.lock* pnpm-lock.yaml* bun.lockb* bun.lock* tsconfig.json* remotion.config.* ./

# Copy source and public folders
COPY src ./src
COPY public ./public

# Install compatible Remotion packages
RUN npm install remotion@3.3.100 @remotion/media-utils@3.3.100 framer-motion styled-components

# Install Chrome for Remotion
RUN npx remotion browser ensure

# Return to the main app directory
WORKDIR /app

# Copy the render script and start script
COPY render.mjs render.mjs
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for n8n and Remotion
EXPOSE 5678 3000

ENTRYPOINT ["/start.sh"]
