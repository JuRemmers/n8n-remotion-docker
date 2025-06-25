FROM node:20-bullseye-slim

# Install system packages + Python + pip (+ yt-dlp via pip)
# Combine all apt-get and pip commands into a single RUN instruction for smaller image layers.
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set environment variables for Puppeteer and n8n
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer"
ENV N8N_HOST="0.0.0.0"

WORKDIR /app

# Install n8n globally and the latest Remotion CLI version
RUN npm install -g n8n@latest @remotion/cli@4.0.319

# Copy the Remotion project template
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

WORKDIR /app/remotion-projects/my-template

# Install compatible Remotion packages for the template.
# All @remotion/* packages should align with the main remotion version.
# If your remotion-template has its own package.json and package-lock.json,
# you should replace this with `RUN npm ci`.
RUN npm install remotion@4.0.319 \
            @remotion/media-utils@4.0.319 \
            @remotion/shapes@4.0.319 \
            @remotion/transitions@4.0.319 \
            @remotion/google-fonts@4.0.319 \
            framer-motion \
            styled-components

# Return to the main app directory
WORKDIR /app

# Copy the start script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for n8n (5678) and Remotion (3000, typically for local studio or rendering)
EXPOSE 5678 3000

# Set the entrypoint for the container
ENTRYPOINT ["/start.sh"]
