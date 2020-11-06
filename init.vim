" My init.vim File :
" ---------------
" @AUTHOR  : Guillaume Seren
" @WEBSITE : http://guillaumeseren.com
" @LICENSE : https://www.gnu.org/licenses/gpl-2.0.html
" @Link    : https://github.com/GuillaumeSeren/neovimrc
" ---------------

" Auto Install {{{1
" plugins {{{2
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" spell {{{2

" Default plugins {{{1
call plug#begin('~/.config/nvim/plugged')
" DEFAULT preset
Plug 'tpope/vim-sensible'
" Extend . usage
Plug 'tpope/vim-repeat'
" Extend C^a / C^x
Plug 'tpope/vim-speeddating'
" Extend netrw
Plug 'tpope/vim-vinegar'
" Several UNIX alias (SudoWrite)
Plug 'tpope/vim-eunuch'
" Manage surround
Plug 'tpope/vim-surround'
" Enhance surround for many html / xml
Plug 'tpope/vim-ragtag'
" Easy comment gcc
Plug 'tpope/vim-commentary'
" show a diff when recover a file
Plug 'chrisbra/Recover.vim'
" linter
Plug 'w0rp/ale'
" wiki
Plug 'vimwiki/vimwiki'
" zettelkasten
Plug 'michal-h21/vim-zettel'
" vim-pandoc
Plug 'vim-pandoc/vim-pandoc'
" vim-pandoc syntax
Plug 'vim-pandoc/vim-pandoc-syntax'

" Access undotree of a file
Plug 'mbbill/undotree'
" some i3 control
Plug 'fabi1cazenave/suckless.vim'
" Readline binding for insert and command mode
Plug 'tpope/vim-rsi'
" Status line config
Plug 'vim-airline/vim-airline'
" Status line theme
Plug 'vim-airline/vim-airline-themes'
" Git in vim
Plug 'tpope/vim-fugitive'
" Show diff when git commit
Plug 'rhysd/committia.vim'
" ansi escap sequence concealed
" Plug 'powerman/vim-plugin-AnsiEsc'
" vim-man
" Plug 'vim-utils/vim-man'
" Show indent wiht a line
Plug 'Yggdroot/indentLine'
" Show icon relative to filetype
Plug 'ryanoasis/vim-devicons'
" Distraction free writing
Plug 'junegunn/goyo.vim'
" Color preview
Plug 'chrisbra/Colorizer'
" Extend " / @ to see content
Plug 'junegunn/vim-peekaboo'
" Mark quickfix and location list with sign
Plug 'tomtom/quickfixsigns_vim'
" colorize parentheses
Plug 'luochen1990/rainbow'
" Make the yanked region apparent
Plug 'machakann/vim-highlightedyank'
" Colorschemes
" Solarized
Plug 'altercation/vim-colors-solarized'
" Gruvbox
Plug 'morhetz/gruvbox'
" Extend session
Plug 'xolox/vim-session' | Plug 'xolox/vim-misc'
" Restore cursor position and folding
Plug 'vim-scripts/restore_view.vim'
" search / finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" Perl regex in vim
Plug 'othree/eregex.vim'
" Multi-language DBGP debugger
Plug 'joonty/vdebug'
" Mail completion with notmuch
Plug 'adborden/vim-notmuch-address'
" yaml
Plug 'mrk21/yaml-vim'
" jinja2
Plug 'Glench/Vim-Jinja2-Syntax'

" Install missing plugins {{{1
" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Syntax plugins {{{1
Plug 'tmux-plugins/vim-tmux'
call plug#end()
filetype plugin indent on

" Tweaking Plugins {{{1
" FZF {{{2
if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

nnoremap <silent> <Leader><Leader> :Files<CR>

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })

" indentLine {{{2
" Vim
let g:indentLine_color_term = 248
" GVim
let g:indentLine_color_gui = '#fbf1c7'
" none X terminal
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" Background (Vim, GVim)
let g:indentLine_bgcolor_term = 229
let g:indentLine_bgcolor_gui = '#fbf1c7'
let g:indentLine_char       = '│'

" highlightedyank {{{2
let g:highlightedyank_highlight_duration = 1000
hi HighlightedyankRegion cterm=reverse gui=reverse

" Goyo {{{2
let g:goyo_width  = '100%'
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
    :IndentLinesDisable
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
    :IndentLinesEnable
    :QuickfixsignsEnable
    set scrolloff=5
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

nnoremap <Leader>G :Goyo<CR>

" Colorizer {{{2
" auto loading
let g:colorizer_auto_color = 1

" Rainbow parentheses {{{2
" Active by default
let g:rainbow_active = 1

" vim-session {{{2
" Extended session management for Vim (:mksession on steroids)
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'

" Committia {{{2
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

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

" restore_view {{{2
set viewoptions=cursor,folds,slash,unix

" airline {{{2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_powerline_fonts = 1

" vim ale {{{2
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8'],
\   'sh': ['shfmt'],
\}
" Use ALE's function for omnicompletion.
set omnifunc=ale#completion#OmniFunc

let g:ale_completion_enabled = 1

" " Fix bash detection
" function! ShellcheckDetect(buffer)
"   for l:line_num in [1, 2, 3]
"     let l:line = get(getbufline(a:buffer, l:line_num), 0, '')
"
"     if l:line[:11] is# '# shellcheck'
"       let l:command = l:line
"       for l:possible_shell in ['bash', 'dash', 'ash', 'tcsh', 'csh', 'zsh', 'ksh', 'sh']
"         if l:command =~# l:possible_shell . '\s*$'
"           return l:possible_shell
"         endif
"       endfor
"     endif
"   endfor
"
"   return ''
" endfunction
"
" function! ShellcheckSet(buffer)
"   let l:shell = ShellcheckDetect(a:buffer)
"   if l:shell == 'bash'
"     call setbufvar(a:buffer, 'is_bash', 1)
"   else
"     call setbufvar(a:buffer, 'is_bash', 0)
"   endif
" endfunction
"
" autocmd FileType sh call ShellcheckSet(bufnr("%"))

" eregex {{{2
" Do not load by default
" use :%S// for perl style regex
let g:eregex_default_enable = 0

" vimwiki {{{2
let g:vimwiki_list = [{"path":"~/vimwiki",      'syntax': 'markdown', 'ext': '.md'},
                    \ {"path":"~/zettelkasten", 'syntax': 'markdown', 'ext': '.md'}]
" let g:vimwiki_use_mouse = 1
" let g:vimwiki_folding = 'expr'
" let g:vimwiki_auto_chdir = 1

" zettel
let g:zettel_options = [{"front_matter" : {"tags" : ":new:"}, "template" : "~/vimwiki/template/zettelkasten.tpl"},
                      \ {"front_matter" : {"tags" : ""},      "template" : "~/vimwiki/template/zettelkasten.tpl"}]
let g:zettel_format = "%d%m%y%H%M%S-%file_no"
let g:zettel_fzf_command = "rg --column --line-number --ignore-case --no-heading --color=always "
" let g:initialize_wiki_number

" Core configuration {{{1
" grepprg {{{2
" if available use ag
" From: http://robots.thoughtbot.com/faster-grepping-in-vim
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Indent {{{2
set shiftwidth=2
" set smarttab
set tabstop=2
set softtabstop=2
set expandtab
set shiftround

" Completion {{{2
" set omnifunc=syntaxcomplete#Complete

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

" Swap {{{2
" !! I still use the same backup dir that I use for vim
set swapfile
let g:dotvim_backup=expand('$HOME') . '/.vim/swap'
if ! isdirectory(g:dotvim_backup)
    call mkdir(g:dotvim_backup, "p")
endif
" set &directory=g:dotvim_backup
exec "set directory=".g:dotvim_backup

" Backups {{{2
set backup
let g:dotvim_backups=expand('$HOME') . '/.vim/backups'
if ! isdirectory(g:dotvim_backups)
    call mkdir(g:dotvim_backups, "p")
endif
exec "set backupdir=" . g:dotvim_backups
" set &backupdir = g:dotvim_backups
set writebackup

" Undos {{{2
set undofile
let g:dotvim_undos=expand('$HOME') . '/.vim/undos'
if ! isdirectory(g:dotvim_undos)
    call mkdir(g:dotvim_undos, "p")
endif
exec "set undodir =". g:dotvim_undos
if has('persistent_undo')
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" LINE WRAPPING {{{2
set si
set wrap
set linebreak
set textwidth=80

" COMMAND HISTORY {{{2
set history=10000

" Folding {{{2
set foldmethod=indent
set foldlevelstart=1

" colorscheme {{{2
" set the background light or dark
set background=light
" let g:solarized_termtrans = 1
let g:gruvbox_box = 1
let g:gruvbox_italic = 1
let g:gruvbox_underline = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_termcolors = 256 " 16 or 256
" colorscheme solarized
colorscheme gruvbox

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

" Launch neomake on save {{{2
" if has("autocmd")
"   autocmd! BufWritePost * Neomake
" endif
" Functions {{{1
" AppendModeline() {{{2
" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
"
" Custom Function {{{2
" AppendModeline() {{{3
function! AppendModeline()
  let l:modeline = printf(" vim: set ft=%s ts=%d sw=%d tw=%d foldmethod=%s %set :",
        \ &filetype, &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

" Pulse on focus {{{3
" from https://github.com/airblade/dotvim/blob/dd5d7737e39aad5e24c1a4a8c0d115ff2ae7b488/vimrc#L294-L310
function! s:Pulse()
  setlocal cursorline!
  redraw
  sleep 100m

  setlocal cursorline!
  redraw
  sleep 100m

  setlocal cursorline!
  redraw
  sleep 100m

  setlocal cursorline!
  redraw
  sleep 100m

  " setlocal nocursorline
  " redraw
endfunction
autocmd FocusGained * call s:Pulse()

" CLOSING {{{3
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
" no <down>   ddp
" no <up>     ddkP
vnoremap <down> :m '>+1<CR>gv=gv
vnoremap <up>   :m '<-2<CR>gv=gv

" Remap Arrow Right / Left to switch tab {{{3
no <left>   :tabprevious<CR>
no <right>  :tabnext<CR>

" Change default leader key {{{2
" Suggestion: Space as leader key — Spacemacs style!
nmap <Space> <Nop>
let mapleader = "\<Space>"

" SpeedDating {{{2
" Reselect after increment decrement
map <C-A> <Plug>SpeedDatingUpgv

map <C-X> <Plug>SpeedDatingDowngv

" " NeoMan {{{2
" " Overload K
" nnoremap <silent> K :Nman<CR>
" " Open vertical split man page with the word under the cursor.
" nnoremap <silent> <leader>mv :Vnman<CR>

" nmap <silent> <BS> :nohlsearch<CR>

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" Make Y behave like other capitals
nnoremap Y y$

" QuickFix
nnoremap ]q :cnext<cr>zz
nnoremap [q :cprev<cr>zz
nnoremap ]l :lnext<cr>zz
nnoremap [l :lprev<cr>zz

" Buffers
nnoremap ]b :bnext<cr>
nnoremap [b :bprev<cr>

" <tab> / <s-tab> | Circular windows navigation
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" Binding leaders {{{2
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>
noremap <silent> ZZ :call AutocloseSession()<CR>
" 'cd' towards the dir in which the current file is edited
" but only change the path for the current window
map <leader>cd :lcd %:h<CR>
" Open files located in the same dir in with the current file is edited
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
" Create file if it did not exist
map <leader>gf :e <cfile><cr>

" testing {{{2
noremap <Space> <C-d>zz
noremap <NUL> <C-u>zz  "// Ctrl + Space --> Ctrl + u + z + z

vmap r "_dP

" vim: set foldmethod=marker :
