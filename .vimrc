if has("autocmd")
    filetype on
    filetype indent on
    filetype plugin on
endif

syntax on

set nocompatible
set showcmd
set ruler
set laststatus=2
set paste
set showtabline=2
set title
set confirm
set nonumber
set hlsearch
:colorscheme elflord
set wcm=<Tab>
set backupcopy=yes

map <F2> i#!/bin/bash<ESC>o# This file was created on <ESC>:r!date "+\%c"<ESC>kJ<ESC>
map <F3> i# Last edit on <ESC>:r!date "+\%c"<ESC>kJ<ESC>
imap <f9> <esc>:set<space>nu!<cr>a
nmap <f9> :set<space>nu!<cr>
"imap <F2> <Esc>:w<CR>
"map <F2> <Esc>:w<CR>
imap <F4> <Esc>:browse tabnew<CR> 
map <F4> <Esc>:browse tabnew<CR>
imap <F5> <Esc> :tabprev <CR>i
map <F5> :tabprev <CR>
imap <F6> <Esc> :tabnext <CR>i
map <F6> :tabnext <CR>

menu Exit.quit     :quit<CR>
menu Exit.quit!    :quit!<CR>
menu Exit.save     :exit<CR>
map <F10> :emenu Exit.<Tab>		

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

"set autoindent"
set smartindent
"set smarttab"
set shiftwidth=2
set softtabstop=2
set tabstop=4
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

filetype plugin on
filetype indent on

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital


set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2

" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256

