#!/bin/bash

# Discord Auto-Updater Uninstaller
# This script removes the automatic update system

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

main() {
    echo ""
    echo "=========================================="
    echo "  Discord Auto-Updater Uninstaller"
    echo "=========================================="
    echo ""
    
    print_warning "This will remove the Discord auto-updater"
    read -p "Are you sure you want to continue? (y/n) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Uninstall cancelled"
        exit 0
    fi
    
    # Remove auto-update script
    if [ -f /usr/local/bin/discord-auto-update ]; then
        print_info "Removing auto-update script..."
        sudo rm /usr/local/bin/discord-auto-update
        print_success "Auto-update script removed"
    fi
    
    # Restore desktop launcher
    if [ -f /usr/share/applications/discord.desktop.backup ]; then
        print_info "Restoring original desktop launcher..."
        sudo mv /usr/share/applications/discord.desktop.backup /usr/share/applications/discord.desktop
        print_success "Desktop launcher restored"
    else
        print_warning "No backup found. Manually resetting desktop launcher..."
        sudo sed -i 's|^Exec=.*|Exec=/usr/share/discord/Discord|g' /usr/share/applications/discord.desktop
        print_success "Desktop launcher reset"
    fi
    
    # Remove sudoers file
    if [ -f /etc/sudoers.d/discord-auto-update ]; then
        print_info "Removing sudoers configuration..."
        sudo rm /etc/sudoers.d/discord-auto-update
        print_success "Sudoers configuration removed"
    fi
    
    echo ""
    print_success "Uninstall complete!"
    echo ""
    print_info "Discord will now use the default launcher (manual updates)"
    echo ""
}

main