# Use Debian Bookworm (Debian 12) as the base, which has a newer GLIBC
FROM node:20-bookworm-slim

# --- Stage 1: Install core system dependencies for rendering and n8n ---
# Removed 'chromium-browser' from the apt-get install list.
# Puppeteer will now download its own compatible Chromium binary.
# The 'lib*' packages are still needed as they are common dependencies for ANY headless browser (even Puppeteer's downloaded one).
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    fonts-liberation \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir -U yt-dlp

# Set environment variables for Remotion and n8n.
# CRITICAL: REMOVED PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# and PUPPETEER_EXECUTABLE_PATH. This tells Puppeteer to download its own Chromium.
ENV REMOTION_BROWSER_ARGS="--no-sandbox --disable-gpu --disable-software-rasterizer"
ENV N8N_HOST="0.0.0.0"

# --- Stage 2: Install Global n8n CLI ---
RUN npm install -g n8n@latest

# --- Stage 3: Setup Remotion Project ---
WORKDIR /app
RUN mkdir -p /app/remotion-projects/my-template
COPY remotion-projects/remotion-template/package.json \
     remotion-projects/remotion-template/package-lock.json \
     /app/remotion-projects/my-template/
WORKDIR /app/remotion-projects/my-template
RUN npm ci --omit=dev --loglevel=error
COPY remotion-projects/remotion-template/ .

# --- Stage 4: Prepare Startup Script ---
WORKDIR /app
COPY start.sh /start.sh
RUN chmod +x /start.sh

# --- Final Configuration ---
EXPOSE 5678 3000

ENTRYPOINT ["/start.sh"]
