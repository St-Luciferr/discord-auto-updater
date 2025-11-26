# Detailed Setup Guide

This guide provides step-by-step instructions for installing and configuring Discord Auto-Updater.

## Prerequisites

Before installing, ensure you have:

1. **A Debian/Ubuntu-based distribution**
   - Ubuntu 20.04, 22.04, 24.04
   - Linux Mint
   - Pop!_OS
   - Elementary OS
   - Debian 10, 11, 12
   - Or any derivative

2. **Basic command line knowledge**
   - How to open a terminal
   - How to navigate directories

3. **Discord installed** (optional - installer can do this)
   - Check with: `which discord`

## Installation Steps

### Step 1: Clone the Repository

Open a terminal and run:

```bash
cd ~
git clone https://github.com/St-Luciferr/discord-auto-updater.git
cd discord-auto-updater
```

### Step 2: Make Scripts Executable

```bash
chmod +x install.sh uninstall.sh
```

### Step 3: Run the Installer

```bash
./install.sh
```

### Step 4: Follow the Prompts

The installer will ask you:

1. **"Discord doesn't appear to be installed. Do you want to install Discord first?"**
   - Type `y` if you need to install Discord
   - Type `n` if Discord is already installed

2. **"Do you want to enable passwordless updates?"**
   - Type `y` for automatic updates without password prompts (recommended)
   - Type `n` if you prefer to enter your password each time

### Step 5: Verify Installation

Check that the script was installed:

```bash
ls -l /usr/local/bin/discord-auto-update
```

You should see: `-rwxr-xr-x 1 root root ...`

Check the desktop launcher was modified:

```bash
grep Exec /usr/share/applications/discord.desktop
```

You should see: `Exec=/usr/local/bin/discord-auto-update`

## Testing the Installation

### Test 1: Launch Discord

Click the Discord icon in your application menu. You should see:

```
Installed version: X.X.XXX
Latest version: X.X.XXX
Discord is up to date (X.X.XXX)
```

Then Discord launches normally.

### Test 2: Manual Update Check

Run the updater directly:

```bash
discord-auto-update
```

This should check for updates and launch Discord.

### Test 3: Force Update (Optional)

To test the update mechanism:

1. Downgrade Discord to an older version:
   ```bash
   wget https://stable.dl2.discordapp.net/apps/linux/0.0.50/discord-0.0.50.deb
   sudo apt install ./discord-0.0.50.deb
   ```

2. Launch Discord - it should automatically update to the latest version

## Configuration Options

### Enable/Disable Passwordless Updates

If you skipped passwordless updates during installation, you can enable it later:

```bash
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/apt install -y /tmp/*/discord.deb" | sudo tee /etc/sudoers.d/discord-auto-update
sudo chmod 0440 /etc/sudoers.d/discord-auto-update
```

To disable it:

```bash
sudo rm /etc/sudoers.d/discord-auto-update
```

### Disable Notifications

If you don't want update notifications, edit the script:

```bash
sudo nano /usr/local/bin/discord-auto-update
```

Comment out (add `#` before) all lines containing `notify-send`:

```bash
# notify-send "Discord Update" "Downloading..." -i discord
```

### Change Update Check Behavior

By default, Discord checks for updates every time you launch it. To modify this:

Edit `/usr/local/bin/discord-auto-update` and add a timestamp check at the beginning:

```bash
LAST_CHECK_FILE="$HOME/.discord-last-update-check"
CURRENT_TIME=$(date +%s)

if [ -f "$LAST_CHECK_FILE" ]; then
    LAST_CHECK=$(cat "$LAST_CHECK_FILE")
    TIME_DIFF=$((CURRENT_TIME - LAST_CHECK))
    
    # Only check once per day (86400 seconds)
    if [ $TIME_DIFF -lt 86400 ]; then
        /usr/share/discord/Discord "$@"
        exit 0
    fi
fi

echo "$CURRENT_TIME" > "$LAST_CHECK_FILE"
```

## Troubleshooting

### Issue: "command not found: discord-auto-update"

**Solution**: The script wasn't installed correctly. Reinstall:

```bash
cd discord-auto-updater
./install.sh
```

### Issue: "Permission denied" when launching Discord

**Solution**: Make sure the script is executable:

```bash
sudo chmod +x /usr/local/bin/discord-auto-update
```

### Issue: Update fails with "could not get lock"

**Solution**: Another package manager is running. Close other package managers (Software Center, Synaptic, etc.) and try again.

### Issue: Discord launches but doesn't check for updates

**Solution**: The desktop launcher might not be modified. Fix it:

```bash
sudo sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop
```

### Issue: "Failed to execute child process" error

**Solution**: Discord might not be in the expected location. Find it:

```bash
which discord
```

Then edit `/usr/local/bin/discord-auto-update` and update the path in the last line.

## Uninstalling

If you want to remove the auto-updater:

```bash
cd discord-auto-updater
./uninstall.sh
```

Discord will remain installed and will work normally, but you'll need to manually update it again.

## Advanced Usage

### Running at System Startup

To check for updates when you log in (before launching Discord):

Create a desktop autostart entry:

```bash
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/discord-check-update.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Discord Update Check
Exec=/usr/local/bin/discord-auto-update --no-launch
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
```

Then modify `/usr/local/bin/discord-auto-update` to support `--no-launch`:

```bash
# At the end of the script, replace:
/usr/share/discord/Discord "$@"

# With:
if [ "$1" != "--no-launch" ]; then
    /usr/share/discord/Discord "$@"
fi
```

### Logging Updates

To keep a log of all updates:

Add at the beginning of `/usr/local/bin/discord-auto-update`:

```bash
LOG_FILE="$HOME/.discord-update.log"
echo "[$(date)] Checking for updates..." >> "$LOG_FILE"
```

And log the results after the update check.

## Getting Help

If you encounter issues not covered here:

1. Check the [main README](README.md)
2. Check existing [GitHub Issues](https://github.com/St-Luciferr/discord-auto-updater/issues)
3. Open a new issue with:
   - Your Linux distribution and version
   - Discord version
   - Error messages
   - Output of `discord-auto-update`

## Contributing

Want to improve this tool? See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.