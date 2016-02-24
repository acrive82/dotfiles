"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                _                                            "
"                         __   _(_)_ __ ___  _ __ ___                         "
"                         \ \ / / | '_ ` _ \| '__/ __|                        "
"                          \ V /| | | | | | | | | (__                         "
"                           \_/ |_|_| |_| |_|_|  \___|                        "
"                                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NOTE: NeoVim
" The config if NeoVim set it to default or don't work with nvim,
" comment out with '">>> '
"
" See :h vim_diff
"
" written by Shotaro Fujimoto (https://github.com/ssh0)
"------------------------------------------------------------------------------
" Initial Setting:                                                          {{{
"------------------------------------------------------------------------------

" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

if has('vim_starting')
  ">>> if &compatible
  ">>>   set nocompatible
  ">>> endif

  " Required:
  set runtimepath+=~/.config/nvim/bundle/neobundle.vim/
endif

" use <Space> for mapleader & localleader
let mapleader = "\<Space>"
let localleader = "\<Space>"

" encoding
scriptencoding utf8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"---------------------------------------------------------------------------}}}
" NeoBundle:                                                                {{{
"------------------------------------------------------------------------------

" Required:
call neobundle#begin(expand('~/.config/nvim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" surround.vim                                                              {{{
NeoBundle 'surround.vim'
"                                                                           }}}
" tpope/vim-commentary                                                      {{{
NeoBundle 'tpope/vim-commentary'
"                                                                           }}}
" Shougo/unite.vim                                                          {{{
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload': {
      \     'commands': ['Unite'],
      \     'function_prefix': 'Unite'
      \     },
      \ }

let s:hooks = neobundle#get_hooks('unite.vim')
function! s:hooks.on_source(bundle)
  let g:unite_enable_start_insert=1
  let g:unite_source_history_yank_enable =1
  let g:unite_source_file_mru_limit = 200
endfunction
unlet s:hooks

nnoremap <silent> <Leader>uy :<C-u>Unite history/yank<CR>
nnoremap <silent> <Leader>ub :<C-u>Unite buffer<CR>
nnoremap <silent> <Leader>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> <Leader>ur :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> <Leader>uu :<C-u>Unite file_mru buffer<CR>
"                                                                           }}}
" Shougo/vimfiler.vim                                                       {{{
NeoBundleLazy 'Shougo/vimfiler.vim', {
\   'depends': ["Shougo/unite.vim"],
\   'autoload': {
\       'commands': [ "VimFilerTab", "VimFiler", "VimFilerExplorer", "VimFilerBufferDir" ],
\       'mappings': ['<Plug>(vimfiler_switch)'],
\       'explorer': 1
\   }
\}
nnoremap <silent> <Leader>e :VimFilerBufferDir -buffer-name=explorer -split
      \ -simple -winwidth=35 -toggle -no-quit<CR>
"                                                                           }}}
" Shougo/vimproc                                                            {{{
NeoBundle 'Shougo/vimproc', {
      \ 'build': {
      \     'windows': 'tools\\update-dll-mingw',
      \     'cygwin': 'make -f make_cygwin.mak',
      \     'mac': 'make -f make_mac.mak',
      \     'linux': 'make',
      \     'unix': 'gmake',
      \    },
      \ }
"                                                                           }}}
" lambdalisue/vim-gita                                                      {{{
NeoBundleLazy 'lambdalisue/vim-gita', {
      \ 'autoload': {
      \   'commands': ['Gita'],
      \    },
      \ }
"                                                                           }}}
" rking/ag                                                                  {{{
if executable('ag')
  NeoBundle 'rking/ag.vim'
endif
"                                                                           }}}
" ctrlpvim/ctrlp.vim                                                        {{{
NeoBundle 'ctrlpvim/ctrlp.vim'
if executable('ag')
  let g:ctrlp_user_command='ag %s -i --nocolor --nogroup -g ""'
endif
nnoremap <Leader>oo :CtrlP<CR>
nnoremap <Leader>om :CtrlPMixed<CR>
nnoremap <Leader>or :CtrlPMRUFiles<CR>
" Once CtrlP is open:
" * Press `<F5>` to purge the cache for the current directory to get new  
"   files, remove deleted files and apply new ignore options.
" * Press `<c-f>` and `<c-b>` to cycle between modes.
" * Press `<c-d>` to switch to filename only search instead of full path.
" * Press `<c-r>` to switch to regexp mode.
" * Use `<c-j>`, `<c-k>` or the arrow keys to navigate the result list.
" * Use `<c-t>` or `<c-v>`, `<c-x>` to open the selected entry in a new  
"   tab or in a new split.
" * Use `<c-n>`, `<c-p>` to select the next/previous string in the  
"   prompt's history.
" * Use `<c-y>` to create a new file and its parent directories.
" * Use `<c-z>` to mark/unmark multiple files and `<c-o>` to open them.
"                                                                           }}}
" ervandew/supertab                                                         {{{
NeoBundle 'ervandew/supertab'
"                                                                           }}}
" ujihisa/neco-look                                                         {{{
" NeoBundle 'ujihisa/neco-look', {
"       \ 'depends': ['Shougo/neocomplcache.vim']
"       \ }
"                                                                           }}}
" tacroe/unite-mark                                                         {{{
NeoBundleLazy 'tacroe/unite-mark', {
      \ 'autoload': {'commands': ['Unite']},
      \ }

let s:hooks = neobundle#get_hooks("unite-mark")
function! s:hooks.on_source(bundle)
  let g:unite_source_mark_marks =
        \   "abcdefghijklmnopqrstuvwxyz"
        \ . "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        \ . "0123456789.'`^<>[]{}()\""
endfunction
unlet s:hooks

" key bind: `` or ''
nnoremap <silent> `` :Unite mark<CR>
nnoremap <silent> '' :Unite mark<CR>
"                                                                           }}}
" kshenoy/vim-signature                                                     {{{
NeoBundle 'kshenoy/vim-signature'
" Highlight signs of marks dynamically based upon state indicated by
" vim-gitgutter or vim-signify
let g:SignatureMartTextHLDynamic = 1
let g:SignatureMarkTextHL = "'SignColumn'"
"                                                                           }}}
" LeafCage/FoldCC                                                           {{{
NeoBundle 'LeafCage/foldCC'
set foldtext=FoldCCtext()
"                                                                           }}}
" Yggdroot/indentLine                                                       {{{
" NeoBundle 'Yggdroot/indentLine'
" let g:indentLine_color_term = 239
" let g:indentLine_char = '│'
"                                                                           }}}
" lilydjwg/colorizer                                                        {{{
NeoBundle 'lilydjwg/colorizer'
"                                                                           }}}
" tyru/open-browser                                                         {{{
NeoBundleLazy 'tyru/open-browser.vim', {
      \ 'autoload': {
      \     'functions': 'OpenBrowser',
      \     'commands': ['OpenBrowser', 'OpenBrowserSearch'],
      \     'mappings': '<Plug>(openbrowser-smart-search)'
      \     },
      \ }

"                                                                           }}}
" itchyny/lightline.vim                                                     {{{
NeoBundle 'itchyny/lightline.vim'
" my color scheme for lightline
NeoBundle 'ssh0/easyreading.vim'
" Project directory:
" ($HOME/.vim/bundle/easyreading.vim/autoload/lightline/colorscheme/easyreading.vim)
let g:lightline = {
      \ 'colorscheme': 'easyreading',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'tabline': {
      \   'left': [
      \     [ 'tabs' ],
      \   ],
      \   'right': [
      \     [ 'close' ],
      \     [ 'git_branch', 'git_traffic', 'git_status', 'cwd' ],
      \   ],
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'git_branch': 'g:lightline.my.git_branch',
      \   'git_traffic': 'g:lightline.my.git_traffic',
      \   'git_status': 'g:lightline.my.git_status',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': '▒', 'right': '▒' },
      \ 'subseparator': { 'left': '│', 'right': '│' },
      \ 'tabline_separator': { 'left': '', 'right': '▒' },
      \ 'tabline_subseparator': { 'left': '│', 'right': '│' },
      \ }

function! MyModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return winwidth(0) > 40 ? (
        \ fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? (strlen(fname) < 20 ? fname : '') : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
        \ ) : ''
endfunction

" gita (steal from vimgita README)
let g:lightline.my = {}
function! g:lightline.my.git_branch() " 
  return winwidth(0) > 70 ? gita#statusline#preset('branch') : ''
endfunction

function! g:lightline.my.git_traffic() " 
  return winwidth(0) > 70 ? gita#statusline#preset('traffic') : ''
endfunction

function! g:lightline.my.git_status() " 
  return winwidth(0) > 70 ? gita#statusline#preset('status') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 30 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
      \ 'main': 'CtrlPStatusFunc_1',
      \ 'prog': 'CtrlPStatusFunc_2',
      \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

"                                                                           }}}
" thinca/vim-quickrun                                                       {{{
NeoBundle 'thinca/vim-quickrun'

let g:quickrun_config = {}
let g:quickrun_no_default_key_mapping = 0

if $USER == "ssh0"
  let g:quickrun_user_tex_autorun = 0
else
  let g:quickrun_user_tex_autorun = 1
endif

"                                                                           }}}
" thinca/vim-template                                                       {{{
NeoBundle 'thinca/vim-template'
augroup template
  autocmd!
  " inside <%= %> is estimated by vim and expanded automatically
  autocmd User plugin-template-loaded
        \ silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
  " if you write like below, the string is expanded to date.
  " <%= strftime('%Y-%m-%d') %>

  " move the cursor to <+CURSOR+>
  autocmd User plugin-template-loaded
        \    if search('<+CURSOR+>')
        \  |   execute 'normal! "_da>'
        \  | endif
augroup END
"                                                                           }}}
" thinca/vim-splash                                                         {{{
NeoBundle 'thinca/vim-splash'
let g:splash#path = expand('~/.splash-vim.txt')
"                                                                           }}}
" tpope/vim-markdown                                                        {{{
NeoBundle 'tpope/vim-markdown'
"                                                                           }}}
" tyru/markdown-codehl-onthefly.vim                                         {{{
NeoBundle 'tyru/markdown-codehl-onthefly.vim'
"                                                                           }}}
" rcmdnk/vim-markdown                                                       {{{
" NeoBundle 'rcmdnk/vim-markdown', {
"       \ 'depends': ['godlygeek/tabular'],
"       \ }

" " Enable folding
" let g:vim_markdown_folding_disabled = 0
" " Disable Default Key Mapping
" let g:vim_markdown_no_default_key_mappings = 1
" " LaTeX math
" let g:vim_markdown_math = 1
"                                                                           }}}
" joker1007/vim-markdown-quote-syntax                                       {{{
">>> NeoBundle 'joker1007/vim-markdown-quote-syntax'
">>> Don't work with markdown
"                                                                           }}}
" lervag/vimtex                                                             {{{
NeoBundle 'lervag/vimtex'
let g:vimtex_fold_envs = 1
let g:vimtex_view_general_viewer = 'mupdf'
"                                                                           }}}
" davidhalter/jedi-vim                                                      {{{
" for python
NeoBundle 'davidhalter/jedi-vim'
" jedi complete
let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 1
"                                                                           }}}
" nvie/vim-flake8                                                           {{{
" Press <F7> to run flake8
NeoBundle 'nvie/vim-flake8'
"                                                                           }}}
" hynek/vim-python-pep8-indent                                              {{{
NeoBundleLazy 'hynek/vim-python-pep8-indent', {
      \ 'autoload': {
      \     'insert': 1,
      \     'filetype': ['python', 'python3', 'djangohtml']
      \     }
      \ }
"                                                                           }}}
" lambdalisue/vim-gista                                                     {{{
" easily sent a gista
NeoBundle 'lambdalisue/vim-gista', {
      \ 'depends': [
      \     'Shougo/unite.vim',
      \     'tyru/open-browser.vim',
      \     ]
      \ }
let g:gista#github_user = 'ssh0'
let g:gista#update_on_write = 1
"                                                                           }}}
" moznion/hateblo                                                           {{{
" provide some funtions of Hatena Blog by using AtomPub API
NeoBundle 'moznion/hateblo.vim', {
      \ 'depends': ['mattn/webapi-vim', 'Shougo/unite.vim'],
      \ }
" config file is in ~/.hateblo.vim
" (You should create manually. See the project's README.)
"                                                                           }}}
" googlesuggest-complete-vim                                                {{{
" set complete function from googlesuggest
" Require:
"   set completefunc=googlesuggest#Complete
NeoBundle 'mattn/googlesuggest-complete-vim'
"                                                                           }}}
" Lolaltog/powerline-fontpatcher                                            {{{
NeoBundle 'Lokaltog/powerline-fontpatcher'
"                                                                           }}}
" ssh0/easy-reading.vim                                                     {{{
NeoBundle 'ssh0/easy-reading.vim'
" It's my vim's whole color theme.
" Project directory:
" ($HOME/.vim/bundle/easy-reading.vim/colors/easy-reading.vim)
"                                                                           }}}

call neobundle#end()

" If there are uninstalled bundles dfound on startup,
" this will conveiently prompt you to install them.
NeoBundleCheck

" Required:
filetype plugin indent on
syntax on
colorscheme easy-reading

"---------------------------------------------------------------------------}}}
" Autocmd:                                                                  {{{
"------------------------------------------------------------------------------

" set title for currently viewing
" [tmux tabs with name of file open in vim - Stack Overflow]
" http://stackoverflow.com/questions/15123477/tmux-tabs-with-name-of-file-open-in-vim
if $TMUX != ""
  augroup titlesettings
    autocmd!
    autocmd BufEnter,InsertEnter * call system("tmux rename-window " . "'(vim)" . expand("%:t") . "'")
    autocmd VimLeave * call system("tmux rename-window zsh")
    autocmd BufEnter * let &titlestring = ' ' . expand("%:t")
  augroup END
endif

augroup filetype
  autocmd!
  " markdown
  autocmd BufRead,BufNewFile *.{mkd,md} set filetype=markdown
  autocmd! FileType markdown hi! def link markdownItalic Normal
  autocmd FileType markdown set commentstring=<\!--\ %s\ -->
  " tex file (I always use latex)
  autocmd BufRead,BufNewFile *.tex set filetype=tex
  " bib file
  autocmd BufRead,BufNewFile *.bib set filetype=bib
  autocmd Filetype bib let &formatprg="bibclean"
  " python
  autocmd Filetype python let &formatprg="autopep8 -"
  autocmd FileType python setlocal completeopt-=preview
  " html
  let html_to_html  = "pandoc --from=html --to=markdown"
  let html_to_html .= " | pandoc --from=markdown --to=html"
  autocmd Filetype html let &formatprg=html_to_html
augroup END

augroup set_K_help
  autocmd!
  autocmd FileType vim setlocal keywordprg=:help
augroup END

augroup texmath
  autocmd!
  autocmd FileType texmath setlocal syntax=tex
augroup END

"---------------------------------------------------------------------------}}}
" Set Options:                                                              {{{
"------------------------------------------------------------------------------
" System                                                                    {{{
" ------

" don't use backup or swap files
set nowritebackup nobackup noswapfile

" how many stock command history
set history=1000

" save information to ~/.viminfo
set viminfo='1000,<3000,f50,c,h

" use unnamed register (for outer programs)
set clipboard+=unnamedplus

" less timeoutlen
set timeout timeoutlen=400 ttimeoutlen=75

" disable 8-bit num
set nrformats-=octal

" use mouse
">>> if has('mouse')
">>>   set mouse=a
">>> endif

" set completion popup's height
set pumheight=10

" always split vertically when using vimdiff
set diffopt=vertical

" Indicates a fast terminal connection
">>> set ttyfast

set whichwrap=b,s,[,],<,>

" help language
set helplang=ja,en

" try to open under the cursor with `gx`
let g:netrw_browsex_viewer= "xdg-open"

"                                                                           }}}
" Search                                                                    {{{
" ------

" case sensitive for search
set noignorecase nosmartcase
" Show matches while typing
">>> set incsearch
" highlighted search index
">>> set hlsearch
" wrapscan
set wrapscan

"                                                                           }}}
" Apearance                                                                 {{{
" ---------

" don't give the intro message
">>> set shortmess+=I

" don't redraw screen during macros
set lazyredraw

" no number line
set nonumber norelativenumber numberwidth=3

" autoindent
">>> set autoindent

" insert space instead of TAB
set expandtab shiftround
">>> set smarttab

" default tab width
set softtabstop=4 shiftwidth=4

" don't break a long line
set textwidth=0

" wrapped by 80 characters(PEP8)
set colorcolumn=80

" status line
set title noshowcmd

" highlight cursorline
set cursorline

" height of commandline
set cmdheight=1

" the last window will have a status line always
">>> set laststatus=2

" show wildmenu
set wildmenu

" show Tab and Space at end of the line
set list listchars=tab:▸\ ,trail:~

" showbreaks
set showbreak=\ ↪

" highlight mathched parenthesis
set showmatch matchtime=1

" folding
set foldmethod=marker foldcolumn=0

" characters to vertical separator
set fillchars=vert:\|

" modeline
set modeline

" disable the conceal function
let g:tex_conceal=''

"                                                                           }}}
"---------------------------------------------------------------------------}}}
" Indent:                                                                   {{{
"------------------------------------------------------------------------------

autocmd FileType sh         setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType apache     setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
autocmd FileType css        setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd FileType diff       setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd FileType html       setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd FileType java       setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
autocmd FileType javascript setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd FileType ruby       setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType eruby      setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType sql        setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
autocmd FileType tex        setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType vim        setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType xml        setlocal shiftwidth=4 softtabstop=4 tabstop=4 noexpandtab
autocmd FileType yaml       setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType zsh        setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab
autocmd FileType coffee     setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab

"---------------------------------------------------------------------------}}}
" My function:                                                              {{{
"------------------------------------------------------------------------------

function! Markdown_h1()
  normal! V"ly"lpVr=
endfunction

function! Markdown_h2()
  normal! V"ly"lpVr-
endfunction

function! Markdown_h3()
  normal! I### 
endfunction

"---------------------------------------------------------------------------}}}
" Key Bindings:                                                             {{{
"------------------------------------------------------------------------------

" Escape by jj, kk
inoremap <silent> jj <ESC>
inoremap <silent> kk <ESC>

" Toggle relative number by <Space> + l
nnoremap <silent> <Leader>l :setlocal relativenumber! number!<CR>

" move in wrapped line by arrow key
nnoremap <Down> gj
nnoremap <Up> gk

" move from line head to line end
nnoremap h <Left>zv

" move from line end to line head
nnoremap l <Right>zv

" yank to line end
nnoremap Y y$

" cursor moved in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

" move between windows by easy key mapping
nnoremap <silent> <C-h> :wincmd h<CR>
nnoremap <silent> <C-j> :wincmd j<CR>
nnoremap <silent> <C-k> :wincmd k<CR>
nnoremap <silent> <C-l> :wincmd l<CR>

" clear highlight by pressing Esc twice
nnoremap <silent> <ESC><ESC> :nohlsearch<CR>

" open the file in new tab
nnoremap gf <C-w>gf
" create the file and open in new tab
nnoremap gF :tabedit <C-r><C-f><CR>

" multi tab jamp
nnoremap <C-]> g<C-]>

" for Japanese IME mode"{{{
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap え e
nnoremap お o
nnoremap っd dd
nnoremap っy yy
nnoremap し” ci"
nnoremap し’ ci'
nnoremap せ ce
nnoremap で de
inoremap <silent> っj <ESC>

nnoremap っz zz
nnoremap ・ /
"}}}

" quote and bracket
inoremap {} {}<Left>
inoremap [] []<Left>
inoremap () ()<Left>
inoremap "" ""<Left>
inoremap '' ''<Left>
inoremap <> <><Left>
inoremap $$ $$<Left>

vnoremap < <gv
vnoremap > >gv

" source vimrc
map <Leader>so :source ~/.config/nvim/init.vim

" my functions
nnoremap <silent> <Leader>h1 :call Markdown_h1()<CR>
nnoremap <silent> <Leader>h2 :call Markdown_h2()<CR>
nnoremap <silent> <Leader>h3 :call Markdown_h3()<CR>

"---------------------------------------------------------------------------}}}
