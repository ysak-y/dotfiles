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
NeoBundle 'Shougo/unite.vim'
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
NeoBundle 'Shougo/neomru.vim'
call neobundle#end()

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray ctermbg=gray
" 偶数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgray ctermbg=darkgray

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

nmap <Space> [unite]
nnoremap <silent> [unite]a :<C-u>UniteWithBufferDir -buffer-name=files file<CR>

"スペースキーとfキーでバッファと最近開いたファイル一覧を表示
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer file_mru<CR>
"スペースキーとdキーで最近開いたディレクトリを表示
nnoremap <silent> [unite]d :<C-u>Unite<Space>directory_mru<CR>
"スペースキーとbキーでバッファを表示
nnoremap <silent> [unite]b :<C-u>Unite<Space>buffer<CR>
"スペースキーとrキーでレジストリを表示
nnoremap <silent> [unite]r :<C-u>Unite<Space>register<CR>
"スペースキーとtキーでタブを表示
nnoremap <silent> [unite]t :<C-u>Unite<Space>tab<CR>
"スペースキーとhキーでヒストリ/ヤンクを表示
nnoremap <silent> [unite]h :<C-u>Unite<Space>history/yank<CR>
"スペースキーとoキーでoutline
nnoremap <silent> [unite]o :<C-u>Unite<Space>outline<CR>
"スペースキーとENTERキーでfile_rec:!
nnoremap <silent> [unite]<CR> :<C-u>Unite<Space>file_rec:!<CR>
"unite.vimを開いている間のキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
      " ESCでuniteを終了
          nmap <buffer> <ESC> <Plug>(unite_exit)
        endfunction"}}}
