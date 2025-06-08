# Use Node.js 18 as base image
FROM node:18-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libnss3 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libxss1 \
    libgconf-2-4 \
    libxtst6 \
    libatspi2.0-0 \
    libappindicator3-1 \
    libsecret-1-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome instead of Chromium for better compatibility
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Install yt-dlp
RUN pip3 install yt-dlp

# Set working directory
WORKDIR /app

# Install n8n globally
RUN npm install -g n8n@latest

# Install Remotion globally
RUN npm install -g @remotion/cli@latest

# Create directory structure
RUN mkdir -p /app/workflows /app/remotion-projects /app/downloads /app/renders

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV GENERIC_TIMEZONE=UTC

# Create a basic Remotion project
WORKDIR /app/remotion-projects
RUN npx create-video --template=blank my-template

# Install additional Remotion dependencies that might be needed
WORKDIR /app/remotion-projects/my-template
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions

# Switch back to main app directory
WORKDIR /app

# Create startup script directly in the container
RUN echo '#!/bin/bash\n\
echo "Starting n8n..."\n\
n8n start &\n\
echo "n8n started on port 5678"\n\
echo "You can start Remotion Studio manually if needed:"\n\
echo "  docker exec -it remotion-n8n-container bash"\n\
echo "  cd /app/remotion-projects/my-template"\n\
echo "  npm start"\n\
tail -f /dev/null' > /app/start.sh && chmod +x /app/start.sh

# Expose ports
EXPOSE 5678 3000

# Start services
CMD ["/app/start.sh"]