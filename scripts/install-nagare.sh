#!/bin/bash

VERSION="0.0.3"
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

# Map architecture names
case "${ARCH}" in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
esac

BINARY_NAME="nagare_${VERSION}_${OS}_${ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/saasuke-labs/nagare/releases/download/v${VERSION}/${BINARY_NAME}"

echo "Downloading nagare v${VERSION} for ${OS}/${ARCH}..."
curl -L -o "${BINARY_NAME}" "${DOWNLOAD_URL}"

echo "Extracting binary..."
tar xzf "${BINARY_NAME}"

echo "Installing nagare..."
chmod +x nagare
sudo mv nagare /usr/local/bin/

echo "Cleaning up..."
rm "${BINARY_NAME}"

echo "nagare v${VERSION} installed successfully!"
nagare version
