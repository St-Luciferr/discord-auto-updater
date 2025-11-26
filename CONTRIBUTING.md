# Contributing to Discord Auto-Updater

Thank you for considering contributing to Discord Auto-Updater! This document provides guidelines for contributing to the project.

## How Can I Contribute?

### Reporting Bugs

If you find a bug, please create an issue with:

- **Clear title**: Summarize the bug in one sentence
- **Description**: Detailed description of the issue
- **Environment**:
  - Linux distribution and version (e.g., Ubuntu 24.04)
  - Discord version
  - Shell being used (bash, zsh, etc.)
- **Steps to reproduce**:
  1. Step 1
  2. Step 2
  3. Expected result
  4. Actual result
- **Error messages**: Include full error output
- **Logs**: Output from running `discord-auto-update` manually

### Suggesting Features

Feature suggestions are welcome! Please create an issue with:

- **Use case**: Why do you need this feature?
- **Proposed solution**: How should it work?
- **Alternatives**: Have you considered other approaches?

### Pull Requests

We welcome pull requests! Here's the process:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/my-feature`
3. **Make your changes**
4. **Test thoroughly**: Test on multiple distributions if possible
5. **Commit with clear messages**: Follow the commit message guidelines below
6. **Push to your fork**: `git push origin feature/my-feature`
7. **Create a Pull Request**

## Development Setup

### Prerequisites

- A Debian/Ubuntu-based system for testing
- Basic bash scripting knowledge
- Git

### Testing Your Changes

Before submitting a PR, test:

1. **Fresh installation**: Test on a clean system if possible
2. **Update scenarios**: 
   - Up-to-date Discord (no update needed)
   - Outdated Discord (update needed)
   - Fresh Discord installation
3. **Uninstallation**: Verify clean removal
4. **Edge cases**:
   - No internet connection
   - Discord servers down
   - Invalid Discord installation

### Test Script

```bash
#!/bin/bash
# Save as test.sh

echo "Testing fresh install..."
./install.sh

echo "Testing Discord launch..."
discord-auto-update

echo "Testing uninstall..."
./uninstall.sh

echo "Verifying cleanup..."
[ ! -f /usr/local/bin/discord-auto-update ] && echo "✓ Script removed"
[ ! -f /etc/sudoers.d/discord-auto-update ] && echo "✓ Sudoers removed"
```

## Code Style Guidelines

### Bash Scripts

- Use 4 spaces for indentation (no tabs)
- Add comments for complex logic
- Use meaningful variable names (avoid single letters except in loops)
- Quote variables: `"$VARIABLE"` not `$VARIABLE`
- Check command success: `if [ $? -eq 0 ]; then`
- Use `set -e` for safety (fail on errors)

### Example

```bash
# Good
DISCORD_VERSION=$(get_version)
if [ -n "$DISCORD_VERSION" ]; then
    echo "Version: $DISCORD_VERSION"
fi

# Avoid
VER=$(get_version)
if [ -n $VER ]; then
    echo "Version: $VER"
fi
```

### Functions

- Name functions clearly: `install_discord` not `inst_disc`
- Add comments describing what the function does
- Keep functions focused (single responsibility)

```bash
# Check if Discord is installed
check_discord_installed() {
    command -v discord &> /dev/null
    return $?
}
```

### Error Handling

- Always check for errors
- Provide helpful error messages
- Use the color functions: `print_error`, `print_warning`, `print_info`, `print_success`

```bash
if ! wget -O discord.deb "$URL"; then
    print_error "Failed to download Discord"
    return 1
fi
```

## Commit Message Guidelines

Follow this format:

```
<type>: <short summary>

<optional longer description>

<optional footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples

```
feat: add option to disable notifications

Added --no-notifications flag to suppress desktop notifications
during updates.

Closes #42
```

```
fix: handle spaces in username correctly

Quote $USER variable to handle usernames with spaces in sudoers
configuration.

Fixes #38
```

## Documentation

When changing functionality:

- Update README.md if user-facing
- Update SETUP.md if affecting installation
- Add inline comments for complex code
- Update version number if applicable

## Code Review Process

Pull requests will be reviewed for:

1. **Functionality**: Does it work as intended?
2. **Code quality**: Is it readable and maintainable?
3. **Testing**: Has it been tested?
4. **Documentation**: Are docs updated?
5. **Style**: Does it follow the guidelines?

## Adding New Features

When adding features:

1. **Check existing issues**: Someone might have already suggested it
2. **Discuss first**: Open an issue to discuss the feature
3. **Keep it simple**: Match the project's minimalist approach
4. **Maintain compatibility**: Don't break existing functionality
5. **Document well**: Add usage examples

## Release Process

Maintainers will:

1. Review and test PRs
2. Merge approved changes
3. Update version numbers
4. Create release notes
5. Tag releases

## Questions?

- Open an issue for questions
- Check existing issues and discussions
- Be respectful and patient

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Welcome newcomers
- Keep discussions professional

Thank you for contributing! 🎉