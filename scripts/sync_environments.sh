#!/bin/bash
# Bash script to synchronize Terraform files from dev to stg and prod environments.
# Development purpose: Maintain consistency across environments.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SOURCE_DIR="$SCRIPT_DIR/../environments/dev"
TARGET_DIRS=("$SCRIPT_DIR/../environments/stg" "$SCRIPT_DIR/../environments/prod")

for TARGET_DIR in "${TARGET_DIRS[@]}"; do
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
        echo "Created directory: $TARGET_DIR"
    fi

    echo "Synchronizing files to: $TARGET_DIR"

    # Copy *.tf files
    cp "$SOURCE_DIR"/*.tf "$TARGET_DIR/" 2>/dev/null
    
    # Copy *.tfvars files
    cp "$SOURCE_DIR"/*.tfvars "$TARGET_DIR/" 2>/dev/null

    echo "  Synchronization to $(basename "$TARGET_DIR") complete."
done

echo "Global synchronization complete!"
