FROM node:20-bookworm-slim

# Install basic packages first
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install media packages
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Install Chromium and dependencies
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp
RUN pip3 install --no-cache-dir -U yt-dlp

# Set environment variables for Puppeteer and n8n
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer" \
    N8N_HOST="0.0.0.0"

WORKDIR /app

# Install n8n and Remotion CLI
RUN npm install -g n8n@latest @remotion/cli@latest

# Copy Remotion template
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

WORKDIR /app/remotion-projects/my-template

# Check if package.json exists and install dependencies
RUN if [ ! -f package.json ]; then npm init -y; fi && \
    npm install --legacy-peer-deps @remotion/media-utils @remotion/shapes @remotion/transitions @remotion/google-fonts framer-motion styled-components

# Return to the main app directory
WORKDIR /app

# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5678 3000

ENTRYPOINT ["/start.sh"]
