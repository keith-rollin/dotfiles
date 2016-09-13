" Vundle Support {{{1
" -------------------
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" To try out:
"  bling/vim-airline
"  fatih/vim-go
"  kballard/vim-swift (supports syntastic)
"  landaire/deoplete-swift
"  mitsuse/autocomplete-swift
"  powerline/powerline
"  scrooloose/nerdtree
"  scrooloose/syntastic
"  Shougo/neobundle.vim
"  toyamarinyon/vim-swift
"  tpope/vim-pathogen
"  tpope/vim-rsi
"  tpope/vim-surround
"  vim-scripts/DrawIt

Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'junegunn/vim-easy-align'
Plugin 'keith/swift.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-vinegar'

call vundle#end()
filetype plugin indent on

" Variables {{{1
" --------------
set autowriteall                " Write the file when we switch buffers.
set lcs=tab:▸\ ,trail:•,nbsp:∆  " Treatment of invisible characters
set list                        " Show invisible characters
set modeline                    " Enable modeline support
set modelines=4                 " Scan last four lines of file for modeline
set noerrorbells                " Disable error bells
set nojoinspaces                " Only one space after a period when joining lines.
set nostartofline               " Don’t reset cursor to start of line when moving around.
set shortmess=atI               " Don’t show the intro message when starting Vim

" Search related
set hlsearch                    " Highlight searches
set ignorecase                  " Ignore case of searches
set smartcase                   " Case-insensitive searching unless we type at least one capital letter

" TAB related
set expandtab                   " Convert tabs to spaces
set shiftwidth=4                " Number of spaces to use for each step of (auto)indent.
set softtabstop=4               " Number of spaces in tab when editing
set tabstop=4                   " Number of visual spaces per TAB

" Folding related
set foldlevelstart=10           " Start with fold level of 1
set foldmethod=indent           " Fold based on indent level
set foldnestmax=10              " Max 10 depth
nnoremap <space> za

" Misc. {{{1
" -----------
let g:swift_no_conceal=1                        " Don't show the fancy -> in Swift source files.
au BufNewFile,BufRead *.txt set textwidth=78    " Set text width to 78 when a .txt file is created or opened.

" "source" .vimrc after we edit and save it. {{{1
" -----------------------------------------------
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Cursor restoration {{{1
" -----------------------
" Restore the last cursor position. From: 'help last-position-jump'
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Custom keys {{{1
" ----------------
let mapleader = ","

" Use ',ev' to edit this file, ',eb' to edit the .bashrc file.
nmap <leader>ev :edit $MYVIMRC<CR>
nmap <leader>eb :edit $HOME/.bashrc<CR>

" Use ',l; to toggle "list" (i.e., show invisibles) mode.
nmap <leader>l :set list!<CR>

" Use ',,' to switch between companion source files
nmap <leader>, :FSHere<CR>

" CtrlP-Funky
nnoremap <Leader>f :CtrlPFunky<CR>
nnoremap <Leader>u :execute 'CtrlPFunky ' . expand('<cword>')<CR>

" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Misc. from https://github.com/mathiasbynens/dotfiles/blob/master/.vimrc {{{1
" ----------------------------------------------------------------------------
" Strip trailing whitespace (,ss)
function! StripWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    :%s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" Automatic commands
if has("autocmd")
    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" vim:foldmethod=marker:foldlevel=1
