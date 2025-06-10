#!/bin/bash

# Start n8n in the background
echo "Starting n8n..."
n8n start --host 0.0.0.0 --port 5678 &
N8N_PID=$!

# Wait for n8n to start (optional, but good for robust startup)
# You might need to adjust this delay or implement a proper health check
sleep 10

# Start the Remotion render script
echo "Starting Remotion render..."
node render.mjs

# Wait for the background processes to finish (if they are long-running)
wait $N8N_PID

echo "All processes finished."