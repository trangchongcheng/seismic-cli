#!/bin/bash

# Step 1: Install Rust
echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | sh  # Choose default, just press enter
. "$HOME/.cargo/env"

# Step 2: Install jq (For Ubuntu via apt-get)
echo "Installing jq..."
if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y jq git  # Ensure git is installed
else
    echo "apt-get not found, please ensure you're using Ubuntu or Debian-based system."
    exit 1
fi

# Step 3: Install sfoundryup
echo "Installing sfoundryup...1"
curl -L \
     -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Ensure sfoundryup is in the PATH
echo 'export PATH=$PATH:/root/.seismic/bin' >> ~/.bashrc
source ~/.bashrc

# Step 4: Run sfoundryup
echo "Running sfoundryup...1"
if ! command -v sfoundryup &>/dev/null; then
    echo "sfoundryup installation failed or not found. Please check the installation logs."
    exit 1
fi

sfoundryup  # This could take between 5m to 60m and may stall at 98% (which is normal)

# Step 5: Clone repository
echo "Cloning repository..."
git clone --recurse-submodules https://github.com/SeismicSystems/try-devnet.git
cd try-devnet/packages/contract/

# Check if deploy script exists
if [[ ! -f "script/deploy.sh" ]]; then
    echo "Deploy script not found. Please ensure the repository structure is correct."
    exit 1
fi

# Step 6: Deploy contract
echo "Deploying contract..."
bash script/deploy.sh

echo "Setup completed!"
