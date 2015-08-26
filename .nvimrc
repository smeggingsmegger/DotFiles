" Heavily based on the Neovim configuration by Ben Hayden (beardedprojamz)
" Neo is The Chosen One
" Maintainer:   Scott Blevins
" Version:      0.1

scriptencoding utf-8

" Set up vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup plug_install
    au!
    au! VimEnter * PlugInstall
  augroup END
endif

" ===========
" Plugin List
" ===========

call plug#begin('~/.vim/plugged')

" Nicer start screen
Plug 'mhinz/vim-startify'
" Better color schemes.
Plug 'chriskempson/base16-vim'
" Lots of non-base16 colorschemes to choose from as well.
Plug 'smeggingsmegger/vim-colorschemes'
" I prefer tagbar
Plug 'majutsushi/tagbar', { 'on':  'TagbarToggle' }
" Tim Pope Time
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
" Simple Statusline
Plug 'maciakl/vim-neatstatus'
" NeoVim Syntax Checking
Plug 'benekastah/neomake'
" Better Python Indenting
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
" Less support
Plug 'groenewege/vim-less', { 'for': 'less' }
" Unite.vim for uniting all user interfaces
Plug 'Shougo/vimproc.vim', { 'do': function('fxns#MakeVimProc') }
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'     " Most recently used
Plug 'Shougo/unite-outline'  " Function/Class Outline
Plug 'tsukkee/unite-tag'     " Search ctags
" Dark-powered Auto completion
" Plug 'Shougo/deoplete.nvim'
" Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
" Notice Git File changes
Plug 'airblade/vim-gitgutter'
" Autopairing
Plug 'jiangmiao/auto-pairs'
" Match HTML Tags
Plug 'Valloric/MatchTagAlways'
" Auto close HTML Tags
Plug 'alvan/vim-closetag'
" Salt highlighting
Plug 'saltstack/salt-vim', { 'for': 'sls' }
" Puppet highlighting
Plug 'rodjek/vim-puppet', { 'for': 'puppet' }
" Do not pass Go
Plug 'fatih/vim-go', { 'for' : 'go' }

call plug#end()

" =============
" Basic Options
" =============

set wildmode=longest,list,full
set hidden
set nostartofline
set mouse=a
set nowrap
set ignorecase
set infercase
set smartcase
set autochdir
set tags=./tags;
set undolevels=1000
" Persistent undo
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p')
endif
set undofile
set undodir=~/.vim/undo
" Keep temp files stored in one place
if !isdirectory($HOME.'/.vim/tmp')
    call mkdir($HOME.'/.vim/tmp', 'p')
endif
set directory=~/.vim/tmp
" Automatically insert comment leader on return,
" and let gq format comments
set formatoptions=rq

" ==========
" UI Options
" ==========

set hlsearch
set background=dark
set number
set cursorline
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme blayden

" =====================================
" Mappings, Commands, and Auto Commands
" =====================================

let mapleader=','
" Edit .vimrc
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
" Simple Keybindings
nnoremap <Leader>c :close<CR>
nnoremap <Leader>w :write<CR>
nnoremap <Leader>q :quit!<CR>
nnoremap <Leader>d :bdelete!<CR>
" nnoremap <Leader>. :only<CR>
nnoremap <C-j> i<CR><Esc>
" Arrow heresy
nnoremap <S-Down> 10j
nnoremap <S-Up> 10k
inoremap <S-Down> <Esc>10ji
inoremap <S-Up> <Esc>10ki
vnoremap <S-Down> 10j
vnoremap <S-Up> 10k
" Mapping tab commands
nnoremap <Leader>tc :tabc<return>
nnoremap <Leader>tn :tabn<return>
nnoremap <Leader>tp :tabp<return>
nnoremap <Leader>te :tabe<space>
" Add Tagbar Toggle
nnoremap <Leader>tb :TagbarToggle<return>
" Fix whitespace issues
nnoremap <Leader>ws :TrimWS<return>
nnoremap <Leader>rt gg=G
nnoremap <Leader>rw :TrimWS<return>gg=G
" Toggle line-wrap
nnoremap <Leader>lw :set wrap!<return>:set linebreak!<return>:set list!<return>
" Write as sudo
command! W w !sudo tee % > /dev/null
" Shortcut for posting to slack channels
command! -range Slack <line1>,<line2> call fxns#Slack()
vnoremap <Leader>sl <Esc>:'<,'>:Slack<CR>
" System clipboard mappings
vnoremap <Leader>y "*y
vnoremap <Leader>x "*x
vnoremap <Leader>pp "*p
vnoremap <Leader>pP "*P
nnoremap <Leader>pp "*p
nnoremap <Leader>pP "*P
" Search visually selected text
vnoremap // y/<C-R>"<CR>"
" 'Parameters' Operator mapping
" Usage: dp - Delete between ()
onoremap p i(

augroup dotvimrc
  au!
  " Trim Whitespace before write
  au! BufWritePre * %s/\s\+$//e
  " Check syntastic on save
  au! BufWritePost * Neomake
  " Source Vimrc on save
  au! BufWritePost $MYVIMRC source $MYVIMRC
        \| source ~/.vim/plugged/vim-neatstatus/after/plugin/neatstatus.vim
  " Reopen at last location
  au! BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") && &filetype != 'gitcommit'
        \| exe "normal! g'\"" | endif
augroup END

au Filetype python setl et ts=4 sw=4

" ===================
" Custom Functions
" ===================

" Trim trailing whitespace
command! TrimWS %s/\s*$//g | noh

" Clear highlighting
nnoremap <Leader>ch :noh<return>
" Insert a line above or below cursor without insert mode.
nnoremap <Leader>O O<Esc>
nnoremap <Leader>o o<Esc>

" ===================
" Startify settings
" ===================

let g:startify_session_persistence = 1
let g:startify_custom_header = [
            \'    ─────────────────────────────────────────────────────────── ',
            \'   |`##::: ##:`########::`#######::`##::::`##:`####:`##::::`##:│',
            \'   | ###:: ##: ##.....::`##.... ##: ##:::: ##:. ##:: ###::`###:│',
            \'   | ####: ##: ##::::::: ##:::: ##: ##:::: ##:: ##:: ####`####:│',
            \'   | ## ## ##: ######::: ##:::: ##: ##:::: ##:: ##:: ## ### ##:│',
            \'   | ##. ####: ##...:::: ##:::: ##:. ##:: ##::: ##:: ##. #: ##:│',
            \'   | ##:. ###: ##::::::: ##:::: ##::. ## ##:::: ##:: ##:.:: ##:│',
            \'   | ##::. ##: ########:. #######::::. ###::::`####: ##:::: ##:│',
            \'   |..::::..::........:::.......::::::...:::::....::..:::::..::│',
            \'    ─────────────────────────────────────────────────────────── '
            \'',
            \''
            \]

" ===================
" Neatstatus Settings
" ===================

let g:NeatStatusLine_color_normal   = 'guifg=#f1efee guibg=#5ab738 gui=NONE ctermfg=15 ctermbg=2  cterm=NONE'
let g:NeatStatusLine_color_insert   = 'guifg=#f1efee guibg=#f22c40 gui=NONE ctermfg=15 ctermbg=1  cterm=NONE'
let g:NeatStatusLine_color_replace  = 'guifg=#f1efee guibg=#407ee7 gui=NONE ctermfg=15 ctermbg=4  cterm=NONE'
let g:NeatStatusLine_color_visual   = 'guifg=#f1efee guibg=#6666ea gui=NONE ctermfg=15 ctermbg=13 cterm=NONE'
let g:NeatStatusLine_color_position = 'guifg=#f1efee guibg=#1b1918 gui=NONE ctermfg=15 ctermbg=0  cterm=NONE'
let g:NeatStatusLine_color_modified = 'guifg=#f1efee guibg=#c33ff3 gui=NONE ctermfg=15 ctermbg=17 cterm=NONE'
let g:NeatStatusLine_color_line     = 'guifg=#6666ea guibg=#1b1918 gui=NONE ctermfg=5  ctermbg=0  cterm=NONE'
let g:NeatStatusLine_color_filetype = 'guifg=#f1efee guibg=#00ad9c gui=NONE ctermfg=15 ctermbg=6  cterm=NONE'

" ===========================
" Neomake Settings & Mappings
" ===========================

nnoremap <Leader>el :lopen<CR>

" =================
" Vim-plug Mappings
" =================

nnoremap <Leader>pi :PlugInstall<CR>
nnoremap <Leader>pu :PlugUpdate<CR>
nnoremap <Leader>pc :PlugClean<CR>

" =========================
" Unite Settings & Mappings
" =========================

let g:unite_source_history_yank_enable = 1
let g:unite_data_directory = expand('~/.vim/cache/unite')
let g:neomru#file_mru_path = expand('~/.vim/cache/neomru/file')
let g:neomru#directory_mru_path = expand('~/.vim/cache/neomru/directory')
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden'
let g:unite_source_grep_recursive_opt = ''
call unite#custom#profile('default', 'context', {
\   'start_insert': 1,
\   'winheight': 10
\ })
nnoremap <Leader>T :Unite -buffer-name=files   -start-insert file_rec/async:!<CR>
nnoremap <Leader>r :Unite -buffer-name=tags    -start-insert tag<CR>
nnoremap <Leader>/ :Unite -buffer-name=grep    -start-insert -no-quit grep<CR>
nnoremap <Leader>? :UniteWithCursorWord -buffer-name=grep    -no-quit grep<CR>
nnoremap <Leader>f :Unite -buffer-name=files   -start-insert file<CR>
nnoremap <Leader>F :Unite -buffer-name=files   -start-insert file/new<CR>
nnoremap <Leader>u :Unite -buffer-name=mru     -start-insert file_mru<CR>
nnoremap <Leader>tb :Unite -buffer-name=outline -vertical -direction=botright outline<CR>
nnoremap <Leader>. :Unite -buffer-name=outline -start-insert outline<CR>
nnoremap <Leader>L :Unite -buffer-name=buffer  -start-insert buffer<CR>
nnoremap <Leader>l :Unite -buffer-name=buffer  -quick-match  buffer<CR>
nnoremap <Leader>y :Unite -buffer-name=yank    history/yank<CR>

" =================
" Neomake Settings
" =================

let g:neomake_error_sign = {'text': '❗️', 'texthl': 'GitGutterAdd'}
let g:neomake_warning_sign = {'text': '❓', 'texthl': 'GitGutterAdd'}
" Let's use pyflakes for python
let g:neomake_python_enabled_makers = ['pyflakes']
" Check python files when you open them.
autocmd BufRead *.py NeomakeFile

" =================
" Deoplete Settings
" =================

let g:deoplete#enable_at_startup = 1

" ===============================
" Neosnippets Settings & Mappings
" ===============================

" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" ===================
" Commentary Mappings
" ===================

nmap <Leader>, <Plug>CommentaryLine
vmap <Leader>, <Plug>Commentary

" =================
" Fugitive Mappings
" =================

nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>go :Gbrowse<CR>
nnoremap <Leader>gO :Gbrowse!<CR>
vnoremap <Leader>go :Gbrowse<CR>
vnoremap <Leader>gO :Gbrowse!<CR>
nnoremap <Leader>gs :Gstatus<CR>

" vim:set ft=vim et sw=2:
