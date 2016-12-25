#!/bin/bash

set -e

# fix locale issue for now
export LANG="en_US.utf8"
export LANGUAGE="en_US.utf8"
export LC_ALL="en_US.utf8"

# update and some useful packages
apt-get update
apt-get upgrade -y
apt-get install -y ntp ntpstat vim git python-pip glances
pip install pip --upgrade

# fix locale issue forever
if [[ $(wc -l < /etc/environment) = 1 ]]; then
  echo 'LC_ALL="en_US.UTF-8"' >> /etc/environment
fi

# install docker and compose
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
            --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
if [[ ! -f /etc/apt/sources.list.d/docker.list ]]; then
  rel=$(lsb_release -cs)
  echo "deb https://apt.dockerproject.org/repo ubuntu-$rel main" > \
       /etc/apt/sources.list.d/docker.list
fi

apt-get update
apt-get install -y docker-engine
pip install docker-compose

# skeleton for new users
rm -rf /etc/skel/.ssh /etc/skel/.vim /etc/skel/gitprompt

# aliases
echo 'alias dc=docker-compose' > /etc/skel/.bash_aliases
echo 'alias d=docker' >> /etc/skel/.bash_aliases

# ssh
mkdir -p /etc/skel/.ssh
chmod 700 /etc/skel/.ssh
touch /etc/skel/.ssh/authorized_keys
chmod 600 /etc/skel/.ssh/authorized_keys

# vim
echo 'set nocompatible
set autoindent
set backup
set nu
set smartindent
set showmatch
set textwidth=80
set title
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set paste
set noswapfile
set nobackup
set nowritebackup
syntax on
set t_Co=256
filetype on
filetype indent on
filetype plugin on
set modeline
set ls=2
colorscheme molokai' > /etc/skel/.vimrc
git clone https://github.com/vertisfinance/molokai.git /etc/skel/.vim

# prompt
git clone https://github.com/richardbann/gitprompt.git /etc/skel/gitprompt
echo 'complete -F _docker_compose dc' >> /etc/skel/.bashrc
echo 'set_bash_prompt(){
    PS1="$(python ~/gitprompt/prompt.py)"
}

PROMPT_COMMAND=set_bash_prompt' >> /etc/skel/.bashrc

# bash completion
dcv=$(docker-compose version --short)
url=https://raw.githubusercontent.com/docker/compose/$dcv
url=$url/contrib/completion/bash/docker-compose
curl -L $url -o /etc/bash_completion.d/docker-compose

# default user
read -er -p "administrator username (enter to skip): " username
if [[ -n $username ]]; then
  if [[ $(id -u $username 2>/dev/null | wc -m) = 0 ]]; then
    adduser $username
  else
    echo "user $username already exists"
  fi

  # make this a sudo user
  read -p "add this user to sudoers' list? (Yn): " yn
  if [[ ! $(echo ${yn,} | cut -c 1) = 'n' ]]; then
    adduser $username sudo
  fi

  read -p "add public key? (Yn): " yn
  if [[ ! $(echo ${yn,} | cut -c 1) = 'n' ]]; then
    read -er -p 'public key for the user: ' pubkey
    echo $pubkey >> /home/$username/.ssh/authorized_keys
  fi
fi

# sshd config
read -p "modify sshd config? (yN): " yn
if [[ $(echo ${yn,} | cut -c 1) = 'y' ]]; then
  conf=/etc/ssh/sshd_config
  sed -ri 's/^#?(PasswordAuthentication|PermitRootLogin).*/\1 no/' "$conf"
fi

read -p "reboot now? (yN): " yn
if [[ $(echo ${yn,} | cut -c 1) = 'y' ]]; then
  reboot
fi
