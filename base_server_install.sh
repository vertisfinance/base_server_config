export LC_ALL="en_US.UTF-8"
sudo apt-get install -y vim git python-pip curl
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y docker-engine
sudo pip install docker-compose
sudo mkdir -p /etc/skel/
sudo sh -c "echo 'alias dc=docker-compose
alias d=docker' > /etc/skel/.bash_aliases"
sudo mkdir -p /etc/skel/.ssh
sudo sh -c "echo '' > /etc/skel/.ssh/authorized_keys"
sudo sh -c "echo 'set nocompatible
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
syntax on
set t_Co=256
filetype on
filetype indent on
filetype plugin on
set modeline
set ls=2
colorscheme molokai' > /etc/skel/.vimrc"
sudo rm -rf /etc/skel/.vim
sudo git clone https://github.com/vertisfinance/molokai.git /etc/skel/.vim/
