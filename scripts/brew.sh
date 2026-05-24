/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >> "$HOME/.zshrc"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo pacman -S base-devel
brew install gcc
