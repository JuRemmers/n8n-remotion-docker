# Use Node.js 18 Alpine (much smaller base image)
FROM node:18-alpine

# Install system dependencies and chromium, ffmpeg
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
    # Clean up
    && rm -rf /var/cache/apk/*

# Set environment variables for Puppeteer/Remotion to use chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Set working directory
WORKDIR /app

# Install n8n globally
RUN npm install -g n8n@latest

# Install Remotion CLI globally
RUN npm install -g @remotion/cli@latest

# Create needed directories
RUN mkdir -p /app/workflows /app/remotion-projects /app/downloads /app/renders

# Copy your local remotion project to container
COPY remotion-projects/remotion-template /app/remotion-projects/my-template

# Install additional Remotion dependencies inside the project
WORKDIR /app/remotion-projects/my-template
RUN npm install @remotion/media-utils @remotion/shapes @remotion/transitions

# Switch back to app root
WORKDIR /app

# Create startup script
RUN echo '#!/bin/sh\n\
echo "Starting n8n..."\n\
n8n start &\n\
echo "n8n started on port 5678"\n\
echo "To start Remotion Studio manually:"\n\
echo "  docker exec -it remotion-n8n-container sh"\n\
echo "  cd /app/remotion-projects/my-template"\n\
echo "  npm start"\n\
tail -f /dev/null' > /app/start.sh && chmod +x /app/start.sh

# Expose ports for n8n and Remotion studio
EXPOSE 5678 3000

# Start the container with startup script
CMD ["/app/start.sh"]