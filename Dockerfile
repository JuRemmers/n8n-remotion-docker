FROM node:22-bookworm-slim
# install system packages + Python + pip (+ yt-dlp via pip)
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
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer"
ENV N8N_HOST="0.0.0.0"
WORKDIR /app
# Install older Remotion version that works with Bullseye/GLIBC 2.31
RUN npm install -g n8n@latest @remotion/cli@latest
COPY remotion-projects/remotion-template /app/remotion-projects/my-template
WORKDIR /app/remotion-projects/my-template
# Install compatible Remotion packages (some packages may not exist in 3.3.100)
RUN npm install remotion@3.3.100 @remotion/media-utils@3.3.100 framer-motion styled-components
# Return to the main app directory
WORKDIR /app
# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh
EXPOSE 5678 3000
ENTRYPOINT ["/start.sh"]
