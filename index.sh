#!/bin/bash

# Step 1: Install Rust
echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y  # Chọn cài đặt mặc định
. "$HOME/.cargo/env"

# Step 2: Install prerequisites (jq, git, file)
echo "Installing prerequisites..."
if command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y jq git file  # Thêm file utility để tránh lỗi với sfoundryup
else
    echo "apt-get not found, please ensure you're using Ubuntu or Debian-based system."
    exit 1
fi

# Step 3: Install sfoundryup
echo "Installing sfoundryup...1"
curl -L \
     -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash

# Cập nhật PATH và kiểm tra cài đặt sfoundryup
source ~/.bashrc
export PATH=$PATH:/root/.seismic/bin
if [ ! -f "/root/.seismic/bin/sfoundryup" ]; then
    echo "sfoundryup installation failed. Please check the installation logs."
    exit 1
fi

# Step 4: Run sfoundryup
echo "Running sfoundryup..."
sfoundryup  # Quá trình này có thể mất từ 5 đến 60 phút và có thể dừng ở 98% (bình thường)

# Kiểm tra xem scast có sẵn không
if ! command -v scast &>/dev/null; then
    echo "scast not found. Please ensure sfoundry is installed correctly."
    exit 1
fi

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
