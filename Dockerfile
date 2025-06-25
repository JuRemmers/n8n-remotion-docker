FROM node:22-bookworm-slim

# Install system dependencies and Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    ffmpeg \
    chromium \
    ca-certificates \
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
    curl \
    && pip3 install --no-cache-dir --break-system-packages -U yt-dlp \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer"
ENV N8N_HOST="0.0.0.0"

# Set working directory
WORKDIR /app

# Install global packages
RUN npm install -g n8n@latest @remotion/cli@4.0.313

# Copy Remotion template
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

WORKDIR /app/remotion-projects/my-template

# Install Remotion template dependencies
RUN npm install remotion@4.0.313 \
            @remotion/media-utils@4.0.313 \
            @remotion/shapes@4.0.313 \
            @remotion/transitions@4.0.313 \
            @remotion/google-fonts@4.0.313 \
            framer-motion \
            styled-components

# Back to main directory
WORKDIR /app

# Copy and set permissions on startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose necessary ports
EXPOSE 5678 3000

# Define startup entrypoint
ENTRYPOINT ["/start.sh"]
