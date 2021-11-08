call plug#begin(stdpath('data') . '/plugged')
	Plug 'ervandew/supertab'
	Plug 'numToStr/Comment.nvim'
	"Plug 'vim-airline/vim-airline'
	"Plug 'vim-airline/vim-airline-themes'
	Plug 'reedes/vim-pencil'
	Plug 'tpope/vim-fugitive'
call plug#end()
lua require('Comment').setup()


" let g:airline_theme='onedark'
let g:pyindent_open_paren=shiftwidth()
let g:netrw_banner=0
set clipboard+=unnamedplus

" indents
set smartindent
set tabstop=4
set shiftwidth=4

" visuals
set relativenumber
set number
set scrolloff=999
set cursorline
hi CursorLine   cterm=NONE ctermbg=237 ctermfg=NONE
hi MatchParen ctermbg=241

" trailing whitespace er greit for meg
inoremap <CR> <CR>x<BS>
nnoremap o ox<BS>
nnoremap O Ox<BS>

" put everything in the black hole
nnoremap x "_x
nnoremap d "_d
nnoremap D "_D
vnoremap d "_d

nnoremap <leader>d ""d
nnoremap <leader>D ""D
vnoremap <leader>d ""d

" move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" leader kommandoer
let mapleader=" "
" git stuff
nnoremap <leader>gc :!git commit -am 
nnoremap <leader>gp :!git push<CR>
nnoremap <leader>gg :!git pull<CR>
nnoremap <Enter> :noh<CR>
" move mellom splits
nnoremap <leader>h <C-w>h
nnoremap <leader>l <C-w>l
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
" move mellom tabs
nnoremap H gT
nnoremap L gt
" aapne tabs og splits
nnoremap <leader>t :tabnew 
nnoremap <leader>v :vsplit 
" search and replace
nnoremap <leader>s :%s//gc<Left><Left><Left>
" bedre shift yank
map Y y$
""""""""""""" Her maa de legges til conditional execution --------------

" build stuff

" ------- python --------
autocmd FileType python map <buffer> <C-b> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-b> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>

" ------- latex ---------
autocmd FileType tex map <buffer> <C-b> :w<CR>:exec '!pdflatex %'<CR>:silent exec '!xdg-open %<.pdf'<CR>
autocmd FileType tex imap <buffer> <C-b> <esc>:w<CR>:exec '!pdflatex %'<CR>:silent exec '!xdg-open %<.pdf'<CR>

" --------- C -----------
autocmd FileType c map <buffer> <C-b> :w<CR>:!gcc % -o %< <CR>:exec '!./%<'<CR>
autocmd FileType c imap <buffer> <C-b> <esc> :w<CR>:!gcc % -o %< <CR>:exec '!./%<'<CR>

" -------- Java ---------
autocmd FileType java map <buffer> <C-b> :w<CR>:!javac *.java <CR>:exec '!java %<'<CR>
autocmd FileType java imap <buffer> <C-b> <esc> :w<CR>:!javac *.java <CR>:exec '!java %<'<CR>
