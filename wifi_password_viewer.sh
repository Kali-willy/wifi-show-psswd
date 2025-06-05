#!/bin/bash

# WiFi Password Viewer Script
# Works on Kali Linux and Windows (using Windows Subsystem for Linux)
# Created by WillyGailo

# Password protection
echo "Enter password to continue:"
read -s password
if [ "$password" != "willy" ]; then
    echo "Incorrect password. Exiting."
    exit 1
fi
echo "Password correct. Continuing..."

# Function to check operating system
check_os() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS=$NAME
    elif command -v systeminfo >/dev/null 2>&1; then
        OS="Windows"
    else
        OS="Unknown"
    fi
    echo $OS
}

# Function to get WiFi passwords on Linux
get_linux_wifi_passwords() {
    echo "=== Saved WiFi Networks on Linux ==="
    
    if [ -d "/etc/NetworkManager/system-connections/" ]; then
        echo "Found NetworkManager connections..."
        
        if [ "$EUID" -ne 0 ]; then
            echo "This script needs root privileges to read WiFi passwords on Linux."
            echo "Please run with sudo."
            exit 1
        fi
        
        for file in /etc/NetworkManager/system-connections/*; do
            if [ -f "$file" ]; then
                SSID=$(grep -oP '(?<=ssid=).*' "$file" 2>/dev/null)
                PSK=$(grep -oP '(?<=psk=).*' "$file" 2>/dev/null)
                
                if [ -n "$SSID" ] && [ -n "$PSK" ]; then
                    echo "Network: $SSID"
                    echo "Password: $PSK"
                    echo "------------------------"
                fi
            fi
        done
    else
        echo "NetworkManager connections directory not found."
        echo "Trying alternative method..."
        
        if command -v nmcli >/dev/null 2>&1; then
            echo "Using nmcli to get connections..."
            nmcli -g NAME,UUID con show | while IFS=: read -r name uuid; do
                echo "Network: $name"
                password=$(nmcli -s -g 802-11-wireless-security.psk con show "$uuid" 2>/dev/null)
                if [ -n "$password" ]; then
                    echo "Password: $password"
                    echo "------------------------"
                fi
            done
        else
            echo "nmcli not found. Cannot retrieve WiFi passwords."
        fi
    fi
}

# Function to get WiFi passwords on Windows
get_windows_wifi_passwords() {
    echo "=== Saved WiFi Networks on Windows ==="
    
    # Get list of WiFi profiles
    networks=$(netsh wlan show profiles | grep -oP '(?<=: ).*' | grep -v "^$")
    
    if [ -z "$networks" ]; then
        echo "No WiFi profiles found or netsh command failed."
        return
    fi
    
    echo "$networks" | while read -r network; do
        # Clean up network name (remove trailing spaces)
        network=$(echo "$network" | sed 's/ *$//')
        
        # Get password for each network
        password_info=$(netsh wlan show profile name="$network" key=clear)
        
        # Extract password
        password=$(echo "$password_info" | grep -oP '(?<=Key Content\s+: ).*' 2>/dev/null)
        
        echo "Network: $network"
        if [ -n "$password" ]; then
            echo "Password: $password"
        else
            echo "Password: Not found or not accessible"
        fi
        echo "------------------------"
    done
}

# Main script
echo "WiFi Password Viewer"
echo "This script shows saved WiFi passwords on your system."
echo "------------------------"

OS=$(check_os)
echo "Detected OS: $OS"

if [[ "$OS" == *"Kali"* ]] || [[ "$OS" == *"Debian"* ]] || [[ "$OS" == *"Ubuntu"* ]] || [[ "$OS" == *"Linux"* ]]; then
    get_linux_wifi_passwords
elif [[ "$OS" == "Windows" ]] || command -v netsh >/dev/null 2>&1; then
    get_windows_wifi_passwords
else
    echo "Trying both methods as OS detection is uncertain..."
    get_linux_wifi_passwords
    echo ""
    get_windows_wifi_passwords
fi

echo ""
echo "Script completed." 