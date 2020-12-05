#!/bin/sh

# Ensuring that apt supports https
sudo apt update
sudo apt upgrade
apt-get install -y gnupg-agent software-properties-common apt-transport-https wget curl

# Download OpenVPN
echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" >/etc/apt/sources.list.d/openvpn.list
wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -
apt-get update
apt-get install -y openvpn iptables openssl ca-certificates
apt-get update

# Download Easy-rsa
local version="3.0.7"
wget -O ~/easy-rsa.tgz https://github.com/OpenVPN/easy-rsa/releases/download/v${version}/EasyRSA-${version}.tgz
mkdir -p /etc/openvpn/easy-rsa
tar xzf ~/easy-rsa.tgz --strip-components=1 --directory /etc/openvpn/easy-rsa
rm -f ~/easy-rsa.tgz

sudo apt-get install rkhunter

# Download VS Code
# Import the Microsoft GPG key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
# Enable the Visual Studio Code repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
sudo apt install -y code

# Download GOLANG and confirm
cd ~
wget https://golang.org/dl/go1.15.6.src.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

# Download Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Download Front-End Tools
sudo npm install npm -g
sudo apt install nodejs

# Download Brave Browser
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install -y brave-browser

# Download Spotify
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client

# Download Git & ZSH
apt-get install -y git
apt-get install -y zsh
zsh --version
# Make zsh the default shell for the current user
sudo usermod -s /usr/bin/zsh $(whoami)

# Install CLI Aesthetics
apt-get install -y powerline fonts-powerline
apt-get install -y zsh-theme-powerlevel9k
# echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> ~/.zshrc
sudo apt-get install -y zsh-syntax-highlighting
# Install Oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/
install.sh -O -)"

# Download GitHub repos
cd ~
cd Development
git clone https://github.com/Tristan6/Tristan6.git
git clone https://github.com/Tristan6/tristan6.github.io.git
git clone https://github.com/Tristan6/slack-clone-client.git
cd -

cd ~/go/src
git clone https://github.com/Tristan6/server-side-mirror.git
cd -

# Download gparted in case you need to repartition the Ubuntu volume
mkdir software; cd software
sudo apt-get install -y gparted
cd -

# Make zsh the default shell
exec zsh
# Restart the machine (laptop/desktop/etc.)
sudo reboot