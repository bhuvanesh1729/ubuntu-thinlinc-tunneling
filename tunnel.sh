#!/bin/bash

set -e

# Function to install dependencies
install_dependencies() {
    echo "Installing required dependencies..."
    if ! command -v nmap &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y nmap
    fi
    
    if ! command -v ssh &> /dev/null; then
        sudo apt-get install -y openssh-client
    fi
    echo "Dependencies installed successfully"
}

# Function to detect LAN target
detect_lan_target() {
    # Get the default route interface
    DEFAULT_INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
    
    # Get the network address range
    NETWORK=$(ip route | grep "$DEFAULT_INTERFACE" | grep -v default | awk '{print $1}' | head -n1)
    
    # Scan the network for systems with SSH (port 22)
    echo "Scanning network for systems with ThinLinc server access..."
    FOUND_TARGET=$(nmap -p22 --open "$NETWORK" -n --max-retries 1 | grep "Nmap scan" | head -n1 | awk '{print $5}')
    
    if [ -n "$FOUND_TARGET" ]; then
        echo "Found system with ThinLinc Server at: $FOUND_TARGET"
        return 0
    else
        ip a
        echo "No system with ThinLinc server found automatically."
        return 1
    fi
}

# Function to validate IP address
validate_ip() {
    if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to setup SSH tunnel
setup_tunnel() {
    local target=$1
    echo "Setting up SSH tunnel for $target:22 -> localhost:2222"
    ssh -N -L 2222:$target:22 localhost &
    echo $! > /tmp/thinlinc-tunnel.pid
    echo "Tunnel established. You can now connect to ThinLinc using localhost:2222"
}

# Function to stop SSH tunnel
stop_tunnel() {
    if [ -f /tmp/thinlinc-tunnel.pid ]; then
        pid=$(cat /tmp/thinlinc-tunnel.pid)
        kill $pid 2>/dev/null || true
        rm /tmp/thinlinc-tunnel.pid
        echo "Tunnel stopped"
    else
        echo "No active tunnel found"
    fi
}

# Main script
case "$1" in
    "install")
        install_dependencies
        ;;
    "on")
        # Try to detect LAN target first
        if detect_lan_target; then
            LAN_TARGET=$FOUND_TARGET
        else
            # If automatic detection fails, ask for manual input
            read -p "Enter target IP address: " LAN_TARGET
            if ! validate_ip "$LAN_TARGET"; then
                echo "Invalid IP address format"
                exit 1
            fi
        fi
        setup_tunnel "$LAN_TARGET"
        ;;
    "off")
        stop_tunnel
        ;;
    *)
        echo "Usage: $0 {install|on|off}"
        echo "  install - Install required dependencies"
        echo "  on      - Start ThinLinc tunnel"
        echo "  off     - Stop ThinLinc tunnel"
        exit 1
        ;;
esac
