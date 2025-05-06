#!/bin/bash

# iCloud Shortcut Source Code Extractor
# Converts iCloud shortcut links to XML format
# Usage: ./shortcut-extractor.sh <iCloud link>
# original author: zhuxingtongxue

set -e

# Check parameters
if [ $# -lt 1 ]; then
  echo "Usage: $0 <iCloud shortcut link>"
  exit 1
fi

# Define variables
SHORTCUT_URL="$1"

echo "Starting to process shortcut: $SHORTCUT_URL"

# Check for plutil
if ! command -v plutil &> /dev/null; then
  echo "Error: Need to install plutil"
  exit 1
fi

# Extract shortcut ID from URL
SHORTCUT_ID=$(echo "$SHORTCUT_URL" | grep -o '[^/]*$')
if [ -z "$SHORTCUT_ID" ]; then
  echo "Error: Unable to extract shortcut ID from URL"
  exit 1
fi

# Build API URL
API_URL="https://www.icloud.com/shortcuts/api/records/$SHORTCUT_ID"
echo "API URL: $API_URL"

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download API data
echo "Downloading shortcut metadata..."
RESPONSE_FILE="$TMP_DIR/response.json"
curl -s "$API_URL" > "$RESPONSE_FILE"

# Check API response
if ! jq -e . "$RESPONSE_FILE" &>/dev/null; then
  echo "Error: API response is not valid JSON"
  cat "$RESPONSE_FILE"
  exit 1
fi

# Extract download URL and shortcut name
DOWNLOAD_URL=$(jq -r '.fields.shortcut.value.downloadURL' "$RESPONSE_FILE")
SHORTCUT_NAME=$(jq -r '.fields.name.value' "$RESPONSE_FILE")

# If name is null or empty, use ID as name
if [ -z "$SHORTCUT_NAME" ] || [ "$SHORTCUT_NAME" == "null" ]; then
  SHORTCUT_NAME="shortcut_$SHORTCUT_ID"
fi

# Clean filename
SHORTCUT_NAME=$(echo "$SHORTCUT_NAME" | tr ' ' '_' | tr -cd '[:alnum:]_-')
echo "Shortcut name: $SHORTCUT_NAME"

if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" == "null" ]; then
  echo "Error: Unable to find download link"
  exit 1
fi

echo "Download link: $DOWNLOAD_URL"

# Download plist file
PLIST_FILE="$TMP_DIR/$SHORTCUT_NAME.plist"
echo "Downloading shortcut plist file..."
curl -s "$DOWNLOAD_URL" -o "$PLIST_FILE"

# Check plist file
if [ ! -s "$PLIST_FILE" ]; then
  echo "Error: Plist file download failed or is empty"
  exit 1
fi

# Output file
OUTPUT_FILE="$SHORTCUT_NAME.xml"

# Convert plist to XML format
echo "Converting to XML format..."
plutil -convert xml1 "$PLIST_FILE" -o "$OUTPUT_FILE"

echo "Success! Shortcut saved as: $OUTPUT_FILE"

# Print file size
echo ""
echo "Shortcut information:"
echo "File size: $(du -h "$OUTPUT_FILE" | cut -f1)"