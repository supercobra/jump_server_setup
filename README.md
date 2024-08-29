# README: Jump ssh server with shared home directory

This setup allows multiple users to share the same home directory while maintaining proper permissions and security. It also installs build tools and libraries that are commonly needed for software development for ruby and ruby gems.
)

## What the script does

Script to set up multiple users sharing the same home directory

- Creates the shared directory if it doesn’t exist.
- Creates a group (sharedgroup) if it doesn’t exist.
- Sets the correct ownership and permissions on the shared directory.
- Adds each specified user to the shared group.
- Changes each user's home directory to the shared directory.
- Ensures each user has a umask setting that ensures proper permissions for new files created in the shared directory.
- This script will set up the environment so that multiple users can safely share the same home directory.

Usage:
    # users must already exists
    sudo ./setup_shared_home.sh user1 user2 user3

Or to run the script from the repo, run:

    # replace user1 user2 user3 with the actual user names

    bash <(wget -qO- https://raw.githubusercontent.com/supercobra/jump_server_setup/master/setup_shared_home.sh user1 user2 user3)

## Optionally setup_build_tools.sh

Do this if you are setting up a new jump server that uses ruby and ruby gems. Do this as a second step after setting up the shared home directory.

This script installs build tools and libraries that are commonly needed for software development for ruby and ruby gems.

Usage:

    sudo ./setup_build_tools.sh

or

To run the script from the repo, run:

    bash <(wget -qO- https://raw.githubusercontent.com/supercobra/jump_server_setup/master/setup_build_tools.sh
