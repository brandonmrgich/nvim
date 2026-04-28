" =============================================================================
" .vimrc — vanilla Vim configuration (no plugins)
"
" Mirrors the Neovim config under lua/bmrgich/core/ as closely as possible
" while staying within plain Vim built-ins. Anything that depends on a plugin
" or is Neovim-only (LSP, Telescope, Treesitter, inccommand, pumblend, etc.)
" is intentionally omitted.
"
" Strict rules:
"   - No plugins, no plugin managers, no external runtime files.
"   - Single .vimrc file, organized by section banners.
" =============================================================================

" -----------------------------------------------------------------------------
" Compatibility & leaders
" -----------------------------------------------------------------------------
set nocompatible
let mapleader      = " "
let maplocalleader = "\\"

filetype plugin indent on
syntax on

" -----------------------------------------------------------------------------
" General options
" -----------------------------------------------------------------------------
set textwidth=100
set formatoptions=jcroqlnt

" Line numbers
set relativenumber
set number

" Tabs & indentation
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set shiftround

" Wrapping
set wrap
set linebreak

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch
set grepformat=%f:%l:%c:%m
if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" Cursor
set cursorline

" Editing behavior
set backspace=indent,eol,start
if empty($SSH_TTY)
    set clipboard=unnamedplus
endif
set completeopt=menu,menuone,noselect
set confirm
set autowrite
set virtualedit=block

" UI
set encoding=UTF-8
set ruler
set title
set hidden
set ttimeoutlen=50
set wildmenu
set wildmode=longest:full,full
set showcmd
set showmatch
set noshowmode
set conceallevel=2
set pumheight=10
set scrolloff=4
set sidescrolloff=8
set winminwidth=5
silent! set jumpoptions=view
silent! set laststatus=3
if &laststatus < 2
    set laststatus=2
endif

" Timeouts
set timeoutlen=300
set updatetime=200

" Persistence
set undofile
set undolevels=10000
set noswapfile
set sessionoptions=buffers,curdir,tabpages,winsize,help,globals,folds

" Undo directory (keep undo files out of source trees)
if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p')
endif
set undodir=~/.vim/undo

" Shortmess
set shortmess+=WIcC

" Spelling
set spelllang=en
silent! set spelloptions+=noplainbuffer

" Folds
set foldlevel=99
set fillchars=fold:\ ,diff:╱,eob:\

" -----------------------------------------------------------------------------
" Appearance
" -----------------------------------------------------------------------------
if has('termguicolors')
    set termguicolors
endif
set background=dark
set signcolumn=yes

" -----------------------------------------------------------------------------
" Splits
" -----------------------------------------------------------------------------
set splitright
set splitbelow
silent! set splitkeep=screen

" -----------------------------------------------------------------------------
" Netrw
" -----------------------------------------------------------------------------
let g:netrw_liststyle       = 3
let g:netrw_keepdir         = 0
let g:netrw_winsize         = 30
let g:netrw_banner          = 0
let g:netrw_localcopydircmd = 'cp -r'

" -----------------------------------------------------------------------------
" Markdown
" -----------------------------------------------------------------------------
let g:markdown_recommended_style = 0

" -----------------------------------------------------------------------------
" Big-file guard (>1.5 MB: disable syntax/undo for performance)
" -----------------------------------------------------------------------------
let g:bigfile_size = 1024 * 1024 * 3 / 2

augroup bmrgich_bigfile
    autocmd!
    autocmd BufReadPre *
        \ if getfsize(expand('<afile>')) > g:bigfile_size |
        \   syntax clear |
        \   setlocal eventignore+=FileType |
        \   setlocal noundofile noswapfile bufhidden=unload |
        \   let b:large_file = 1 |
        \ endif
augroup END

" =============================================================================
" Keymaps
" =============================================================================

" -----------------------------------------------------------------------------
" General
" -----------------------------------------------------------------------------
inoremap jk <ESC>
nnoremap <leader>cs :nohl<CR>

" Delete a single char without clobbering the unnamed register
nnoremap x "_x

" Increment / decrement
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" -----------------------------------------------------------------------------
" Buffer management
" -----------------------------------------------------------------------------
nnoremap <silent> <leader>j  :bp<CR>
nnoremap <silent> <leader>k  :bn<CR>
nnoremap <silent> <leader>bd :bd<CR>
nnoremap <silent> <leader>bD :bd<CR>
nnoremap <silent> <leader>bb :e #<CR>

" -----------------------------------------------------------------------------
" Window management
" -----------------------------------------------------------------------------
nnoremap <leader>sv <C-w>v
nnoremap <leader>sh <C-w>s
nnoremap <leader>se <C-w>=
nnoremap <leader>sx :close<CR>

nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" -----------------------------------------------------------------------------
" Tab management
" -----------------------------------------------------------------------------
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>td :tabclose<CR>
nnoremap <leader>t  :tabn<CR>
nnoremap <leader>T  :tabp<CR>

" -----------------------------------------------------------------------------
" Terminal (vim 8+ :terminal)
" -----------------------------------------------------------------------------
if has('terminal')
    tnoremap jk    <C-\><C-n>
    tnoremap <C-h> <C-\><C-n>:wincmd h<CR>
    tnoremap <C-j> <C-\><C-n>:wincmd j<CR>
    tnoremap <C-k> <C-\><C-n>:wincmd k<CR>
    tnoremap <C-l> <C-\><C-n>:wincmd l<CR>
endif

" -----------------------------------------------------------------------------
" Netrw
" -----------------------------------------------------------------------------
nnoremap <leader>e :Explore<CR>

" -----------------------------------------------------------------------------
" Movement remaps
" -----------------------------------------------------------------------------
" Better up/down: respect display lines unless a count is given
nnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j      v:count == 0 ? 'gj' : 'j'
nnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
xnoremap <expr> <Down> v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k      v:count == 0 ? 'gk' : 'k'
nnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'
xnoremap <expr> <Up>   v:count == 0 ? 'gk' : 'k'

" Save with Ctrl-s
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
xnoremap <C-s> <Esc>:w<CR>
snoremap <C-s> <Esc>:w<CR>

" Esc clears search highlight
nnoremap <silent> <Esc> :nohlsearch<CR><Esc>
inoremap <silent> <Esc> <C-o>:nohlsearch<CR><Esc>

" Clear search, diff update, redraw
nnoremap <leader>ur :nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>

" =============================================================================
" Autocommands
" =============================================================================

" Reload files changed outside of vim when regaining focus
augroup bmrgich_checktime
    autocmd!
    autocmd FocusGained,BufEnter * if &buftype !=# 'nofile' | checktime | endif
augroup END

" Equalize splits when the host window is resized
augroup bmrgich_resize_splits
    autocmd!
    autocmd VimResized * let s:cur_tab = tabpagenr() | tabdo wincmd = | execute 'tabnext ' . s:cur_tab
augroup END

" Restore last cursor position when reopening a buffer (skip gitcommit)
augroup bmrgich_last_loc
    autocmd!
    autocmd BufReadPost *
        \ if &filetype !~# 'gitcommit' && line("'\"") >= 1 && line("'\"") <= line("$") |
        \   execute 'normal! g`"' |
        \ endif
augroup END

" Close certain read-only/utility buffers with `q`
augroup bmrgich_close_with_q
    autocmd!
    autocmd FileType help,qf,man,netrw,checkhealth
        \ setlocal nobuflisted |
        \ nnoremap <buffer><silent> q :close<CR>
augroup END

" Make man pages unlisted
augroup bmrgich_man_unlisted
    autocmd!
    autocmd FileType man setlocal nobuflisted
augroup END

" Wrap and spellcheck for prose filetypes
augroup bmrgich_wrap_spell
    autocmd!
    autocmd FileType text,plaintex,tex,gitcommit,markdown setlocal wrap spell
augroup END

" Disable concealment for JSON variants
augroup bmrgich_json_conceal
    autocmd!
    autocmd FileType json,jsonc,json5 setlocal conceallevel=0
augroup END

" Auto-create parent directory on save
augroup bmrgich_auto_mkdir
    autocmd!
    autocmd BufWritePre *
        \ let s:dir = expand('<afile>:p:h') |
        \ if s:dir !~# '^\w\+://' && !isdirectory(s:dir) |
        \   call mkdir(s:dir, 'p') |
        \ endif
augroup END
