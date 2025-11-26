# Quick Start Guide

A quick reference for Discord Auto-Updater commands and usage.

## Installation

```bash
git clone https://github.com/St-Luciferr/discord-auto-updater.git
cd discord-auto-updater
chmod +x install.sh
./install.sh
```

## Uninstallation

```bash
cd discord-auto-updater
./uninstall.sh
```

## Common Commands

### Check for updates manually
```bash
discord-auto-update
```

### Check Discord version
```bash
dpkg -l | grep discord
```

### View current script
```bash
cat /usr/local/bin/discord-auto-update
```

### Test update without launching Discord
```bash
# Edit script and comment out the last line:
# /usr/share/discord/Discord "$@"
```

### View desktop launcher configuration
```bash
cat /usr/share/applications/discord.desktop | grep Exec
```

## Troubleshooting Quick Fixes

### Script not found
```bash
sudo ln -s /usr/local/bin/discord-auto-update /usr/bin/discord-auto-update
```

### Permission denied
```bash
sudo chmod +x /usr/local/bin/discord-auto-update
```

### Reset desktop launcher
```bash
sudo sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop
```

### Reinstall Discord
```bash
wget https://discord.com/api/download?platform=linux&format=deb -O discord.deb
sudo apt install ./discord.deb
```

## File Locations

| File | Location |
|------|----------|
| Update script | `/usr/local/bin/discord-auto-update` |
| Desktop launcher | `/usr/share/applications/discord.desktop` |
| Launcher backup | `/usr/share/applications/discord.desktop.backup` |
| Sudoers config | `/etc/sudoers.d/discord-auto-update` |
| Discord binary | `/usr/share/discord/Discord` |

## Enable/Disable Features

### Enable passwordless updates
```bash
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/apt install -y /tmp/*/discord.deb" | sudo tee /etc/sudoers.d/discord-auto-update
sudo chmod 0440 /etc/sudoers.d/discord-auto-update
```

### Disable passwordless updates
```bash
sudo rm /etc/sudoers.d/discord-auto-update
```

### Disable notifications
Edit `/usr/local/bin/discord-auto-update` and comment out `notify-send` lines:
```bash
sudo nano /usr/local/bin/discord-auto-update
# Add # before: notify-send "..." ...
```

## Logs & Debugging

### Run with verbose output
```bash
bash -x /usr/local/bin/discord-auto-update
```

### Check latest Discord version
```bash
curl -sI "https://discord.com/api/download?platform=linux&format=deb" | grep -i location
```

### Check installed version
```bash
discord --version
# or
dpkg -l | grep discord | awk '{print $3}'
```

### Manual download test
```bash
wget -O /tmp/discord-test.deb "https://discord.com/api/download?platform=linux&format=deb"
dpkg-deb -I /tmp/discord-test.deb | grep Version
```

## Quick Test

Test if everything is working:
```bash
# 1. Check script exists and is executable
ls -l /usr/local/bin/discord-auto-update

# 2. Check desktop launcher
grep Exec /usr/share/applications/discord.desktop

# 3. Run update check
discord-auto-update

# 4. Launch from app menu
# Should auto-update if needed
```

## Emergency Reset

If something breaks, reset everything:

```bash
# Remove auto-updater
sudo rm /usr/local/bin/discord-auto-update
sudo rm /etc/sudoers.d/discord-auto-update

# Restore Discord launcher
echo "[Desktop Entry]
Name=Discord
StartupWMClass=discord
Comment=All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.
GenericName=Internet Messenger
Exec=/usr/share/discord/Discord
Icon=discord
Type=Application
Categories=Network;InstantMessaging;
Path=/usr/bin" | sudo tee /usr/share/applications/discord.desktop
```

## Getting Help

- 📖 Full docs: [README.md](README.md)
- 🔧 Setup guide: [SETUP.md](SETUP.md)
- 🐛 Report bugs: [GitHub Issues](https://github.com/St-Luciferr/discord-auto-updater/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/St-Luciferr/discord-auto-updater/discussions)