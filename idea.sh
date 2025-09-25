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
BINARY_WRAPPER="/usr/local/bin/idea"

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
Exec=$BINARY_WRAPPER %f
Terminal=false
Type=Application
Icon=$INSTALL_DIR/$FINAL_DIR_NAME/bin/idea.svg
Categories=Development;Utilities;
StartupWMClass=jetbrains-intellij
EOF
    fi

    # Check if binary wrapper exists
    if [ ! -f "$BINARY_WRAPPER" ]; then
        echo ">>> Creating binary wrapper in $BINARY_WRAPPER..."
        cat << 'EOF' | sudo tee "$BINARY_WRAPPER" > /dev/null
#!/bin/bash
/opt/idea/bin/idea "$@" >/dev/null 2>&1 &
EOF
        sudo chmod +x "$BINARY_WRAPPER"
    fi
    
    exit 0
fi

# URL for the latest IntelliJ IDEA Ultimate for Linux
IDEA_URL="https://download.jetbrains.com/idea/ideaIU-2025.2.2.tar.gz"

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
EXTRACTED_DIR=$(find "$INSTALL_DIR" -maxdepth 1 -type d -name "$EXTRACTED_DIR_NAME" | head -n 1)

if [ -z "$EXTRACTED_DIR" ]; then
    echo "ERROR: Could not find the extracted IntelliJ IDEA directory."
    exit 1
fi

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
Exec=$BINARY_WRAPPER %f
Terminal=false
Type=Application
Icon=$INSTALL_DIR/$FINAL_DIR_NAME/bin/idea.svg
Categories=Development;Utilities;
StartupWMClass=jetbrains-intellij
EOF

# --- 5. Create Binary Wrapper ---
echo ">>> Creating binary wrapper in $BINARY_WRAPPER..."
cat << 'EOF' | sudo tee "$BINARY_WRAPPER" > /dev/null
#!/bin/bash
/opt/idea/bin/idea "$@" >/dev/null 2>&1 &
EOF
sudo chmod +x "$BINARY_WRAPPER"

# --- 6. Clean up ---
echo ">>> Cleaning up..."
rm "$TMP_FILE"

echo ">>> IntelliJ IDEA Ultimate installed successfully in $INSTALL_DIR/$FINAL_DIR_NAME"
echo ">>> You can now run it using: idea ~/projeto"
