# WiFi Password Viewer

This repository contains scripts to view saved WiFi passwords on both Linux (specifically Kali Linux) and Windows systems.

**Created by WillyGailo**

## Scripts

1. `wifi_password_viewer.sh` - Bash script for Linux/Kali Linux and Windows with WSL
2. `wifi_password_viewer.bat` - Batch script for Windows

## Password Protection

Both scripts are password protected. When running either script, you will be prompted to enter a password.

**Password: willy**

## Usage Instructions

### For Linux/Kali Linux Users:

1. Make the script executable:
   ```
   chmod +x wifi_password_viewer.sh
   ```

2. Run the script with sudo privileges:
   ```
   sudo ./wifi_password_viewer.sh
   ```

3. Enter the password when prompted.

4. The script will display all saved WiFi networks and their passwords.

### For Windows Users:

#### Option 1: Using the Batch Script

1. Double-click on `wifi_password_viewer.bat` or run it from Command Prompt with administrator privileges.
2. Enter the password when prompted.
3. The script will display all saved WiFi networks and their passwords.

#### Option 2: Using Windows Subsystem for Linux (WSL)

If you have WSL installed:

1. Make the bash script executable:
   ```
   chmod +x wifi_password_viewer.sh
   ```

2. Run the script:
   ```
   ./wifi_password_viewer.sh
   ```

3. Enter the password when prompted.

## How It Works

### Linux/Kali Linux
- The script searches for WiFi connection information in NetworkManager's system connections directory
- It uses either direct file reading or nmcli commands to extract passwords

### Windows
- The script uses the `netsh wlan` command to list all saved WiFi profiles
- It then retrieves the key content (password) for each profile

## Requirements

- Linux/Kali Linux: Root privileges (sudo)
- Windows: Administrator privileges
- Windows with WSL: No special privileges needed for WSL

## Note

This tool is intended for legitimate purposes only, such as recovering your own forgotten WiFi passwords. Using it to access passwords without authorization may be illegal. 
