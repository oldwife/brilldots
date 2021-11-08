nnoremap <SPACE> <Nop>
let mapleader =" "

"let mapleader =","


" vim-markdown settings
set conceallevel=2
set nofoldenable
set clipboard+=unnamedplus
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set nospell

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>





" Goyo plugin makes text more readable when writing prose:
map <leader>f :Goyo \| :Limelight
nmap J <C-d>
nmap K <C-u>
nmap <leader>s :set nospell
" Latex/Markdown prose help
"au BufReadPost,BufNewFile *.md,*.tex :set nonumber norelativenumber
au BufReadPost,BufNewFile *.md,*.tex :SoftPencil

" easy markdown mappings
vnoremap " <Esc>`>a"<Esc>`<i"<Esc>
vnoremap * <Esc>`>a*<Esc>`<i*<Esc> v
noremap 2* <Esc>`>a**<Esc>`<i**<Esc>
vnoremap # <Esc>`>a #<Esc>`<i# <Esc>
vnoremap 2# <Esc>`>a ##<Esc>`<i## <Esc>
vnoremap 3# <Esc>`>a ###<Esc>`<i### <Esc>
vnoremap \ <Esc>`>a */<Esc>`<i/* <Esc>

"for vimtex
let g:tex_flavor = 'latex'
let g:vimtex_syntax_conceal_default = '0'
"let g:vimtex_syntax_conceal = 'disable'
"for pandoc preview
let g:pandoc_preview_pdf_cmd = "zathura" 



" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif




call plug#begin('~/.vim/plugged')

"Plug 'brainfucksec/wal.vim'
Plug 'dylanaraps/wal.vim'
Plug 'reedes/vim-pencil'
Plug 'lervag/vimtex'
"Plug 'vim-pandoc/vim-pandoc'
"Plug 'vim-pandoc/vim-pandoc-syntax'
"Plug 'lingnand/pandoc-preview.vim'
"Plug 'ChesleyTan/wordcount.vim'
"Plug 'junegunn/limelight.vim'

call plug#end()

colorscheme wal

" Removes status bar
"set noruler
"set laststatus=0
"set noshowcmd
"set cmdheight=1
"set nospell
