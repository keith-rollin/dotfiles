" Vundle Support {{{1
" -------------------
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-sensible'
Plugin 'kien/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'derekwyatt/vim-fswitch'

" Plugin 'fatih/vim-go'
" Plugin 'tpope/vim-pathogen'
" Plugin 'kballard/vim-swift'
"
call vundle#end()
filetype plugin indent on

" Variables {{{1
" --------------
set modeline            " Indicate that we want the formatting line to be recognized.
set modelines=2
set ignorecase          " Case-insensitive searching...
set smartcase           " ... unless we type at least one capital letter
set hlsearch            " Turn on hightlighting of search text
set autowriteall        " Write the file when we switch buffers.

set tabstop=4           " number of visual spaces per TAB
set softtabstop=4       " number of spaces in tab when editing
set expandtab           " Convert tabs to spaces

set showcmd             " show command in bottom bar
" set number              " show line numbers
" set cursorline          " highlight current line

" Folding {{{1
" ------------
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
"set foldenable         " don't fold files by default on open
nnoremap <space> za
set foldlevelstart=10   " start with fold level of 1

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
" Restore the last cursor position. From:
"
" http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
"
" See also: 'help last-position-jump'

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END

" Custom keys {{{1
" ----------------
let mapleader = ","

" Use '\v' to edit this file.
nmap <leader>ev :edit $MYVIMRC<CR>
nmap <leader>eb :edit $HOME/.bashrc<CR>

" Use '\l; to toggle "list" (i.e., show invisibles) mode.
nmap <leader>l :set list!<CR>

" Use '\,' to switch between companion source files
nmap <leader>, :FSHere<CR>

" CtrlP-Funky
nnoremap <Leader>f :CtrlPFunky<CR>
nnoremap <Leader>u :execute 'CtrlPFunky ' . expand('<cword>')<CR>

" Open a file in the same directory as the current file.
"nmap <leader>ew :e <C-R>=expand("%:p:h") ."/"<CR>
"nmap <leader>es :sp <C-R>=expand("%:p:h") ."/"<CR>
"nmap <leader>ev :vsp <C-R>=expand("%:p:h") ."/"<CR>

" vim:foldmethod=marker:foldlevel=0
