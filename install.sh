#!/bin/bash

# Discord Auto-Updater Installer
# This script installs an automatic update system for Discord on Ubuntu/Debian

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on supported system
check_system() {
    if ! command -v apt &> /dev/null; then
        print_error "This installer only works on Debian/Ubuntu-based systems"
        exit 1
    fi
    
    if ! command -v discord &> /dev/null; then
        print_warning "Discord doesn't appear to be installed"
        read -p "Do you want to install Discord first? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            install_discord
        else
            print_error "Discord must be installed first. Exiting."
            exit 1
        fi
    fi
}

# Install Discord if not present
install_discord() {
    print_info "Installing Discord..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    sudo apt install -y ./discord.deb
    rm -rf "$TEMP_DIR"
    print_success "Discord installed!"
}

# Create the auto-update script
create_update_script() {
    print_info "Creating auto-update script..."
    
    sudo tee /usr/local/bin/discord-auto-update > /dev/null << 'EOF'
#!/bin/bash

# Discord Auto-Updater Script
# Checks for updates and installs them automatically

# Function to get installed Discord version
get_installed_version() {
    dpkg -l | grep discord | awk '{print $3}' | head -1 2>/dev/null || echo "0.0.0"
}

# Function to get latest available version from Discord's download URL
get_latest_version() {
    curl -sI "https://discord.com/api/download?platform=linux&format=deb" | 
    grep -i "location:" | 
    grep -oP 'discord-\K[0-9]+\.[0-9]+\.[0-9]+' | 
    head -1
}

# Function to compare versions
version_greater() {
    # Returns 0 (true) if $1 > $2
    [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$1" ]
}

# Get versions
INSTALLED_VERSION=$(get_installed_version)
LATEST_VERSION=$(get_latest_version)

echo "Installed version: $INSTALLED_VERSION"
echo "Latest version: $LATEST_VERSION"

# Check if update is needed
if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch latest version"
    /usr/bin/discord "$@"
    exit 0
fi

if version_greater "$LATEST_VERSION" "$INSTALLED_VERSION"; then
    echo "Update available: $INSTALLED_VERSION -> $LATEST_VERSION"
    notify-send "Discord Update" "Downloading Discord $LATEST_VERSION..." -i discord 2>/dev/null || true
    
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # Download the update
    echo "Downloading Discord $LATEST_VERSION..."
    wget -q --show-progress -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    
    if [ -f discord.deb ]; then
        echo "Installing update..."
        notify-send "Discord Update" "Installing Discord $LATEST_VERSION..." -i discord 2>/dev/null || true
        
        # Try with pkexec first, fall back to sudo
        # Include sed command to re-apply desktop launcher modification (the .deb package overwrites it)
        if command -v pkexec &> /dev/null; then
            pkexec bash -c "apt install -y '$TEMP_DIR/discord.deb' && sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop"
        else
            sudo bash -c "apt install -y '$TEMP_DIR/discord.deb' && sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop"
        fi

        if [ $? -eq 0 ]; then
            notify-send "Discord Updated" "Discord has been updated to $LATEST_VERSION" -i discord 2>/dev/null || true
            echo "Update successful!"
            echo "Desktop launcher re-configured"
        else
            notify-send "Discord Update Failed" "Could not install update" -i discord -u critical 2>/dev/null || true
            echo "Update failed!"
        fi
    fi
    
    rm -rf "$TEMP_DIR"
else
    echo "Discord is up to date ($INSTALLED_VERSION)"
fi

# Launch Discord
/usr/bin/discord "$@"
EOF

    sudo chmod +x /usr/local/bin/discord-auto-update
    print_success "Auto-update script created at /usr/local/bin/discord-auto-update"
}

# Modify Discord desktop launcher
modify_desktop_launcher() {
    print_info "Modifying Discord desktop launcher..."
    
    # Backup original
    if [ -f /usr/share/applications/discord.desktop ]; then
        sudo cp /usr/share/applications/discord.desktop /usr/share/applications/discord.desktop.backup
        print_info "Backup created at /usr/share/applications/discord.desktop.backup"
    fi
    
    # Modify the Exec line
    sudo sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop
    
    print_success "Desktop launcher modified"
}

# Setup passwordless sudo for updates (optional)
setup_passwordless_sudo() {
    print_info "Setting up passwordless updates..."
    echo ""
    print_warning "This will allow Discord updates without entering your password."
    print_warning "This only affects Discord updates, not other sudo commands."
    read -p "Do you want to enable passwordless updates? (y/n) " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        SUDOERS_FILE="/etc/sudoers.d/discord-auto-update"
        echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/apt install -y /tmp/*/discord.deb" | sudo tee "$SUDOERS_FILE" > /dev/null
        sudo chmod 0440 "$SUDOERS_FILE"
        print_success "Passwordless updates enabled"
    else
        print_info "Skipped passwordless setup. You'll need to enter your password when Discord updates."
    fi
}

# Main installation
main() {
    echo ""
    echo "=========================================="
    echo "  Discord Auto-Updater Installer"
    echo "=========================================="
    echo ""
    
    check_system
    create_update_script
    modify_desktop_launcher
    setup_passwordless_sudo
    
    echo ""
    print_success "Installation complete!"
    echo ""
    echo "Next time you launch Discord, it will automatically:"
    echo "  1. Check for updates"
    echo "  2. Download and install if available"
    echo "  3. Launch Discord"
    echo ""
    print_info "To uninstall, run: ./uninstall.sh"
    echo ""
}

main