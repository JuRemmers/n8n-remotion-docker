FROM node:20-alpine

# Install system packages
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    chromium \
    curl \
    ca-certificates \
    font-noto \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont

# Install yt-dlp
RUN pip3 install --no-cache-dir -U yt-dlp

# Set environment variables for Puppeteer and n8n
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer --disable-dev-shm-usage" \
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
