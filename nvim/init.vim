call plug#begin(stdpath('data') . '/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'} " lsp
    Plug 'numToStr/Comment.nvim' " gc for comments
    Plug 'sonph/onehalf', { 'rtp' : 'vim' } " theme
    Plug 'itchyny/vim-gitbranch' " git statusline
    Plug 'kshenoy/vim-signature' " visualize marks
    Plug 'vimwiki/vimwiki' " make wikis
    Plug 'ap/vim-buftabline' " tabs are stupid make it buffers instead
    Plug 'nvim-tree/nvim-tree.lua' " filelist with C-n
    Plug 'folke/tokyonight.nvim' " dark mode theme
    Plug 'chaoren/vim-wordmotion' " make underscores and camelCase word boundaries
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'lervag/vimtex'
    Plug 'ap/vim-css-color'
call plug#end()
lua require('Comment').setup()



" holds configs for lua only plugins
luafile $XDG_CONFIG_HOME/nvim/lua.lua

" let g:transparent_enabled=1


let g:buftabline_show=1
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


" beautiful bespoke light theme
colorscheme onequarterlight
let g:onehalflight=0

function! ColorschemeToggle()
    if g:onehalflight
        colorscheme onequarterlight
        let g:onehalflight = 0

    else
        colorscheme onehalflight
        let g:onehalflight = 1
    endif
endfunction


set spelllang=nb,en


set ignorecase
set smartcase


function! ProseStart()
  setlocal linebreak
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
endfunction

function! ProseStop()
  setlocal nolinebreak
  unmap <buffer> j
  unmap <buffer> k
endfunction




" folds
set foldlevel=99
" nnoremap <BS> za


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

" bogo operator on functions by using folds
vnoremap af :<C-U>silent! normal! [zkVj]z<CR>
onoremap af :normal Vaf<CR>

" move lines
nnoremap <A-j> :m .+1<CR>
nnoremap <A-k> :m .-2<CR>
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

nnoremap <C-n> :NvimTreeToggle<CR>

" -------- leader kommandoer -----------
let mapleader=" "

nnoremap <leader>t :call ColorschemeToggle()<cr>
" clipboard
nnoremap <leader>p "+p
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y

nnoremap gp :put<CR>

" toggle wordmotion

let g:wordmotion_nomap = 1
let g:wordmotion_on = 0

nnoremap <buffer> <nowait> <leader>w :call WordMotionToggle()<cr>


function! WordMotionToggle()
    if g:wordmotion_on
        echo "WordMotion off"
        let g:wordmotion_on = 0
        unmap w
        unmap b
        unmap e
        unmap iw
        unmap aw

    else
        echo "WordMotion on"
        let g:wordmotion_nomap = 0
        let g:wordmotion_on = 1

        call wordmotion#reload()


    endif
endfunction

" remove highlight for last searched
nnoremap <BS> :NvimTreeToggle<CR>
nnoremap <leader><BS> :noh<CR>

" nnoremap <CR> :w<CR>:!touch /tmp/tmp.pw.socket<CR><CR>


" schmoovement
noremap J :keepjumps normal! }<CR>
noremap K :keepjumps normal! {<CR>

xnoremap J :<C-u>keepjumps normal! gv}<CR>
xnoremap K :<C-u>keepjumps normal! gv{<CR>


nnoremap } J


" S is cc so pointless. S is for save
nnoremap S :w<CR>
" M is for middle of screen but who cares. M for Make this damn file close
nnoremap M :q<CR>

" U is undo line which is stupid
nnoremap U <C-r>


" move mellom tabs
nnoremap H :bprev<CR>
nnoremap L :bnext<CR>
" aapne tabs og splits
nnoremap <leader>v :vsplit
" replace alt som ble soekt paa sist
nnoremap <leader>s :%s///g<Left><Left>
vnoremap <leader>s :s///g<Left><Left>
" bedre shift yank
map Y y$
" format python
" make print(x) into print(f"{x=}")
nnoremap <leader>f 0f(af'{<ESC>$i=}'<ESC>
nnoremap <leader>m :delmarks!<CR>
nnoremap <leader>z :!zathura %<.pdf & <CR><CR>
nnoremap <silent> <leader>d :bp<BAR>bd#<CR>
nnoremap <leader>c :colorscheme 

nnoremap <leader>h :call SynStack()<CR>

" go to the position I was when last editing the file
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

set title
set titlestring=nvim\ \ \ %F

" keep undo history even after closing file
set undodir=$XDG_DATA_HOME/nvim/undo_dir
set undofile


" ----------- vimwiki -------------
let g:vimwiki_ext2syntax = {}
let g:vimwiki_key_mappings = {'global': 0}


" get highlight group of cursor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

let g:vimtex_toc_config = {
    \ 'layers' : ['content'],
    \ 'mode' : 1,
    \ 'show_help' : 0,
    \ 'tocdepth' : 2,
    \ 'indent_levels' : 1,
    \ 'split_pos' : 'full',
    \}

let g:vimtex_compiler_enabled=0
let g:vimtex_complete_enabled=0
let g:vimtex_doc_enabled=0
let g:vimtex_imaps_enabled=0
let g:vimtex_delim_list={}
let g:vimtex_mappings_enabled=0


" ------------ COC ---------------- "
" random things that need to be set for coc to work maybe
set hidden
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set signcolumn=number
set signcolumn=yes


" tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" part of tab completion
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col-1] =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)

" Use ? to show documentation in preview window.
nnoremap <silent> ? :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
" ---------- end COC -------------


autocmd FileType python command! Main execute "normal! idef main():<CR><CR><BS>if __name__ == '__main__':<CR>main()<ESC>gg$"

autocmd FileType python command! Plt execute "normal! oplt.rcParams.update({'font.size': 22})<ESC>"

autocmd FileType c command! Main execute "normal! i#include <stdlib.h><CR><CR>void main() {<CR>}<ESC>k$"
""""""""""""" Her maa de legges til conditional execution --------------

" build stuff



" make sure that command line mode works with enter
augroup CommandLineWindow
  autocmd!
  " When the Command Line window is opened, restore the default behavior of <CR>
  autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
  " When leaving the Command Line window, restore the original mapping
  autocmd CmdwinLeave * nunmap <buffer> <CR>
augroup END


" ------ text files universal -------
autocmd FileType text,markdown,vimwiki,tex call ProseStart()
autocmd FileType text,tex set spell

" ------- python --------
autocmd FileType python map <buffer> <C-b> :w<CR>:exec '!python3' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-b> <esc>:w<CR>:exec '!python3' shellescape(@%, 1)<CR>
" pyright sucks at diagnostics
autocmd FileType python let b:coc_diagnostic_disable=1
autocmd FileType python nnoremap <leader>b :!ruff format %<CR>
autocmd FileType python set foldmethod=indent

" ------- latex ---------
autocmd FileType tex map <buffer> <C-b> :w<CR>:CompileLatex<CR>
autocmd FileType tex imap <buffer> <C-b> <esc>:w<CR>:CompileLatex<CR>
autocmd FileType tex set conceallevel=0
autocmd FileType tex nnoremap <leader>b :!bibtex %<<CR>
autocmd FileType tex nnoremap <leader>v :!biber %<<CR>
autocmd FileType tex nnoremap <CR> :VimtexTocToggle<CR>

autocmd FileType tex map <buffer> <leader>l :w<CR>:exec '!pdflatex %'<CR>

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

" -------- shell --------
autocmd FileType sh map <buffer> <C-b> :w<CR>:!sh %<CR>
autocmd FileType sh imap <buffer> <C-b> <esc> :w<CR>:!sh %<CR>

" -------- lua --------
autocmd FileType lua map <buffer> <C-b> :w<CR>:!lua %<CR>
autocmd FileType lua imap <buffer> <C-b> <esc> :w<CR>:!lua %<CR>

" --------- R -----------
autocmd FileType r map <buffer> <C-b> :w<CR>:!Rscript %<CR>
autocmd FileType r imap <buffer> <C-b> <esc> :w<CR>:!Rscript %<CR>
autocmd FileType r set shiftwidth=2
autocmd FileType r nnoremap <leader>r {opng("temp")<esc>}Odev.off()<CR>system("xdg-open temp")<esc>


" ------- gdscript --------
autocmd FileType gdscript map <buffer> <C-b> :w<CR>:exec '!godot --path $(pwd)'<CR><CR>
autocmd FileType gdscript set noexpandtab



" ------ markdown --------
autocmd FileType markdown map <buffer> <C-b> :w<CR>:exec '!pandoc % --standalone --output %<.pdf'<CR>

" Remote files
autocmd BufRead scp://* set cmdheight=2 " this is to stop stupid confirmation message
