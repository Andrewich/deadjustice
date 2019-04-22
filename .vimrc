colorscheme darkblue
set nocompatible 
set scrolloff=3 
set wrap
set linebreak 
set showmatch 
set autoread 
set t_Co=256 
set laststatus=2 
set noruler 
set noswapfile 
set visualbell 
set clipboard=unnamed 
syntax on
set shiftwidth=3
set tabstop=3
set softtabstop=3
set autoindent
set cindent
set expandtab
set smartindent
set list

execute pathogen#infect()
syntax on
filetype plugin indent on

autocmd vimenter * NERDTree
