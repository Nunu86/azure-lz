#!/usr/bin/env bash

set -euo pipefail

echo "🧹 Cleaning Terraform/Terragrunt caches..."

# Remove all .terraform directories
find . -type d -name ".terraform" -prune -exec rm -rf {} +
echo "✅ Removed all .terraform directories"

# Remove all .terraform.lock.hcl files
find . -type f -name ".terraform.lock.hcl" -exec rm -f {} +
echo "✅ Removed all .terraform.lock.hcl files"

# Optional: remove Terragrunt cache
find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} +
echo "✅ Removed all .terragrunt-cache directories"

echo "🎉 Cleanup complete!"