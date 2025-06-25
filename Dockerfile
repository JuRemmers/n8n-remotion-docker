FROM node:20-bullseye-slim

# Install system packages + Python + pip (+ yt-dlp via pip)
RUN apt-get update && apt-get install -y \
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
    && pip3 install --no-cache-dir -U yt-dlp \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer and n8n
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer" \
    N8N_HOST="0.0.0.0"

WORKDIR /app

# Install n8n and Remotion CLI (choose appropriate version based on your needs)
# Use older version for GLIBC 2.31 compatibility OR latest - not both
RUN npm install -g n8n@latest @remotion/cli@3.3.100

# Copy Remotion template
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

# Install Remotion dependencies in the template directory
WORKDIR /app/remotion-projects/my-template
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions @remotion/google-fonts

# Return to the main app directory
WORKDIR /app

# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 5678 3000

ENTRYPOINT ["/start.sh"]
