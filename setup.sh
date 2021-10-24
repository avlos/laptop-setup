#!/usr/bin/env bash

# From https://askubuntu.com/questions/1289947/how-i-can-customize-the-ubuntu-live-iso-installer-using-cubic-add-remove-and
# add-apt-repository --yes main
# add-apt-repository --yes restricted
# add-apt-repository --yes universe
# add-apt-repository --yes multiverse


# Update and upgrade the system
sudo apt-get update
sudo apt-get -y dist-upgrade

# Add useful packages

sudo apt-get install -y curl iftop iotop vim neovim pydf silversearcher-ag libgmp-dev gettext gnome-tweaks net-tools libglib2.0-dev dconf-cli git gconf2 gconf-service tmux screen htop python-is-python3
sudo apt-get install -y ca-certificates curl gnupg lsb-release build-essential make libsass1 sassc

# Remove unneeded Packages
# apt autoremove --purge totem rhythmbox

# Install Albert
# https://albertlauncher.github.io/installing/
# Full example for Ubuntu 20.04
echo "Installing Albert"
curl https://build.opensuse.org/projects/home:manuelschneid3r/public_key | sudo apt-key add -
echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_20.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
sudo apt-get update
sudo apt-get -y install albert

echo "Installing Mattermost"
# Instal mattermost application
# https://docs.mattermost.com/install/desktop-app-install.html#ubuntu-and-debian-based-systems
cd /tmp
wget https://releases.mattermost.com/desktop/5.0.1/mattermost-desktop-5.0.1-linux-amd64.deb
sudo dpkg -i mattermost-desktop-5.0.1-linux-amd64.deb

# Install Slack application
# https://slack.com/intl/en-gr/downloads/linux
# wget https://downloads.slack-edge.com/releases/linux/4.20.0/prod/x64/slack-desktop-4.20
# sudo dpkg -i slack-desktop-4.20

# Install google chrome
# Taken from https://www.ubuntuupdates.org/ppa/google_chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Setup 1password for ubuntu
# Taken from https://support.1password.com/install-linux/
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main' | sudo tee /etc/apt/sources.list.d/1password.list
sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
sudo apt-get update
sudo apt-get install -y 1password

# Get some customizations going
mkdir ~/.local/src
cd ~/.local/src

# Install ArcMenu
# https://gitlab.com/arcmenu/ArcMenu/-/wikis/Install-From-Source-Guide
git clone --single-branch --branch gnome-3.36/3.38 https://gitlab.com/arcmenu/ArcMenu.git
cd ArcMenu
make install

# Install Orchis-theme
cd ~/.local/src
git clone https://github.com/vinceliuice/Orchis-theme.git
cd Orchis-theme
./install.sh --name Avlos

# Install awesome gnome-terminal themes from Gogh
# bash -c  "$(wget -qO- https://git.io/vQgMr)"

# ADD THESE TO /etc/skel
# Get a great screenrc file
cd
wget https://gist.githubusercontent.com/joaopizani/2718397/raw/9e2560b77e1e1298ef24be16297d853f9885b20d/.screenrc

# Setup awesome tmux configuration
cd
git clone https://github.com/shamangeorge/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# Setup oh-my-bash (for some awesome bash customization)
# https://github.com/ohmybash/oh-my-bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# Set the gnome desktop
# https://linuxconfig.org/set-wallpaper-on-ubuntu-20-04-using-command-line
wget -O $HOME/Pictures/wallpaper.png https://avlos.ai/avlos_linux_desktop.png
gsettings set org.gnome.desktop.background picture-uri file:////$HOME/Pictures/wallpaper.png

# Customize grub
# https://github.com/stuarthayhurst/argon-grub-theme
# Some other cool themes here: https://github.com/sandesh236/sleek--themes
# General search here: https://www.gnome-look.org/browse?cat=109&ord=latest
# Also check the gnu grub2 manual https://www.gnu.org/software/grub/manual/grub/html_node/Simple-configuration.html
cd ~/.local/src
git clone https://github.com/stuarthayhurst/argon-grub-theme.git
cd argon-grub-theme
sudo ./install.sh -i -b $HOME/Pictures/wallpaper.png --icons coloured

# Enable customization of login screen
# https://www.linuxuprising.com/2021/05/how-to-change-gdm3-login-screen-greeter.html
# https://mike632t.wordpress.com/2016/05/28/gnome-3-customizing-the-login-screen/
cd ~/.local/src
git clone --depth=1 https://github.com/realmazharhussain/gdm-tools.git
cd gdm-tools
./install.sh
set-gdm-theme backup update
set-gdm-theme set -b $HOME/Pictures/wallpaper.png

# Setup docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Setup docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Instal awscli v2
# https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html

# To customize the desktop change /usr/share/glib-2.0/schemas/10_ubuntu-settings.gschema.override
# https://help.gnome.org/admin/system-admin-guide/stable/desktop-favorite-applications.html.en
# Taken from https://itectec.com/ubuntu/ubuntu-how-to-customise-gnome-default-background-and-lock-screen-image/
# Fix the pubkey issues https://chrisjean.com/fix-apt-get-update-the-following-signatures-couldnt-be-verified-because-the-public-key-is-not-available/
#[org.gnome.shell]
#favorite-apps = [ 'org.gnome.Nautilus.desktop', 'google-chrome.desktop', 'mattermost-desktop.desktop', '1password.desktop', 'org.gnome.Terminal.desktop' ]

#[org.gnome.desktop.background]
#picture-uri = 'file:///usr/share/backgrounds/avlos_linux_desktop.png'

#[org.gnome.desktop.screensaver]
#picture-uri = 'file:///usr/share/backgrounds/avlos_linux_desktop.png'

# then run
# sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

