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
Plug 'tpope/vim-fugitive'  "Gitdiff
Plug 'tpope/vim-rhubarb' "Github
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'airblade/vim-gitgutter' "Git
" Plug 'vim-scripts/grep.vim'
Plug 'vim-scripts/CSApprox'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Raimondi/delimitMate'
" Plug 'jiangmiao/auto-pairs'  " delimitMate alternative
Plug 'Vimjas/vim-python-pep8-indent'  " fixes indent for inside parenthesis and closing bracket
Plug 'majutsushi/tagbar'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'  " putting '(. etc around
Plug 'tpope/vim-repeat'
Plug 'arcticicestudio/nord-vim'
Plug 'ervandew/supertab'
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}
Plug 'xolox/vim-misc' " required by vim-session
Plug 'xolox/vim-session'
Plug 'github/copilot.vim'
Plug 'mechatroner/rainbow_csv'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ojroques/vim-oscyank'

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
set noruler
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
let g:indentLine_concealcursor = ''
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
    " set textwidth=99
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

"" Show current file path
nnoremap <leader>p :echo expand('%:p')<CR>

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
  autocmd FileType python nmap <F2> :w <bar> :!python %<CR>
  autocmd FileType python nmap <F1> oimport ipdb; ipdb.set_trace(context=10)<ESC>
augroup END

" shell
autocmd FileType sh nmap <F10> :w <bar> :!./%<CR>

" c/c++
autocmd FileType c,cpp setlocal shiftwidth=2 tabstop=2

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
let g:NERDTreeStatusline='' " default: %{exists('b:NERDTree')?b:NERDTree.root.path.str():''}
cnoreabbrev nt NERDTreeToggle
cnoreabbrev ntff NERDTreeFind
cnoreabbrev ntf NERDTreeFocus
autocmd VimEnter * call NERDTreeAddKeyMap({
        \ 'key': 'yy',
        \ 'callback': 'NERDTreeCopyPath',
        \ 'quickhelpText': 'put full path of current node into the default register' })

" tagbar
let g:tagbar_autoshowtag=1 " automatically open fold

" fzf vim
nnoremap <C-p> :Files<CR>
nnoremap <leader>f :Rg<CR>
nnoremap <leader>m :Marks<CR>

"" vim-fugitive
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :G commit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gst :Git status<CR>
noremap <Leader>gb :Git blame<CR>
noremap <Leader>gd :Gvdiffsplit!<CR>
noremap <Leader>gr :Gremove<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
nnoremap <Leader>go :GBrowse<CR>

" vim-session
cnoreabbrev so OpenSession<Space>
cnoreabbrev ss SaveSession<Space>
cnoreabbrev sd DeleteSession
cnoreabbrev sc CloseSession<CR>
cnoreabbrev sv ViewSession<CR>
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" " grep.vim
" nnoremap <silent> <leader>f :Rgrep<CR>
" let Grep_Default_Options = '-IR'
" let Grep_Skip_Files = '*.log *.db'
" let Grep_Skip_Dirs = '.git node_modules'

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

" let g:airline#extensions#branch#enabled = 1
" let g:airline_skip_empty_sections = 1
" let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tagbar#flags = 'f'  " show full tag hierarchy
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
" https://github.com/vim-airline/vim-airline/issues/1845
let g:airline_section_a = '' " turn off vim mode display
let g:airline_section_c = '' " turn off file name, it's available in the tabline
let g:airline_section_x = '%#__accent_bold#%#__restore__#%{airline#util#prepend("",0)}%{airline#util#prepend(airline#extensions#tagbar#currenttag(),0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("", 0)}%{airline#util#prepend("",0)}' " took out filetype
" let g:airline_section_x = '"%#__accent_bold#%#__restore__#%{airline#util#prepend("",0)}%{airline#util#prepend(airline#extensions#tagbar#currenttag(),0)}%{airline#util#prepend("",0)}%{airline#util#prepend("",0)}%{airline#util#prepend("", 0)}%{airline#util#prepend("",0)}%{airline#util#wrap(airline#parts#filetype(),0)}' " this is the default
let g:airline_section_y = '' " turn off encoding (e.g. unix)
let g:airline_section_z = '' " turn off current position

let g:tmuxline_preset = {
    \'a'       : '#S',
    \'win'     : ['#I', '#W'],
    \'cwin'    : ['#I', '#W #F'],
    \'y'       : '%Y-%m-%d %R',
    \'z'       : '#(bash ~/dotfiles/tmux_hostname/hostname.sh)',
    \'options' : {'status-justify' : 'left'}}

" ALE
let g:ale_linters = {
\    'python': ['ruff'],
\    'sh': ['shellcheck'],
\}
let g:ale_fixers = {
\    'python': ['ruff', 'ruff_format', 'trim_whitespace', 'remove_trailing_lines'],
\    'sh': ['shfmt', 'trim_whitespace', 'remove_trailing_lines'],
\    'markdown': ['pandoc', 'prettier', 'trim_whitespace', 'remove_trailing_lines'],
\ }
let g:ale_python_ruff_options = 'check --select ALL --line-length 99 --target-version py310'
let g:ale_python_ruff_format_options = '--line-length 99'
let g:ale_sh_shfmt_options = '-i 2 -ci -w 80'
" let g:ale_history_log_output = 1
let g:ale_set_highlights = 1
let g:ale_echo_cursor = 1
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'
let g:ale_set_signs = 0
let g:ale_sign_error='x'
let g:ale_sign_warning='!'
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
highlight ALEError ctermbg=NONE ctermfg=red cterm=undercurl
highlight ALEWarning ctermbg=NONE ctermfg=yellow cterm=underline
" let g:ale_completion_enabled = 1
" nnoremap <leader>d :ALEGoToDefinition<CR>
" nnoremap <leader>n :ALEFindReferences<CR>

" Tagbar
cnoreabbrev tb TagbarToggle
let g:tagbar_autofocus = 1
let g:tagbar_map_nexttag = "<C-j>"
let g:tagbar_map_prevtag = "<C-k>"
let g:tagbar_sort = 0

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
let g:polyglot_disabled = ['python']
let python_highlight_all = 1

" supertab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCrMapping = 1

"requires jq install
cnoreabbrev jq %!jq .

" close location list and quickfix list
nnoremap <leader>c :ccl<CR> <bar> :lcl<CR>

" hack to turn off airline status bar
" autocmd VimEnter * set laststatus=0

cnoreabbrev copy only <bar> GitGutterDisable <bar> IndentLinesDisable <bar> set nonu
cnoreabbrev nocopy GitGutterEnable <bar> IndentLinesEnable <bar> set nu

" yy in any mode uses OSCYank
" https://github.com/ojroques/vim-oscyank/issues/19#issuecomment-913422361
autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankRegister "' | endif
