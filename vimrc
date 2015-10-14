set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
" Plugin 'tpope/vim-pathogen'
Plugin 'tpope/vim-sensible'
Plugin 'kballard/vim-swift'
call vundle#end()
filetype plugin indent on



"" Invoke pathogen
"
"runtime bundle/vim-pathogen/autoload/pathogen.vim
"execute pathogen#infect()

" Manually load sensible.vim in case we want to override anything it does
" here.
"
" runtime! plugin/sensible.vim
"

set modeline		" Indicate that we want the formatting line to be recognized.
set modelines=7
set ignorecase		" Case-insensitive searching...
set smartcase		" ... unless we type at least one capital letter
set hlsearch		" Turn on hightlighting of search text
set autowriteall	" Write the file when we switch buffers.
set expandtab		" Convert tabs to spaces

let g:swift_no_conceal = 1			" Don't show the fancy -> in Swift source files.
au BufNewFile,BufRead *.txt set textwidth=78	" Set text width to 78 when a .txt file is created or opened.

" Reread this file after we edit and save it.

if has("autocmd")
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

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

" Custom keys

let mapleader = ","

" Use '\v' to edit this file.
nmap <leader>v :edit $MYVIMRC<CR>

" User '\l; to toggle "list" (i.e., show invisibles) mode.
nmap <leader>l :set list!<CR>

" Open a file in the same directory as the current file.
nmap <leader>ew :e <C-R>=expand("%:p:h") ."/"<CR>
nmap <leader>es :sp <C-R>=expand("%:p:h") ."/"<CR>
nmap <leader>ev :vsp <C-R>=expand("%:p:h") ."/"<CR>
