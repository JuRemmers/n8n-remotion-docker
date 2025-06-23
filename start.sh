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

# Start n8n in foreground (this keeps the container alive)
exec n8n start --host=0.0.0.0 --port=5678
