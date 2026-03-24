#!/bin/bash
# JSXBIN to JSX Converter: Unix Build Script
# This compiles the Dart core and the Bun-based beautifier into a minimal bundle.

TEMP_DIR="__temp_compile_build"
RELEASE_DIR="release"
PLATFORM="linux" # Change to 'macos' if needed

# Clean old artifacts
echo "Cleaning old build files..."
rm -rf "$TEMP_DIR" "$RELEASE_DIR"
mkdir -p "$TEMP_DIR" "$RELEASE_DIR"

# 1. Compile Dart (with obfuscation and stripped symbols)
echo "Compiling Dart core engine..."
cd jsbin-conv
dart pub get
# -S strips debug info; --obfuscate requires --split-debug-info for mapping if needed
dart compile exe bin/jsbin_conv.dart -o "../$TEMP_DIR/jsbin-conv" -S "../$TEMP_DIR/debug_info"
cd ..

# 2. Copy Clang-format based beautifier (The "Makeup Man")
echo "Bundling the makeup-man beautifier..."
# Ensure assets exist, or just copy if you expect them to be there.
cp assets/jsxbin-conv-makeup-man "$TEMP_DIR/"

# 3. Copy Installation Scripts
echo "Bundling installation scripts..."
cp install_scripts/install.sh "$TEMP_DIR/"
cp install_scripts/install.ps1 "$TEMP_DIR/"
cp install_scripts/install.bat "$TEMP_DIR/"

# 4. Create ZIP Bundle
echo "Creating the bundle repository..."
ZIP_NAME="jsbin-conv-$PLATFORM-bundle.zip"
cd "$TEMP_DIR"
# Use zip if available, fallback to tar or just output warning
if command -v zip >/dev/null 2>&1; then
    zip -r "../$RELEASE_DIR/$ZIP_NAME" .
else
    echo "Warning: 'zip' command not found. Copying files raw to release/ instead."
    cp -r . "../$RELEASE_DIR/"
fi
cd ..

# Clean up temporary build artifacts
echo "Build procedure completed."
echo "Artifact generated at: $RELEASE_DIR/$ZIP_NAME"
