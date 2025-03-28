# Quick Deployment

```bash
rm -f tunnel.sh && curl -O https://raw.githubusercontent.com/bhuvanesh1729/ubuntu-thinlinc-tunneling/main/tunnel.sh && chmod +x tunnel.sh && ./tunnel.sh install && ./tunnel.sh on
```

This one-liner will:
1. Remove any existing tunnel.sh file
2. Download the tunnel script directly from GitHub
2. Make the script executable
3. Install required dependencies (nmap and ssh)
4. Start the tunnel service with automatic LAN detection
