#!/bin/sh
set -e
echo "Starting n8n..."
echo "n8n will be available on port 5678"
echo ""
echo "Remotion project is mounted at /app/remotion-projects/my-template"
echo "To run Remotion Studio manually:"
echo "  docker exec -it <container-name> sh"
echo "  cd /app/remotion-projects/my-template"
echo "  npm start"
echo ""
echo "Service will run for 8 hours then shut down"
echo ""

# Start n8n in background
n8n start &
N8N_PID=$!

# Wait for 8 hours (28800 seconds)
sleep 28800

# Gracefully shutdown n8n
echo "8 hours elapsed, shutting down n8n..."
kill -TERM $N8N_PID
wait $N8N_PID

echo "n8n has been shut down"
