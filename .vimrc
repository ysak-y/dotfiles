scriptencoding utf-8
set number 
set autoindent
set shiftwidth=2
set tabstop=2
set paste
set nocompatible

"Leaderの設定
let mapleader = ","
" ,のデフォルト機能を使うために\に設定
noremap \ ,

" 括弧の補完
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
nnoremap <C-e> :NERDTreeToggle<CR>

inoremap jj <Esc>
nmap <Space>u [unite]
nnoremap [unite] <Nop>
" 色コード
autocmd ColorScheme * highlight LineNr ctermfg=74
colorscheme hybrid 


if has("vim_starting")
  filetype plugin off
  filetype indent off
  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
endif

call neobundle#begin(expand('~/.vim/bundle'))

set expandtab
set noswapfile
set nobackup
" インデントに色を付けて見やすくする
NeoBundle "vim-scripts/taglist.vim" 
NeoBundle "Shougo/unite.vim"
NeoBundle 'tpope/vim-endwise'
NeoBundle "Shougo/vimproc"
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'taichouchou2/surround.vim'
NeoBundle 'hail2u/vim-css3-syntax'
" NeoBundle 'taichouchou2/html5.vim'
