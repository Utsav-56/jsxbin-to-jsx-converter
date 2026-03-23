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
SHELL_RC=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.profile" ]; then
    SHELL_RC="$HOME/.profile"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# JSXBIN to JSX Converter PATH" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
        echo "Successfully added $INSTALL_DIR to $SHELL_RC"
    else
        echo "Path already configured in $SHELL_RC"
    fi
fi

echo ""
echo "Installation Successful!"
echo "IMPORTANT: Please restart your shell or run: source $SHELL_RC to start using '$COMMAND_NAME'."
