cloudflared tunnel --no-autoupdate --url http://localhost:5000 > /tmp/cloudflared.log 2>&1 &
echo "Cloudflared started with PID $!" >> /tmp/startup.log
mkdir -p /tmp

# Wait for the URL to appear in the log file
while ! grep -q "+--*+" /tmp/cloudflared.log; do
  sleep 1
done

# Extract and display the URL - modified to handle the specific log format
TUNNEL_URL=$(grep -A 2 "+--*+" /tmp/cloudflared.log | grep "https://" | sed -E 's/.*https:\/\/([^[:space:]]*).*/\1/')
echo "======== CLOUDFLARED TUNNEL URL ========"
echo "https://$TUNNEL_URL"
echo "========================================"

# Start ComfyUI with suppressed output
python server.py --listen 0.0.0.0 --port 5000 > /tmp/server.log 2>&1 &
