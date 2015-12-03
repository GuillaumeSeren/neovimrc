" My init.vim File :
" ---------------
" @AUTHOR  : Guillaume Seren
" @WEBSITE : http://guillaumeseren.com
" @LICENSE : https://www.gnu.org/licenses/gpl-2.0.html
" @Link    : https://github.com/GuillaumeSeren/neovimrc
" ---------------

" Default plugin {{{1
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vimwiki/vimwiki'
Plug 'mbbill/undotree'
Plug 'fabi1cazenave/suckless.vim'
" Display
Plug 'Yggdroot/indentLine'
Plug 'gorodinskiy/vim-coloresque'
Plug 'altercation/vim-colors-solarized'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'bling/vim-airline'
Plug 'tomtom/quickfixsigns_vim'
" Session
Plug 'joequery/Stupid-EasyMotion'
Plug 'xolox/vim-session' | Plug 'xolox/vim-misc'
Plug 'vim-scripts/restore_view.vim'
" search / finder
Plug 'junegunn/fzf',        { 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
" code
Plug 'joonty/vdebug'
" VCS
Plug 'vcscommand.vim'
Plug 'tpope/vim-fugitive'
Plug 'rhysd/committia.vim'

" Lazy plugins {{{1
Plug 'honza/dockerfile.vim', { 'for': 'docker' }
Plug 'leafo/moonscript-vim' , { 'for': 'moon' }
Plug 'avakhov/vim-yaml', { 'for': ['python', 'yaml'] }
Plug 'Matt-Deacalion/vim-systemd-syntax', { 'for': 'systemd' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'othree/html5.vim', { 'for': ['html', 'xhtml'] }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
call plug#end()
filetype plugin indent on

" Tweaking Plugins {{{1
" FZF {{{2
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <silent> <Leader><Leader> :Files<CR>

imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Goyo {{{2
let g:goyo_width = '100%'
let g:goyo_height = '100%'
let g:goyo_linenr = '100'
function! s:goyo_enter()
  if has('gui_running')
    set fullscreen
    set background=light
    set linespace=7
  elseif exists('$TMUX')
    silent !tmux set status off
    set noshowmode
    set noshowcmd
    set nonumber
    " Show number relative from the cursor
    set norelativenumber
    " Disable quickfixsign
    :QuickfixsignsDisable
    set scrolloff=999
  endif
endfunction

function! s:goyo_leave()
  if has('gui_running')
    set nofullscreen
    set background=dark
    set linespace=0
  elseif exists('$TMUX')
    silent !tmux set status on
    set showmode
    set showcmd
    set number
    " Show number relative from the cursor
    set relativenumber
    :QuickfixsignsEnable
    set scrolloff=5
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>G :Goyo<CR>

" vim-session {{{2
" Extended session management for Vim (:mksession on steroids)
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

" Committia {{{2
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    end

    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

function! g:committia_hooks.diff_open(info)
    " No fold on the committia diff screen
    set nofoldenable
endfunction

" indentLine {{{2
let g:indentLine_color_term = 239
let g:indentLine_color_gui  = '#09AA08'
let g:indentLine_char       = '│'

" restore_view {{{2
set viewoptions=cursor,folds,slash,unix

" Core configuration {{{1
" grepprg {{{2
" if available use ag
" From: http://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Indent {{{2
set shiftwidth=2
set tabstop=2
set softtabstop=2
set expandtab
set shiftround

" Completion {{{2
" set complete=.,w,b,u,t
set complete-=i

" SPELL CHECKER {{{2
" https://georgebrock.github.io/talks/vim-completion/
" Autocomplete with dictionary words when spell check is on
set complete+=kspell
" Dictionaries files: http://wordlist.aspell.net/
set spell
" [s / ]s : saute au prochain / précédant mot avec faute.
" z=      : affiche la liste de suggestion pour corriger.
" zg      : Ajoute le mot au dico local.
" zG      : Ajoute le mot au dico global.
" @TODO: Test if dictionnary is available before activating it.
set spelllang=fr,en

" SEARCH {{{2
set smartcase
set ignorecase
set hlsearch
set showmatch

" PASTE / NOPASTE {{{2
set nopaste

" BACKUP {{{2
" !! I still use the same backup dir that I use for vim
set swapfile
let g:dotvim_backup=expand('$HOME') . '/.vim/backup'
if ! isdirectory(g:dotvim_backup)
    call mkdir(g:dotvim_backup, "p")
endif
set directory=~/.vim/backup

" Backups with persistent undos {{{2
set backup
let g:dotvim_backups=expand('$HOME') . '/.vim/backups'
if ! isdirectory(g:dotvim_backups)
    call mkdir(g:dotvim_backups, "p")
endif
exec "set backupdir=" . g:dotvim_backups
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
    exec "set undodir=" . g:dotvim_backups
endif

" LINE WRAPPING {{{2
set si
set wrap
set linebreak
set textwidth=80

" COMMAND HISTORY {{{2
set history=10000

" LinterConfiguration {{{2
augroup linterConfiguration
    autocmd FileType xml   setlocal  makeprg=xmllint\ -
    autocmd FileType xml   setlocal  equalprg=xmllint\ --format\ -
    autocmd FileType html  setlocal  equalprg=tidy\ -q\ -i\ -w\ 80\ -utf8\ --quote-nbsp\ no\ --output-xhtml\ yes\ --show-warnings\ no\ --show-body-only\ auto\ --tidy-mark\ no\ -
    autocmd FileType xhtml setlocal  equalprg=tidy\ -q\ -i\ -w\ 80\ -utf8\ --quote-nbsp\ no\ --output-xhtml\ yes\ --show-warnings\ no\ --show-body-only\ auto\ --tidy-mark\ no\ -
    autocmd FileType json  setlocal  equalprg=python\ -mjson.tool
augroup END

" Folding {{{2
set foldmethod=indent

" colorscheme {{{2
" set the background light or dark
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized
" Change le colorscheme en mode diff
if &diff
    colorscheme solarized
endif

" VISUAL BELL {{{2
" Error bells are displayed visually.
set visualbell

" DIFF {{{2
" Affiche toujours les diffs en vertical
set diffopt=vertical

" Split {{{2
" Set the split below the active region.
set splitbelow

" Display cmd mod {{{2
" Indiquer le nombre de modification lorsqu'il y en a plus de 0
" suite à une commande
set report=0

" Title {{{2
" This is nice if you have something
" that reset the title of you term at
" each command, othersize it's annoying ...
set title

" Show Special Char {{{2
" show tabs / nbsp ' ' / trailing spaces
set list listchars=nbsp:¬,tab:··,trail:¤,extends:▷,precedes:◁

" Cursor {{{2
" SHOW CURRENT LINE :
set cursorline
"SHOW CURRENT COLUMN :
set cursorcolumn
" SHOW CURSOR
highlight Cursor  guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

" LINE NUMBER {{{2
" Show line number
set number
" Show number relative from the cursor
set relativenumber

" HighLighting {{{2
augroup highlight
    " From «More Instantly Better Vim» - OSCON 2013
    " http://youtu.be/aHm36-na4-4
    " Highlight long lines
    autocmd ColorScheme * highlight OverLength ctermbg=darkblue ctermfg=white guibg=darkblue guibg=white
    autocmd ColorScheme * call matchadd('OverLength', '\%81v', 100)
    " Highlight TODO:
    autocmd ColorScheme * highlight todo ctermbg=darkcyan ctermfg=white guibg=darkcyan guibg=white
    autocmd ColorScheme * call matchadd('todo', 'TODO\|@TODO', 100)
    " Highlight MAIL:
    autocmd ColorScheme * call matchadd('todo', 'MAIL\|mail', 100)
    " Highlight misspelled word: errreur
    autocmd ColorScheme * highlight SpellBad ctermfg=red guifg=red
    " Highlight BUGFIX / FIXME
    autocmd ColorScheme * highlight fix ctermbg=darkred ctermfg=white guibg=darkred guibg=white
    autocmd ColorScheme * call matchadd('fix', 'BUGFIX\|@BUGFIX\|bugfix\|FIXME\|@FIXME\|fixme', 100)
    " Highlight author
    autocmd ColorScheme * highlight author ctermfg=brown guibg=brown
    autocmd ColorScheme * call matchadd('author', 'author\|@author', 100)
augroup END

doautoall highlight ColorScheme

" Do not tab expand on Makefile
autocmd FileType make set noexpandtab shiftwidth=4 softtabstop=0

" enable fenced code block syntax highlighting
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

" AutoReLoad init.vim {{{2
" Auto apply modification to vimrc
if has("autocmd")
    autocmd bufwritepost ~/.config/nvim/init.vim source ~/.config/nvim/init.vim
endif

" SESSION {{{2
" Récupération de la position du curseur entre 2 ouvertures de fichiers
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
                \| exe "normal g'\"" | endif
endif

" Functions {{{1
" AppendModeline() {{{2
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d %set :",
        \ &filetype, &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

" CLOSING {{{2
" ZZ now saves all files, creates a session and exits
function! AutocloseSession()
    wqall
endfunction

" Input bindings {{{1
" Searching {{{2
" From http://lambdalisue.hatenablog.com/entry/2013/06/23/071344
" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" better diff mode {{{2
" ooooo
"
nnoremap gdo do]c
nnoremap gdp dp]c

" Reselect visual block after indentation {{{2
vnoremap > >gv
vnoremap < <gv

" Arrow remapping {{{2
" Disable Arrow in insert mode {{{3
ino <down>  <Nop>
ino <left>  <Nop>
ino <right> <Nop>
ino <up>    <Nop>

" Disable Arrow in visual mode {{{3
vno <down>  <Nop>
vno <left>  <Nop>
vno <right> <Nop>
vno <up>    <Nop>

" Remap Arrow Up/Down to move line {{{3
" Real Vimmer forget the cross
no <down>   ddp
no <up>     ddkP

" Remap Arrow Right / Left to switch tab {{{3
no <left>   :tabprevious<CR>
no <right>  :tabnext<CR>

" Change default leader key {{{2
" Suggestion: Space as leader key — Spacemacs style!
nmap <Space> <Nop>
let mapleader = "\<Space>"

" Vim Easy Motion {{{2
let g:EasyMotion_leader_key = '\'

" SpeedDating {{{2
" Reselect after increment decrement
map <C-A> <Plug>SpeedDatingUpgv
map <C-X> <Plug>SpeedDatingDowngv

" Binding leaders {{{2
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
noremap <silent> ZZ :call AutocloseSession()<CR>
