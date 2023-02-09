call plug#begin(stdpath('data') . '/plugged')
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'numToStr/Comment.nvim'
	Plug 'reedes/vim-pencil'
	Plug 'stevearc/vim-arduino'
	Plug 'sonph/onehalf', { 'rtp' : 'vim' }
	Plug 'itchyny/vim-gitbranch'
	Plug 'untitled-ai/jupyter_ascending.vim'
	Plug 'kshenoy/vim-signature'
call plug#end()
lua require('Comment').setup()


let g:pyindent_open_paren=shiftwidth()
let g:netrw_banner=0

" indents
set smartindent
set tabstop=4
set shiftwidth=4

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


" ------------ COC ---------------- "
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

highlight CocMenuSel ctermbg=252


function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col-1] =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

autocmd FileType python command! Main execute "normal! idef main():<CR><CR><BS>if __name__ == '__main__':<CR>main()<ESC>gg$"
autocmd FileType c command! Main execute "normal! i#include <stdlib.h><CR><CR>void main() {<CR>}<ESC>k$"
""""""""""""" Her maa de legges til conditional execution --------------

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
