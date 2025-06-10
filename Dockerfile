FROM node:18-bullseye-slim

# Install dependencies for chromium to run
RUN apt-get update && apt-get install -y \
    python3 \
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
    && rm -rf /var/lib/apt/lists/*

# Set env vars (adjust if needed)
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Continue as you had...
WORKDIR /app

RUN npm install -g n8n@latest @remotion/cli@latest

COPY remotion-projects/remotion-template /app/remotion-projects/my-template

WORKDIR /app/remotion-projects/my-template
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions

WORKDIR /app

# start.sh same as before

EXPOSE 5678 3000

CMD /start.sh