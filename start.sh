#!/bin/sh

echo "Starting n8n..."
n8n start &

echo "n8n started on port 5678"

echo ""
echo "Remotion project is mounted at /app/remotion-projects/my-template"
echo "To run Remotion Studio manually:"
echo "  docker exec -it <container-name> sh"
echo "  cd /app/remotion-projects/my-template"
echo "  npm start"

# Keep the container running
tail -f /dev/null