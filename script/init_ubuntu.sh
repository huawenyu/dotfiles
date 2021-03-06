#!/bin/bash
# Usage-dotfiles {{{1
# Please get the config into your home dir firstly.
# cd ~
# git clone https://github.com/huawenyu/dotfiles.git
#

# Basic {{{1
sudo apt-get update
sudo apt-get install -f
sudo update-rc.d cron defaults

sudo apt-get remove mono-runtime-common
sudo apt-get install -y audacious gnome-mplayer xfce4-notes
sudo apt-get install -y linuxbrew-wrapper

sudo apt-get install -y curl mutt ruby traceroute rlwrap smbclient sshpass openssh-server minicom lftp meld
sudo apt-get install -y build-essential file

# shell: zsh {{{2
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/huawenyu/zsh-local.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-local

# terminal: rxvt-unicode,alacritty {{{2
sudo apt-get install -y rxvt-unicode alacritty

# grep-like ripgrep {{{2
#sudo apt-get install -y silversearcher-ag
sudo add-apt-repository ppa:x4121/ripgrep
sudo apt-get update
sudo apt-get install -y ripgrep

# os tools {{{1

# vim/neovim {{{2

# vim/neovim plug manager {{{3

#From https://github.com/huawenyu/vim.config/blob/master/docs/nvim.md
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c 'PluginInstall'

mkdir ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

mkdir ~/.config
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim


# vim plugin: fzy {{{3
# Plugin fzy: https://github.com/jhawthorn/fzy
wget https://github.com/jhawthorn/fzy/releases/download/0.9/fzy_0.9-1_amd64.deb
sudo dpkg -i fzy_0.9-1_amd64.deb

# neovim as default {{{3
# neovim:
## https://github.com/neovim/neovim/wiki/Installing-Neovim
#sudo add-apt-repository ppa:neovim-ppa/stable
#sudo apt-get install software-properties-common
#sudo apt-get update
#sudo apt-get install neovim
## nvim :help nvim_python
##sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
##sudo update-alternatives --config vi
##sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
##sudo update-alternatives --config vim
##sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
##sudo update-alternatives --config editor
##sudo update-alternatives --config vimdiff		+=== choose /usr/bin/vimdiff.nvim

# home brew {{{2
# [brew](http://http://linuxbrew.sh/): substitute for apt-get install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
brew install neovim
# An kind of node package manager
brew install yarn
# Terminal Dashboard
brew install wtfutil

# Color command output:  https://github.com/garabik/grc
brew install grc

brew unlink python@2
brew unlink python@3

# make sure we not using brew's python: sometimes it's misup our python depended env
sudo apt-get install python-dev python-pip python3-dev python3-pip
sudo pip install neovim
sudo pip install pynvim
sudo pip install pexpect
sudo pip3 install neovim
sudo pip3 install pynvim

# ansi2txt (kbtin) {{{2
sudo apt-get install -y w3m kbtin

# helper-ts: cmd outout timestamp {{{2
# https://ostechnix.com/moreutils-collection-useful-unix-utilities/
#      chronic - Runs a command quietly unless it fails.
#      combine - Combine the lines in two files using boolean operations.
#      errno - Look up errno names and descriptions.
#      ifdata - Get network interface info without parsing ifconfig output.
#      ifne - Run a program if the standard input is not empty.
#      isutf8 - Check if a file or standard input is utf-8.
#      lckdo - Execute a program with a lock held.
#      mispipe - Pipe two commands, returning the exit status of the first.
#      parallel - Run multiple jobs at once.
#    pee - tee standard input to pipes.
#      sponge - Soak up standard input and write to a file.
#    ts - timestamp standard input.
#      vidir - Edit a directory in your text editor.
#      vipe - Insert a text editor into a pipe.
#      zrun - Automatically uncompress arguments to command.
sudo apt-get install -y moreutils


# taskwarrior {{{2
# https://taskwarrior.org/docs/examples.html
# taskserver-setup:  https://www.swalladge.net/archives/2018/03/17/taskwarrior-taskserver-syncing-tutorial/
sudo apt-get install -y taskwarrior
#    https://github.com/vit-project/vit/blob/2.x/vit/keybinding/vi.ini
#    VIT is a lightweight, fast, curses-based front end to Taskwarrior
sudo pip install vit

# Java JDK {{{2
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer
# Please add this line to the shell profile
# export JAVA_HOME="/usr/lib/jvm/java-8-oracle"


# Develop Env {{{1

# build tools {{{2
sudo apt-get install -y build-essential ia32-libs libc6-dbg:i386 manpages-dev
# Gcc Compile: check header not found error
# sudo updatedb
# locate stdio.h


# multiplex: tmux, screen {{{2
# https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/
# https://linuxize.com/post/how-to-use-linux-screen/#_
#    screen-config:
#       full-default-config: http://www.guckes.net/Setup/screenrc
#       sample-config-file:  https://gist.github.com/barryvanveen/2fcdfe95b0349a5daf1e
#    screen-usage: Use screen nested-in tmux pane to implement tmux's pane's share between different tmux-window:
#      screen -S doc    <=== start a server pane in one tmux-pane
#      screen -x doc    <=== then share the screen from other tmux-window-pane
sudo apt-get install -y tmux screen
## tmuxinator
#mkdir ~/.tmuxinator
#sudo gem install tmuxinator
#ln -s ~/dotfiles/tmuxinator_work.yml ~/.tmuxinator/work.yml

mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# git, svn, tig {{{2
sudo apt-get install -y git git-svn subversion tig
ln -s ~/dotfiles/tigrc ~/tigrc


## vim (+clientserver)
#sudo apt-get install -y vim-gnome
## vim (+lua): apt-cache search libluajit
#sudo apt-get install libluajit-5.1-2
# indexer: ctags, cscope {{{2
sudo apt-get install -y universal-ctags
sudo apt-get install -y tree cscope

## network tools {{{2
# wireshark {{{3
sudo add-apt-repository ppa:wireshark-dev/stable
sudo apt-get update
sudo apt-get install wireshark
sudo dpkg-reconfigure wireshark-common
sudo usermod -a -G wireshark $USER

# tshark {{{3
# tshark, command-line of wireshark
# tshark -i eth0 -w tmp.pcap
sudo apt-get install --force-yes tshark
sudo chgrp $USER /usr/bin/dumpcap
sudo chmod 750 /usr/bin/dumpcap
sudo setcap cap_net_raw,cap_net_admin+eip /usr/bin/dumpcap


# tftp {{{3
sudo apt-get install xinetd tftpd tftp
sudo cp tftp /etc/xinetd.d/tftp
sudo mkdir /tftpboot
sudo chmod -R 777 /tftpboot
sudo chown -R nobody /tftpboot
sudo service xinetd restart

# Samba {{{3
## https://help.ubuntu.com/community/Samba/SambaServerGuide
## Assume linux already have a username $USER, otherwise please add it first.
#sudo apt-get install -y samba smbclient
#sudo smbpasswd -a $USER
#sudo patch -p0 /etc/samba/smb.conf patch.smbconf
#sudo smbpasswd -a $USER
#sudo smbd reload
#sudo service smbd restart
## List all shares:
##smbclient -L //<HOST_IP_OR_NAME>/<folder_name> -U <user>
## connect:
##smbclient //<HOST_IP_OR_NAME>/<folder_name> -U <user>

# If laptop, install battery
#sudo apt-get install indicator-power

# System Admin {{{1

# Startup.sh {{{2
crontab -l > /tmp/my-crontab
echo "@reboot sh /home/$USER/.startup.sh > /tmp/cronlog 2>&1" >> /tmp/my-crontab
sudo crontab /tmp/my-crontab

