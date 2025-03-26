#!/bin/bash

# Step 1: Install Rust
echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | sh  # Choose default, just press enter
. "$HOME/.cargo/env"

# Step 2: Install jq (For Ubuntu via apt-get)
echo "Installing jq..."
if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y jq
else
    echo "apt-get not found, please ensure you're using Ubuntu or Debian-based system."
    exit 1
fi

# Step 3: Install sfoundryup
echo "Installing sfoundryup..."
curl -L \
     -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Source the bashrc to apply changes
source ~/.bashrc

# Step 4: Run sfoundryup
echo "Running sfoundryup..."
sfoundryup  # This could take between 5m to 60m and may stall at 98% (which is normal)

# Step 5: Clone repository
echo "Cloning repository..."
git clone --recurse-submodules https://github.com/SeismicSystems/try-devnet.git
cd try-devnet/packages/contract/

# Step 6: Deploy contract
echo "Deploying contract..."
bash script/deploy.sh

echo "Setup completed!"
