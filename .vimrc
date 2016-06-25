set number 
set autoindent
set shiftwidth=2
set tabstop=2
set nocompatible
set expandtab
set nobackup
set noswapfile

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

call neobundle#begin(expand('~/.vim/bundle/'))

" インデントに色を付けて見やすくする
NeoBundle "vim-scripts/taglist.vim" 
NeoBundle "Shougo/unite.vim"
NeoBundle 'tpope/vim-endwise'
NeoBundle "https://github.com/Shougo/vimproc"
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'taichouchou2/surround.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'marijnh/tern_for_vim'
NeoBundle 'https://github.com/kien/ctrlp.vim.git'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'YankRing.vim'
NeoBundle 'https://github.com/Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'https://github.com/scrooloose/nerdtree.git'
NeoBundle 'https://github.com/scrooloose/syntastic.git'
NeoBundle "thinca/vim-quickrun"
call neobundle#end()

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray ctermbg=gray
" 偶数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgray ctermbg=darkgray

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
"ここまでneocomplcache用の設定

syntax on
filetype plugin indent on
filetype indent on

"クリップボードの内容を全体で共有
set clipboard+=autoselect
set clipboard+=unnamedplus,unnamed

set mouse=a

"jedi-vimの設定
let g:jedi#completions_command = "<C-N>"
"let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 0
