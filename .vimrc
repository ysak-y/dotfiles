if &compatible
  set nocompatible " Be iMproved
endif

" Deinで管理するディレクトリを指定
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin(expand('~/.vim/dein'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('Shougo/denite.nvim')
call dein#add("cohama/lexima.vim")

" Ruby向けにendを自動挿入してくれる
call dein#add('tpope/vim-endwise')

" 自動で括弧を締める"
call dein#add('Townk/vim-autoclose')

" ファイルをtree表示してする
call dein#add('scrooloose/nerdtree')
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" 行末の半角スペースを可視化
 call dein#add('bronson/vim-trailing-whitespace')

" ログファイルを色づけしてくれる
call dein#add('vim-scripts/AnsiEsc.vim')

" vimでペーストする際に、自動でpaste modeにする
call dein#add('ConradIrwin/vim-bracketed-paste')

" vimの画面の一番下にあるステータスラインの表示内容が強化
call dein#add('itchyny/lightline.vim')

" deoplete
" call dein#add('Shougo/deoplete.nvim')
" if !has('nvim')
"   call dein#add('roxma/nvim-yarp')
"   call dein#add('roxma/vim-hug-neovim-rpc')
" endif
" let g:deoplete#enable_at_startup = 1

call dein#end()

"pluginのインストール
if dein#check_install()
  call dein#install()
endif

set number
set autoindent
set shiftwidth=2
set tabstop=2
autocmd FileType python setlocal sw=4 sts=4 ts=4 et
set nocompatible
set expandtab
set nobackup
set noswapfile
set backspace=indent,eol,start

"Leaderの設定
let mapleader = "\<Space>"
" ,のデフォルト機能を使うために\に設定
noremap \ ,

set nowritebackup
" ファイルを上書きする前にバックアップを作ることを無効化
set nobackup
"文字コードをUFT-8に設定
set fenc=utf-8

"------------------------
" 検索
"------------------------
" 検索するときに大文字小文字を区別しない
set ignorecase
" 小文字で検索すると大文字と小文字を無視して検索
set smartcase
" 検索がファイル末尾まで進んだら、ファイル先頭から再び検索
set wrapscan
" インクリメンタル検索 (検索ワードの最初の文字を入力した時点で検索が開始)
set incsearch
" 検索結果をハイライト表示
set hlsearch


" 対応する括弧やブレースを表示
set showmatch matchtime=1

" yでコピーした時にクリップボードに入る
set guioptions+=a

" ヤンクでクリップボードにコピー
set clipboard+=unnamed

nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h

inoremap jj <Esc>
" 色コード
autocmd ColorScheme * highlight LineNr ctermfg=74
colorscheme hybrid

if has("vim_starting")
  " 引数なしでvimを開くとNERDTreeを起動
  let file_name = expand('%')
  if file_name == ''
    autocmd VimEnter * NERDTree ./
  endif
endif

syntax on
filetype plugin indent on
filetype indent on

"クリップボードの内容を全体で共有
set clipboard+=autoselect
set clipboard+=unnamedplus,unnamed

set mouse=a

" denite の設定
if dein#tap('denite.nvim')
  " Add custom menus
  let s:menus = {}
  let s:menus.file = {'description': 'File search (buffer, file, file_rec, file_mru'}
  let s:menus.line = {'description': 'Line search (change, grep, line, tag'}
  let s:menus.others = {'description': 'Others (command, command_history, help)'}
  let s:menus.file.command_candidates = [
        \ ['buffer', 'Denite buffer'],
        \ ['file: Files in the current directory', 'Denite file'],
        \ ['file_rec: Files, recursive list under the current directory', 'Denite file_rec'],
        \ ['file_mru: Most recently used files', 'Denite file_mru']
        \ ]
  let s:menus.line.command_candidates = [
        \ ['change', 'Denite change'],
        \ ['grep :grep', 'Denite grep'],
        \ ['line', 'Denite line'],
        \ ['tag', 'Denite tag']
        \ ]
  let s:menus.others.command_candidates = [
        \ ['command', 'Denite command'],
        \ ['command_history', 'Denite command_history'],
        \ ['help', 'Denite help']
        \ ]

  call denite#custom#var('menu', 'menus', s:menus)

  nnoremap [denite] <Nop>
  nmap <Leader>u [denite]
  nnoremap <silent> [denite]b :Denite buffer<CR>
  nnoremap <silent> [denite]c :Denite changes<CR>
  nnoremap <silent> [denite]f :Denite file<CR>
  nnoremap <silent> [denite]g :Denite grep<CR>
  nnoremap <silent> [denite]h :Denite help<CR>
  nnoremap <silent> [denite]h :Denite help<CR>
  nnoremap <silent> [denite]l :Denite line<CR>
  nnoremap <silent> [denite]t :Denite tag<CR>
  nnoremap <silent> [denite]m :Denite file_mru<CR>
  nnoremap <silent> [denite]u :Denite menu<CR>

  call denite#custom#map(
        \ 'insert',
        \ '<Down>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<Up>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-N>',
        \ '<denite:move_to_next_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-P>',
        \ '<denite:move_to_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-G>',
        \ '<denite:assign_next_txt>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<C-T>',
        \ '<denite:assign_previous_line>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'normal',
        \ '/',
        \ '<denite:enter_mode:insert>',
        \ 'noremap'
        \)
  call denite#custom#map(
        \ 'insert',
        \ '<Esc>',
        \ '<denite:enter_mode:normal>',
        \ 'noremap'
        \)
endif

