#!/bin/bash

APP_NAME="directory-sharing-app"
VERSION="1.0.0"
JAR_FILE="target/${APP_NAME}-${VERSION}.jar"
INSTALL_DIR="/usr/local/lib/${APP_NAME}"
SCRIPT_DEST="/usr/local/bin/dir-share"

echo "Building the project..."
mvn clean package
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting."
    exit 1
fi

echo "Creating install directory: $INSTALL_DIR"
sudo mkdir -p "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo "Failed to create $INSTALL_DIR. Exiting."
    exit 1
fi

echo "Copying JAR to $INSTALL_DIR"
sudo cp "$JAR_FILE" "$INSTALL_DIR/"
if [ $? -ne 0 ]; then
    echo "Failed to copy JAR. Exiting."
    exit 1
fi

echo "Creating and installing dir-share script to $SCRIPT_DEST"
cat << EOF | sudo tee "$SCRIPT_DEST" > /dev/null
#!/bin/bash
JAR_FILE="$INSTALL_DIR/${APP_NAME}-${VERSION}.jar"

if [ ! -f "\$JAR_FILE" ]; then
    echo "JAR file not found at \$JAR_FILE. Please install it first."
    exit 1
fi

PORT=8080
while getopts "p:d:" opt; do
    case \$opt in
        p) PORT="\$OPTARG";;
        d) DIR="\$OPTARG";;
    esac
done

if lsof -i :\$PORT > /dev/null; then
    echo "Port \$PORT is in use by:"
    lsof -i :\$PORT
    exit 1
fi

java -jar "\$JAR_FILE" "\$@"
EOF

sudo chmod +x "$SCRIPT_DEST"
if [ $? -ne 0 ]; then
    echo "Failed to set executable permissions on $SCRIPT_DEST. Exiting."
    exit 1
fi

echo "Installation complete! You can now run 'dir-share' from anywhere."