#!/bin/bash

# Function to handle errors
handle_error() {
    local error_message="$1"
    echo "ERROR: $error_message"
    exit 1
}

# Define the paths to the source files
CURRENT_DIR=$(pwd)
APP_FILE="$CURRENT_DIR/OpenApplist"
APP_LIST_FILE="$CURRENT_DIR/app_list.txt"
ICON_FILE="$CURRENT_DIR/resources/OpenApplistIcon.icns"
INFO_PLIST_FILE="$CURRENT_DIR/resources/Info.plist"

# Validate input files
for file in "$APP_FILE" "$APP_LIST_FILE" "$ICON_FILE" "$INFO_PLIST_FILE"; do
    [ -f "$file" ] || handle_error "$file does not exist."
done

# Define destination directories and their respective files to be copied
APPLICATION_DIR="/Applications/OpenApplist.app"
DEST_DIRS=("$APPLICATION_DIR" "$HOME/Library/Application Support/OpenApplist" "$APPLICATION_DIR/Contents/Resources" "$APPLICATION_DIR/Contents")
FILES_TO_COPY=("$APP_FILE" "$APP_LIST_FILE" "$ICON_FILE" "$INFO_PLIST_FILE")

# Remove the primary application directory if it exists
if [ -d "$APPLICATION_DIR" ]; then
    echo "Directory $APPLICATION_DIR already exists. Removing..."
    sudo rm -rf "$APPLICATION_DIR" || handle_error "Failed to remove $APPLICATION_DIR"
fi

# Initialize an array to hold the output lines for clean formatting
output_lines=()

# Create directories and copy files
for (( i=0; i<${#DEST_DIRS[@]}; i++ )); do
    dest_dir="${DEST_DIRS[i]}"
    file_to_copy="${FILES_TO_COPY[i]}"
  
    # Prepare the directory
    sudo mkdir -p "$dest_dir" || handle_error "Failed to create directory $dest_dir"
  
    # Copy the file
    sudo cp "$file_to_copy" "$dest_dir" || handle_error "Failed to copy $file_to_copy to $dest_dir"
  
    # Add the copy operation to the output lines array using '|' as a delimiter
    output_lines+=("Copied|$(basename "$file_to_copy")|to|$dest_dir")
done

# Print the output lines aligned using '|' as the delimiter for columns
printf "%s\n" "${output_lines[@]}" | column -s '|' -t

echo "All necessary files have been copied."

# Add OpenApplist to login items
echo "Adding OpenApplist to login items..."
if osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$APPLICATION_DIR\", hidden:false}" >/dev/null 2>&1; then
    echo "Login item added successfully."
else
    handle_error "Failed to add OpenApplist to login items"
fi

echo "Script execution completed."
