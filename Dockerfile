# Use a Node.js base image with Bookworm (Debian 12)
FROM node:22-bookworm-slim

# Set working directory inside the container
WORKDIR /app

# Install Chrome dependencies for Remotion, plus Python/ffmpeg for yt-dlp
# We do this in a single RUN command to optimize Docker layer caching and reduce image size
RUN apt-get update && apt-get install -y \
  libnss3 \
  libdbus-1-3 \
  libatk1.0-0 \
  libgbm-dev \
  libasound2 \
  libxrandr2 \
  libxkbcommon-dev \
  libxfixes3 \
  libxcomposite1 \
  libxdamage1 \
  libatk-bridge2.0-0 \
  libpango-1.0-0 \
  libcairo2 \
  libcups2 \
  python3 \
  python3-pip \
  ffmpeg \
  # Clean up apt caches to reduce image size after installation
  && rm -rf /var/lib/apt/lists/*

# Copy package manager files and install Node.js dependencies first for caching
# This layer only changes if package.json or lock files change
COPY package.json package*.json yarn.lock* pnpm-lock.yaml* bun.lockb* bun.lock* ./
RUN npm i

# Install Chrome for Remotion (this uses Puppeteer's internal mechanism)
RUN npx remotion browser ensure

# Install n8n globally
RUN npm install -g n8n@latest

# Install yt-dlp using pip
# Using pip for yt-dlp often provides the latest version with necessary dependencies.
RUN pip3 install -U "yt-dlp[default]"

# Copy all application files
# This copies your source code, Remotion projects, and render script
# We are assuming 'downloads' and 'workflows' folders might be used at runtime,
# but if they contain large static assets, consider adding them to .dockerignore or copying only specific needed files.
COPY src ./src
COPY public ./public
COPY remotion-projects/remotion-template /app/remotion-projects/my-template
COPY render.mjs ./render.mjs
COPY workflows ./workflows # If your n8n expects workflows to be present at boot
# Assuming 'downloads' is for output/runtime, no need to copy it from host unless it contains required input files
# If you need an empty 'downloads' directory to exist, create it:
RUN mkdir -p /app/downloads


# Set n8n related environment variables
# N8N_HOST and N8N_PORT are used by the n8n start command in start.sh
ENV N8N_WEBHOOK_URL="http://localhost:5678" # Adjust for your public URL on Railway (e.g., https://${RAILWAY_PUBLIC_DOMAIN})
ENV N8N_DATA_FOLDER="/home/node/.n8n" # Default n8n data folder, important for Railway volume

# Environment variables for Puppeteer/Remotion if needed to override browser path
# npx remotion browser ensure usually handles this, so these might not be strictly necessary,
# but can be helpful for debugging if Remotion struggles to find the browser.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
# You might need to inspect where npx remotion browser ensure puts the browser if it's not detected automatically.
# Often it's within node_modules or a global npm prefix.
# If you run into issues, try: RUN find / -name "chrome" 2>/dev/null to locate the executable.
# For now, let's assume Remotion finds it.

# Copy the start script and make it executable
COPY start.sh ./start.sh
RUN chmod +x ./start.sh

# Expose ports for n8n (5678) and potentially Remotion development server (3000)
EXPOSE 5678 3000

# Use the start script as the entry point
CMD ["./start.sh"]