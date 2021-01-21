"***************************************************************************************
" 0. Download this vimrc:
"       $ wget --no-check-certificate -O ~/.vimrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
" Install:
"   - Windows MobaXterm + vim 8.0
"       Enter local bash
"       $ apt-get install vim
"       $ vim --version       <=== check version
"       $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
"   - vim
"       $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
"   - nvim
"       $ sudo apt-get install neovim
"       $ nvim --version
"       $ sudo update-alternatives --display vi
"       $ sudo update-alternatives --config vi
"
"       $ sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
"       $ sudo update-alternatives --config vi
"       $ sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
"       $ sudo update-alternatives --config vim
"       $ sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
"       $ sudo update-alternatives --config editor
"
"       from vi -c 'help nvim-from-vim'
"       $ mkdir ~/.vim
"       $ mkdir ~/.config
"       $ ln -s ~/.vim ~/.config/nvim
"       $ ln -s ~/.vimrc ~/.config/nvim/init.vim
"
"       $ curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"          https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"
""   - For all
"       $ vi -c 'PlugInstall'
"       $ vi -c 'checkhealth'
"            Plugin 'deoplete' require:
"               sudo apt-get install python3-pip
"               pip3 install --user msgpack
"               pip3 install --user libtmux
"
" 1. Auto-Setup-IDE-without-Plugs:
"       $ nvim -u ~/.vimrc
" 2. Hi, the <leader> is <space> and ',' :)
"       let mapleader = ","
"       nmap <space> <leader>
"       Check map: verbose map <leader>f, verboser map ;
" 3. Help: press 'K'
"    When focus a plug's name, for example, please move cursor to following line, then press 'K':
"       @note:nvim
"       @note:test-vim
" 4. Start slow troubleshooting:
"       $ vi --startuptime /tmp/log.1
" 5. Displaying the current Vim environment
"       @note:vim_runtime
" 6. Remote-mode:
"       NVIM_LISTEN_ADDRESS=/tmp/nvim.trace nvim
" 7. Options for .vimrc from env command-line:
"       debugger=vimspector vi <file>
" 8. MACRO, suppose recorded the macro into register q by qq, then we can change the macro like:
"    "qp    paste the contents of the register to the current cursor position
"    I      enter insert mode at the begging of the pasted line
"    ^      add the missing motion to return to the front of the line
"    <c-[>  return to visual mode
"    "qyy   yank this new modified macro back into the q register
"
" 9. @note:troubleshooting
" 10. [Neovim 0.5 features and the switch to init.lua](https://oroques.dev/notes/neovim-init/)
"     [Learn X in Y minutes](https://learnxinyminutes.com/docs/lua/)
" =============================================================
"@mode: ['all', 'basic', 'theme', 'local', 'editor',
"      \   'admin', 'QA', 'coder',
"      \
"      \   'vimscript', 'c', 'python', 'latex', 'perl', 'javascript', 'clojure', 'database',
"      \   'golang', 'tcl', 'haskell', 'rust',
"      \   'note', 'script',
"      \
"      \   'morecool', 'todo', 'tool',
"      \]
"
"  Sample:
"     'mode': ['all', ],
"     'mode': ['basic', 'theme', 'local', 'editor', ],
"     'mode': ['basic', 'theme', 'local', 'editor', 'advance'],
"     'mode': ['basic', 'theme', 'local', 'editor', 'admin', 'coder', 'c', 'vimscript', 'script'],
let g:vim_confi_option = {
      \ 'mode': ['basic', 'theme', 'local', 'editor', 'advance', 'admin', 'coder', 'c', 'vimscript', 'script', 'tool'],
      \ 'change_leader': 1,
      \ 'theme': 1,
      \ 'conf': 1,
      \ 'debug': 1,
      \ 'folding': 0,
      \ 'upper_keyfixes': 1,
      \ 'auto_install_vimplug': 1,
      \ 'auto_install_plugs': 1,
      \ 'auto_install_tools': 1,
      \ 'plug_note': 'vim.config',
      \ 'plug_patch': 'vim.config',
      \
      \ 'auto_chdir': 0,
      \ 'auto_restore_cursor': 1,
      \ 'auto_qf_height': 1,
      \
      \ 'keywordprg_filetype': 1,
      \
      \ 'editor_number': 0,
      \}
" =============================================================

if g:vim_confi_option.change_leader
    " Bother when termopen and input space cause a little pause-stop-wait
    let mapleader = "\<Space>"
    let maplocalleader="\<Space>"
    "
    "Bother when in select-mode and use the leader not works, so also provide another leader
    "    Space can be a bit tricky. Why not just map space to <leader>
    "        nmap <space> <leader>
    "    let mapleader = ","
    "nnoremap <Space> <Nop>

    " diable Ex mode
    map Q <Nop>
endif

" Environment {{{1
    " Platform identification {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! CYGWIN()
            return has('win32unix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
        silent function! UNIXLIKE()
            return !WINDOWS()
        endfunction
        silent function! FREEBSD()
          let s:uname = system("uname -s")
          return (match(s:uname, 'FreeBSD') >= 0)
        endfunction

        if LINUX()
              let s:uname = system("uname -a")
        else
              let s:uname = ""
        endif

        silent function! UBUNTU()
            return (match(s:uname, 'Ubuntu') >= 0)
        endfunction
        "Linux localhost.localdomain 3.10.0-957.el7.x86_64 #1 SMP Thu
        "Linux .*.fc29.x86_64 #
        "Linux .el7.x86_64 #
        silent function! CENTOS()
            " echo match("Linux localhost.localdomain 3.10.0-957.el7.x86_64 #1 SMP Thu", 'Linux .*\.el\d\+x86_64 #')
            return (match(s:uname, 'Linux .*\.el\d\+\.') >= 0)
        endfunction
        silent function! FEDORA()
            " echo match("Linux localhost.localdomain 3.10.0-957.el7.x86_64 #1 SMP Thu", 'Linux .*\.el\d\+x86_64 #')
            return (match(s:uname, 'Linux .*\.fc\d\+\.') >= 0)
        endfunction
    " }


    " Basics {
        set nocompatible        " Must be first line
        if UNIXLIKE()
            set shell=/bin/sh

            ":help 'rtp'
            ":help $VIMRUNTIME
            if !empty($VIM)
                let $VIM='/usr/share/nvim'
            endif
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }


    " Debug {
        " This is old style debug, suggest using log style: @note:nvim (~Press 'K'~)
        set verbose=0
        "set verbose=9
        "set verbosefile=/tmp/nvim.log

        let g:decho_enable = 0
        let g:bg_color = 233 | " current background's color value, used by mylog.syntax

        " Old echo type, abandon
        function! Decho(...)
            return
        endfunction
    " }


    " Setup python
    if LINUX()
        let s:uname = system("uname")

        let g:python_host_prog = '/usr/bin/python'
        let g:python3_host_prog = '/usr/bin/python3'

        if s:uname == "Darwin\n"
            let g:python_host_prog='/usr/bin/python'
            let g:python3_host_prog='/usr/bin/python3'
        endif

        " [Using-pyenv](https://github.com/tweekmonster/nvim-python-doctor/wiki/Advanced:-Using-pyenv)
        "   pyenv install 3.6.7
        "   pyenv virtualenv 3.6.7 neovim3
        "   pyenv activate neovim3
        "   pip install neovim
        if !empty(glob($HOME.'/.pyenv/versions/neovim2'))
            let g:python_host_prog = $HOME.'/.pyenv/versions/neovim2/bin/python'
            let g:python3_host_prog = $HOME.'/.pyenv/versions/neovim3/bin/python'
        endif

        " https://github.com/neovim/neovim/issues/2094
        " Test this cause start slow 1~2secs, reproduce by:
        "       $ vi --startuptime /tmp/log.1
        "if !has('python3')
        "    echomsg "AutoInstall: pynvim"
        "    call system("pip3 install --user pynvim")
        "else
        "    call system("pip3 install --user --upgrade pynvim")
        "endif
    endif


    " Plug related:
    function! Cond(cond, ...)
        let opts = get(a:000, 0, {})
        return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
    endfunction

    function! HasIntersect(list1, list2) abort
        let result = copy(a:list1)
        call filter(result, 'index(a:list2, v:val) >= 0')
        return !empty(result)
    endfunction

    function! Mode(mode) abort
        if index(g:vim_confi_option.mode, 'all') >= 0
            return 1
        endif
        return HasIntersect(a:mode, g:vim_confi_option.mode)
    endfunction

    function! CheckPythonModule(name)
        if !executable('python') | return -1 | endif
        let importStr = system("python -c 'import ". a:name. "'")
        if stridx(importStr, 'No module named') >= 0 | return 0 | endif
        return 1
    endfunction

    " @Note only work with 'vim-plug'
    " @param type  0, Have the plug
    "              1, Select the plug
    "              2, Runtime Loaded the plug
    function! CheckPlug(name, type)
        if (exists("g:plugs") && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir))
            if a:type == 0
                return 1
            elseif a:type == 1
                if has_key(g:plugs[a:name], 'on') && empty(g:plugs[a:name]['on'])
                    return 0
                else
                    return 1
                endif
            elseif a:type == 2
                return stridx(&rtp, g:plugs[a:name].dir) >= 0
            endif
        endif
        return 0
    endfunction

    function! PlugGetDir(name)
        if (exists("g:plugs") && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir))
            return g:plugs[a:name].dir
        endif
        return ''
    endfunction


    " @see PlugForce
    function! PlugPatch(info)
        if empty(g:vim_confi_option.plug_patch) | return | endif

        " info is a dictionary with 3 fields
        " - name:   name of the plugin
        " - status: 'installed', 'updated', or 'unchanged'
        " - force:  set on PlugInstall! or PlugUpdate!
        if a:info.status == 'installed' || a:info.force
            !./install.py
        endif
    endfunction


    " Plug Force update with discard local change:
    "   1. git stash after save patch
    "   2. update
    "   3. patch again
    function! PlugForce()
        if !empty(g:vim_confi_option.plug_patch) && CheckPlug(g:vim_confi_option.plug_patch, 1)
            let dir_patch_repo = PlugGetDir(g:vim_confi_option.plug_patch)
            let dir_patch_tmp = dir_patch_repo. "../patch_tmp"
            call system(printf("rm -fr %s && mkdir -p %s", dir_patch_tmp, dir_patch_tmp))
            let dirties = filter(copy(g:plugs),
                  \ {_, v -> len(system(printf("cd %s && git diff --no-ext-diff --name-only", shellescape(v.dir))))})
            if len(dirties)
                call map(copy(dirties),
                      \ {name, v -> system(printf("cd %s && git diff HEAD > %s/%s.patch",
                      \                         shellescape(v.dir),
                      \                         dir_patch_tmp, name))})

                " Add patch to git-repo
                call system(printf("cd %s && rm -fr ./patch && cp -fr %s ./patch && git add ./patch",
                      \         dir_patch_repo, dir_patch_tmp))

                " Discard all local change & update
                call map(values(copy(dirties)),
                      \ {_, v -> system(printf("cd %s && git checkout -f", shellescape(v.dir)))})
                PlugUpdate --sync
                execute 'PlugInstall!' join(keys(dirties))

                " patch backto plugs
                call map(dirties,
                      \ {name, v -> system(printf("cd %s && patch -p1 < %s/%s.patch",
                      \                         shellescape(v.dir),
                      \                         dir_patch_tmp, name))})
                "call system(printf("rm -fr %s", dir_patch_tmp))
                return
            endif
        endif

        PlugUpdate
    endfunction
    command! PlugForce call PlugForce()


" }}}

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }


" Auto download the plug
if g:vim_confi_option.auto_install_vimplug
    if LINUX()
        if empty(glob('~/.vim/autoload/plug.vim'))
            echomsg "AutoInstall: download vim-plug; mkdir .vim,.config/nvim; softlink .vimrc to init.vim"

            call system("curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
            call system("curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")

            call system("touch ~/.vimrc; mkdir ~/.vim; mkdir ~/.config")
            call system("ln -s ~/.vim ~/.config/nvim")
            call system("ln -s ~/.vimrc ~/.config/nvim/init.vim")

            if UBUNTU()
                call system("sudo apt install python3-pip")
                call system("sudo apt install python3-distutils")
            elseif CENTOS() || FEDORA()
                call system("sudo yum install python3-pip")
                call system("sudo yum install python3-distutils")
            endif

            call system("pip3 install --user setuptools")
            call system("pip install --user pynvim")
            call system("pip3 install --user pynvim")

            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        endif
    endif
endif


if g:vim_confi_option.auto_install_tools
    if LINUX()
        " https://github.com/Kuniwak/vint/
        if !CheckPythonModule('vim-vint')
            " https://github.com/mattn/efm-langserver
            " https://github.com/neoclide/coc.nvim/wiki/Language-servers
            " https://github.com/igorshubovych/markdownlint-cli
            "
            echomsg "Installing vim-vint"
            call system("pip install --user vim-vint")
        endif

        if !executable('efm-langserver') && executable('brew')
            echomsg "Installing go,efm-langserver"
            if !executable('go')
                call system("brew install go")
            endif
            call system("go get github.com/mattn/efm-langserver")
        endif
    endif
endif



" Plugins {{{1}}}
call plug#begin('~/.vim/bundle')

" Plugs Global {{{2
    " Disable all plugins's auto-maps
    "let g:no_plugin_maps = 1
"}}}

" Plug setup: Basic-config/Plugs-customize, order-sensible {{{2
    Plug 'tpope/vim-sensible', Cond(Mode(['basic',]))
    "Plug 'huawenyu/vim-basic', Cond(Mode(['basic',]), { 'do': function('PlugPatch')})
    Plug 'huawenyu/vim-basic', Cond(Mode(['basic',]))
    Plug 'huawenyu/vim.config', Cond(Mode(['basic', 'local']))  | " config the plugs
    Plug 'huawenyu/vim.command', Cond(Mode(['basic', 'local']))  | " config the plugs
"}}}

" ColorTheme {{{2
    Plug 'vim-scripts/holokai', Cond(Mode(['theme',]))
    Plug 'NLKNguyen/papercolor-theme', Cond(Mode(['theme',]))  | " set background=light;colorscheme PaperColor
    Plug 'junegunn/seoul256.vim', Cond(Mode(['theme',]))
    "Plug 'tomasr/molokai', Cond(Mode(['theme',]))
    "Plug 'darkspectrum', Cond(Mode(['theme',]))
    "Plug 'dracula/vim', Cond(Mode(['theme',]))
    "Plug 'morhetz/gruvbox', Cond(Mode(['theme',]))
    "Plug 'sjl/badwolf', Cond(Mode(['theme',]))
    "Plug 'jnurmine/Zenburn', Cond(Mode(['theme',]))
    "Plug 'joshdick/onedark.vim', Cond(Mode(['theme',]))
    "Plug 'ryu-blacknd/vim-nucolors', Cond(Mode(['theme',]))
    "Plug 'chriskempson/base16-vim', Cond(Mode(['theme',]))
    "Plug 'Lokaltog/vim-distinguished', Cond(Mode(['theme',]))
    "Plug 'flazz/vim-colorschemes', Cond(Mode(['theme',]))
    "Plug 'nanotech/jellybeans.vim', Cond(Mode(['theme',]))
    "Plug 'huawenyu/color-scheme-holokai-for-vim', Cond(Mode(['theme',]))
"}}}

" Mode {{{2
    " REPL (Read, Eval, Print, Loop) {{{3
    "  - Command Line Tool: https://github.com/BenBrock/reple
        "Plug 'sillybun/vim-repl', Cond(Mode(['coder',]))  | " Not work :REPLToggle
        "Plug 'rhysd/reply.vim', Cond(Mode(['coder',]))
        "Plug 'amiorin/vim-eval', Cond(Mode(['coder',]) && Mode(['vimscript',]))
        "Plug 'fboender/bexec', Cond(Mode(['admin',]))         | " :Bexec
        "Plug 'metakirby5/codi.vim', Cond(Mode(['coder',]))     | " :Codi [filetype]
        "Plug 'axvr/zepl.vim', Cond(Mode(['coder',]))     | " :Repl [filetype]
        Plug 'thinca/vim-quickrun', Cond(Mode(['coder',]))     | " :QuickRun
    "}}}

    " Hex editor {{{3
        " sudo apt install wxHexEditor
        "Plug 'Shougo/vinarise.vim', Cond(Mode(['editor',])) | " Hex viewer, but cannot append to tail
        Plug 'fidian/hexmode', Cond(Mode(['editor',])) | " Hex viewer, wrap of xxd, it's good.
        "Plug 'prettier/vim-prettier', Cond(Mode(['editor',]), { 'do': 'yarn install' })  | " brew install prettier
    "}}}

    " Script {{{3
    " Take current text file as script
        "
    "}}}

    " VimScript {{{3
        Plug 'junegunn/vader.vim', Cond(Mode(['coder',]) && Mode(['vimscript',]))     | " A simple Vimscript test framework
        Plug 'tpope/vim-scriptease', Cond(Mode(['admin',]))   | " A Vim plugin for Vim plugins
        Plug 'mhinz/vim-lookup', Cond(Mode(['coder',]) && Mode(['vimscript',]))

        " Execute eval script: using singlecompile
        Plug 'huawenyu/SingleCompile', Cond(Mode(['admin',]))                     | " :SingleCompile, SingleCompileRun

    "}}}

    " C/Cplus {{{3
        Plug 'wsdjeg/SourceCounter.vim', Cond(Mode(['coder',]))
        "Plug 'aitjcize/cppman', Cond(Mode(['coder',]) && Mode(['c',]))
        "Plug 'vim-utils/vim-man', Cond(Mode(['coder',]) && Mode(['c',]))
        "Plug 'powerman/vim-plugin-viewdoc', Cond(Mode(['coder',]) && Mode(['c',]))          | " work with 'K', and also fix 'cannot find man#open_page()'

        Plug 'huawenyu/c-utils.vim', Cond(Mode(['coder',]) && Mode(['c',]))
        Plug 'octol/vim-cpp-enhanced-highlight', Cond(Mode(['coder',]) && Mode(['c',]))
        Plug 'tenfyzhong/CompleteParameter.vim', Cond(Mode(['coder',]) && Mode(['c',]))
        "Plug 'WolfgangMehner/c-support', Cond(Mode(['coder',]) && Mode(['c',]))            | "[Start Slow]
        "Plug 'tyru/current-func-info.vim', Cond(Mode(['coder',]) && Mode(['c',]))          | "[Bad performance] Show current function name in statusline
        "Plug 'bbchung/Clamp', Cond(Mode(['coder',]) && Mode(['c',]))   | " support C-family code powered by libclang
        "Plug 'apalmer1377/factorus', Cond(Mode(['coder',]) && Mode(['c',]))
        "Plug 'hari-rangarajan/CCTree', Cond(Mode(['coder',]) && Mode(['c',]))
    "}}}

    " Indexer/Tags/cscope {{{3
        " [Tags](https://zhuanlan.zhihu.com/p/36279445)
        " [C++](https://www.zhihu.com/question/47691414/answer/373700711)
        "
        "Plug 'ludovicchabant/vim-gutentags', Cond(Mode(['coder',]))        | " autogen tags, bad performance
            "Plug 'skywind3000/gutentags_plus', Cond(Mode(['coder',]))          | " <leader>c*: cs symbol, cc caller, ct text, ce egrep, ca assign, cz ctags
            "Plug 'huawenyu/vim-autotag', Cond(Mode(['coder',])) | " First should exist tagfile which tell autotag auto-refresh: ctags -f .tags -R .
            "Plug 'huawenyu/vim-preview', Cond(Mode(['coder',]))
            "Plug 'whatot/gtags-cscope.vim', Cond(Mode(['coder',]))

        "Plug 'lyuts/vim-rtags', Cond(Mode(['coder',]))         | " Bad performance
        "Plug 'w0rp/ale', Cond(Mode(['coder',]))   | " 1. Not using clang's lint, 2. find references look not work

        " Please install yarn (-- a node package manger) first.
        " @note:ccls sometimes cause high cpu
        "Plug 'neoclide/coc.nvim', Cond(Mode(['coder',]) && LINUX(), {'branch': 'release'})
            "Plug 'neoclide/coc.nvim', Cond(Mode(['coder',]) && LINUX(), {'do': 'yarn install --frozen-lockfile'})  | " sometimes find references fail
            "Plug 'neoclide/coc.nvim', Cond(Mode(['coder',]) && LINUX(), {'on': ['<Plug>(coc-definition)', '<Plug>(coc-references)'], 'do': 'yarn install --frozen-lockfile'})  | " Increase stable by only load the plugin after the 1st command call.
            "Plug 'neoclide/coc-rls', Cond(Mode(['coder',]) && LINUX())
            " :CocInstall coc-rust-analyzer

        Plug 'liuchengxu/vista.vim', Cond(Mode(['coder',]))    | " tagbar kinds support Language Server Protocol
    "}}}

    " Python {{{3
        " https://github.com/neovim/python-client
        " Install https://github.com/davidhalter/jedi
        " https://github.com/zchee/deoplete-jedi
        "Plug 'neovim/python-client', Cond(Mode(['coder',]) && Mode(['python',]))
        Plug 'python-mode/python-mode', Cond(Mode(['coder',]) && Mode(['python',]), {'for': 'python'})
        Plug 'davidhalter/jedi-vim', Cond(Mode(['coder',]) && Mode(['python',]), {'for': 'python'})
    "}}}

    " LaTeX {{{3
        "Plug 'lervag/vimtex', Cond(Mode(['editor',]) && Mode(['latex',]))  | " A modern vim plugin for editing LaTeX files
    "}}}

    " Perl {{{3
        Plug 'vim-perl/vim-perl', Cond(Mode(['coder',]) && Mode(['perl',]), { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' })
        Plug 'tpope/vim-cucumber', Cond(Mode(['coder',]) && Mode(['perl',]))  | " Auto test framework base on Behaviour Drive Development(BDD)
    "}}}

    " Javascript {{{3
        Plug 'pangloss/vim-javascript', Cond(Mode(['coder',]) && Mode(['javascript',]))
        Plug 'maksimr/vim-jsbeautify', Cond(Mode(['coder',]) && Mode(['javascript',]))
        Plug 'elzr/vim-json', Cond(Mode(['coder',]) && Mode(['javascript',]))

        " https://hackernoon.com/using-neovim-for-javascript-development-4f07c289d862
        Plug 'ternjs/tern_for_vim', Cond(Mode(['coder',]) && Mode(['javascript',]))      | " Tern-based JavaScript editing support.
        Plug 'carlitux/deoplete-ternjs', Cond(Mode(['coder',]) && Mode(['javascript',]))
    "}}}

    " TypeScript {{{3
        Plug 'palantir/tslint', Cond(Mode(['coder',]) && Mode(['typescript',]), { 'for': 'typescript' })
    "}}}

    " Clojure {{{3
        Plug 'tpope/vim-fireplace', Cond(Mode(['coder',]) && Mode(['clojure',]), { 'for': 'clojure' })
    "}}}

    " Database {{{3
        Plug 'tpope/vim-dadbod', Cond(Mode(['coder',]) && Mode(['database',]))       | " :DB mongodb:///test < big_query.js
    "}}}

    " Golang {{{3
        Plug 'fatih/vim-go', Cond(Mode(['coder',]) && Mode(['golang',]))
        Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
    "}}}

    " Tcl {{{3
        "Plug 'LStinson/TclShell-Vim', Cond(Mode(['coder',]) && Mode(['tcl',]))
        "Plug 'vim-scripts/tcl.vim', Cond(Mode(['coder',]) && Mode(['tcl',]))
    "}}}

    " Haskell {{{3
        Plug 'lukerandall/haskellmode-vim', Cond(Mode(['coder',]) && Mode(['haskell',]), {'for': 'haskell'})
        Plug 'eagletmt/ghcmod-vim', Cond(Mode(['coder',]) && Mode(['haskell',]), {'for': 'haskell'})
        Plug 'ujihisa/neco-ghc', Cond(Mode(['coder',]) && Mode(['haskell',]), {'for': 'haskell'})
        Plug 'neovimhaskell/haskell-vim', Cond(Mode(['coder',]) && Mode(['haskell',]), {'for': 'haskell'})
    "}}}

    " Rust {{{3
        Plug 'racer-rust/vim-racer', Cond(Mode(['coder',]) && Mode(['rust',]), {'for': 'rust'})
        Plug 'rust-lang/rust.vim', Cond(Mode(['coder',]) && Mode(['rust',]), {'for': 'rust'})
        Plug 'timonv/vim-cargo', Cond(Mode(['coder',]) && Mode(['rust',]), {'for': 'rust'})
    "}}}

    " Markdown/Writing/Wiki {{{3
    " 1. `mdp`:  PPT-command-line-base, A command-line based markdown presentation tool.  https://github.com/visit1985/mdp
    " 2. `grip`: Render to HTML, But event render not better than vim.  https://github.com/joeyespo/grip
    "
        Plug 'godlygeek/tabular', Cond(Mode(['editor',]), {'for': 'markdown'})  | Plug 'plasticboy/vim-markdown', Cond(Mode(['editor',]), {'for': 'markdown'})
        Plug 'huawenyu/tpope-markdown', Cond(Mode(['editor',]), {'for': 'markdown'} )     | " Fork for use two markdown-plugins together. no pretty code-fence/blocks
        "
        " Set prefix=;
        "   prefix i        Insert/update TOC
        "   prefix I        Load TOC to quickfix
        "   prefix ,        Convert CSV to table
        "   ge              Jump #link
        "   prefix '        Toggle Quote
        "   prefix ln       Toggle Link
        "   prefix /b`s     Toggle italic/bold/code/strike
        " List:
        "   shift+enter     Support multi-line list
        "Plug 'SidOfc/mkdx', Cond(Mode(['editor',]), {'for': 'markdown'})

        "Plug 'vim-pandoc/vim-pandoc', Cond(Mode(['editor',]), {'for': 'markdown'})
        "Plug 'vim-pandoc/vim-pandoc-syntax', Cond(Mode(['editor',]), {'for': 'markdown'})

        Plug 'sotte/presenting.vim', Cond(Mode(['editor',]), {'for': 'markdown'})
        "Plug 'tomtom/vikibase_vim', Cond(Mode(['editor',]), {'for': 'markdown'})

        "Plug 'iamcco/markdown-preview.nvim', Cond(Mode(['editor',]), { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']})
        "Plug 'sindresorhus/github-markdown-css', Cond(Mode(['editor',]), {'for': 'markdown'})

        " Todo/list {{{4
            Plug 'romainl/vim-qf', Cond(Mode(['editor',]))              | " Tame the quickfix window
            "Plug 'tomtom/quickfixsigns_vim', Cond(Mode(['editor',]))
            "Plug 'jceb/vim-editqf', Cond(Mode(['editor',]))            | " when review source

            Plug 'stefandtw/quickfix-reflector.vim', Cond(Mode(['editor',]))    | " Directly edit the quickfix, Refactor code from a quickfix list and makes it editable
            "Plug 'Olical/vim-enmasse', Cond(Mode(['editor',]))  | " Popup another view for our change, Refactor code from a quickfix list and makes it editable

            Plug 'freitass/todo.txt-vim', Cond(Mode(['editor',]))       | " codeblock with 'todo', http://todotxt.org/
            "Plug 'dkarter/bullets.vim', Cond(Mode(['editor',]))       | " Implement by markdown
        "}}}

        " Vimwiki {{{4
            "Plug 'vimwiki/vimwiki', Cond(Mode(['editor',]), { 'branch': 'dev' })  | " Another choice is [Gollum](https://github.com/gollum/gollum)
            "Plug 'mattn/calendar-vim', Cond(Mode(['editor',])) | " :Calendar

            "Plug 'freitass/todo.txt-vim', Cond(Mode(['editor',]))     | " Like todo.txt-cli command-line, but here really needed is the wrap of Todo.txt-cli.
            "Plug 'elentok/todo.vim', Cond(Mode(['editor',]))
            "
            " Require vimwiki, tasklib, [taskwarrior](https://taskwarrior.org/download/)
            " taskwarrior: a command line task management tool, config by ~/.taskrc
            "Plug 'blindFS/vim-taskwarrior', Cond(executable('task') && Mode(['editor',]))

            " Prerequirement: brew install task; sudo pip3 install tasklib; ln -s ~/.task, ~/.taskrc;
            "Plug 'tbabej/taskwiki', Cond(executable('task') && Mode(['editor',]))  | " Only handles *.wiki file contain check lists which beginwith asterisk '*'
            Plug 'huawenyu/vim-notes', Cond(Mode(['editor',])) | Plug 'xolox/vim-misc', Cond(Mode(['editor',]))    | " Use as our plugins help
            Plug 'pbrisbin/vim-mkdir', Cond(Mode(['editor',]))

            Plug 'michal-h21/vim-zettel', Cond(Mode(['editor',])) | " :Note indexer

            "Plug 'asciidoc/asciidoc', Cond(Mode(['editor',])) | " :Notepad
            "Plug 'habamax/vim-asciidoctor', Cond(Mode(['editor',])) | " :Notepad
        "}}}

        " viki {{{4
            "Plug 'tomtom/tlib_vim', Cond(Mode(['editor',]))   | " :VikiMinorMode
            "Plug 'tomtom/vikibase_vim', Cond(Mode(['editor',]))   | " :VikiMinorMode
            "Plug 'tomtom/autolinker_vim', Cond(Mode(['editor',])) | " :Autolinkbuffer
        "}}}
    "}}}

    Plug 'vim-scripts/iptables', Cond(Mode(['admin',]))
    "Plug 'jceb/vim-orgmode', Cond(Mode(['editor',]) && Mode(['note',]))
    "Plug 'tpope/vim-speeddating', Cond(Mode(['editor',]) && Mode(['note',]))
    Plug 'tpope/vim-commentary', Cond(Mode(['editor',]))

    " Session management
    "Plug 'huawenyu/vim-workspace', Cond(Mode(['editor',]))
        "Plug 'thaerkh/vim-workspace', Cond(Mode(['editor',]))
        "Plug 'xolox/vim-session'
        "Plug 'vim-ctrlspace/vim-ctrlspace', Cond(Mode(['editor',]))    | "[Bad performance], confuse
        "Plug 'tpope/vim-obsession' | Plug 'dhruvasagar/vim-prosession' | "[Conflict: cause 'vi -t tag' fail]

"}}}

" Facade {{{2
    Plug 'Raimondi/delimitMate'
    Plug 'millermedeiros/vim-statline'      | " Simple, not annoy to distract our focus
    Plug 'huawenyu/vim-linux-coding-style'
    "Plug 'vim-airline/vim-airline'
    "Plug 'vim-airline/vim-airline-themes'
    "Plug 'MattesGroeger/vim-bookmarks'
    "Plug 'hecal3/vim-leader-guide'
    "Plug 'megaannum/self'
    "Plug 'megaannum/forms'
    "Plug 'mhinz/vim-startify'
    "Plug 'pi314/ime.vim'    | " Chinese input in vim
"}}}

" Syntax/Language {{{2
    Plug 'vim-syntastic/syntastic', Cond(Mode(['editor',]))
    Plug 'Chiel92/vim-autoformat', Cond(Mode(['coder',]))
    Plug 'justinmk/vim-syntax-extra', Cond(Mode(['coder',]) && Mode(['vimscript',]))
    "Plug 'justinmk/vim-dirvish', Cond(Mode(['editor',]))   | " ?
    "Plug 'kovisoft/slimv', Cond(Mode(['editor',]))
    "Plug 'AnsiEsc.vim', Cond(Mode(['editor',]))
    Plug 'powerman/vim-plugin-AnsiEsc', Cond(Mode(['editor',]))
    "Plug 'huawenyu/robotframework-vim', Cond(Mode(['QA',]))
    "Plug 'bpstahlman/txtfmt', Cond(Mode(['editor',]))
    Plug 'tmux-plugins/vim-tmux', Cond(Mode(['editor',]))  | " The syntax of .tmux.conf

    Plug 'vim-scripts/awk.vim', Cond(Mode(['admin',]) && Mode(['script',]))
    "Plug 'WolfgangMehner/vim-support', Cond(Mode(['admin',]) && Mode(['vimscript',]))   | " The syntax of vimscript, but too many keymap
    "Plug 'WolfgangMehner/awk-support', Cond(Mode(['admin',]) && Mode(['script',]))

    "
    " http://www.thegeekstuff.com/2009/02/make-vim-as-your-bash-ide-using-bash-support-plugin/
    " Must config to avoid annoy popup message:
    "   $ cat ~/.vim/templates/bash.templates
    "       SetMacro( 'AUTHOR',      'name' )
    "       SetMacro( 'AUTHORREF',   'name' )
    "       SetMacro( 'EMAIL',       'name@mail.com' )
    "       SetMacro( 'COPYRIGHT',   'Copyright (c) |YEAR|, |AUTHOR|' )
    "Plug 'WolfgangMehner/bash-support', Cond(Mode(['admin',]) && Mode(['script',]))
    "Plug 'vim-scripts/DirDiff.vim', Cond(Mode(['editor',]))
    Plug 'rickhowe/diffchar.vim', Cond(Mode(['editor',]))
    Plug 'chrisbra/vim-diff-enhanced', Cond(Mode(['editor',])) | " vimdiff:  ]c - next;  [c - previous; do - diff obtain; dp - diff put; zo - unfold; zc - fold; :diffupdate - re-scan
    Plug 'huawenyu/vim-log-syntax', Cond(Mode(['editor',]))
"}}}

" Improve {{{2
    " Basic {{{3
        Plug 'junegunn/fzf', Cond(Mode(['editor',]) && Mode(['advance',]), { 'dir': '~/.fzf', 'do': './install --all' })
        Plug 'junegunn/fzf.vim', Cond(Mode(['editor',]) && Mode(['advance',]) && CheckPlug('fzf', 1))
        " Tmux layout scripting made easy, Heytmux requires Ruby 2.0+ and tmux 2.3+.
        Plug 'junegunn/heytmux', Cond(Mode(['editor',]) && Mode(['advance',]), { 'do': 'gem install heytmux' })     | " Shell: $ heytmux workspace.yml
    "}}}

    " Search {{{3
        " [Create float-windows](https://kassioborges.dev/2019/04/10/neovim-fzf-with-a-floating-window.html)
        Plug 'huawenyu/fzf-cscope.vim', Cond(Mode(['coder',]) && Mode(['advance',]))

        "Plug 'huawenyu/neovim-fuzzy', Cond(has('nvim') && Mode(['editor',]))
        "Plug 'Dkendal/fzy-vim', Cond(Mode(['editor',]))

        " http://blog.owen.cymru/fzf-ripgrep-navigate-with-bash-faster-than-ever-before
        "Plug 'ctrlpvim/ctrlp.vim', Cond(Mode(['editor',]) && Mode(['todo',]))
            "Plug 'nixprime/cpsm', Cond(Mode(['editor',]), {'do': 'env PY3=ON ./install.sh'})
            "Plug 'ryanoasis/vim-devicons', Cond(Mode(['editor',]) && Mode(['morecool',]))

        Plug 'mhinz/vim-grepper', Cond(Mode(['editor',]))    | " :Grepper text
    "}}}

    Plug 'sunaku/vim-shortcut', Cond(Mode(['editor',]))         | " ';;' Popup shortcut help, but don't execute
    Plug 'liuchengxu/vim-which-key', Cond(Mode(['editor',]), { 'on': ['WhichKey', 'WhichKey!'] })   | " Cannot work
    "Plug 'lambdalisue/lista.nvim', Cond(Mode(['editor',]))     | " Cannot work
    "Plug 'markonm/traces.vim', Cond(Mode(['editor',]))         | " Range, pattern and substitute preview for Vim [Just worry about performance]

    "Plug 'derekwyatt/vim-fswitch', Cond(Mode(['editor',]))
    Plug 'kopischke/vim-fetch', Cond(Mode(['editor',]))
    Plug 'terryma/vim-expand-region', Cond(Mode(['editor',]))   | "   W - select region expand; B - shrink

    " http://www.futurile.net/2016/03/19/vim-surround-plugin-tutorial/
    "   <command><(s)urroundMode>[count]<surround-target>[replacement]
    "       <command>: (d)elete, (c)hange, vi(S)ual, (y)add
    "
    "       <surround-object>: sS -- cS(new-line), yS<motion><addition>
    "       <surround-target>: (<[{'"`<b> <word><sentence><paragrph>      -- the add/delete str,
    "                          barB    t   w     s         p
    "       [replacement]:     '"(                  -- only require under (c)hange/(y)add mode
    " Sample:
    "   ds"         -- remove "
    "   dst         -- remove <tag>
    "   ds( | dsb   -- remove ()
    "
    "   cs<surround target><replacement>:
    "       cs"'        -- change from " to '
    "       cS'<p>      -- change from ' to <p>, also put then end '</p>' into new-line
    "
    "   ys<motion|text-object><addition>:
    "       ys$"        -- wrap by " from cur to <end>
    "       ys3wb       -- wrap by ) from cur to 3w
    "
    "    +yss<addition>: wrap current line
    "       yssB        -- wrap by { of current line
    "
    "   yS<motion><addition>:
    "       ySf"t       -- wrap by <tag> from cur to (f)ound "
    "    +ySS<addition>: Whole line and do the above/after
    "       ySSb        -- add () into two-lines
    "   vS<surround target>:
    "       viwS*       -- *<word>*
    "       Shift-v+S<p>-- <p>
    "                      <selected>
    "                      </p>
    "       Ctrl-v+S<li>-- <li>item 1</li>
    "                      <li>item 2</li>
    "   (S)elected:
    "       <Selected>S"-- wrap by " of selected-text
    "
    Plug 'tpope/vim-surround', Cond(Mode(['editor',]))         | " Help add/remove surround
    Plug 'tpope/vim-endwise', Cond(Mode(['editor',]))          | " smart insert certain end structures automatically.
    Plug 'tpope/vim-rsi', Cond(Mode(['admin',]))               | " Readline shortcut for vim

    "Plug 'nathanaelkane/vim-indent-guides', Cond(Mode(['editor',]) && Mode(['advance',])) | "[Color issue]
    "Plug 'huawenyu/vim-indentwise', Cond(Mode(['editor',]))    | " Automatic set indent, shiftwidth, expandtab
    "Plug 'ciaranm/detectindent', Cond(Mode(['editor',]))       | " Seems abandon
    "Plug 'roryokane/detectindent', Cond(Mode(['editor',]))
    "Plug 'tpope/vim-sleuth', Cond(Mode(['editor',]))            | " Behaviour wield
    Plug 'Chiel92/vim-autoformat', Cond(Mode(['editor',]))

    "Plug 'szw/vim-maximizer', Cond(Mode(['editor',]))          | " Can't restore windows after complex operate
    "Plug 'ervandew/maximize', Cond(Mode(['editor',]))          | " Cannot max the quickfix windows
    Plug 'dhruvasagar/vim-zoom', Cond(Mode(['editor',]))        | " nmap <a-w>    <Plug>(zoom-toggle)

    Plug 'huawenyu/vim-mark', Cond(Mode(['editor',]))
    "Plug 'tomtom/tmarks_vim', Cond(Mode(['editor',]))
    "Plug 'tomtom/vimform_vim', Cond(Mode(['editor',]))
    "Plug 'huawenyu/highlight.vim', Cond(Mode(['editor',]))
    Plug 'huawenyu/vim-signature', Cond(Mode(['editor',]))      | " place, toggle and display marks

    " CommandLine {{{3
        Plug 'houtsnip/vim-emacscommandline', Cond(Mode(['editor',]))   | " Improve command line shortcut like bash
        " Ctl-a  begin; Ctl-e  end; Ctl-f/b  forward/backward
    "}}}

    " Quickfix {{{3
        Plug 'romainl/vim-qf', Cond(Mode(['editor',]))              | " Tame the quickfix window
        "Plug 'tomtom/quickfixsigns_vim', Cond(Mode(['editor',]))
        "Plug 'jceb/vim-editqf', Cond(Mode(['editor',]))            | " when review source

        Plug 'stefandtw/quickfix-reflector.vim', Cond(Mode(['editor',]))    | " Directly edit the quickfix, Refactor code from a quickfix list and makes it editable
        "Plug 'Olical/vim-enmasse', Cond(Mode(['editor',]))  | " Popup another view for our change, Refactor code from a quickfix list and makes it editable
    "}}}

    " Motion {{{3
        "Plug 'justinmk/vim-sneak', Cond(Mode(['editor',]))    | " s + prefix-2-char to choose the words
        Plug 'easymotion/vim-easymotion', Cond(Mode(['editor',]))
        Plug 'tpope/vim-abolish', Cond(Mode(['editor',]))      | " :Subvert/child{,ren}/adult{,s}/g

        " 1. Rename a var:  search the var -> cgn -> change-it -> .(repeat-it-whole)
        Plug 'tpope/vim-repeat', Cond(Mode(['editor',]))
            " gA                   shows the four representations of the number under the cursor.
            " crd, crx, cro, crb   convert the number under the cursor to decimal, hex, octal, binary, respectively.
            Plug 'glts/vim-radical', Cond(Mode(['editor',]))
            Plug 'glts/vim-magnum', Cond(Mode(['editor',]))
        "Plug 'vim-utils/vim-vertical-move', Cond(Mode(['editor',]))
        "Plug 'rhysd/accelerated-jk', Cond(Mode(['editor',]))   | " Cause h/j cannot move If sometimes not load the plug
        "Plug 'unblevable/quick-scope', Cond(Mode(['editor',]))
        "Plug 'dbakker/vim-paragraph-motion', Cond(Mode(['editor',])) | " treat whitespace only lines as paragraph breaks so { and } will jump to them
        "Plug 'vim-scripts/Improved-paragraph-motion', Cond(Mode(['editor',]))
        Plug 'christoomey/vim-tmux-navigator', Cond(Mode(['editor',]))
        Plug 'rhysd/clever-f.vim', Cond(Mode(['editor',]))   | " Using 'f' to repeat, and also we can release ';' as our new map leader

        Plug 'huawenyu/vim-motion', Cond(Mode(['editor',]))  | " Jump according indent
        " @Devote: https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
        "Plug 'terryma/vim-multiple-cursors', Cond(Mode(['editor',]))  | " Don't really need it
    "}}}

    " Tools {{{3
        Plug 'tpope/vim-eunuch', Cond(Mode(['admin',]))  | " Support unix shell cmd: Delete,Unlink,Move,Rename,Chmod,Mkdir,Cfind,Clocate,Lfind,Wall,SudoWrite,SudoEdit
        Plug 'tpope/vim-dotenv', Cond(Mode(['admin',]))  | " Basic support for .env and Procfile
        Plug 'kassio/neoterm', Cond(Mode(['admin',]) && has('nvim'))        | " a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>

        Plug 'vim-scripts/DrawIt', Cond(Mode(['editor',]))                       | " \di \ds: start/stop;  draw by direction-key
        Plug 'reedes/vim-pencil', Cond(Mode(['editor',]))                        | "
        "Plug 'gyim/vim-boxdraw', Cond(Mode(['editor',]))                        | " Performance issue
        Plug 'sk1418/blockit', Cond(Mode(['editor',]))                           | " :Block -- Draw a Box around text region
        Plug 'chrisbra/NrrwRgn', Cond(Mode(['editor',]))                         | " focus on a selected region. <leader>nr :NR - Open selected into new window; :w - (in the new window) write the changes back
        Plug 'junegunn/vim-easy-align', Cond(Mode(['editor',]))                  | " tablize selected and ga=
        "Plug 'webdevel/tabulous', Cond(Mode(['editor',]))                       | " draw table
        Plug 'dhruvasagar/vim-table-mode', Cond(Mode(['editor',]))               | " <leader>tm :TableModeToggle
        Plug 'junegunn/goyo.vim', Cond(Mode(['editor',]))                        | " :Goyo 80
        "Plug 'junegunn/limelight.vim', Cond(Mode(['editor',]))                  | " Unsupport colorscheme
        Plug 'jamessan/vim-gnupg', Cond(Mode(['admin',]))                        | " implements transparent editing of gpg encrypted files.
        Plug 'FooSoft/vim-argwrap', Cond(Mode(['coder',]))                       | " an argument wrapping and unwrapping
    "}}}
"}}}

" Project/struct/test/make {{{2
    Plug 'tpope/vim-projectionist', Cond(Mode(['editor',]))      | " MVC like project, used when our project have some fixed struct map rule
    Plug 'c-brenn/fuzzy-projectionist.vim', Cond(Mode(['editor',]))     | " Change the prefixChar from E to F, we can get fuzzy feature
    "Plug 'vim-test/vim-test', Cond(Mode(['editor',]))            | " Help us running tests

    " Async {{{3
        Plug 'tpope/vim-dispatch', Cond(Mode(['admin',]))
        "Plug 'huawenyu/vim-dispatch', Cond(Mode(['admin',]))        | " Run every thing. :Dispatch :Make :Start man 3 printf
        "Plug 'radenling/vim-dispatch-neovim', Cond(has('nvim') && Mode(['admin',]))

        Plug 'Shougo/vimproc.vim', Cond(Mode(['admin',]), {'do' : 'make'})
        Plug 'skywind3000/asyncrun.vim', Cond(Mode(['admin',]))
        Plug 'huawenyu/neomake', Cond(has('nvim') && Mode(['coder',]))
        "Plug 'neomake/neomake', Cond(has('nvim') && Mode(['coder',]))
        "Plug 'vhdirk/vim-cmake', Cond(has('nvim') && Mode(['coder',]))
        "Plug 'cdelledonne/vim-cmake', Cond(has('nvim') && Mode(['coder',]))
        Plug 'nickhutchinson/vim-cmake-syntax', Cond(has('nvim') && Mode(['coder',]))

        "Plug 'liuchengxu/vim-clap', Cond(has('nvim') && Mode(['coder',]))
        "Plug 'voldikss/vim-floaterm', Cond(has('nvim') && Mode(['admin',]))
    "}}}

    " File/Explore {{{3
        "Plug 'justinmk/vim-dirvish'

        Plug 'preservim/nerdtree', Cond(Mode(['editor',]), { 'on':  ['NERDTreeToggle', 'NERDTreeTabsToggle'] })   | " :NERDTreeToggle; <Enter> open-file; '?' Help, and remap 'M' as menu
        Plug 'jistr/vim-nerdtree-tabs', Cond(Mode(['editor',]), { 'on':  'NERDTreeTabsToggle' })   | " :NERDTreeTabsToggle, Just one NERDTree, always and ever. It will always look the same in all tabs, including expanded/collapsed nodes, scroll position etc.
        "Plug 'scrooloose/nerdcommenter', Cond(Mode(['editor',]), { 'on':  ['NERDTreeToggle', 'NERDTreeTabsToggle'] })
        "Plug 'Xuyuanp/nerdtree-git-plugin', Cond(Mode(['editor',]), { 'on':  ['NERDTreeToggle', 'NERDTreeTabsToggle'] })
        "Plug 'jeetsukumaran/vim-buffergator', Cond(Mode(['editor',]))
        "Plug 'huawenyu/vim-rooter', Cond(Mode(['editor',]))  | " Get or change current dir

        "Plug 'tpope/vim-vinegar', Cond(Mode(['editor',]))   | " '-' open explore
        "Plug 'mcchrish/nnn.vim', Cond(Mode(['editor',]))   | " Require: brew install nnn;

        " Plugin 'defx' {{{4
        if has('nvim')
            Plug 'Shougo/defx.nvim', Cond(Mode(['editor',]), { 'do': ':UpdateRemotePlugins' })
        else
            Plug 'Shougo/defx.nvim', Cond(Mode(['editor',]))
            Plug 'roxma/nvim-yarp', Cond(Mode(['editor',]))
            Plug 'roxma/vim-hug-neovim-rpc', Cond(Mode(['editor',]))
        endif
        Plug 'kristijanhusak/defx-git', Cond(Mode(['editor',]))
        Plug 'kristijanhusak/defx-icons', Cond(Mode(['editor',]))

    "}}}

    " View/Outline/Context {{{3
        " VOom support +python3, :Voomhelp,
        "   yy      Copy node(s).
        "   dd      Cut node(s).
        "   pp      Paste node(s) after the current node or fold.
        "   <Space>            Expand/contract the current node
        "   ^^, __, <<, >>     Move up/down, left, right the select nodes
        Plug 'huawenyu/VOoM', Cond(Mode(['editor',])) 
        Plug 'vim-voom/VOoM_extras', Cond(Mode(['editor',]))

        " Why search tags from the current file path:
        "   consider in new-dir open old-dir's file, bang!
        Plug 'vim-scripts/taglist.vim', Cond(Mode(['coder',]) && LINUX())
        Plug 'majutsushi/tagbar', Cond(Mode(['coder',]))
        "Plug 'tomtom/ttags_vim', Cond(Mode(['coder',]))
        "Plug 'wellle/context.vim', Cond(Mode(['coder',]))  | " performance issue: show code function-name/while/for as context
    "}}}

"}}}

" GUI/Mode {{{2
    "Plug 'kana/vim-submode', Cond(Mode(['editor',]) && !has('nvim'))       | " Create new 'modes', but neovim can't use it.
        "Plug 'dstein64/vim-win', Cond(Mode(['editor',]))                  | " Enter vim-win mode with <leader>w or :Win, then Press <esc> to leave vim-win, help ?
    "Plug 'Iron-E/nvim-libmodal', Cond(Mode(['editor',]) && has('nvim'))    | " Create new 'modes'

    "Plug 'itchyny/lightline.vim'       | " A light and configurable statusline/tabline
    "
    " Show Indent level vertical line
    "Plug 'Yggdroot/indentLine'
    "Plug 'nathanaelkane/vim-indent-guides'
    "
    "Plug 'kien/tabman.vim', Cond(Mode(['editor',]))        | " Tab management for Vim
    "Plug 'gcmt/taboo.vim', Cond(Mode(['editor',]))
    Plug 'huawenyu/vim-tabber', Cond(Mode(['editor',]))        | " Tab management for Vim: the orig-version have no commands

    " Gen menu
    Plug 'skywind3000/vim-quickui', Cond(Mode(['editor',]))      | " customize menu
    "Plug 'skywind3000/quickmenu.vim', Cond(Mode(['editor',]))   | " customize menu from size pane
    "Plug 'Timoses/vim-venu', Cond(Mode(['editor',]))            | " :VenuPrint, customize menu from command-line

"}}}

" Integration {{{2
    " gdb front-end by vim {{{3
        " version@1
        "Plug 'huawenyu/neogdb.vim', Cond(Mode(['coder',]) && has('nvim'))
        " version@2
        "Plug 'huawenyu/neogdb2.vim', Cond(Mode(['coder',]) && has('nvim')) | Plug 'kassio/neoterm', Cond(Mode(['editor',]) && has('nvim')) | Plug 'paroxayte/vwm.vim', Cond(Mode(['editor',]) && has('nvim'))
        if $debugger == 'vimspector'
            " version@5: choose new gdb from command-line:
            "   https://puremourning.github.io/vimspector/configuration.html#remote-debugging-support
            "   https://www.cnblogs.com/kongj/p/12831690.html
            "   ###vim --cmd 'let vimgdb=0 | let vimspector=1'
            Plug 'puremourning/vimspector', Cond(Mode(['coder',]))   | " Best debugger for vim/neovim
        elseif $debugger == 'nvim-gdb'
            Plug 'sakhnik/nvim-gdb', Cond(Mode(['coder',]) && has('nvim'))
        elseif $debugger == 'new.vim'
            " version@3
            Plug 'huawenyu/new.vim', Cond(Mode(['coder',]) && has('nvim')) | Plug 'huawenyu/new-gdb.vim', Cond(Mode(['coder',]) && has('nvim'))  | " New GUI gdb-frontend
        else
            " version@4:
            "   vim <file>
            Plug 'huawenyu/vimgdb', Cond(Mode(['coder',]) && has('nvim'))   | " Base on Tmux + neovim, don't want struggle with neovim.terminal, layout by Tmux
        endif


    "Plug 'cpiger/NeoDebug', Cond(Mode(['coder',]) && has('nvim'), {'on': 'NeoDebug'})
    "Plug 'idanarye/vim-vebugger', Cond(Mode(['coder',]))
    "Plug 'LucHermitte/lh-vim-lib', Cond(Mode(['admin',]))
    " NVIM_LISTEN_ADDRESS=/tmp/nvim.gdb vi

    Plug 'rhysd/conflict-marker.vim', Cond(Mode(['coder',]))            | " [x and ]x jump conflict, `ct` for themselves, `co` for ourselves, `cn` for none and `cb` for both.
    Plug 'ericcurtin/CurtineIncSw.vim', Cond(Mode(['coder',]))          | " Toggle source/header
    Plug 'junkblocker/patchreview-vim', Cond(Mode(['coder',]))          | " :PatchReview some.patch
    "Plug 'cohama/agit.vim', Cond(Mode(['editor',]))    | " :Agit show git log like gitk
    "Plug 'codeindulgence/vim-tig', Cond(Mode(['editor',])) | " Using tig in neovim
    Plug 'iberianpig/tig-explorer.vim', Cond(Mode(['editor',])) | Plug 'rbgrouleff/bclose.vim', Cond(Mode(['editor',]))        | " tig for vim (https://github.com/jonas/tig): should install tig first.
    Plug 'tpope/vim-fugitive', Cond(Mode(['editor',]))   | " Gdiff, Gblame, or from shell 'git dt' to code view
        Plug 'junegunn/gv.vim', Cond(Mode(['editor',]))  | " Awesome git wrapper
        "Plug 'airblade/vim-gitgutter'        | " Shows a git diff in the gutter (sign column)
        "Plug 'rbong/vim-flog', Cond(Mode(['editor',]))  | " Almose same as plug-GV, git branch viewer

    "Plug 'juneedahamed/svnj.vim', Cond(Mode(['editor',]))
    "Plug 'juneedahamed/vc.vim', Cond(Mode(['editor',]))        | " Bad performance: Support git, svn, ...
    "Plug 'vim-scripts/vcscommand.vim', Cond(Mode(['editor',])) | " Bad performance: CVS, SVN, SVK, git, bzr, and hg within VIM
    "Plug 'sjl/gundo.vim', Cond(Mode(['editor',]))              | " Looks no use
    Plug 'mattn/webapi-vim', Cond(Mode(['editor',]))            | " Looks no use
    Plug 'mattn/gist-vim', Cond(Mode(['editor',]))              | " :'<,'>Gist -e 'list-sample'
    "Plug 'kkoomen/vim-doge', Cond(Mode(['editor',]), { 'do': { -> doge#install() } })   | " Looks not work, Document Generate

    " share copy/paste between vim(""p)/tmux
    "Plug 'svermeulen/vim-easyclip', Cond(Mode(['editor',]))  | " change to vim-yoink, similiar: nvim-miniyank, YankRing.vim, vim-yankstack
    "Plug 'bfredl/nvim-miniyank', Cond(Mode(['editor',]))
    "Plug 'svermeulen/vim-yoink', Cond(Mode(['editor',]) && has('nvim')) | " sometimes delete not copyinto paste's buffer

    "Plug 'huawenyu/vimux-script', Cond(Mode(['admin',]) && has('nvim'))
    "Plug 'huawenyu/vim-tmux-runner', Cond(Mode(['admin',]) && has('nvim'))
    Plug 'huawenyu/vim-tmux-runner', Cond(Mode(['admin',]) && has('nvim'), { 'on':  ['VtrLoad', 'VtrSendCommandToRunner', 'VtrSendLinesToRunner', 'VtrSendFile', 'VtrOpenRunner'] })   | " Send command to tmux's marked pane
    Plug 'yuratomo/w3m.vim', Cond(executable('w3m') && Mode(['admin',]) && Mode(['tool',]))
    Plug 'szw/vim-dict', Cond(Mode(['editor',]) && Mode(['tool',]))
    Plug 'szw/vim-g', Cond(Mode(['editor',]) && Mode(['tool',]))
    "Plug 'google/vim-searchindex', Cond(Mode(['editor',]) && Mode(['tool',]))
    Plug 'ianva/vim-youdao-translater', Cond(Mode(['editor',]) && Mode(['tool',]))  | " Youdao dictionay
"}}}

" Completion {{{2
    "Plug 'ervandew/supertab', Cond(Mode(['editor',]))
    "Plug 'Shougo/denite.nvim', Cond(Mode(['editor',]))
    "Plug 'ycm-core/YouCompleteMe', Cond(Mode(['editor',]))

    Plug 'Shougo/deoplete.nvim', Cond(Mode(['editor',]) && has('nvim'))         | "{ 'do': ':UpdateRemotePlugins' }
    Plug 'Shougo/neosnippet.vim', Cond(Mode(['editor',]) && has('nvim'))        | " c-k apply code, c-n next, c-p previous, :NeoSnippetEdit
    Plug 'Shougo/neosnippet-snippets', Cond(Mode(['editor',]) && has('nvim'))
    Plug 'huawenyu/vim-snippets.local', Cond(Mode(['editor',]) && has('nvim'))

    "Plug 'ncm2/ncm2', Cond(Mode(['editor',]) && has('nvim'))                   | " Compare to deoplete, it's slower
    "Plug 'SirVer/ultisnips', Cond(Mode(['editor',]))
    Plug 'honza/vim-snippets', Cond(Mode(['editor',]))

    Plug 'reedes/vim-wordy', Cond(Mode(['editor',]))
    "Plug 'vim-scripts/CmdlineComplete', Cond(Mode(['admin',]) && has('nvim'))
    "Plug 'vim-scripts/AutoComplPop', Cond(Mode(['editor',]))  | " Looks already implement by deoplete or other plug

"}}}

" Text Objects {{{2, https://github.com/kana/vim-textobj-user/wiki
    " vimwiki                               vah
    Plug 'wellle/targets.vim', Cond(Mode(['editor',]))           | " Support build-in obj number-repeat/`n`ext/`l`ast: quota `,`, comma `,`, `(` as n

    Plug 'kana/vim-textobj-user', Cond(Mode(['editor',]))
    "Plug 'kana/vim-repeat', Cond(Mode(['editor',]))

    "Plug 'kana/vim-textobj-indent', Cond(Mode(['editor',]))            | " vai, vaI
    Plug 'michaeljsmith/vim-indent-object', Cond(Mode(['editor',]))     | " <count>ai, aI, ii, iI
    Plug 'glts/vim-textobj-indblock', Cond(Mode(['editor',]))           | " vao, Select a block of indentation whitespace before ascii

    Plug 'kana/vim-textobj-entire', Cond(Mode(['editor',]))             | " vae, Select entire buffer
    Plug 'kana/vim-textobj-function', Cond(Mode(['coder',]))            | " vaf, Support: c, java, vimscript
    " Plug 'machakann/vim-textobj-functioncall', Cond(Mode(['coder',]))

    Plug 'mattn/vim-textobj-url', Cond(Mode(['editor',]))               | " vau
    Plug 'kana/vim-textobj-diff', Cond(Mode(['coder',]))                | " vdh, hunk;  vdH, file;  vdf, file
    " Plug 'thalesmello/vim-textobj-methodcall', Cond(Mode(['coder',]))
    " Plug 'adriaanzon/vim-textobj-matchit', Cond(Mode(['editor',]))
    Plug 'glts/vim-textobj-comment', Cond(Mode(['coder',]))             | " vac, vic
    Plug 'thinca/vim-textobj-between', Cond(Mode(['editor',]))          | " vaf
    Plug 'Julian/vim-textobj-brace', Cond(Mode(['editor',]))            | " vaj
    Plug 'whatyouhide/vim-textobj-xmlattr', Cond(Mode(['coder',]))      | " vax
"}}}

" ThirdpartLibrary {{{2
    Plug 'vim-jp/vital.vim'
        " @note:promise
    "Plug 'google/vim-maktaba'
    Plug 'tomtom/tlib_vim', Cond(Mode(['coder',]) && Mode(['vimscript',]))
"}}}

" Debug {{{2
    "Plug 'vim-utils/vim-man', Cond(Mode(['admin',]))
    Plug 'gu-fan/doctest.vim', Cond(Mode(['admin',]))     | " doctest for language vimscript, :DocTest
        "Plug 'thinca/vim-ref', Cond(Mode(['editor',]) && Mode(['tool',]))   |"[Not good] Man with 'K', should after vim-scriptease to override 'K' map
    Plug 'huawenyu/vimlogger', Cond(Mode(['admin',]))
    "Plug 'vim-scripts/TailMinusF', Cond(Mode(['admin',])) | " Too slow, :Tail <file>
    "Plug 'tyru/restart.vim', Cond(Mode(['editor',]))       | " Not work under terminal
    "Plug 'huawenyu/Decho', Cond(Mode(['coder',]) && Mode(['vimscript',]))
    "Plug 'c9s/vim-dev-plugin', Cond(Mode(['coder',]) && Mode(['vimscript',]))   | " gf: goto-function-define, but when edit vimrc will trigger error
"}}}

call plug#end()


" Keymap fzf {{{2
" If don't source it directly, looks this plugin not works.
if CheckPlug('vim-shortcut', 1)
    " Shortcut! keys description
    let thedir = PlugGetDir('vim-shortcut')
    exec "source ". thedir. "plugin/shortcut.vim"

    Shortcut! ;;    Show Shortcuts
endif


if g:vim_confi_option.debug
    silent! call logger#init('ALL', ['/dev/stdout', '/tmp/vim.log'])

    " 1. Init: Put these in the header of your script file.
    "if !exists("s:init")
    "    let s:init = 1
    "    silent! let s:log = logger#getLogger(expand('<sfile>:t'))
    "endif
    "
    " 2. Use:
    "silent! call s:log.debug("test=", var)
    "
    " 3. View log
    " $ tail -f /tmp/vim.log
endif


" END-setting {{{1
    " Only here works {{{2
        augroup ugly_set
            autocmd!
            autocmd BufEnter * call cscope#LoadCscope()
            autocmd BufEnter * set nolazyredraw lazyredraw
            autocmd BufEnter * redraw!

            autocmd BufRead,BufNewFile * setlocal signcolumn=yes
            autocmd FileType tagbar,nerdtree,voomtree,qf setlocal signcolumn=no
        augroup end
    "}}}

    " reset to sure scroll perfermance {{{2
    " https://stackoverflow.com/questions/307148/vim-scrolling-slowly
    " https://eduncan911.com/software/fix-slow-scrolling-in-vim-and-neovim.html
        set ttyfast
        set nocul
        set synmaxcol=128
        syntax sync minlines=256
    "}}}
"}}}

if filereadable(expand("~/.vimrc.after"))
    source ~/.vimrc.after
endif

let g:neobugger_local_backtrace = 1
let g:neobugger_local_breakpoint = 1

