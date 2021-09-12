" plugin
call plug#begin('~/.vim/plugged')

"Nerd commenter
Plug 'scrooloose/nerdcommenter'

"Numeri a fianco
Plug 'jeffkreeftmeijer/vim-numbertoggle'"

"Parentesi automatiche
Plug 'jiangmiao/auto-pairs'

"Rainbow
Plug 'frazrepo/vim-rainbow'

"Cambia parentesi
Plug 'tpope/vim-surround'

"Nerd tree e file manager
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'     " highlighitng nertree
Plug 'ryanoasis/vim-devicons'                      " Icons for Nerdtree
Plug 'francoiscabrol/ranger.vim'                   "ranger integration
"Tema
"Plug 'arcticicestudio/nord-vim'
"Plug 'morhetz/gruvbox'
Plug 'joshdick/onedark.vim'
"Startpage
Plug 'mhinz/vim-startify'

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

""modificare la barra sotto
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"chiudere automaticamente i tag html
Plug 'heracek/html-autoclosetag'

"Preview degli hex
Plug 'ap/vim-css-color'

"ORG-mode
"Plug 'jceb/vim-orgmode'
"Plug 'dhruvasagar/vim-dotoo'
Plug 'vimwiki/vimwiki'

" Markdown Preview
Plug 'suan/vim-instant-markdown', {'rtp': 'after'}

"Sxhkd-vim
Plug 'kovetskiy/sxhkd-vim'


call plug#end()

" tema + vimwiki
filetype plugin on
syntax on
colorscheme onedark

if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif

set number norelativenumber
"let g:gruvbox_italic=1
"let g:gruvbox_bold=1
"let g:gruvbox_transparent_bg=1
"let g:gruvbox_underline=1
"let g:gruvbox_termcolors=1
"let g:gruvbox_contrast_dark= 'hard'
"
let g:onedark_terminal_italics=1

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

"#ricerca con evidenziatore
":set hlsearch

"set leader key

let mapleader = "\<Space>"

let g:python3_host_prog = '/usr/bin/python3.8'

"set F3 per aprire il NERDTree

noremap <F3>  <ESC>:NERDTree<CR><ESC>
noremap <leader><F3> <ESC>:NERDTreeClose<CR><ESC>
inoremap <F3>  <ESC>:NERDTree<CR><ESC>
inoremap <leader><F3> <ESC>:NERDTreeClose<CR><ESC>

"Splits

noremap  <leader>wv <ESC>:vsplit<CR><ESC>
noremap  <leader>vv <ESC>:split<CR><ESC>
"SetLeader più k-j-l-h per navigare nelle finestre

noremap <leader>j <C-W>j
noremap <leader>k <C-W>k
noremap <leader>h <C-W>h
noremap <leader>l <C-W>l

"Set Leader più frecce direzionali per navigare nelle finestre

noremap <leader><Left> <C-W>h
noremap <leader><Right> <C-W>l
noremap <leader><Down> <C-W>j
noremap <leader><Up> <C-W>k

"Set <leader> + F5 per ricaricare le configurazioni di vim

map <leader><F5> <ESC>:source ~/.config/nvim/init.vim<CR><ESC>

"Set <leader> + 1/2 per navigare nelle tabs
map <leader>1 <ESC>:tabprevious<CR><ESC>
map <leader>2 <ESC>:tabnext<CR><ESC>

"set <leader> + a/e per andare a inizio/fine riga
noremap <leader>e g$
noremap <leader>a g^
vnoremap <leader>e g$
vnoremap <leader>a g^

"ranger
map <leader>f :Ranger<CR>s

"settare il Control Z
noremap <C-Z> <ESC>:undo<CR><ESC>
inoremap <C-Z> <ESC>:undo<CR><ESC>

"settare ge per andare a fine file
noremap ge G

"Python
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 0
let g:python_highlight_all = 1

"rainbow
let g:rainbow_active = 1

"nerdtree
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = '▼'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize=38

"startify
let g:startify_bookmarks = [ {'config': '~/.config/nvim/init.vim'}, {'fish':'~/.config/fish/config.fish'},{ 'apps backup':'/mnt/103C02053C01E696/pacchetti e temi/apps/apps.txt'},  {'suckless':'~/.config/suckless-software/'},{'qute': '~/.config/qutebrowser/config.py'} ]

let g:startify_lists = [
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
          \ { 'type': 'files',     'header': ['   MRU']            },
          \ { 'type': 'commands',  'header': ['   Commands']       },
          \ ]

"other stuff

au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org            call org#SetOrgFileType()

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set guifont=SauceCodePro\ Nerd\ Font:h13
"set guifont=Mononoki\ Nerd\ Font:h15
"set guifont=JetBrains\ Mono:h15

"let g:neovide_transparency=0.95
