apt-get install -y vim git python-pip curl
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list
apt-get update -y
apt-get upgrade -y
apt-get install -y docker-engine glances
pip install docker-compose
mkdir -p /etc/skel/
sh -c "echo 'alias dc=docker-compose
alias d=docker' > /etc/skel/.bash_aliases"
sh -c "echo 'alias dc=docker-compose
alias d=docker' > ~/.bash_aliases"
mkdir -p /etc/skel/.ssh
mkdir -p ~/.ssh
chmod 700 /etc/skel/.ssh
chmod 700 ~/.ssh
sh -c "echo '' > /etc/skel/.ssh/authorized_keys"
sh -c "echo '' > ~/.ssh/authorized_keys"
chmod 640 /etc/skel/.ssh/authorized_keys
chmod 640 ~/.ssh/authorized_keys
sh -c "echo 'set nocompatible
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
colorscheme molokai' > /etc/skel/.vimrc"
sh -c "echo 'set nocompatible
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
colorscheme molokai' > ~/.vimrc"
rm -rf /etc/skel/.vim
rm -rf ~/.vim
git clone https://github.com/vertisfinance/molokai.git /etc/skel/.vim/
git clone https://github.com/vertisfinance/molokai.git ~/.vim/
curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose | tee /etc/bash_completion.d/docker-compose
git clone https://github.com/richardbann/gitprompt.git /etc/skel/
git clone https://github.com/richardbann/gitprompt.git ~/
sh -c "echo 'complete -F _docker_compose dc >> /etc/skel/.bashrc'""
sh -c "echo 'complete -F _docker_compose dc >> ~/.bashrc'""
sh -c "echo 'set_bash_prompt(){
    PS1="$(python [~/gitprompt/prompt.py)"
}

PROMPT_COMMAND=set_bash_prompt >> /etc/skel/.bashrc'"
sh -c "echo 'set_bash_prompt(){
    PS1="$(python [~/gitprompt/prompt.py)"
}

PROMPT_COMMAND=set_bash_prompt >> ~/.bashrc'"
