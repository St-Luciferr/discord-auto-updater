# Discord Auto-Updater for Ubuntu/Debian

Automatically check, download, and install Discord updates when you launch the app - just like on Windows!

## 🚀 Features

- ✅ Automatic version checking before each Discord launch
- ✅ Downloads and installs updates only when available
- ✅ Desktop notifications for update progress
- ✅ Optional passwordless updates
- ✅ No manual `.deb` downloads needed anymore
- ✅ Works seamlessly with your existing Discord installation

## 📋 Requirements

- Ubuntu/Debian-based Linux distribution
- Discord installed (installer can help with this)
- `wget` and `curl` (usually pre-installed)
- Internet connection

## 🔧 Installation

### Quick Install

```bash
git clone https://github.com/St-Luciferr/discord-auto-updater.git
cd discord-auto-updater
chmod +x install.sh
./install.sh
```

That's it! The installer will:
1. Check if Discord is installed
2. Create the auto-update script
3. Modify your Discord launcher
4. Optionally set up passwordless updates

### What Gets Installed

- `/usr/local/bin/discord-auto-update` - The main update script
- Modified `/usr/share/applications/discord.desktop` - Desktop launcher
- `/etc/sudoers.d/discord-auto-update` - Passwordless sudo config (optional)

## 📖 How It Works

When you launch Discord:

1. **Version Check**: Quickly checks Discord's servers for the latest version
2. **Compare**: Compares with your installed version
3. **Update (if needed)**: Downloads and installs the update with progress notifications
4. **Launch**: Opens Discord (whether updated or not)

The entire process takes just a few seconds if you're already up to date!

## 🎮 Usage

Just launch Discord normally:
- Click the Discord icon in your application menu
- Or run `discord` from terminal
- Or use your favorite launcher (GNOME, KDE, etc.)

The auto-updater runs transparently in the background.

### Manual Update Check

You can also run the updater manually:

```bash
discord-auto-update
```

## 🔓 Passwordless Updates (Optional)

During installation, you can choose to enable passwordless updates. This allows Discord to update without prompting for your password.

**Security Note**: This only affects Discord updates from `/tmp/*/discord.deb` - no other sudo commands are affected.

If you skip this during installation, you'll need to enter your password when Discord updates.

## 🗑️ Uninstallation

To remove the auto-updater and restore Discord to its original state:

```bash
cd discord-auto-updater
./uninstall.sh
```

This will:
- Remove the auto-update script
- Restore the original Discord launcher
- Remove passwordless sudo configuration (if enabled)

Discord itself will remain installed and functional.

## 🐛 Troubleshooting

### Discord doesn't update automatically

1. Check if the script is executable:
   ```bash
   ls -l /usr/local/bin/discord-auto-update
   ```

2. Test the updater manually:
   ```bash
   discord-auto-update
   ```

3. Check for errors in the output

### Permission errors during update

If you didn't enable passwordless updates:
- You'll be prompted for your password during updates
- This is normal and secure

If you did enable passwordless updates but still get errors:
```bash
sudo cat /etc/sudoers.d/discord-auto-update
```

Should show: `YOUR_USERNAME ALL=(ALL) NOPASSWD: /usr/bin/apt install -y /tmp/*/discord.deb`

### Desktop launcher not working

Reset the launcher:
```bash
sudo sed -i 's|^Exec=.*|Exec=/usr/local/bin/discord-auto-update|g' /usr/share/applications/discord.desktop
```

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## 📝 License

MIT License - feel free to use and modify as needed.

## ⚠️ Disclaimer

This is an unofficial tool. Discord and its logo are trademarks of Discord Inc.

## 💡 Why This Exists

Discord on Linux requires manual `.deb` file downloads and installation for updates, unlike Windows which auto-updates. This tool bridges that gap and provides a seamless update experience.

## 🙏 Credits

Created to make Discord updates on Linux as smooth as on Windows!

---

**Star ⭐ this repo if it helped you!**