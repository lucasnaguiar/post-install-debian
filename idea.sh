#!/bin/bash

# Script to download and install IntelliJ IDEA Ultimate

# Abort the script if any command fails
set -e

# Determine the user's home directory
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME=$HOME
fi

# Installation directory
INSTALL_DIR="/opt"
FINAL_DIR_NAME="idea"
DESKTOP_SHORTCUT_PATH="$USER_HOME/.local/share/applications/idea.desktop"

# --- Check if already installed ---
if [ -d "$INSTALL_DIR/$FINAL_DIR_NAME" ]; then
    echo ">>> IntelliJ IDEA is already installed in $INSTALL_DIR/$FINAL_DIR_NAME."
    
    # Check if shortcut exists
    if [ ! -f "$DESKTOP_SHORTCUT_PATH" ]; then
        echo ">>> Desktop shortcut not found. Creating it..."
        cat << EOF > "$DESKTOP_SHORTCUT_PATH"
[Desktop Entry]
Name=IntelliJ IDEA
GenericName=Integrated Development Environment
X-GNOME-FullName=Java Integrated Development Environment
Comment=Idea Java IDE
Keywords=java;
Exec=/opt/idea/bin/idea
Terminal=false
Type=Application
Icon=/opt/idea/bin/idea.svg
Categories=Development;Utilities;
StartupWMClass=jetbrains-intellij
EOF
    fi
    
    exit 0
fi

# URL for the latest IntelliJ IDEA Ultimate for Linux
IDEA_URL="https://download.jetbrains.com/idea/ideaIU-2025.2.1.tar.gz"

# Temporary file to store the download
TMP_FILE="/tmp/idea.tar.gz"

EXTRACTED_DIR_NAME="idea-IU-*" # The name of the extracted folder is unknown

# --- 1. Download IntelliJ IDEA ---
echo ">>> Downloading IntelliJ IDEA Ultimate..."
wget -c --show-progress -O "$TMP_FILE" "$IDEA_URL"

# --- 2. Extract to /opt ---
echo ">>> Extracting to $INSTALL_DIR..."
tar -xzf "$TMP_FILE" -C "$INSTALL_DIR"

# --- 3. Rename the folder ---
echo ">>> Renaming the folder..."
# Find the extracted folder name (it usually contains the version number)
EXTRACTED_DIR=$(find "$INSTALL_DIR" -maxdepth 1 -type d -name "$EXTRACTED_DIR_NAME" | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "ERROR: Could not find the extracted IntelliJ IDEA directory."
    exit 1
fi

# Rename the directory
mv "$EXTRACTED_DIR" "$INSTALL_DIR/$FINAL_DIR_NAME"

# --- 4. Create Desktop Shortcut ---
echo ">>> Creating desktop shortcut..."
cat << EOF > "$DESKTOP_SHORTCUT_PATH"
[Desktop Entry]
Name=IntelliJ IDEA
GenericName=Integrated Development Environment
X-GNOME-FullName=Java Integrated Development Environment
Comment=Idea Java IDE
Keywords=java;
Exec=/opt/idea/bin/idea
Terminal=false
Type=Application
Icon=/opt/idea/bin/idea.svg
Categories=Development;Utilities;
StartupWMClass=jetbrains-intellij
EOF

# --- 5. Clean up ---
echo ">>> Cleaning up..."
rm "$TMP_FILE"

echo ">>> IntelliJ IDEA Ultimate installed successfully in $INSTALL_DIR/$FINAL_DIR_NAME"
