" vim-bootstrap b0a75e4

"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.vim/autoload/plug.vim')

let g:vim_bootstrap_langs = "python"
let g:vim_bootstrap_editor = "vim"				" nvim or vim

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.vim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'  "Git
Plug 'tpope/vim-rhubarb' "Github
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'airblade/vim-gitgutter' "Gitdiff
Plug 'vim-scripts/grep.vim'
Plug 'vim-scripts/CSApprox'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Raimondi/delimitMate'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'
Plug 'Yggdroot/indentLine'
Plug 'sheerun/vim-polyglot'
Plug 'cjrh/vim-conda'
Plug 'tpope/vim-surround'  " putting '(. etc around
Plug 'tpope/vim-repeat'
Plug 'arcticicestudio/nord-vim'
Plug 'ervandew/supertab'
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'xolox/vim-misc' " required by vim-session
Plug 'xolox/vim-session'

call plug#end()

" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary
set ttyfast

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac

if exists('$SHELL')
    set shell=$SHELL
else
    set shell=/bin/sh
endif

set splitright

" session management
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "no"
let g:session_command_aliases = 1

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

set completeopt=menu,longest

" Trun spellcheck for md and txt
autocmd BufRead,BufNewFile *.md,*.txt setlocal spell

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
  set clipboard=unnamed " mac clipboard

set updatetime=100 " for fast tagbar sync

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
colorscheme nord
syntax on
set ruler
set rulerformat=%13(%l/%L\ %p%%%)
set number

let no_buffers_menu=1

set mouse=a
set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

let g:CSApprox_loaded = 1

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

if $TERM == 'xterm'
  set term=xterm-256color
endif

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

if has("autocmd")
    if v:version > 701
        autocmd Syntax * call matchadd('Todo', '\W\zs\(NOTE\|QUESTION\|Q\)')
    endif
endif

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

cnoreabbrev fd filetype detect

cnoreabbrev vterm vert term

"*****************************************************************************
"" Functions
"*****************************************************************************
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set linebreak
    " set wm=2
    " set textwidth=79
    set textwidth=0
    set wrapmargin=0

  endfunction
endif

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync fromstart
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" Keep folds
augroup remember_folds
  autocmd!
  " autocmd BufWinLeave * mkview
  " autocmd BufWinEnter * silent! loadview
  autocmd BufWinLeave * if &diff != 'diff' | mkview | endif
  autocmd BufWinEnter *.* if &diff != 'diff' | silent loadview | endif " Do not load when in vimdiff
augroup END

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Conceal a word with `?`
nnoremap <leader>x yiw :syn match Todo \<C-r>0\ conceal cchar=?<CR>
vnoremap <leader>x y :syn match Todo \<C-r>0\ conceal cchar=?<CR>

" noremap YY "+y<CR>
" noremap <leader>p "+gP<CR>
" noremap XX "+x<CR>

"buffer navigate
nnoremap <leader>l :bnext<CR>
nnoremap <leader>z :bprevious<CR>
nnoremap <leader>T :enew<CR>
nnoremap <leader>q :bp\|bd #<CR>

" if has('macunix')
"   " pbcopy for OSX copy/paste
"   vmap <C-x> :!pbcopy<CR>
"   vmap <C-c> :w !pbcopy<CR><CR>
" endif

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv


"*****************************************************************************
"" Custom configs
"*****************************************************************************

" python
" vim-python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=99
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
  autocmd FileType python nmap <F10> :w <bar> :!python %<CR>
  autocmd FileType python nmap <F9> oimport ipdb; ipdb.set_trace(context=10)<ESC>
augroup END

" shell
autocmd FileType sh nmap <F10> :w <bar> :!./%<CR>

"*****************************************************************************
"" Plugins
"*****************************************************************************
"" NERDTree
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 40
let g:NERDTreeNodeDelimiter = "\u00a0"
cnoreabbrev nt NERDTreeToggle
cnoreabbrev ntf NERDTreeFind
cnoreabbrev ntj NERDTreeFocus
autocmd VimEnter * call NERDTreeAddKeyMap({
        \ 'key': 'yy',
        \ 'callback': 'NERDTreeCopyPath',
        \ 'quickhelpText': 'put full path of current node into the default register' })

"" vim-fugitive
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gp :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gst :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiffsplit!<CR>
noremap <Leader>gr :Gremove<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
nnoremap <Leader>o :.Gbrowse<CR>

" vim-session
cnoreabbrev so OpenSession<Space>
cnoreabbrev ss SaveSession<Space>
cnoreabbrev sd DeleteSession
cnoreabbrev sc CloseSession<CR>
cnoreabbrev sv ViewSession<CR>

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules'

" vim-airline
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
let g:airline_theme = 'nord'
let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" let g:airline#extensions#tabline#right_sep = ''
" let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#buffer_nr_show = 0
" let g:airline#extensions#tabline#buffer_nr_format = '%s '
let g:airline#extensions#tabline#fnamemod = ':~:.' " filename-modifiers

let g:airline#extensions#tmuxline = 1
let airline#extensions#tmuxline#color_template = 'normal'

" let g:airline#extensions#syntastic#enabled = 1
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#tagbar#enabled = 1
" let g:airline_skip_empty_sections = 1
" let g:airline#extensions#virtualenv#enabled = 1
" let g:airline#extensions#tagbar#enabled = 1
" let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy
" if !exists('g:airline_powerline_fonts')
"   " let g:airline#extensions#tabline#left_sep = ' '
"   " let g:airline#extensions#tabline#left_alt_sep = '|'
"   let g:airline_left_sep          = '▶'
"   let g:airline_left_alt_sep      = '»'
"   let g:airline_right_sep         = '◀'
"   let g:airline_right_alt_sep     = '«'
"   let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
"   let g:airline#extensions#readonly#symbol   = '⊘'
"   let g:airline#extensions#linecolumn#prefix = '¶'
"   let g:airline#extensions#paste#symbol      = 'ρ'
"   let g:airline_symbols.linenr    = '␊'
"   let g:airline_symbols.branch    = '⎇'
"   let g:airline_symbols.paste     = 'ρ'
"   let g:airline_symbols.paste     = 'Þ'
"   let g:airline_symbols.paste     = '∥'
"   let g:airline_symbols.whitespace = 'Ξ'
" else
"   " let g:airline#extensions#tabline#left_sep = ''
"   " let g:airline#extensions#tabline#left_alt_sep = ''
"   " powerline symbols
"   let g:airline_left_sep = ''
"   let g:airline_left_alt_sep = ''
"   let g:airline_right_sep = ''
"   let g:airline_right_alt_sep = ''
"   let g:airline_symbols.branch = ''
"   let g:airline_symbols.readonly = ''
"   let g:airline_symbols.linenr = ''
" endif

let g:tmuxline_preset = {
    \'a'       : '#S',
    \'win'     : ['#I', '#W'],
    \'cwin'    : ['#I', '#W #F'],
    \'y'       : '%Y-%m-%d %R',
    \'z'       : '#H',
    \'options' : {'status-justify' : 'left'}}

" syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_auto_loc_list=2
let g:syntastic_aggregate_errors = 0
let g:syntastic_python_checkers=['mypy', 'pylint']
let g:syntastic_html_checkers = ['tidy']
let g:syntastic_sh_checkers = ['shellcheck']
" let g:syntastic_quiet_messages = {"!level":  "errors"}
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
cnoreabbrev sc w <bar> SyntasticCheck
cnoreabbrev Sc sc

" Tagbar
cnoreabbrev tb TagbarToggle
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0
let g:tagbar_map_nexttag = "<C-j>"
let g:tagbar_map_prevtag = "<C-k>"

" jedi-vim
autocmd FileType python setlocal completeopt-=preview " do not open docstring on autocompletion
let g:jedi#popup_on_dot = 1
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = "<leader>d"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = "1"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#smart_auto_mappings = 1
let g:jedi#popup_select_first = 1

" Syntax highlight
" Default highlight is better than polyglot
" let g:polyglot_disabled = ['python']
let python_highlight_all = 1

" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCrMapping = 1

"vim-conda
cnoreabbrev conda CondaChangeEnv
let g:conda_startup_msg_suppress = 1

" Nord
cnoreabbrev nord colorscheme nord <bar> AirlineTheme nord

"requires jq install
cnoreabbrev jq %!jq .

" Copy mode
cnoreabbrev copy set invnumber <bar> IndentLinesToggle

" close location list and quickfix list
nnoremap <leader>c :ccl<CR> <bar> :lcl<CR>

" hack to turn off airline status bar
autocmd VimEnter * set laststatus=0

" automatically open fold
let g:tagbar_autoshowtag=1
