" Pull in vim-plug
" ----------------
" NOTE: Under nvim, vim-plug will install plugins into:
"
"   stdpath("data") . '/plugged'
"
" as opposed to:
"
"   stdpath("data") . '/site/pack'
"
" or perhaps:
"
"   stdpath("data") . '/site/pack/plugged/start'
"
" as indicated by ":help packages"
"
" Perhaps switch to minpac: https://github.com/k-takata/minpac.
" See also: http://vimcasts.org/episodes/minpac/.
" NOTE: minpac requires you to manually restart if new plugins are added.
" NOTE: minpac will try to install into packpath[0] by default. This is the
" ~/.vim directory. We may want to force to stdpath("config") or
" stdpath("data") when calling minpac#init().
"
let s:plug_path = stdpath("data")  . "/site/autoload/plug.vim"
let s:plug_repo = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
if empty(glob(s:plug_path))
    silent execute "!curl --create-dirs --fail --location --output \"" .
                \ s:plug_path . "\" \"" . s:plug_repo . "\""
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plugins
" ---------------
call plug#begin()
Plug 'ConradIrwin/vim-bracketed-paste'      " Handle BPM (bracketed paste mode -- see
                                            "   https://cirw.in/blog/bracketed-paste).
Plug 'derekwyatt/vim-fswitch'               " Switching between companion files.
Plug 'tpope/vim-commentary'                 " Comment/uncomment.
Plug 'tpope/vim-sensible'                   " Sensible vim defaults.

" LSP-related
"
" NOTE: Even with all this shizzle here, getting an LSP server installed is a
" manual process. See: ":help LspInstallServer". In my case, for Python, I
" installed pylsp-all.
"
Plug 'mattn/vim-lsp-settings'               " Auto configurations for Language Server for vim-lsp.
Plug 'prabirshrestha/async.vim'             " normalize async job control api for vim and neovim.
Plug 'prabirshrestha/asyncomplete-lsp.vim'  " Provide LSPautocompletion source for asyncomplete.vim and vim-lsp.
Plug 'prabirshrestha/asyncomplete.vim'      " async completion in pure vim script for vim8 and neovim.
Plug 'prabirshrestha/vim-lsp'               " lsp-server client for vim and neovim.

call plug#end()

" Ugh! Took me two days to figure out how to configure pylsp when it's
" installed via vim-lsp-settings! I had been trying to install my settings
" following the instructions in the vim-lsp repo, but my attempts there were
" getting overridden by vim-lsp-settings.
"
" NB: I don't know the difference between 'config' and 'workspace_config', but
" the latter is definitely what we want here.

let g:lsp_settings = {
    \   'pylsp-all': {
    \       'workspace_config': {
    \           'pylsp': {
    \               'plugins': {
    \                   'pycodestyle': {
    \                       'ignore': [ 'E221', 'W503', 'W504' ]
    \                   }
    \               }
    \           }
    \       }
    \   }
    \ }

" Color scheme
" ------------
set background=light
colorscheme morning             " I also like default (in a dark terminal) and pablo.
highlight Normal ctermbg=none   " Use the terminal's background (why is this comment green?).

" Variables
" ---------
set autowriteall                " Write the file when we switch buffers.
set clipboard=unnamed           " Interoperate with the system clipboard.
set cursorline                  " Highlight the row that contains the cursor.
set grepprg=rg\ --vimgrep       " Use ripgrep for grepping.
set list                        " Show invisible characters.
set listchars=tab:▸\\x20        " Show TABs as RIGHT-ARROW + SPACEs. (Overrides vim-sensible)
set listchars+=trail:•          " Show trailing spaces as bullets. (Overrides vim-sensible)
set listchars+=nbsp:∆           " Show non-breaking spaces as deltas. (Overrides vim-sensible)
set mouse=a                     " Use mouse in all (normal, visual, insert, command) modes.
set pastetoggle=<leader>v       " Key sequence for toggling 'paste'.
set path+=**                    " Recursively search subdirectories for files on tab-complete.
set scrolloff=3                 " Keep cursor this many lines from top or bottom for context.
                                " (Overrides vim-sensible)
set shiftround                  " Round indent to multiple of 'shiftwidth'.
set shortmess=atI               " Don't show the intro message when starting Vim.
set smartindent                 " Indent like C-like programs.

" Search related
"
set ignorecase                  " Ignore case of searches.
set smartcase                   " Case-insensitive searching unless we type at least one capital letter.

" Line number related. (Disabled, in part because I don't like selecting the
" line number when I select text for copy/pasting.)
"
set number                      " Show absolute line numbers.
set relativenumber              " Show relative line numbers; w/ above, accommodates both.

" TAB related
"
set expandtab                   " Convert tabs to spaces.
set shiftwidth=4                " Number of spaces to use for each step of (auto)indent.
set softtabstop=4               " Number of spaces in tab when editing.
set tabstop=4                   " Number of visual spaces per TAB.

" Speling corections
" ------------------
abbr adn and
abbr alos also
abbr const_case const_cast
abbr dynamic_case dynamic_cast
abbr fitler filter
abbr funciton function
abbr reinterpret_case reinterpret_cast
abbr static_case static_cast
abbr teh the
abbr tehn then
abbr tempalte template
abbr waht what
abbr .78. ..............................................................................
abbr -78- ------------------------------------------------------------------------------
abbr =78= ==============================================================================
abbr *78* ******************************************************************************
abbr x78x ******************************************************************************

" Misc.
" -----
augroup custom_kr
    autocmd!

    " Set text width to 78 when a .txt file is created or opened.
    autocmd BufNewFile,BufRead *.txt set textwidth=78

    " `:source` .vimrc after we edit and save it.
    autocmd BufWritePost .vimrc,vimrc,init.vim source $MYVIMRC

    " Restore the last cursor position. From: 'help last-position-jump'.
    autocmd BufReadPost * if &ft!="gitcommit" && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Treat .json files as .js.
    autocmd BufNewFile,BufRead *.json setlocal filetype=json syntax=javascript

    " Treat .md files as Markdown.
    autocmd BufNewFile,BufRead *.markdown,*.mdown,*.mkd,*.mkdn,*.mdwn,*.md,*.MD setlocal filetype=markdown

    " Treat .mm files as Objective-C.
    autocmd BufNewFile,BufRead *.mm setlocal filetype=objc

    " Briefly highlight the yanked selection.
    " See ":help lua-highlight".
    au TextYankPost * lua vim.highlight.on_yank()
augroup END

" Match spec for git merge error markers.
"
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Set the default highlighting style for shell scripts. This particular
" setting assumes that our scripts are POSIX compatible and so shows things
" like $(...) without flagging it as invalid.
"
let g:is_posix = 1

" netrw: Configuration
"
let g:netrw_banner=0        " Disable banner.
let g:netrw_liststyle=3     " Tree view.

" Custom keys
" -----------
let mapleader = " "

" Cheat Sheet (from `:help :map-modes`):
"
" There are six sets of mappings:
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
"
nnoremap <silent> <leader>.         <c-^>
nnoremap <silent> <leader>,         :FSHere<CR>
nnoremap <silent> <leader><space>   :call StripWhitespace()<CR>
nnoremap <silent> <leader>eg        :edit ~/.gitconfig<CR>
nnoremap <silent> <leader>ev        :edit $MYVIMRC<CR>
nnoremap <silent> <leader>ez        :edit ~/.zshrc<CR>
nnoremap <silent> <leader>m         :call ParentMake()<CR>
nnoremap <silent> <leader>si        :set cursorline!<CR>
nnoremap <silent> <leader>sl        :set list!<CR>
nnoremap <silent> <leader>ss        :set spell!<CR>
" nnoremap <silent> <leader>v         :set paste!<CR> " Handled with 'pastetoggle'.
nnoremap <silent> <leader>w         :w<CR>

" Find or replace the word under the cursor.
nnoremap <silent> <leader>f         /<C-r><C-w><CR>
nnoremap <silent> <leader>r         :%s/\<<C-r><C-w>\>/<C-r><C-w>/g<Left><Left>

" Take the selection and move it up or down, after which, reselect the text,
" reformat/indent it, and select it again.
"
vnoremap <silent> J                 :m '>+1<CR>gv=gv
vnoremap <silent> K                 :m '<-2<CR>gv=gv

" Stay in visual mode when indenting.
"
vnoremap <silent> <                 <gv
vnoremap <silent> >                 >gv

" From ":help Y":
"
"   If you like "Y" to work from the cursor to the end of line (which is more
"   logical, but not Vi-compatible) use ":map Y y$".
"
nnoremap <silent>Y                  y$

" Support for auto-completion in the asynccomplete plugin.
"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
imap     <C-Space>      <Plug>(asyncomplete_force_refresh)

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    setlocal tagfunc=lsp#tagfunc
    " nmap <buffer> gd <plug>(lsp-definition)
    " nmap <buffer> gs <plug>(lsp-document-symbol-search)
    " nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    " nmap <buffer> gr <plug>(lsp-references)
    " nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    " nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    " nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    " nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 3000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" clang-format support.
"
if executable('clang-format')
    let g:clang_format_path = exepath("clang-format")
    let g:clang_format_root = fnamemodify(fnamemodify(g:clang_format_path, ":h"), ":h")
    let g:clang_format_py = g:clang_format_root . "/share/clang/clang-format.py"
    if ! empty(glob(g:clang_format_py))
        function! FormatAll()
            let l:lines = "all"
            execute :pyfile g:clang_format_py
        endfunction

        function! FormatSelection()
            execute :pyfile g:clang_format_py
        endfunction

        function! FormatChanged()
            let l:formatdiff = 1
            execute :pyfile g:clang_format_py
        endfunction

        nnoremap <leader>cf :call FormatAll()<cr>
        xnoremap <leader>cf :call FormatSelection()<cr>
        autocmd BufWritePre *.h,*.c,*.cc,*.cpp call FormatAll()
    endif
endif

" Functions/Commands
" ------------------

" Strip trailing whitespace.
"
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
"
function! AppendPathComponent(path, filename)
    if strpart(a:path, -1) != "/"
        return a:path . "/" . a:filename
    endif
    return a:path . a:filename
endfunction

" Find a file in an ancestor directory, starting with cwd.
"
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
"
function! ParentMake()
    let l:makefile = FindInAncestorDirectory("Makefile")
    if l:makefile == ""
        echoerr "### Can't find makefile for: " . getcwd()
        return
    endif
    execute 'make -C ' . fnamemodify(l:makefile, ":h")
endfunction

" Reload the .vimrc file, in case for some reason the autocmd above doesn't do
" the trick. This mirrors my bash command that does the same thing with the
" .zshrc file.
"
command! Reload :source $MYVIMRC

" Remind me what file I'm in.
"
command WhatAmI :echo expand("%")

