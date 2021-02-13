"if per far funzionare bene neovim su VSCode
if !exists('g:vscode')
" plugin
call plug#begin('~/.vim/plugged')
"Nerd commenter
Plug 'scrooloose/nerdcommenter'
"Numeri a fianco
Plug 'jeffkreeftmeijer/vim-numbertoggle'" 
"Parentesi automatiche
Plug 'jiangmiao/auto-pairs'
"Cambia parentesi
Plug 'tpope/vim-surround'
"Nerd tree
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
"Tema
Plug 'arcticicestudio/nord-vim'
"utiliti varie
Plug 'tpope/vim-sensible'

"Snippets per linguaggi a <tag>
Plug 'vim-scripts/taglist.vim'

"Snippets e autocompliter
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
Plug 'sirver/ultisnips'
Plug 'davidhalter/jedi-vim'

"jump to definitions
Plug 'pechorin/any-jump.vim'

"modificare la barra sotto
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"ciudere automaticamente i tag html
Plug 'heracek/html-autoclosetag'

call plug#end()

" tema
syntax on
if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

colorscheme nord
set number norelativenumber
"ricerca con evidenziatore
endif
":set hlsearch

"set leader key

let mapleader = "\<Space>"

let g:python3_host_prog = '/usr/bin/python3.8'

"set F3 per aprire il NERDTree

noremap <F3>  <ESC>:NERDTree<CR><ESC>
noremap <leader><F3> <ESC>:NERDTreeClose<CR><ESC>
inoremap <F3>  <ESC>:NERDTree<CR><ESC>
inoremap <leader><F3> <ESC>:NERDTreeClose<CR><ESC>


"Set Control più k-j-l-h per navigare nelle finestre

noremap <C-J> <C-W> j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

"Set Control più frecce direzionali per navigare nelle finestre

noremap <C-Down> <C-W>j
noremap <C-Up> <C-W>k
noremap <C-Left> <C-W>h
noremap <C-Right> <C-W>l

"Set <leader> + F5 per ricaricare le configurazioni di vim

map <leader><F5> <ESC>:source ~/.config/nvim/init.vim<CR><ESC>

"Set <leader> + 1/2 per navigare nelle tabs
map <leader>1 <ESC>:tabprevious<CR><ESC>
map <leader>2 <ESC>:tabnext<CR><ESC>

"set <leader> + a/e per andare a inizio/fine riga
noremap <leader>e $
noremap <leader>a ^
vnoremap <leader>e $
vnoremap <leader>a ^


"settare il Control Z
noremap <C-Z> <ESC>:undo<CR><ESC>
inoremap <C-Z> <ESC>:undo<CR><ESC>

"settare ge per andare a fine file
noremap ge G

let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 0
