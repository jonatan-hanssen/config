call plug#begin(stdpath('data') . '/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'numToStr/Comment.nvim'
	Plug 'reedes/vim-pencil'
	Plug 'stevearc/vim-arduino'
	Plug 'sonph/onehalf', { 'rtp' : 'vim' }
	Plug 'itchyny/vim-gitbranch'
	Plug 'untitled-ai/jupyter_ascending.vim'
	Plug 'kshenoy/vim-signature'
    Plug 'vimwiki/vimwiki'
    Plug 'neovim/nvim-lspconfig'
call plug#end()
lua require('Comment').setup()


" lsp stuff
luafile $XDG_CONFIG_HOME/nvim/lsp.lua

" dont show diagnostics. i dont care
autocmd BufEnter * lua vim.diagnostic.disable()

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:pyindent_open_paren=shiftwidth()
let g:netrw_banner=0

" indents
set smartindent
set expandtab
set breakindent
set shiftwidth=4
set tabstop=4

" -------- visuals ----------
set relativenumber
set number
set scrolloff=999
set cursorline
set list
set listchars=lead:·,trail:·,tab:>·
" alternatively this is uncommented and we have light theme
colorscheme onehalflight



" statusline stuff
set statusline=
set statusline+=\ %{gitbranch#name()}\ 
set statusline+=%#LineNr#
set statusline+=%1*\ %<%F\ %m%r%h%w\ 
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ \[%{&fileencoding?&fileencoding:&encoding}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 
" end statusline

" do an operator on every line in the file (daG, yaG, =aG)
xnoremap aG ggoG
onoremap aG :normal VaG<cr>

" move lines
nnoremap <A-j> :m .+1<CR>
nnoremap <A-k> :m .-2<CR>
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" -------- leader kommandoer -----------
let mapleader=" "

" clipboard
nnoremap <leader>p "+p
nnoremap <leader>y "+y

nnoremap <Enter> :noh<CR>


" schmoovement
noremap J }
noremap K {
nnoremap } J


" move mellom tabs
nnoremap H gT
nnoremap L gt
" aapne tabs og splits
nnoremap <leader>t :tabnew 
nnoremap <leader>v :vsplit 
" replace alt som ble soekt paa sist
nnoremap <leader>s :%s///g<Left><Left>
" bedre shift yank
map Y y$
" format python
nnoremap <leader>b :!black %<CR>
" make print(x) into print(f"{x=}")
nnoremap <leader>f 0f(af"{<ESC>$i=}"<ESC>
nnoremap <leader>m :delmarks!<CR>
nnoremap <leader>z :!zathura %<.pdf & <CR><CR>

" go to the position I was when last editing the file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

set title
set titlestring=nvim\ \ %F

set undodir=$XDG_CONFIG_HOME/nvim/undo_dir
set undofile


" ----------- vimwiki -------------
let g:vimwiki_list = [{ 'path': '~/dnd_wiki/wiki', 'path_html': '~/dnd_wiki/html', 'auto_export': 1, 'auto_toc': 1, 'links_space_char': '_', 'syntax': 'default' }]
hi VimwikiLink ctermfg=blue
let g:vimwiki_global_ext = 0


" get highlight group of cursor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc



" build stuff

" ------- python --------
autocmd FileType python map <buffer> <C-b> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-b> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" pyright sucks at diagnostics
autocmd FileType python let b:coc_diagnostic_disable=1

" ------- latex ---------
autocmd FileType tex map <buffer> <C-b> :w<CR>:exec '!pdflatex %'<CR>
autocmd FileType tex imap <buffer> <C-b> <esc>:w<CR>:exec '!pdflatex %'<CR>

" --------- C -----------
autocmd FileType c map <buffer> <C-b> :w<CR>:!gcc -g -Wall -Wextra -std=gnu11 % -o %< && ./%<<CR>
autocmd FileType c imap <buffer> <C-b> <esc> :w<CR>:!gcc -g -Wall -Wextra -std=gnu11 % -o %< && ./%<<CR>

" --------- C++ ---------
autocmd FileType cpp map <buffer> <C-b> :w<CR>:!g++ % && ./a.out<CR>
autocmd FileType cpp imap <buffer> <C-b> <esc> :w<CR>:!g++ % -o %< && ./%<<CR>

" -------- Java ---------
autocmd FileType java map <buffer> <C-b> :w<CR>:exec '!javac *.java && java %<'<CR>
autocmd FileType java imap <buffer> <C-b> <esc> :w<CR>:!javac *.java && java %<<CR>

" -------- VHDL ---------
autocmd FileType vhdl set expandtab
autocmd FileType vhdl set shiftwidth=2


" ------ markdown --------
let g:pencil#wrapModeDefault = 'soft'

autocmd FileType markdown call pencil#init()
autocmd FileType markdown map <buffer> <C-b> :w<CR>:exec '!pandoc % -o %<.pdf'<CR>
autocmd FileType tex imap <buffer> <C-b> <esc>:w<CR>:exec '!pandoc % -o %<.pdf'<CR>



" Remote files
autocmd BufRead scp://* set cmdheight=2 " this is to stop stupid confirmation message



autocmd FileType text call pencil#init()

