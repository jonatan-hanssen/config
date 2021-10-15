call plug#begin(stdpath('data') . '/plugged')
	Plug 'https://tpope.io/vim/fugitive.git'
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-lua/completion-nvim'
	Plug 'ervandew/supertab'
	"Plug 'git@github.com:vim-scripts/AutoComplPop.git'
call plug#end()


let g:pyindent_open_paren=shiftwidth()
let g:deoplete#enable_at_startup = 1
let g:netrw_banner=0
set relativenumber
set number
inoremap <CR> <CR>x<BS>
set scrolloff=999
set clipboard+=unnamedplus
set smartindent
set tabstop=4
set shiftwidth=4
set cursorline

hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE

augroup reload_conf
	autocmd!
	autocmd! BufWritePost *.vim source %
augroup end

nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv


let mapleader=" "
nnoremap <leader>gc :Git commit -am 
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gg :Git pull<CR>
nnoremap <leader>w :w<CR>
nnoremap <Enter> :noh<CR>
nnoremap <leader>h <C-w>h
nnoremap <leader>l <C-w>l
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
autocmd FileType python map <buffer> <C-b> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-b> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
