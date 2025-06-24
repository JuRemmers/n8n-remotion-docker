# --- Stage 1: Build Stage ---
# Use the full Node.js image to build our dependencies, as it includes build tools.
FROM node:20-bookworm as builder

# Install system dependencies needed for 'npm ci' and Remotion's browser download
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    python3 \
    # Add git, as it can be a dependency for some npm packages
    git && \
    rm -rf /var/lib/apt/lists/*

# Set up the application directory
WORKDIR /app

# Install n8n globally within this stage
RUN npm install -g n8n@latest

# Copy package files for the Remotion project
COPY remotion-projects/remotion-template/package.json \
     remotion-projects/remotion-template/package-lock.json \
     ./remotion-projects/my-template/

# Set the working directory for the Remotion project
WORKDIR /app/remotion-projects/my-template

# Install npm dependencies. We don't --omit=dev here so Puppeteer/Remotion can download its browser
RUN npm ci --loglevel=error

# Copy the rest of the Remotion project source code
COPY remotion-projects/remotion-template/ .


# --- Stage 2: Final Runtime Stage ---
# Start from the slim image for a smaller final size
FROM node:20-bookworm-slim

# Install ONLY the necessary runtime system dependencies for rendering and ffmpeg.
# Alphabetized for readability. We are adding back libgbm1 and including a full font set.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    fonts-liberation \
    fonts-noto-color-emoji \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxkbcommon0 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    python3 \
    python3-pip \
    xdg-utils && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install --no-cache-dir -U yt-dlp

# Set environment variables for Remotion and n8n
ENV REMOTION_BROWSER_ARGS="--no-sandbox"
ENV N8N_HOST="0.0.0.0"
# Tell Remotion where to find the browser downloaded in the builder stage
ENV REMOTION_CHROME_BINARY="/usr/bin/google-chrome"

# Set the working directory
WORKDIR /app

# Copy the globally installed n8n from the builder stage
COPY --from=builder /usr/local/bin/n8n /usr/local/bin/n8n
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Copy the fully installed Remotion project from the builder stage
COPY --from=builder /app/remotion-projects/my-template /app/remotion-projects/my-template

# Copy the startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for n8n and Remotion Studio (if used)
EXPOSE 5678 3000

# Set the entrypoint to the startup script
ENTRYPOINT ["/start.sh"]
