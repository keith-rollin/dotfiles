" Vundle Support
" --------------
set nocompatible    " Should not be needed if a vimrc file (this file) exists.
                    " But I found that pastetoggle does not work unless I
                    " explicitly include this statement.
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" To try out:
"  Lokaltog/powerline                   Or powerline/powerline, Airline, lightline
"  Valloric/YouCompleteMe
"  airblade/vim-gitgutter               Show status of each line in the vim gutter
"  altercation/vim-colors-solarized
"  ap/vim-css-color
"  bling/vim-airline
"  davidhalter/jedi-vim                 Python auto-completion
"  docunext/closetag.vim
"  embear/vim-localvimrc
"  ervandew/supertab
"  fatih/vim-go
"  haya14busa/incsearch.vim
"  itchyny/lightline.vim
"  junegunn/fzf.vim                     Reported to be a better version of CtrlP
"  junegunn/goyo.vim
"  kballard/vim-swift                   Supports syntastic
"  landaire/deoplete-swift
"  mitsuse/autocomplete-swift
"  nathanaelkane/vim-indent-guides
"  powerline/powerline
"  python-rope/ropevim                  Python refactoring
"  scrooloose/syntastic
"  sheerun/vim-polyglot
"  statico/vim-inform7
"  suan/vim-instant-markdown
"  tmux-plugins/vim-tmux
"  tomasr/molokai
"  toyamarinyon/vim-swift
"  tpope/vim-endwise
"  tpope/vim-eunuch
"  tpope/vim-flagship
"  tpope/vim-git
"  tpope/vim-jdaddy
"  tpope/vim-pathogen
"  tpope/vim-repeat
"  tpope/vim-rhubarb
"  tpope/vim-rsi
"  tpope/vim-sleuth
"  tpope/vim-speeddating
"  tpope/vim-surround
"  tpope/vim-tbone
"  tpope/vim-unimpaired
"  vim-scripts/DrawIt
"  w0rp/ale                             Better syntastic
"  wellle/targets.vim
" Stuff in: https://github.com/nicknisi/dotfiles/blob/master/config/nvim/plugins.vim
" Review https://vimawesome.com/

" Configure CtrlP
" TBD: Try out other variable mucking indicated below.
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_root_markers = ['Makefile.shared']
" let g:ctrlp_match_window_bottom = 0       # Now ctrlp_match_window = "top, ..."
" let g:ctrlp_match_window_reversed = 0     # Now ctrlp_match_window = "ttb, ..."
" let g:ctrlp_custom_ignore = '\v\~$|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
" let g:ctrlp_working_path_mode = 0
" let g:ctrlp_dotfiles = 0                  # Now probably ctrlp_show-hidden
" let g:ctrlp_switch_buffer = 0


" Configure swift.vim: don't show the fancy -> in Swift source files.
let g:swift_no_conceal=1

" Configure NERDTree
let g:NERDTreeShowHidden=1

Plugin 'VundleVim/Vundle.vim'       " Vim package manager (TBD: investigate Vim 8.0's built-in mechanism).

Plugin 'ctrlpvim/ctrlp.vim'         " Fuzzy file searching.
Plugin 'derekwyatt/vim-fswitch'     " Switching between companion files.
Plugin 'junegunn/vim-easy-align'    " Aligning source code.
Plugin 'keith/swift.vim'            " Swift syntax highlighting and indenting.
Plugin 'scrooloose/nerdtree'        " Directory hierarchy browser.
Plugin 'tacahiroy/ctrlp-funky'      " CtrlP extension that performs function navigation.
Plugin 'tpope/vim-commentary'       " Comment/uncomment
Plugin 'tpope/vim-fugitive'         " Git integration.
Plugin 'tpope/vim-sensible'         " Sensible vim defaults.

call vundle#end()
filetype plugin indent on

" Variables
" ---------
set autoread                    " Automatically reread externally changed files.
set autowriteall                " Write the file when we switch buffers.
set clipboard=unnamed           " Interoperate with the system clipboard.
set grepprg=rg\ --vimgrep       " Use ripgrep for grepping.
set lcs=tab:▸\ ,trail:•,nbsp:∆  " Treatment of invisible characters. (Overrides vim-sensible)
set list                        " Show invisible characters
set modeline                    " Enable modeline support
set modelines=4                 " Scan last four lines of file for modeline
set noerrorbells                " Disable error bells
set nojoinspaces                " Only one space after a period when joining lines.
set nostartofline               " Don't reset cursor to start of line when moving around.
set pastetoggle=<leader>v       " Key sequence for toggling 'paste'.
set path+=**                    " Recursively search subdirectories for files on tab-complete.
set scrolloff=3                 " Keep cursor this many lines from top or bottom for context. (Overrides vim-sensible)
set showcmd                     " Show the command being entered.
set shortmess=atI               " Don't show the intro message when starting Vim
set statusline=%f\ %h%w%m%r%=%{fugitive#statusline()}\ \ \ %(%l,%c%V%)\ \ \ %P,%L\ \ \ %{strftime('%F\ %T')}
"set wildmode=list:longest       " complete files like a shell

" Search related
set hlsearch                    " Highlight searches
"set incsearch                  " (Set in vim.sensible)
set ignorecase                  " Ignore case of searches
set smartcase                   " Case-insensitive searching unless we type at least one capital letter

" Line number related. (Disabled, in part because I don't like selecting the
" line number when I select text for copy/pasting.)
" set number                      " Show absolute line numbers
" set relativenumber              " Show relative line numbers; w/ above, accommodates both.

" TAB related
set expandtab                   " Convert tabs to spaces
set shiftwidth=4                " Number of spaces to use for each step of (auto)indent.
set softtabstop=4               " Number of spaces in tab when editing
set tabstop=4                   " Number of visual spaces per TAB

" Speling corections
" ------------------
abbr const_case const_cast
abbr dynamic_case dynamic_cast
abbr fitler filter
abbr funciton function
abbr reinterpret_case reinterpret_cast
abbr static_case static_cast
abbr teh the
abbr tempalte template

" Misc.
" -----
let g:HasInsertedAutocmds = get(g:, 'HasInsertedAutocmds', 0)
if !g:HasInsertedAutocmds && has("autocmd")
    let g:HasInsertedAutocmds = 1

    " Set text width to 78 when a .txt file is created or opened.
    autocmd BufNewFile,BufRead *.txt set textwidth=78

    " `:source` .vimrc after we edit and save it.
    autocmd BufWritePost .vimrc,vimrc source $MYVIMRC

    " Restore the last cursor position. From: 'help last-position-jump'
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Close vim if only/last window is NERDTree.
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Set 'cursorline' for the active buffer.
    augroup CursorLine
        au!
        autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        autocmd WinLeave * setlocal nocursorline
    augroup END

    " Treat .json files as .js
    autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript

    " Treat .md files as Markdown
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown

    " Treat .mm files as Objective-C
    autocmd BufNewFile,BufRead *.mm setlocal filetype=objc

    " Open NERDTree on startup. Do this after setting the highlight options or
    " the NERDTree window won't inherit them. After opening the pane, move the
    " cursor back over the main pain to the right.
    "autocmd VimEnter * NERDTree | wincmd l
endif

" Reload the .vimrc file, in case for some reason the autocmd above doesn't do
" the trick. This mirrors my bash command that does the same thing with the
" .bashrc file.
command! Reload :source $MYVIMRC

" Highlight colors
highlight CursorLine cterm=NONE ctermbg=LightBlue ctermfg=Black guibg=LightBlue guifg=Black
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" netrw: Configuration -- compare to vinegar
"let g:netrw_banner=0        " disable banner
"let g:netrw_browse_split=4  " open in prior window
"let g:netrw_altv=1          " open splits to the right
"let g:netrw_liststyle=3     " tree view
"let g:netrw_list_hide=netrw_gitignore#Hide() " hide gitignore'd files
"let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+' " hide dotfiles by default (this is the string toggled by netrw-gh)

" Custom keys
" -----------
let mapleader = ","

" Cheat Sheet (from `:help :map-modes`):
"
" There are six sets of mappings
"
" - For Normal mode: When typing commands.
" - For Visual mode: When typing commands while the Visual area is highlighted.
" - For Select mode: like Visual mode but typing text replaces the selection.
" - For Operator-pending mode: When an operator is pending (after "d", "y", "c",
"   etc.).
" - For Insert mode: These are also used in Replace mode.
" - For Command-line mode: When entering a ":" or "/" command. (KR: And, I
"   suspect, "!" commands.)
"
"      COMMANDS                    MODES
" :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
" :nmap  :nnoremap :nunmap    Normal
" :vmap  :vnoremap :vunmap    Visual and Select
" :smap  :snoremap :sunmap    Select
" :xmap  :xnoremap :xunmap    Visual
" :omap  :onoremap :ounmap    Operator-pending
" :map!  :noremap! :unmap!    Insert and Command-line
" :imap  :inoremap :iunmap    Insert
" :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arglistlist
" :cmap  :cnoremap :cunmap    Command-line
"
" Use *noremap when recursive mapping is not wanted. Use *unmap to remove a
" specified binding. Use *mapclear to remove all bindings for that mode.

    nmap <silent> <leader>.       <c-^>
    nmap <silent> <leader>,       :FSHere<CR>
    nmap <silent> <leader><space> :call StripWhitespace()<CR>
    nmap <silent> <leader>eb      :edit ~/.bashrc<CR>
    nmap <silent> <leader>eg      :edit ~/.gitconfig<CR>
    nmap <silent> <leader>ev      :edit $MYVIMRC<CR>
nnoremap <silent> <leader>fb      :CtrlPBuffer<CR>
nnoremap <silent> <leader>ff      :CtrlPFunky<CR>
nnoremap <silent> <leader>fu      :execute 'CtrlPFunky ' . expand('<cword>')<CR>
    nmap <silent> <leader>ga      <Plug>(EasyAlign)
    xmap <silent> <leader>ga      <Plug>(EasyAlign)
    nmap <silent> <leader>m       :call ParentMake()<CR>
     map <silent> <leader>ntf     :NERDTreeFind<CR>
     map <silent> <leader>ntf     :execute 'NERDTree ' . fnamemodify(@%, ":p:h")<CR>
     map <silent> <leader>ntt     :NERDTreeToggle<CR>
    nmap <silent> <leader>si      :set cursorline!<CR>
    nmap <silent> <leader>sl      :set list!<CR>
    nmap <silent> <leader>ss      :set spell!<CR>
"   nmap <silent> <leader>v       :set paste!<CR> " Handled with 'pastetoggle'
    nmap <silent> <leader>w       :w<CR>

" These are kind of neat, but I think I'm tired of them.
" nnoremap <silent> j               gj
" nnoremap <silent> k               gk
" nnoremap <silent> ^               g^
" nnoremap <silent> $               g$

    nmap <silent> ç               :wincmd c<CR>
    nmap <silent> ˙               :call WinMove('h')<CR>
    nmap <silent> ∆               :call WinMove('j')<CR>
    nmap <silent> ˚               :call WinMove('k')<CR>
    nmap <silent> ¬               :call WinMove('l')<CR>
    nmap <silent> œ               :wincmd q<CR>

" Add some mappings to better unify vim's mini-buffer with other editing
" environments. Experimental at this point -- we'll see how I like them (or if
" I even remember to use them.
cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>

" Functions
" ---------
" Strip trailing whitespace
function! StripWhitespace()
    let l:oldpos = getpos(".")
    let l:oldquery = getreg('/')
    :%s/\s\+$//e
    call setpos('.', l:oldpos)
    call setreg('/', l:oldquery)
endfunction

" Bottleneck function for appending a new component to a path. This is not
" done in a file-system-independent manner, but at least the hackishness is
" localized to this one location.
function! AppendPathComponent(path, filename)
    if strpart(a:path, -1) != "/"
        return a:path . "/" . a:filename
    endif
    return a:path . a:filename
endfunction

" Find a file in an ancestor directory, starting with cwd.
function! FindInAncestorDirectory(filename)
    let l:curpath = fnamemodify(getcwd(), ":p:h")
    while 1
        let l:filepath = AppendPathComponent(l:curpath, a:filename)
        if glob(l:filepath) != ""
            return l:filepath
        endif
        let l:newpath = fnamemodify(l:curpath, ":h")
        if l:newpath == l:curpath
            return ""
        endif
        let l:curpath = l:newpath
    endwhile
endfunction

" Execute :make on a parent makefile.
function! ParentMake()
    let l:makefile = FindInAncestorDirectory("Makefile")
    if l:makefile == ""
        echoerr "### Can't find makefile for: " . getcwd()
        return
    endif
    let l:prefmakeprg = &makeprg
    set makeprg=make-filtered
    try
        execute 'make -C ' . fnamemodify(l:makefile, ":h")
    finally
        execute 'set makeprg=' . l:prefmakeprg
    endtry
endfunction

" Perform the command to move between windows if possible. If not, take that
" as an indication to create a new window in the given direction and then move
" into it.
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd " . a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd " . a:key
    endif
endfunction

