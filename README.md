# Ubuntu ThinLinc Tunneling

A smart SSH tunneling solution for ThinLinc remote desktop connections on Ubuntu systems. This tool automatically detects ThinLinc servers on your LAN and establishes a secure tunnel on port 2222.

## Features

- Automatic LAN server detection
- Secure SSH tunneling
- Port forwarding (22 → 2222)
- Easy to use on/off commands
- Fallback to manual IP input if auto-detection fails

## Prerequisites

- Ubuntu operating system
- nmap (for LAN scanning)
- SSH client
- Network access to ThinLinc server

## Installation

1. Clone this repository:
```bash
git clone https://github.com/bhuvanesh1729/ubuntu-thinlinc-tunneling.git
cd ubuntu-thinlinc-tunneling
```

2. Make the script executable:
```bash
chmod +x tunnel.sh
```

For quick deployment, see [deployment.md](deployment.md).

## Usage

### Start Tunnel
```bash
./tunnel.sh on
```
This will:
- Scan your LAN for ThinLinc servers
- If found, automatically establish tunnel
- If not found, prompt for manual IP input

### Stop Tunnel
```bash
./tunnel.sh off
```

### Connecting to ThinLinc
After starting the tunnel:
1. Open ThinLinc client
2. Connect to `localhost:2222`

## How It Works

1. **LAN Detection**: Uses `nmap` to scan the local network for systems with port 22 open
2. **Tunneling**: Creates an SSH tunnel from localhost:2222 to target:22
3. **Process Management**: Maintains a PID file for clean tunnel termination

## Troubleshooting

1. **No servers found**:
   - Ensure ThinLinc server is running
   - Check network connectivity
   - Try manual IP input

2. **Connection refused**:
   - Verify SSH service is running on target
   - Check firewall settings

3. **Permission denied**:
   - Ensure script has execute permissions
   - Run with appropriate user privileges

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - feel free to use and modify as needed.

## Author

[bhuvanesh1729](https://github.com/bhuvanesh1729)
