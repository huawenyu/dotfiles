"======================================================================
" Installation & Helper {{{1}}}
" ============================
" 1. Vundle.vim
"    $ mv .vim vim-bak; mv .vimrc vimrc-bak;
"    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"    $ vi -c 'PluginInstall'
"
" Usage: {{{2}}}
" ======
" <leader>         ";"
" <leader>;*       my shortkey
"
"  gd <or> D       goto declare <or> global declare
"  [I              list all occurence
"  g; <or> g,      navigate changelist
" :g/regex/t$      copy match lines append to tail
" s<char><char>    sneak quick motion: <num>s - next count, `` <OR> <Ctrl-O> - backword original, s<enter> repeat search
"
" Howtos: {{{2}}}
" =======
"       :R !ls -l           # grab shell cmd output into new tab/buffer
"       :new|0read !ls -l  # grab cmd output into new window
"       :cfile log.marks   # view as quickfix
"       :mks!              # Save to Session.vim
"   Vimgrep:               # Also lvimgrep, short as: vim, lvim
"       samples
"       :vim /some/gj **/*.c **/*.h
"       :vim /^POST \/\(idle\|send\)\/CzHmd/gj %
"
"       /^joe.*fred.*bill/ # AND
"       /fred\|joe/        # OR
"       /.*fred\&.*joe/    # AND no-order
"       /\<fred\>/         # whole word
"       /begin\_.*end/     # search over possible multiple lines
"       /fred\_s*joe/      # any whitespace including newline [C]
"       /^\n\{3}/          # find 3 empty lines
"
"   Grep:                  # grepprg=grep, using outer grep tool
"       samples
"       :grep -Iinr 'string' --include='*.[ch]' dirs
"       :grep -w 'word1\|word2' files
"       :grep '[a-z]\{5\}' files
"       :grep '^POST /\(idle\|send\)/CzHmd' log
"       ‘\w’ matches a character within a word
"       ‘\W’ matches a character which is not within a word
"       ‘\<’ matches the beginning of a word
"       ‘\>’ matches the end of a word
"       ‘\b’ matches a word boundary
"       ‘\B’ matches characters which are not a word boundary
"       ‘\`’ matches the beginning of the whole input
"       ‘\'’ matches the end of the whole input
"
" Tools: {{{2}}}
" ======
"   DrawIt:                # use \di to start (\ds to stop)
"   W3m:
"       :W3m :W3mTab :W3mReload (local) [url or keyword], keyword include: google, wikipedia, man
"       <backspace>        # Back page
"       <enter>            # Open link under the cursor
"
" Self: {{{2}}}
" =====
"   Function:
"       :<C-\>e YourFunc() <CR>       # put YourFunc()'s result here
"   Batchfiles:
"       :TraceAdd,TraceAdjust,TraceClear()     # _WAD_TRACE_
"   CrashLog:              # mark 'a, 'b, then :call Tracecrash()    resolve fgt's crashlog
"======================================================================
if has("unix")
    let s:uname = system("uname")
    let g:python_host_prog='/usr/bin/python'
    if s:uname == "Darwin\n"
        let g:python_host_prog='/usr/bin/python'
    endif
endif

" Plugins {{{1}}}
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'VundleVim/Vundle.vim'

Plugin 'holokai'
Plugin 'darkspectrum'
Plugin 'tomasr/molokai'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'nanotech/jellybeans.vim'

Plugin 'derekwyatt/vim-fswitch'
Plugin 'file-line'
Plugin 'Raimondi/delimitMate'
Plugin 'majutsushi/tagbar'
Plugin 'millermedeiros/vim-statline'

Plugin 'justinmk/vim-sneak'
"Plugin 'kien/ctrlp.vim'
"Plugin 'myusuf3/numbers.vim'
"Plugin 'easymotion/vim-easymotion'
"Plugin 'tpope/vim-repeat'
"Plugin 'tpope/vim-fugitive'
"Plugin 'vim-scripts/CmdlineComplete'
Plugin 'vim-utils/vim-vertical-move'

Plugin 'klen/python-mode'
Plugin 'AnsiEsc.vim'
"Plugin 'tpope/vim-markdown'
"Plugin 'pangloss/vim-javascript'
"Plugin 'jceb/vim-orgmode'
"Plugin 'tpope/vim-speeddating'
Plugin 'vim-scripts/VOoM'
"Plugin 'vimwiki/vimwiki'
Plugin 'szw/vim-maximizer'
Plugin 'chrisbra/NrrwRgn'

"Plugin 'SirVer/ultisnips'
"Plugin 'honza/vim-snippets'
"Plugin 'msanders/snipmate.vim'

"Plugin 'tpope/vim-obsession'
"Plugin 'xolox/vim-misc'
"Plugin 'xolox/vim-session'
"Plugin 'xolox/vim-reload'
"Plugin 'mhinz/vim-startify'

"Plugin 'kana/vim-arpeggio'
"Plugin 'dyng/ctrlsf.vim'
"Plugin 'rking/ag.vim'

"Plugin 'JarrodCTaylor/vim-shell-executor'

"Plugin 'Shougo/vimshell.vim'
"Plugin 'Shougo/unite.vim'
"Plugin 'Shougo/neomru.vim'
"Plugin 'Shougo/neoyank.vim'
"Plugin 'Shougo/vimproc.vim'
"Plugin 'h1mesuke/unite-outline'

Plugin 'yuratomo/w3m.vim'
"Plugin 'DrawIt'
"Plugin 'bruno-/vim-man'
"Plugin 'vim-scripts/DirDiff.vim'

Plugin 'huawenyu/taboo.vim'
Plugin 'huawenyu/vim-mark'
"Plugin 'huawenyu/highlight.vim'
Plugin 'huawenyu/vim-log-syntax'
Plugin 'huawenyu/vimux-script'
Plugin 'huawenyu/vim-dispatch'
Plugin 'huawenyu/c-utils.vim'

" Debug
Plugin 'tpope/vim-scriptease'
Plugin 'huawenyu/Decho'

call vundle#end()
filetype plugin indent on

" Configure {{{1}}}
let mapleader = ";"
" diable Ex mode
map Q <Nop>
nnoremap <C-c> <silent> <C-c>

" Vim status bar prediction/completion
"set wildmode=longest,list,full
set wildmode=longest:full,full
set wildmenu

set clipboard+=unnamed
set clipboard+=unnamedplus

if has("nvim")
  let base16colorspace=256
  let $NVIM_TUI_ENABLE_TRUE_COLOR=0
  set synmaxcol=2048
else
 set term=xterm-256color
endif

set nocompatible
set guifont=Liberation\ Mono\ 13

" Disable any use of bold fonts
set t_md=
set t_vb=
set hidden

" syntax enable
syntax on
"set background=dark
"set t_Co=256

"colorscheme distinguished
"colorscheme darkspectrum
"colorscheme molokai
colorscheme holokai

if has('mouse')
	set mouse=a
	set mousefocus
endif
set foldmethod=manual

set backspace=indent,eol,start
set ignorecase
set smartcase
set hlsearch
set incsearch
set history=1000
set undolevels=1000
set shortmess+=a
set scrolloff=1

set visualbell
set noerrorbells
set nobackup
set noshowmode
set nomodeline
set nowrap
set nowrapscan
set noswapfile
set nostartofline
set noshowmatch
set nonumber
set noexpandtab

" indent
set tabstop=4
set shiftwidth=4
set textwidth=160

" C indent {
"set autoindent
"set smartindent
"set cindent
"}

set list
"set paste           " conflict with auto-pairs, delimitmate, auto-close plugin
"set showcmd
set splitbelow
set splitright

"set autochdir       " if work with shell or cscope, please not change work-dir
set sessionoptions-=options    " do not store global and local values in a session
set ssop-=folds      " do not store folds
set ssop-=curdir     " do not store absolute path
set ssop+=sesdir     " work under current dir as relative path

" Plugins Configure {{{1}}}
" Restore cursor to file {

 " Tell vim to remember certain things when we exit
 "  !    :  The uppercase global VARIABLE will saved
 "  '30  :  marks will be remembered for up to 10 previously edited files
 "  "300 :  will save up to 100 lines for each register
 "  :30  :  up to 20 lines of command-line history will be remembered
 "  %    :  saves and restores the buffer list
 "  n... :  where to save the viminfo files,
 "            here save to /tmp means we have another viminfo manager 'workspace'
if has("nvim")
  set viminfo=!,'30,\"300,:30,%,n~/.nviminfo
else
  "set viminfo=!,'30,\"300,:30,%,n/tmp/viminfo
  set viminfo='30,\"100,:100,n~/.viminfo
endif

 function! ResCur()
   if line("'\"") <= line("$")
     normal! g`"
     return 1
   endif
 endfunction

 augroup resCur
   autocmd!
   autocmd BufWinEnter * call ResCur()
 augroup END

"}

" Save Session
let g:session_autoload = 'no'
let g:session_autosave = 'no'
let g:session_directory = getcwd()
let g:reload_on_write = 0

" Autocmd {
  "autocmd VimLeavePre * cclose | lclose
  autocmd InsertEnter,InsertLeave * set cul!
  " current position in jumplist
  autocmd CursorHold * normal! m'

  autocmd BufNewFile,BufRead *.json set ft=javascript
"}

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
let g:AutoPairsFlyMode = 1

" Use deoplete.
"let g:deoplete#enable_at_startup = 1

" w3m
let g:w3m#command = '/usr/bin/w3m'
let g:w3m#lang = 'en_US'

" vimgrep, ctrlp exclude dir
set wildignorecase
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*,*/\.svn/*
set wildignore+=*.o,*.obj,.hg,*.pyc,.git,*.rbc,*.class,.svn,coverage/*,vendor
set wildignore+=*.gif,*.png,*.map

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }


hi CursorLine guibg=Grey40
hi Visual term=reverse cterm=reverse guibg=Grey

"hi MatchParen cterm=bold ctermfg=cyan
"hi MatchParen cterm=none ctermbg=green ctermfg=none
"hi MatchParen cterm=none ctermbg=green ctermfg=blue
hi MatchParen cterm=bold ctermbg=none ctermfg=magenta

" change highlight color for search hits
"hi Search guibg=peru guifg=wheat
"hi Search ctermfg=grey ctermbg=darkblue cterm=NONE
hi Search ctermfg=Red ctermbg=NONE cterm=NONE

"hi TabLineFill ctermfg=Black ctermbg=Green cterm=NONE
hi TabLine ctermfg=DarkBlue ctermbg=NONE cterm=NONE
hi TabLineSel ctermfg=Red ctermbg=NONE cterm=NONE
hi TabLineFill ctermfg=NONE ctermbg=NONE cterm=NONE

"hi NonText ctermfg=7 guifg=Gray
hi NonText ctermfg=DarkGrey guifg=DarkGrey
hi clear SpecialKey
hi link SpecialKey NonText

" The characters after tab is U+2002. in vim with Ctrl-v u 2 0 0 2 (in insert mode).
set listchars=tab:»\ ,trail:~,extends:<,nbsp:.
"set listchars=nbsp:.,tab:>-,trail:~,extends:>,precedes:<
"set listchars=tab:>.,trail:~,extends:<,nbsp:.
"set listchars=tab:> ,trail:~,extends:<,nbsp:.

let g:AutoComplPop_CompleteoptPreview = 1
let g:AutoComplPop_Behavior = {
\ 'c': [ {'command' : "\<C-x>\<C-o>",
\       'pattern' : ".",
\       'repeat' : 0}
\      ]
\}

"" Vim-session
"let g:session_directory = "."
"let g:session_autoload = "no"
"let g:session_autosave = "yes"
"let g:session_command_aliases = 1

" CommandT
let g:CommandTHighlightColor = 'Ptext'
let g:CommandTNeverShowDotFiles = 1
let g:CommandTScanDotDirectories = 0

"{ taglist tagbar plugin
	let g:tagbar_width = 30
	let g:tagbar_compact = 1
	let g:tagbar_indent = 0
	let g:tagbar_iconchars = ['+', '-']
"}

let g:miniBufExplSplitToEdge = 1
let g:miniBufExplorerAutoStart = 1

let g:vim_json_syntax_conceal = 0

" sneek motion: conflict with leader ';'
let g:sneak#s_next = 1

" tracelog
let g:tracelog_default_dir = $HOME . "/script/trace-wad/"

set grepprg=grep

command! -nargs=1 Silent
  \ | execute ':silent !'.<q-args>
  \ | execute ':redraw!'

" vimdiff output to html ignore the same line
let g:html_ignore_folding = 1
let g:html_use_css = 0
let g:enable_numbers = 0
let g:sneak#s_next = 1

" Key maps {{{1}}}
  nmap <silent> <space> :call utils#ColumnlineOrDeclaration()<CR>

  " when wrap, move by virtual row
  nmap j gj
  nmap k gk
  nmap <leader>i <C-I>
  nmap <leader>o <C-O>

  " make vim yank cross vim-sessions
  "vmap <leader>y   "+y
  "vnoremap <leader>p "_dP
  vmap <leader>y :w! /tmp/vim.yank<CR>
  nmap <silent> <leader>y  :<c-u>call vimuxscript#Copy() <CR>
  nmap <leader>p :r! cat /tmp/vim.yank<CR>

  " vim local list
  nmap <silent> gn :silent! lnext <CR>
  nmap <silent> gp :silent! lpre  <CR>

  " Open tag in new tab
  nmap <silent><Leader><C-]> <C-w><C-]><C-w>T

  nmap <c-h> <c-w>h
  nmap <c-j> <c-w>j
  nmap <c-k> <c-w>k
  nmap <c-l> <c-w>l

  map <silent> <leader>1 :norm! 1gt <CR>
  map <silent> <leader>2 :norm! 2gt <CR>
  map <silent> <leader>3 :norm! 3gt <CR>
  map <silent> <leader>4 :norm! 4gt <CR>
  map <silent> <leader>5 :norm! 5gt <CR>
  map <silent> <leader>6 :norm! 6gt <CR>

  nmap <buffer> <Enter> <C-W><Enter>

  map gf :call utils#GotoFileWithLineNum()<CR>
  map gsf :sp<CR>:call utils#GotoFileWithLineNum()<CR>

  "map <leader>ds :call Asm() <CR>
  map <leader>bs :call blame#SvnBlameCurrent() <CR>
  map <leader>bg :call blame#GitBlameCurrent() <CR>

  nmap          <leader>qf :call utilquickfix#QuickFixFilter() <CR>
  nmap          <leader>qq :call utilquickfix#QuickFixFunction() <CR>
  nmap          <leader>;q :call utilquickfix#QuickFixFunction() <CR>

  "nmap <silent> <leader>;w :NumbersToggle<CR>
  nmap <silent> <leader>;w :MaximizerToggle<CR>
  nmap <silent> <leader>ww :MaximizerToggle<CR>

  nmap          <leader>dd :g/<C-R><C-w>/ norm dd
  nmap          <leader>de  :g/.\{200,\}/d

  let g:voom_tree_placement = 'right'
  let g:tlTokenList = ["FIXME @wilson", "TODO @wilson", "XXX @wilson"]
  let g:ctrlsf_mapping = { "next": "n", "prev": "N", }
  "nmap          <leader>;t :<C-u>Ag -inr --ignore='vim.*' 'TODO @*wilson' .

  nmap <silent> <leader>;l :call layout#DefaultLayout() <CR><CR>
  nmap <silent> <leader>;i :call utils#VoomInsert(0) <CR>
  vmap <silent> <leader>;i :call utils#VoomInsert(1) <CR>
  nmap <silent> <leader>;o :VoomToggle<CR>
  nmap <silent> <leader>;t :TagbarToggle<CR>
  vmap          <leader>;h <Plug>CtrlSFVwordPath
  map  <silent> <leader>;g :redir @a<CR>:g//<CR>:redir END<CR>:tabnew<CR>:put! a<CR>
  nmap <silent> <leader>;s :call utilcscope#CscopeSymbol() <CR>
  nmap <silent> <leader>;r :!/bin/bash gencs.sh -a all <CR>
      \:cs reset <CR><CR>

  nmap <silent> <leader>;. :call verticalmove#VerticalMoveDown(1)<CR>
  nmap <silent> <leader>;, :call verticalmove#VerticalMoveDown(0)<CR>

  " :on[ly][!]  close all other windows, but keep buffer
  nmap <silent> <leader>;n :silent! cnewer <CR>
  nmap <silent> <leader>;p :silent! colder <CR>

  nmap <silent> <c-n> :cn<cr>
  nmap <silent> <c-p> :cp<cr>

  " Execute selected text as shell
  nmap          <leader>ex  :tabclose<CR>
  nmap          <leader>et  :TabooOpen 
  nmap <silent> <leader>eo  :call VimuxOpenRunner()<CR>
  nmap <silent> <leader>ec  :VimuxCloseRunner<CR>
  nmap <silent> <leader>ev  :<c-u>call vimuxscript#StartCopy() <CR>
  nmap <silent> <leader>ey  :<c-u>call vimuxscript#Copy() <CR>
  vmap <silent> <leader>ee  :<c-u>call vimuxscript#ExecuteSelection(1)<CR>
  nmap <silent> <leader>ee  :<c-u>call vimuxscript#ExecuteSelection(0)<CR>
  nmap <silent> <leader>eg  :<c-u>call vimuxscript#ExecuteGroup()<CR>
  nmap          <leader>ew  :!~/tools/dict <C-R>=expand("<cword>") <CR><CR>
  nmap <silent> <leader>;e  :<c-u>call vimuxscript#ExecuteSelection(0)<CR>
  vmap <silent> <leader>;e  :ExecuteSelection <CR>

  " map same key under different mode
  nmap <leader>rr  <ESC>0y$0:<c-u>R !sh -c '<c-r>0'<CR><CR>
  vmap <leader>rr  :<c-u>R !sh -c '<c-r>*'

  " ctags -R *;  ctags -L cscope.files
  "nmap <leader>g :ptag <C-R>=expand("<cword>")<CR><CR>
  "nmap <silent> <leader>, :ptnext<cr>
  "nmap <silent> <leader>. :ptprevious<cr>

  " TAB conflict with ctrl-i
  "nmap <silent> <leader>j <leader>mmxviw:<c-u>%s/<c-r>*/&/gn<cr>:noh<cr>`x
  nmap <silent> <leader>a :FSHere<cr> |" Switch file *.c/h

  " :R !ls -l   grab command output int new buffer
  command! -nargs=* -complete=shellcmd R tabnew
  			\| setlocal buftype=nofile bufhidden=hide syn=diff noswapfile
  			\| r <args>

  " Cause command 'w' delay
  "cmap w!! w !sudo tee % >/dev/null

  map  <leader>va :Decho "wilson some message here" <CR>
  "map  <leader>va :<C-\>e utilgrep#Grep(0,1) <CR>
  nmap <leader>vv :<C-\>e utilgrep#Grep(1,0) <CR><CR>
  vmap <leader>vv :<C-\>e utilgrep#Grep(1,1) <CR><CR>
  map  <leader>vV :<C-\>e utilgrep#Grep(2,1) <CR>
  "map <leader>vr :<C-\>e utilgrep#LocalEasyReplace() <CR>
  map  <leader>vr :<C-\>e tmp#CurrentReplace() <CR>
  nmap <leader>;v :<C-\>e utilgrep#Grep(1,0) <CR><CR>
  vmap <leader>;v :<C-\>e utilgrep#Grep(1,1) <CR><CR>

  "bookmark
  nmap <leader>mo :BookmarkLoad Default
  nmap <leader>ma :BookmarkShowAll <CR>
  nmap <leader>mm :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  "nmap <silent> <leader>;m :call mark#MarkCurrentWord(expand('cword'))<CR>
  nmap <leader>mg :BookmarkGoto <C-R><c-w>
  nmap <leader>mc :BookmarkDel <C-R><c-w>

  "map <leader>s  :<c-u>R !grep-malloc.sh <c-r>*
  nnoremap <leader>;a :<C-u>execute autoreadfiles#WatchForChanges("*",{'autoread':1}) <CR>
  xnoremap * :<C-u>call utils#VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call utils#VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
  vnoremap // y:vim /\<<C-R>"\C/gj %

  let g:voom_tree_width = 45

  " Unite
  let g:unite_source_history_yank_enable = 1
  let g:neoyank#file = $HOME.'/.vim/yankring.txt'
  "call unite#filters#matcher_default#use(['matcher_fuzzy'])
  nnoremap <leader>jt :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
  nnoremap <leader>jf :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec<cr>
  nnoremap <leader>jr :<C-u>Unite -no-split -buffer-name=mru     -start-insert file_mru<cr>
  "nnoremap <leader>jo :<C-u>Unite -no-split -buffer-name=outline -start-insert outline<cr>
  nnoremap <leader>jy :<C-u>Unite -no-split -buffer-name=yank    history/yank<cr>
  nnoremap <leader>jb :<C-u>Unite -no-split -buffer-name=buffer bookmark -start-insert buffer<cr>
  nnoremap <leader>jj :<C-u>Unite jump <CR>
  nnoremap <leader>jc :<C-u>UniteClose <CR>

  " Custom mappings for the unite buffer
  autocmd FileType unite call s:unite_settings() | imap <buffer> <ESC> <Plug>(unite_exit)
  function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  endfunction

"}

" VimL Debug{{{1
  let g:decho_enable = 0
  function! Decho(...)
    return
  endfunction

" }}}

" Python-mode{{{1
  " Activate rope
  " Keys:
  " K             Show python docs
  " <Ctrl-Space>  Rope autocomplete
  " <Ctrl-c>g     Rope goto definition
  " <Ctrl-c>d     Rope show documentation
  " <Ctrl-c>f     Rope find occurrences
  " <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
  " [[            Jump on previous class or function (normal, visual, operator modes)
  " ]]            Jump on next class or function (normal, visual, operator modes)
  " [M            Jump on previous class or method (normal, visual, operator modes)
  " ]M            Jump on next class or method (normal, visual, operator modes)
  let g:pymode_rope = 0

  " Documentation
  let g:pymode_doc = 1
  let g:pymode_doc_key = 'K'

  "Linting
  let g:pymode_lint = 0
  let g:pymode_lint_checker = "pyflakes,pep8"
  " Auto check on save
  let g:pymode_lint_write = 1

  " Support virtualenv
  let g:pymode_virtualenv = 1

  " Enable breakpoints plugin
  let g:pymode_breakpoint = 1
  let g:pymode_breakpoint_bind = '<leader>b'

  " syntax highlighting
  let g:pymode_syntax = 1
  let g:pymode_syntax_all = 1
  let g:pymode_syntax_indent_errors = g:pymode_syntax_all
  let g:pymode_syntax_space_errors = g:pymode_syntax_all

  " Don't autofold code
  let g:pymode_folding = 0
"}}}
