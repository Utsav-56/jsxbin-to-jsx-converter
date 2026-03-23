#!/bin/bash
# JSXBIN to JSX Converter: Unix Installer (Linux/macOS)
# Handles tool checks, custom command naming, and PATH configuration.

INSTALL_DIR="$HOME/utsav-56/jsbin-conv"
DART_URL="https://dart.dev/get-dart"
BUN_URL="https://bun.sh"

# 1. Dependency Checks (Dart SDK & Bun Runtime)
echo "Checking for necessary build tools..."
DART_CHECK=$(command -v dart 2>/dev/null)
BUN_CHECK=$(command -v bun 2>/dev/null)

if [ -z "$DART_CHECK" ] || [ -z "$BUN_CHECK" ]; then
    if [ -z "$DART_CHECK" ]; then
        echo "Error: Dart SDK is not installed or not in the path."
        echo "We cannot continue without it. Go to $DART_URL and follow along to install them."
    fi
    if [ -z "$BUN_CHECK" ]; then
        echo "Error: Bun runtime is not installed or not in the path."
        echo "We cannot continue without it. Go to $BUN_URL and follow along to install them."
    fi
    echo ""
    echo "Tip: If you installed and still this error persists, it might not be in your path."
    echo "Please search google or internet to know how to install to path for your system."
    exit 1
fi

# 2. Ask for Command Name
read -p "What would you like the command to be called? (Default: jsxbin-conv): " COMMAND_NAME
COMMAND_NAME=${COMMAND_NAME:-jsxbin-conv}

# 3. Handle File Persistence (Move vs Copy)
echo ""
read -p "Do you want to keep the original source files after installation? [y/N]: " KEEP_FILES
KEEP_FILES=${KEEP_FILES:-n}

# Warning if moving
if [[ "$KEEP_FILES" =~ ^[Nn]$ ]]; then
    echo "Warning: Source files will be moved to $INSTALL_DIR. This won't affect your usage and is recommended."
fi

# 4. Preparation
mkdir -p "$INSTALL_DIR"
if [ ! -f "jsbin-conv" ] || [ ! -f "Jsbeautify" ]; then
    echo "Error: Binaries (jsbin-conv, Jsbeautify) not found in the current directory."
    exit 1
fi

# 5. Execute Installation (Copy/Move with Rename)
if [[ "$KEEP_FILES" =~ ^[Yy]$ ]]; then
    cp jsbin-conv "$INSTALL_DIR/$COMMAND_NAME"
    cp Jsbeautify "$INSTALL_DIR/"
else
    mv jsbin-conv "$INSTALL_DIR/$COMMAND_NAME"
    mv Jsbeautify "$INSTALL_DIR/"
fi

chmod +x "$INSTALL_DIR/$COMMAND_NAME"
chmod +x "$INSTALL_DIR/Jsbeautify"

# 6. Shell Path Configuration
# We apply a "2-step verification" by updating both specific shell RCs and universal profiles
# This ensures path availability even in non-POSIX shells or different session types.

CONFIG_FILES=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile" "$HOME/.bash_profile")
SUCCESSFULLY_CONFIGURED=()

for rc in "${CONFIG_FILES[@]}"; do
    if [ -f "$rc" ]; then
        if ! grep -q "$INSTALL_DIR" "$rc"; then
            echo "" >> "$rc"
            echo "# JSXBIN to JSX Converter PATH (Added by Installer)" >> "$rc"
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$rc"
            SUCCESSFULLY_CONFIGURED+=("$rc")
        fi
    fi
done

# Special handling for Fish shell (non-POSIX)
if [ -d "$HOME/.config/fish/conf.d" ]; then
    FISH_CONF="$HOME/.config/fish/conf.d/jsxbin-conv.fish"
    if [ ! -f "$FISH_CONF" ]; then
        echo "# JSXBIN to JSX Converter PATH (Fish)" > "$FISH_CONF"
        echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$FISH_CONF"
        SUCCESSFULLY_CONFIGURED+=("$FISH_CONF")
    fi
fi

if [ ${#SUCCESSFULLY_CONFIGURED[@]} -gt 0 ]; then
    echo "Configuration updated in:"
    for item in "${SUCCESSFULLY_CONFIGURED[@]}"; do
        echo "  - $item"
    done
else
    echo "Path was already configured in all detected shell profiles."
fi

echo ""
echo "Installation Successful!"
echo "IMPORTANT: Please restart your shell or terminal to apply the new PATH settings."
echo "You can now run '$COMMAND_NAME' from any new terminal session."
