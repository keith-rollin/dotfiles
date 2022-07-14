" Set mapleader here so that we can use it anywhere in the file.
"
let mapleader = "\<space>"

" Clear out our custom autocommands. Do it here by itself so that, through
" this file, we can open and close the group to add new commands without
" having to worry if any particular group is the first one and that should be
" the one to clear out old commands.
"
augroup custom_kr
    autocmd!
augroup END

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
" Plug 'hrsh7th/nvim-cmp'                     " A completion plugin for neovim coded in Lua.
" Plug 'hrsh7th/cmp-nvim-lsp'                 " nvim-cmp source for neovim builtin LSP client
Plug 'neovim/nvim-lspconfig'                " Quickstart configs for Nvim LSP
Plug 'tpope/vim-commentary'                 " Comment/uncomment.
Plug 'tpope/vim-sensible'                   " Sensible vim defaults.
Plug 'vim-autoformat/vim-autoformat'        " Provide easy code formatting in Vim by
                                            " integrating existing code formatters.
                                            " NOTE: needs pynvim installed in python.
Plug 'vim-scripts/indentpython.vim'         " PEP8 auto-indenting. TODO: This better handles
                                            " ()'s, []'s, {}'s, and if/else, but doesn't handle
                                            " long strings. Can I fix those issues?
call plug#end()

" Configure LSP
"
lua << END

    -- vim-cmp and cmp-nvim-lsp configurationn from:
    -- https://github.com/hrsh7th/nvim-cmp

--     cmp = require'cmp';
--     cmp.setup {
--         sources = {
--             -- { name = 'nvim_lsp' }
--         },
--         mapping = cmp.mapping.preset.insert({
--              -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--              -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
--              -- ['<C-Space>'] = cmp.mapping.complete(),
--              -- ['<C-e>'] = cmp.mapping.abort(),
--              -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
--         }),
--     }

--     local capabilities = vim.lsp.protocol.make_client_capabilities()
--     capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    -- Establish LSP mappings from:
    --
    --   https://github.com/neovim/nvim-lspconfig
    --

    local do_map = function(keys, fn)
        vim.keymap.set('n', '<leader>' .. keys, fn, { noremap = true, silent = true })
    end
    do_map('[d', vim.diagnostic.goto_prev)
    do_map(']d', vim.diagnostic.goto_next)

    local on_attach = function(client, bufnr)
        local do_map = function(keys, fn)
            vim.keymap.set('n', '<leader>' .. keys, fn, { noremap = true, silent = true, buffer = bufnr })
        end
        do_map('gd', vim.lsp.buf.definition)
        do_map('gr', vim.lsp.buf.references)
        do_map('K',  vim.lsp.buf.hover)
        do_map('rn', vim.lsp.buf.rename)
    end

    require('lspconfig').pylsp.setup{
        on_attach = on_attach,
        -- capabilities = capabilities,

        --
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pylsp
        --
        settings = { pylsp = { plugins = { pycodestyle = {
            ignore = {
                -- https://pycodestyle.pycqa.org/en/latest/intro.html#error-codes
                'E221', -- multiple spaces before operator
                'W503', -- line break before binary operator
                'W504', -- line break after binary operator
            }
        } } } }
    }
END

" Configure vim-autoformat
"
let g:python3_host_prog = exepath("python3")

nnoremap <leader>af :Autoformat<cr>
augroup custom_kr
    autocmd BufWrite *.py,*.rs :Autoformat
augroup END

" Color scheme
" ------------
" set background=light
" colorscheme morning             " I also like default (in a dark terminal) and pablo.
" highlight Normal ctermbg=none   " Use the terminal's background (why is this comment green?).
highlight CursorLine cterm=none " Turn off underlining, since it leaves residue in Terminal right now.
highlight ColorColumn ctermbg=LightGrey

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
set splitbelow                  " New horizontal splits appear below.
set splitright                  " New vertical splits appear to the right.
set title                       " Set window title.

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
abbr hte the
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

" Split navigation
"
" NOTE: CTRL-L conflicts with vim-sensible's mapping that removes
" highlighting. I really like the latter and may miss it.
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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

