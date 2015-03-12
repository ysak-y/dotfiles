
set number 
set autoindent
set shiftwidth=2
set tabstop=2

scriptencoding utf-8
set nocompatible

" 括弧の補完
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap < <><Left>

inoremap jj <Esc>
" 色コード
autocmd ColorScheme * highlight LineNr ctermfg=74
colorscheme hybrid 


if has("vim_starting")
  filetype plugin off
  filetype indent off
  execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
endif

call neobundle#begin(expand('~/.vim/bundle'))

" インデントに色を付けて見やすくする
NeoBundle "vim-scripts/taglist.vim" 
NeoBundle "Shougo/unite.vim"
NeoBundle "git://github.com/Shougo/vimproc"
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'taichouchou2/surround.vim'
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'taichouchou2/vim-javascript'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle "Shougo/neocomplcache"
NeoBundle 'marijnh/tern_for_vim'
NeoBundle 'git://github.com/kien/ctrlp.vim.git'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'git://github.com/scrooloose/nerdtree.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
call neobundle#end()

" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
"let g:indent_guides_enable_on_vim_startup = 1
"let g:indent_guides_auto_colors=0
" 奇数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=gray ctermbg=gray
" 偶数インデントのカラー
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=darkgray ctermbg=darkgray

"ctags用のコマンド"
set tags = tags
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"  " ctagsのコマンド
let Tlist_Show_One_File = 1                         "現在表示中のファイルのみのタグしか表示しない
let Tlist_Use_Right_Window = 1                    "右側にtag listのウインドうを表示する
"taglistのウインドウだけならVimを閉じる
let Tlist_Exit_OnlyWindow = 1                     
"taglistウインドウを開いたり閉じたり出来るショートカット
map <silent> <leader>l :TlistToggle<CR>     

"neocomplcache用の設定
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
     \ 'default' : ''
     \ }

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
set clipboard+=unnamed

set mouse=a

"jedi-vimの設定
let g:jedi#completions_command = "<C-N>"
"let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 0
