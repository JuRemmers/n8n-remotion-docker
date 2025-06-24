# Use Debian Bookworm (Debian 12) as the base, which has a newer GLIBC
FROM node:20-bookworm-slim

# --- Stage 1: Install core system dependencies for rendering and n8n ---
# Install system packages. Replaced 'chromium' with 'chromium-browser'.
# Added --no-install-recommends for smaller image.
# Sorted packages for readability.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    chromium-browser \  # Corrected package name for Bookworm
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
    python3-pip \
    # Clean up apt cache to keep image small
    && rm -rf /var/lib/apt/lists/* \
    # Install yt-dlp after python and pip are ready
    && pip3 install --no-cache-dir -U yt-dlp

# --- Stage 2: Install Global n8n CLI ---
# Install n8n globally (as per your existing setup)
RUN npm install -g n8n@latest

# --- Stage 3: Setup Remotion Project ---
# Create the root app directory
WORKDIR /app

# Create the Remotion project's parent directory
RUN mkdir -p /app/remotion-projects/my-template

# Copy only package.json and package-lock.json first for better caching
# Adjust 'remotion-projects/remotion-template' to your actual project path relative to Dockerfile context
COPY remotion-projects/remotion-template/package.json \
     remotion-projects/remotion-template/package-lock.json \
     /app/remotion-projects/my-template/

# Change to Remotion project directory
WORKDIR /app/remotion-projects/my-template

# Install Remotion project dependencies using npm ci for reproducibility
# Ensure @remotion/cli is NOT installed globally, but as a dev/prod dep in package.json
# Your package.json already pins Remotion versions, which is good.
RUN npm ci --omit=dev --loglevel=error # --omit=dev for smaller image, --loglevel for less noise

# Copy the rest of the Remotion project files, including src/ and public/
COPY remotion-projects/remotion-template/ .

# --- Stage 4: Prepare Startup Script ---
# Return to the main app directory (if start.sh expects it)
WORKDIR /app

# Copy the start script and make it executable
# Assuming start.sh is in the same directory as the Dockerfile
COPY start.sh /start.sh
RUN chmod +x /start.sh

# --- Final Configuration ---
EXPOSE 5678 3000 # n8n and Remotion internal server port

ENTRYPOINT ["/start.sh"]
