#!/bin/bash

# if [ "$(uname)" == "Darwin" ]; then
#     # Do something under Mac OS X platform        
# elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
#     # Do something under GNU/Linux platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
#     # Do something under 32 bits Windows NT platform
# elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
#     # Do something under 64 bits Windows NT platform
# fi

set -e
trap 'echo "Error occurred at line $LINENO"' ERR

# Ensure script runs as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo privileges."
   exit 1
fi

update_envs () {
    echo "Updating and upgrading packages..."
    sudo apt update && sudo apt upgrade -y
}

install_docker () {
    echo "Installing Docker..."
    sudo apt-get install -y ca-certificates curl
    sudo mkdir -p /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo "Installing Docker Compose..."
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    sudo curl -SL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

install_nvim () {
    echo "Installing Neovim..."
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y neovim
}

install_essentials () {
    echo "Installing essential tools..."
    sudo apt install -y tmux ranger htop curl
    pip install --user gdown nvitop 
}

install_conda () {
    echo "Installing Anaconda..."
    CONDA_INSTALLER=$(curl -s https://repo.anaconda.com/archive/ | grep -oP 'Anaconda3-.*Linux-x86_64.sh' | head -1)
    curl -O https://repo.anaconda.com/archive/$CONDA_INSTALLER
    bash $CONDA_INSTALLER -b -p $HOME/anaconda3
    source $HOME/anaconda3/bin/activate
    conda update -y conda
    conda update -y anaconda
}

copy_configs () {
    cp ../tmux/.tmux.conf ~/
    mkdir -p ~/.config/nvim/
    cp -r ../neovim/* ~/.config/nvim/
}

run_flow () {
    update_envs
    install_essentials
    install_nvim
    install_conda
    install_docker
    copy_configs
}

case $1 in
    update_envs) update_envs ;;
    install_docker) install_docker ;;
    install_nvim) install_nvim ;;
    install_essentials) install_essentials ;;
    install_conda) install_conda ;;
    copy_configs) copy_configs ;;
    all) run_flow ;;
    *) echo "Usage: $0 {update_envs|install_docker|install_nvim|install_essentials|install_conda|copy_configs|all}"; exit 1 ;;
esac

