#!/bin/bash
# JSXBIN to JSX Converter: Linux Install Script
# Sets up the environment and adds binaries to PATH

INSTALL_DIR="$HOME/utsav-56/jsbin-conv"
mkdir -p "$INSTALL_DIR"

echo "Installing to $INSTALL_DIR..."

# Move binaries to the install directory
if [ -f "jsbin-conv" ] && [ -f "Jsbeautify" ]; then
    cp jsbin-conv "$INSTALL_DIR/"
    cp Jsbeautify "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/jsbin-conv"
    chmod +x "$INSTALL_DIR/Jsbeautify"
else
    echo "Error: Binaries not found in the current directory."
    exit 1
fi

# Determine shell config file
SHELL_RC=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.profile" ]; then
    SHELL_RC="$HOME/.profile"
fi

# Add to PATH if not already there
if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# JSXBIN to JSX Converter" >> "$SHELL_RC"
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$SHELL_RC"
        echo "Successfully added $INSTALL_DIR to $SHELL_RC"
    else
        echo "Path already exists in $SHELL_RC"
    fi
else
    echo "Warning: Could not find shell configuration file (~/.bashrc, ~/.zshrc, or ~/.profile)."
    echo "Please manually add $INSTALL_DIR to your PATH."
fi

echo "Installation complete!"
echo "Please restart your terminal or run: source $SHELL_RC"
