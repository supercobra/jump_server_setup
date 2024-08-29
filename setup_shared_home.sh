#!/bin/bash

# What the Script Does:
# Script to set up multiple users sharing the same home directory
#
# Creates the shared directory if it doesn’t exist.
# Creates a group (sharedgroup) if it doesn’t exist.
# Sets the correct ownership and permissions on the shared directory.
# Adds each specified user to the shared group.
# Changes each user's home directory to the shared directory.
# Ensures each user has a umask setting that ensures proper permissions for new files created in the shared directory.
# This script will set up the environment so that multiple users can safely share the same home directory.
#
# Usage:
# sudo ./setup_shared_home.sh user1 user2 user3

# Variables
SHARED_DIR="/shared/home"
GROUP_NAME="sharedgroup"
PERMISSIONS="770"

# Display usage help message if no arguments are provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 username1 username2 ... usernameN"
    echo "Example: $0 user1 user2 user3"
    echo "This script sets up multiple users to share the same home directory."
    echo "The shared directory is set to $SHARED_DIR."
    exit 1
fi

# Create the shared home directory
if [ ! -d "$SHARED_DIR" ]; then
    echo "Creating shared home directory at $SHARED_DIR"
    sudo mkdir -p "$SHARED_DIR"
fi

# Create the group if it doesn't exist
if ! getent group "$GROUP_NAME" > /dev/null; then
    echo "Creating group $GROUP_NAME"
    sudo groupadd "$GROUP_NAME"
else
    echo "Group $GROUP_NAME already exists"
fi

# Set ownership and permissions on the shared directory
echo "Setting ownership and permissions on $SHARED_DIR"
sudo chown root:"$GROUP_NAME" "$SHARED_DIR"
sudo chmod "$PERMISSIONS" "$SHARED_DIR"
sudo chmod g+s "$SHARED_DIR"

# Function to add users to the shared directory
add_user_to_shared_home() {
    local username="$1"

    # Check if the user exists
    if id "$username" &>/dev/null; then
        echo "Adding user $username to group $GROUP_NAME"
        sudo usermod -aG "$GROUP_NAME" "$username"

        echo "Changing home directory of $username to $SHARED_DIR"
        sudo usermod -d "$SHARED_DIR" "$username"

        # Set umask globally for the user
        echo "Setting umask for user $username globally"
        if ! sudo grep -q "umask 007" "/etc/profile"; then
            echo "umask 007" | sudo tee -a "/etc/profile" > /dev/null
        fi
    else
        echo "User $username does not exist. Skipping."
    fi
}

# Add users to the shared directory
for user in "$@"; do
    add_user_to_shared_home "$user"
done

echo "Setup complete. The following users have been configured to share $SHARED_DIR: $@"
