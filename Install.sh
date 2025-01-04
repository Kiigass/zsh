#!/bin/bash

# Ensure the script is being run with bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script must be run with bash."
    exit 1
fi

# This will make the script exit on every error
set -e

# Update package list and install prerequisites
echo "We are running sudo. The password requested is your sudo-pw."
sudo apt update
sudo apt install -y git curl zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Set Zsh as the default shell
chsh -s $(which zsh)

# Download and install MesloLGS NF fonts
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

declare -a fonts=( \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" \
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" \
)

for font_url in "${fonts[@]}"; do
    font_file="$FONT_DIR/$(basename "$font_url")"
    curl -fLo "$font_file" "$font_url"
done

# Update font cache
fc-cache -fv

echo "MesloLGS NF fonts installed. Please set them as your terminal font."

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install fzf-zsh-plugin
git clone --depth 1 https://github.com/unixorn/fzf-zsh-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-zsh-plugin
sed -i 's/plugins=(/plugins=(fzf-zsh-plugin /' ~/.zshrc

# Install fzf-tab plugin
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
sed -i 's/plugins=(/plugins=(fzf-tab /' ~/.zshrc

# Install zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc

# Install zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/plugins=(/plugins=(zsh-syntax-highlighting /' ~/.zshrc

# Apply changes
# source ~/.zshrc

echo "Installation complete. PLEASE RESTART YOUR TERMINAL."

