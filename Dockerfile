FROM node:18-alpine

# Install dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    ffmpeg \
    chromium \
    nss \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    bash \
    curl \
    git \
    && rm -rf /var/cache/apk/*

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set working directory
WORKDIR /app

# Install global packages
RUN npm install -g n8n@latest @remotion/cli@latest

# Copy your local Remotion project into the container
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

# Install dependencies inside Remotion project
WORKDIR /app/remotion-projects/my-template
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions

# Go back to app root
WORKDIR /app

# Create a reliable startup script
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'echo "Starting n8n..."' >> /start.sh && \
    echo 'n8n start &' >> /start.sh && \
    echo 'echo "n8n started on port 5678"' >> /start.sh && \
    echo 'echo "To start Remotion Studio manually:"' >> /start.sh && \
    echo 'echo "  docker exec -it <container-name> sh"' >> /start.sh && \
    echo 'echo "  cd /app/remotion-projects/my-template && npm start"' >> /start.sh && \
    echo 'tail -f /dev/null' >> /start.sh && \
    chmod +x /start.sh

# Expose necessary ports
EXPOSE 5678 3000

# Set default command
CMD ["/start.sh"]