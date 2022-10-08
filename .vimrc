" vim: set expandtab: set tabstop=4: set shiftwidth=4: set softtabstop=4:
" =============================================================
" TryIt:
" - vim --clean         Startup vim without any config/plug
" - <Space>             Is the leader
" - Press ';;'          Top-outline of shortcuts, search 'silent! Shortcut!' in ~/.vim/bundle
" - Press 'H'           on topic word with the '?' sign (by cheat?)
" - Maps desc(which-key.nvim)   Search '<c-U>' in ~/.vim/bundle
"
" - Troubleshooting:
" -------------
"   - Enable log:   let g:vim_confi_option.debug = 1
"   - Check log:    (LinuxPC) $ tail -f /tmp/vim.log
"   - Reload a plugin:    :PlugUpdate deoplete.nvim
"
" Install:  help 'H' on the topic
" - [Debian]
"     $ wget --no-check-certificate -O ~/.vimrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
"     $ curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"     #$ sudo add-apt-repository ppa:neovim-ppa/unstable -y
"     $ sudo add-apt-repository ppa:neovim-ppa/stable -y
"     $ sudo apt-get install neovim
"     $ sudo update-alternatives --config vi
"     $ sudo update-alternatives --config vim
"
"     ### .vimrc as Config [Reference: vi -c 'help nvim-from-vim']
"         ### oneline version
"         $ mkdir -p ~/.vim && rm -fr ~/.vim/init.vim && ln -s ~/.vimrc ~/.vim/init.vim && mkdir -p ~/.config && rm -fr ~/.config/nvim && ln -s ~/.vim ~/.config/nvim
"
"         ### Split into multiple lines
"         $ mkdir ~/.vim
"         $ ln -s ~/.vimrc ~/.vim/init.vim
"         $ mkdir ~/.config
"         $ ln -s ~/.vim ~/.config/nvim
"
"     $ vi -c 'PlugInstall'
"
" - [Optional] - other config/tool
"     zshrc -- Simpler zshrc for oh-my-zsh
"       $ sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
"       $ wget --no-check-certificate -O ~/.zshrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.zshrc
"     tmux.conf -- Simpler zshrc for oh-my-zsh
"       $ wget --no-check-certificate -O ~/.tmux.conf https://raw.githubusercontent.com/huawenyu/dotfiles/master/.tmux.conf
"
" Customize:
"   ~/.vimrc.before     " Set variable before plugin load
"   ~/.vimrc.after      " Finally re-change keymap
"
"   For example,
"   $ cat ~/.vimrc.before
"       let mylocal_vim_confi = {
"             \ 'debug': 1,
"             \
"             \ 'auto_chdir': 1,
"             \
"             \ 'view_folding': 1,
"             \ 'show_number': 1,
"             \ 'wrapline': 1,
"             \ 'indentline': 1,
"             \
"             \ 'fzf_files': ['~/mywiki',],
"             \ 'fzf_notes': ['~/mywiki',],
"             \}
"       let g:vim_confi_option = extend(g:vim_confi_option, mylocal_vim_confi)
"
"
" Help:(press 'H' on the words, or list all wiki, and builtin tutor commands ":vimtutor" for vim, ":Tutor" for neovim)
" require-plug(vim-floaterm/vim-basic/vim.config
"
" - vim-tutor?
" - latest-neovim?
" - vi-to-neovim?
" - windows-install?
" - checkhealth?
" - vim-more?
" - troubleshooting? (Find which script change the config, howto enable debug log)
" - vim-config?
" - vim-search?
" - vimscript?
" - vim-fold?
" - vim-lsp? (Nvim built-in supports the Language Server Protocol)
" - quickfix?
" =============================================================
"  Mode:
"  Support set from env's variable, like: mode=basic vi ~/.vimrc
"
"  - config: conf-basic, conf-local, conf-extra,
"  - addon:  snippet, tool, admin, theme, plugin, extra, library, git, hub
"  - role:   basic, editor, writer, coder
"    - coder-language: c, markdown, script, python, javascript
"
"
"                         ┌──────┐
"                     ┌──►│writer│
"  ┌─────┐  ┌──────┐  │   └──────┘
"  │basic│─►│editor│──┤
"  └─────┘  └──────┘  │   ┌──────┐
"                     └──►│coder │
"                         └──────┘
"               ┌──────┐
"               │config│
"               └──┬───┘
"          ┌───────┼─────────┐
"          ▼       ▼         ▼
"       ┌─────┐  ┌─────┐  ┌─────┐
"       │basic│  │local│  │extra│
"       └─────┘  └─────┘  └─────┘
"
"               ┌──────┐
"               │addon │
"               └──┬───┘
"      ┌───────┬───┴─────┬────────┬──────────┐
"      ▼       ▼         ▼        ▼          ▼
"   ┌─────┐  ┌─────┐  ┌─────┐  ┌───────┐  ┌──────┐
"   │theme│  │tool │  │admin│  │snippet│  │plugin│
"   └─────┘  └─────┘  └─────┘  └───────┘  └──────┘
"
"  Misc:
"  - start_page:    startscreen
"  - fzf_files:     current use as cheat search by filename
"
let g:vim_confi_option = {
      \ 'mode': ['basic', 'theme', 'local', 'editor', 'admin', 'coder', 'log', 'c', 'markdown', 'git', 'script', 'tool'],
      \ 'remap_leader': 1,
      \ 'theme': 1,
      \ 'conf': 1,
      \ 'verbose': 0,
      \ 'debug': 0,
      \
      \ 'upper_keyfixes': 1,
      \ 'enable_map_basic': 1,
      \ 'enable_map_useful': 1,
      \
      \ 'auto_install_vimplug': 1,
      \ 'auto_install_plugs': 1,
      \ 'auto_install_tools': 1,
      \
      \ 'auto_chdir': 0,
      \ 'auto_save': 1,
      \ 'auto_restore_cursor': 1,
      \ 'auto_qf_height': 0,
      \ 'auto_session': 'vim.session',
      \
      \ 'keywordprg_filetype': 1,
      \
      \ 'view_folding': 0,
      \ 'show_number': 0,
      \ 'wrapline': 0,
      \ 'indentline': 0,
      \
      \ 'help_keys': 1,
      \ 'qf_preview': 0,
      \
      \ 'start_page': '$HOME/dotfiles/startpage.md',
      \ 'fzf_files': ['~/dotwiki/fortinet/doc', '~/dotwiki/cheat', '~/wiki/tool/cheat', '~/wiki/cheat', '~/.vim/bundle/vim.config/docs', ],
      \ 'fzf_notes': ['~/wiki', '~/dotwiki', '~/work-doc', ],
      \ 'tmp_file': '/tmp/vim.tmp',
      \}
" =============================================================

" Plugins {{{1
" https://github.com/habamax/.vim/blob/e9312935fb915fd6bfc4436b70b300387445aef8/vimrc
" Vim-Plug bootstrapping. {{{2
" Don't forget to call :PlugInstall
let g:vim_plug_installed = filereadable(expand('~/.vim/autoload/plug.vim'))
if !g:vim_plug_installed
    echomsg "Install vim-plug with 'InstallVimPlug' command and restart vim."
    echomsg "'curl' should be installed first"
    command InstallVimPlug !mkdir -p ~/.vim/autoload |
                \ curl -fLo ~/.vim/autoload/plug.vim
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Do not load plugins if plugin manager is not installed.
if !g:vim_plug_installed
    finish
endif

if g:vim_confi_option.remap_leader
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


if !empty($mode)
    let g:vim_confi_option.mode = [$mode]
    "echomsg "UserMode=". $mode
endif

if !empty($debug)
    let g:vim_confi_option.debug = 1
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
    "        a:0 > 0, negative return
    function! CheckPlug(name, type, ...)
        if (a:0 == 0)
            let has = 1
            let hasno = 0
        else
            let has = 0
            let hasno = 1
        endif

        if (exists("g:plugs") && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir))
            if a:type == 0
                return has
            elseif a:type == 1
                if has_key(g:plugs[a:name], 'on') && empty(g:plugs[a:name]['on'])
                    return hasno
                else
                    return has
                endif
            elseif a:type == 2
                return stridx(&rtp, g:plugs[a:name].dir) >= 0
            endif
        endif
        return hasno
    endfunction


    " Have and select the plug
    function! HasPlug(name)
        return CheckPlug(a:name, 1)
    endfunction

    " Check a plugin by order
    function! HasNoPlug(name)
        return CheckPlug(a:name, 1, 0)
    endfunction

    " Alias HasNoPlug, only load the plugin in advance.
    function! IfNoPlug(name)
        return CheckPlug(a:name, 1, 0)
    endfunction


    function! HasEnv(name)
        return !empty(a:name)
    endfunction

    function! HasNoEnv(name)
        return empty(a:name)
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
                call system("sudo apt install -y python3-pip")
                call system("sudo apt install -y python3-distutils")
            elseif CENTOS() || FEDORA()
                call system("sudo yum install -y python3-pip")
                call system("sudo yum install -y python3-distutils")
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
" more-plugins?
call plug#begin('~/.vim/bundle')

" Using vimplug as multiple repo manager: other not vim-plugins repos {{{2
    Plug 'huawenyu/dotfiles',         {'dir': '~/dotfiles', 'do': './script/up-dot.sh', 'on': ['NeverEverLoadMe'], 'for': 'RepoManager'}
    Plug 'huawenyu/zsh-local',        {'dir': '~/.oh-my-zsh/custom/plugins/zsh-local', 'do': './install --all', 'on': ['NeverEverLoadMe'], 'for': 'RepoManager'}  | " [oh-my-zsh plugin] my zsh env/alias/commands
    Plug 'zsh-users/zsh-completions', {'dir': '~/.oh-my-zsh/custom/plugins/zsh-completions', 'do': './install --all', 'on': ['NeverEverLoadMe'], 'for': 'RepoManager'} | "[oh-my-zsh plugin]
    Plug 'dooblem/bsync',             {'dir': '~/bin/bsync', 'do': 'chmod +x bsync && ln -s ./bsync ../bsync || true', 'on': ['NeverEverLoadMe'], 'for': 'RepoManager'} | " Tool: sync two dirs base-on rsync
"}}}

" Plug config: order-sensible {{{2
    Plug 'tpope/vim-sensible',   Cond(Mode(['basic', 'log', 'floatview']))
    Plug 'huawenyu/vim-basic',   Cond(Mode(['local', 'log', 'conf-basic', 'floatview']))
    Plug 'huawenyu/vim.config',  Cond(Mode(['local', 'log', 'conf-plug']))  | " config the plugs
    Plug 'huawenyu/vim.command', Cond(Mode(['local', 'log', 'conf-extra'])) | " config the plugs
"}}}

" ColorTheme {{{2
    Plug 'vim-scripts/holokai',        Cond(IfNoPlug('seoul256.vim') && Mode(['theme', 'floatview']))
    Plug 'junegunn/seoul256.vim',      Cond(IfNoPlug('holokai')      && Mode(['theme', 'floatview']))
    Plug 'NLKNguyen/papercolor-theme', Cond(Mode(['theme', 'floatview']))        |  " set background=light;colorscheme PaperColor
"}}}

" Writer {{{2
    Plug 'junegunn/goyo.vim',      Cond(Mode(['writer',])) | " :Goyo 80
    Plug 'junegunn/limelight.vim', Cond(Mode(['writer',])) | "
"}}}

" Coder {{{2
    " Try/test {{{3
        " Plug 'neovim/nvim-lspconfig'
        " " setting with vim-lsp
        " if executable('ccls')
        "    au User lsp_setup call lsp#register_server({
        "       \ 'name': 'ccls',
        "       \ 'cmd': {server_info->['ccls']},
        "       \ 'root_uri': {server_info->lsp#utils#path_to_uri(
        "       \   lsp#utils#find_nearest_parent_file_directory(
        "       \     lsp#utils#get_buffer_path(), ['.ccls', 'compile_commands.json', '.git/']))},
        "       \ 'initialization_options': {
        "       \   'highlight': { 'lsRanges' : v:true },
        "       \   'cache': {'directory': stdpath('cache') . '/ccls' },
        "       \ },
        "       \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        "       \ })
        " endif

        " Plug 'nvim-treesitter/nvim-treesitter'
        " Plug 'nvim-treesitter/nvim-treesitter-refactor'
        " Plug 'nvim-treesitter/playground'
        " Plug 'romgrk/nvim-treesitter-context'
        " Plug 'nelstrom/vimprint'
    "}}}

    " Comment,Extra {{{3
        Plug 'wsdjeg/SourceCounter.vim',         Cond(Mode(['coder'])) | " report by command ':SourceCounter'

        Plug 'tpope/vim-commentary',            Cond(Mode(['coder'])) | " gcc comment-line, gc<motion>: gcap comment-paragraph)
        "Plug 'numToStr/Comment.nvim',           Cond(Mode(['coder'])) | " gcc, gbc, gcw; not works good
        Plug 'huawenyu/nerdcommenter',           Cond(Mode(['coder'])) | " remap to <C-/>

        Plug 'Chiel92/vim-autoformat',           Cond(Mode(['coder']))
        Plug 'vim-scripts/iptables',             Cond(Mode(['admin']) && Mode(['extra']))
        Plug 'tenfyzhong/CompleteParameter.vim', Cond(Mode(['coder']) && Mode(['extra']))
        Plug 'FooSoft/vim-argwrap',              Cond(Mode(['coder']) && Mode(['extra']))        | " an argument wrapping and unwrapping
        Plug 'ericcurtin/CurtineIncSw.vim',      Cond(Mode(['coder',]))          | " Toggle source/header
    "}}}

    " Repl {{{3
        Plug 'voldikss/vim-floaterm',      Cond(Mode(['editor',])) | "
        Plug 'huawenyu/vim-floaterm-repl', Cond(HasPlug('vim-floaterm') && HasPlug('vim-basic') && Mode(['editor',]))  | "
        Plug 'wsdjeg/notifications.vim',   Cond(Mode(['editor',]))	| " :Echoerr xxxxx
        Plug 'huawenyu/vim-tmux-runner',   Cond(Mode(['admin']) && has('nvim'), { 'on':  ['VtrLoad', 'VtrSendCommandToRunner', 'VtrSendLinesToRunner', 'VtrSendFile', 'VtrOpenRunner'] })   | " Send command to tmux's marked pane

        "Plug 'michaelb/sniprun',           Cond(Mode(['admin']) && has('nvim'), {'do': 'bash install.sh'})   | " REPL/interpreters:  :SnipRun, :'<,'>SnipRun, :SnipReset, :SnipClose
        "Plug 'arjunmahishi/flow.nvim',     Cond(Mode(['coder',]))   | " runcode.nvim
        "Plug 'huawenyu/vimux-script',      Cond(Mode(['coder',]))	| " :
        "Plug 'xolox/vim-misc',            Cond(Mode(['coder',]))	| " :

    "}}}

    " gdb front-end {{{3
        "Plug 'huawenyu/vimgdb',        Cond(Mode(['coder']) && IfNoPlug('vimspector') && has('nvim'))    | "
        Plug 'huawenyu/vwm.vim',        Cond(Mode(['coder']))      |  " Clone from fireflowerr/vwm.vim, vim windows management
        Plug 'huawenyu/termdebug.nvim', Cond(Mode(['coder']) && IfNoPlug('vimspector') && has('nvim'))    | " Add config after copy /usr/share/nvim/runtime/pack/dist/opt/termdebug/plugin/termdebug.vim
    "}}}

    " Diff {{{3
        "Plug 'rickhowe/diffchar.vim',       Cond(Mode(['editor']))
        Plug 'chrisbra/vim-diff-enhanced',  Cond(Mode(['editor'])) | " vimdiff:  ]c - next;  [c - previous; do - diff obtain; dp - diff put; zo - unfold; zc - fold; :diffupdate - re-scan
        "Plug 'junkblocker/patchreview-vim', Cond(Mode(['editor'])) | " :PatchReview some.patch,  :DiffReview git show <SHA1>  :DiffReview git staged --no-color -U5
    "}}}

    " Hex editor {{{3
        Plug 'fidian/hexmode', Cond(Mode(['editor',])) | " Hex viewer, wrap of xxd, it's good.
    "}}}

    " plugin {{{3
        Plug 'huawenyu/vim-scriptease', Cond(Mode(['coder'])) | " A Vim plugin for Vim plugins
        Plug 'junegunn/vader.vim',      Cond(Mode(['coder']) && Mode(['plugin'])) | " A simple Vimscript test framework
        Plug 'mhinz/vim-lookup',        Cond(Mode(['coder']) && Mode(['plugin']))
    "}}}

    " C/Cplus {{{3
        Plug 'huawenyu/vim-linux-coding-style',  Cond(Mode(['coder']) && Mode(['c']))
        Plug 'octol/vim-cpp-enhanced-highlight', Cond(Mode(['coder']) && Mode(['c', 'floatview']))
        Plug 'bfrg/vim-cpp-modern',              Cond(HasPlug('vim-cpp-enhanced-highlight'))
    "}}}

    " Python {{{3
        Plug 'python-mode/python-mode', Cond(Mode(['coder']) && Mode(['python']), {'for': 'python'})
        Plug 'davidhalter/jedi-vim',    Cond(Mode(['coder']) && Mode(['python']), {'for': 'python'}) | " K: doc-of-method; <leader>d: go-definition; n: usage-of-file; r: rename
    "}}}

    " LaTeX {{{3
    "Plug 'lervag/vimtex', Cond(Mode(['editor',]) && Mode(['latex',]))  | " A modern vim plugin for editing LaTeX files
    "}}}

    " Perl {{{3
        Plug 'vim-perl/vim-perl',  Cond(Mode(['coder']) && Mode(['perl']), { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' })
        Plug 'tpope/vim-cucumber', Cond(Mode(['coder']) && Mode(['perl'])) | "      Auto    test  framework                                                               base on Behaviour Drive Development(BDD)
    "}}}

    " Javascript {{{3
        Plug 'pangloss/vim-javascript',  Cond(Mode(['coder']) && Mode(['javascript']))
        Plug 'maksimr/vim-jsbeautify',   Cond(Mode(['coder']) && Mode(['javascript']))
        Plug 'elzr/vim-json',            Cond(Mode(['coder']) && Mode(['javascript']))
        Plug 'tpope/vim-jdaddy',         Cond(Mode(['coder']) && Mode(['javascript']))  | " `:%!jq     .`         ;       `:%!jq --sort-keys .`
        Plug 'ternjs/tern_for_vim',      Cond(Mode(['coder']) && Mode(['javascript'])) | " Tern-based JavaScript editing support.
        Plug 'carlitux/deoplete-ternjs', Cond(Mode(['coder']) && Mode(['javascript']))
    "}}}

    " TypeScript {{{3
        Plug 'palantir/tslint', Cond(Mode(['coder']) && Mode(['typescript']), { 'for': 'typescript' })
    "}}}

    " Clojure {{{3
        Plug 'tpope/vim-fireplace', Cond(Mode(['coder']) && Mode(['clojure']), { 'for': 'clojure' })
    "}}}

    " Database {{{3
        Plug 'tpope/vim-dadbod', Cond(Mode(['coder']) && Mode(['database']))       | " :DB mongodb:///test < big_query.js
    "}}}

    " Golang {{{3
        Plug 'fatih/vim-go', Cond(Mode(['coder']) && Mode(['golang']))
        "Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
    "}}}

    " Tcl {{{3
        "Plug 'LStinson/TclShell-Vim', Cond(Mode(['coder',]) && Mode(['tcl',]))
        "Plug 'vim-scripts/tcl.vim', Cond(Mode(['coder',]) && Mode(['tcl',]))
    "}}}

    " Haskell {{{3
        Plug 'lukerandall/haskellmode-vim', Cond(Mode(['coder']) && Mode(['haskell']), {'for': 'haskell'})
        Plug 'eagletmt/ghcmod-vim',         Cond(Mode(['coder']) && Mode(['haskell']), {'for': 'haskell'})
        Plug 'ujihisa/neco-ghc',            Cond(Mode(['coder']) && Mode(['haskell']), {'for': 'haskell'})
        Plug 'neovimhaskell/haskell-vim',   Cond(Mode(['coder']) && Mode(['haskell']), {'for': 'haskell'})
    "}}}

    " Rust {{{3
        Plug 'racer-rust/vim-racer', Cond(Mode(['coder']) && Mode(['rust']), {'for': 'rust'})
        Plug 'rust-lang/rust.vim',   Cond(Mode(['coder']) && Mode(['rust']), {'for': 'rust'})
        Plug 'timonv/vim-cargo',     Cond(Mode(['coder']) && Mode(['rust']), {'for': 'rust'})
    "}}}

    " Meson build system: meson.build {{{3
        "Plug 'igankevich/mesonic', Cond(Mode(['coder']))
    "}}}

    " Markdown/Writing/Wiki {{{3
        " tool-render?
        Plug 'vimwiki/vimwiki',         Cond(Mode(['editor']) && Mode(['markdown']), {'for': 'markdown'})  |     "        Another choice is  [Gollum](https://github.com/gollum/gollum)
        Plug 'godlygeek/tabular',       Cond(Mode(['editor']) && Mode(['markdown']), {'for': 'markdown'})

        " ge: open link
        " ]], ]c, ]u, ][: next-header/cur-header/parent/sibling/
        " [[, []: previous header/sibling
        Plug 'preservim/vim-markdown', Cond(Mode(['editor']) && Mode(['markdown']), {'for': 'markdown'})

        "Plug 'SidOfc/mkdx',             Cond(Mode(['editor']) && Mode(['markdown']), {'for': 'markdown'})
        "Plug 'tpope/vim-markdown',      Cond(Mode(['editor']) && Mode(['markdown']), {'as':  'tpope_vim-markdown', 'for': 'markdown'} )     |        "       Light  but good enough
        Plug 'alok/notational-fzf-vim', Cond(Mode(['editor']) && len(g:vim_confi_option.fzf_notes), { 'on':  ['NV'] })    | " :NV <text> Grep 'text' then fzf-preview from multiple dirs
    "}}}

"}}}

" Facade {{{2
    Plug 'huawenyu/startscreen.vim',         Cond(Mode(['editor']) && len(g:vim_confi_option.start_page))
    Plug 'millermedeiros/vim-statline',      Cond(Mode(['coder',]))	 | " Show current-function-name, simple,not annoy to distract our focus
    Plug 'junegunn/rainbow_parentheses.vim', Cond(Mode(['editor']))
    Plug 'huawenyu/vim-mark',                Cond(Mode(['editor'])) | " mm  colorize current word
    Plug 'huawenyu/vim-signature',           Cond(Mode(['editor'])) | " place, toggle and display marks
    Plug 'lukas-reineke/indent-blankline.nvim', Cond(Mode(['editor']) && g:vim_confi_option.indentline)

    " Copy directly into vim.config/plugin/misc.vim
    "Plug 'teto/vim-listchars',               Cond(IfNoPlug('cyclist.vim') && Mode(['coder']))	 | " cycle listchars
    " prettier/vim-prettier

    " Windows related
    "Plug 'stevearc/stickybuf.nvim',           Cond(Mode(['coder']))      |  " Can't make it works; bind buffer with the window
    Plug 'folke/which-key.nvim',              Cond(Mode(['coder']) && g:vim_confi_option.help_keys) |  " Show/remember vim keymaps

    " Preview
    Plug 'skywind3000/vim-preview',           Cond(Mode(['coder'])) |  " Improve preview
"}}}

" Syntax/Language {{{2
    " Speedup vim by disable syntastic checker when write event
    "Plug 'vim-syntastic/syntastic',   Cond(Mode(['editor', 'floatview']))
    ""Plug 'Chiel92/vim-autoformat',   Cond(Mode(['coder',]))

    Plug 'justinmk/vim-syntax-extra', Cond(Mode(['coder',]), {'for': 'vim'})
    Plug 'vim-scripts/awk.vim',       Cond(Mode(['admin',]) && Mode(['script']))
    Plug 'huawenyu/vim-log-syntax',   Cond(Mode(['editor', 'log', ]), {'for': 'log'})
    Plug 'huawenyu/vim-autotest-syntax',   Cond(Mode(['editor', 'log', ]), {'for': 'log'})
    Plug 'tmux-plugins/vim-tmux',     Cond(Mode(['editor',]), {'for': 'tmux'})  | " The syntax of .tmux.conf
    Plug 'nickhutchinson/vim-cmake-syntax', Cond(has('nvim') && Mode(['coder',]))
    Plug 'xuhdev/syntax-dosini.vim',  Cond(has('nvim') && Mode(['coder',]))
"}}}

" Improve {{{2
    " Basic {{{3
        Plug 'junegunn/fzf',        Cond(Mode(['editor',]), { 'dir': '~/.fzf', 'do': './install --all' })
        Plug 'junegunn/fzf.vim',    Cond(HasPlug('fzf') && Mode(['editor',]))
        Plug 'junegunn/heytmux',    Cond(Mode(['editor',]), { 'do': 'gem install heytmux' })     | " Shell: $ heytmux workspace.yml

        Plug 'sunaku/vim-shortcut', Cond(Mode(['basic', 'editor', 'floatview']))         | " ';;' Popup shortcut help, but don't execute
        Plug 'kopischke/vim-fetch', Cond(Mode(['editor',]))			| " Support vim fname:line

        "Plug 'sudormrfbin/cheatsheet.nvim'
        "Plug 'nvim-lua/popup.nvim'
        "Plug 'nvim-lua/plenary.nvim'
        "Plug 'nvim-telescope/telescope.nvim'

        Plug 'ojroques/vim-oscyank',     Cond(Mode(['basic', 'floatview']))       | " Copy/paste cross host/instance when coperate with terminal Alacritty
        "Plug 'editorconfig/editorconfig-vim',   Cond(Mode(['editor']))      |  " vim config auto set
    "}}}

    " Async {{{3
        "Plug 'tpope/vim-dispatch',        Cond(Mode(['admin',]))
        "Plug 'Shougo/vimproc.vim',         Cond(Mode(['admin',]), {'do' : 'make'})
        Plug 'skywind3000/asyncrun.vim',   Cond(Mode(['admin',]))
        Plug 'skywind3000/asynctasks.vim', Cond(HasPlug('asyncrun.vim') && Mode(['admin',]), { 'do': 'ln -s $HOME/.vim_tasks.ini $HOME/.vim/tasks.ini' })   | " ~/.vim/tasks.ini
    "}}}

    " Search/Jump {{{3
        Plug 'google/vim-searchindex',      Cond(Mode(['editor',]))  | " Show the times a search pattern occurs in the current buffer
        Plug 'mhinz/vim-grepper',           Cond(Mode(['editor',]))  | " :Grepper text
            Plug 'huawenyu/c-utils.vim',             Cond(Mode(['coder']) && HasPlug('vim-grepper') )
        "Plug 'pechorin/any-jump.vim',       Cond(Mode(['coder',]))  | " Regex-fail when search-by 'rg',   ;jj  ;jb  ;jl
        Plug 'chengzeyi/fzf-preview.vim',   Cond(Mode(['coder',]) && HasPlug('fzf.vim'))   | " Wrap with enable preview of fzf.vim
            Plug 'huawenyu/fzf-cscope.vim', Cond(Mode(['coder',]) && HasPlug('fzf-preview.vim') && HasPlug('vim-basic'))

        " Tags/cscope/indexer? {{{4
            Plug 'preservim/tagbar',       Cond(IfNoPlug('vista.vim') && Mode(['coder',]))
            "Plug 'liuchengxu/vista.vim',    Cond(IfNoPlug('tagbar')    && Mode(['coder',]))
            "Plug 'vim-scripts/taglist.vim', Cond(HasPlug('tagbar')     && Mode(['coder',]) && LINUX())
        "}}}

        " Quickfix/Todo list {{{4
            Plug 'huawenyu/quickfix-reflector.vim',  Cond(Mode(['editor',]))    | " Directly edit the quickfix, Refactor code from a quickfix list and makes it editable
            Plug 'kevinhwang91/nvim-bqf',            Cond(Mode(['editor',]) && g:vim_confi_option.qf_preview)    | " Better quickfix: zf   fzf-mode
            "Plug 'romainl/vim-qf',                  Cond(Mode(['editor',]))    | " Tame the quickfix window

            "Plug 'freitass/todo.txt-vim',           Cond(Mode(['editor',]) && Mode(['extra']))       | " codeblock with 'todo', http://todotxt.org/
            "Plug 'bfrg/vim-qf-preview'

        "}}}

        " history {{{4
            "Plug 'liuchengxu/vim-clap',              Cond(Mode(['editor',]))    | "
        "}}}
    "}}}

    " Suggar {{{3
        Plug 'Raimondi/delimitMate',      Cond(Mode(['editor']) && IfNoPlug('auto-pairs'))
        Plug 'jiangmiao/auto-pairs',      Cond(Mode(['editor']) && IfNoPlug('delimitMate')) |  " Not work if  :set paste
        Plug 'huawenyu/vim-unimpaired',   Cond(Mode(['editor']))     | "Clone from @tpope
        Plug 'terryma/vim-expand-region', Cond(Mode(['editor']))     | " W - select region expand; B - shrink
        Plug 'tpope/vim-surround',		  Cond(Mode(['editor']))     | " Help add/remove surround
        Plug 'tpope/vim-endwise',         Cond(Mode(['editor']))     | " smart insert certain end structures automatically.
        Plug 'tpope/vim-rsi',             Cond(Mode(['editor']))     | " Readline shortcut for vim
        Plug 'houtsnip/vim-emacscommandline', Cond(Mode(['editor',]))| " Ctl-a  begin; Ctl-e  end; Ctl-f/b  forward/backward
    "}}}

    " Motion {{{3
        Plug 'christoomey/vim-tmux-navigator', Cond(Mode(['basic', 'editor', 'log', 'floatview']))
        Plug 'easymotion/vim-easymotion',      Cond(Mode(['editor',]))
        Plug 'tpope/vim-abolish',              Cond(Mode(['editor',]))      | " :Subvert/child{,ren}/adult{,s}/g

        " 1. Rename a var:  search the var -> cgn -> change-it -> .(repeat-it-whole)
        Plug 'tpope/vim-repeat', Cond(Mode(['editor',]))
            " gA                   shows the four representations of the number under the cursor.
            " crd, crx, cro, crb   convert the number under the cursor to decimal, hex, octal, binary, respectively.
            Plug  'glts/vim-radical',           Cond(HasPlug('vim-repeat') && Mode(['editor',]))
            Plug  'glts/vim-magnum',            Cond(HasPlug('vim-repeat') && Mode(['editor',]))

            "Plug 'svermeulen/vim-macrobatics', Cond(HasPlug('vim-repeat') && Mode(['editor',]))
            "Plug  'huawenyu/vim-macroscope',    Cond(HasPlug('vim-repeat') && Mode(['editor',]))

        Plug 'rhysd/clever-f.vim',  Cond(Mode(['editor',]))   | " Using 'f' to repeat, and also we can release ';' as our new map leader
        Plug 'huawenyu/vim-motion', Cond(Mode(['editor',]))  | " Jump according indent
        Plug 'junegunn/vim-easy-align', Cond(Mode(['editor',]))   | " tablize selected and ga=
        Plug 'dhruvasagar/vim-table-mode', Cond(Mode(['editor',]))| " <leader>tm :TableModeToggle; <leader>tr: Align; <leader>tt: Format existed
    "}}}

    " Auto completion {{{2

        " The autocomp fzf seems not works
        "Plug 'ms-jpq/coq_nvim',         Cond(Mode(['coder',]) && LINUX(), {'branch': 'coq'})
        "Plug 'ms-jpq/coq.artifacts',    Cond(Mode(['coder',]) && LINUX(), {'branch': 'artifacts'})
        "Plug 'ms-jpq/coq.thirdparty',   Cond(Mode(['coder',]) && LINUX(), {'branch': '3p'})

        Plug 'Shougo/deoplete.nvim',        Cond(Mode(['editor',]) && has('nvim'))         | "{ 'do': ':UpdateRemotePlugins' }
        Plug 'Shougo/neosnippet.vim',       Cond(HasPlug('deoplete.nvim') && Mode(['editor',]) && has('nvim'))        | " c-k apply code, c-n next, c-p previous, :NeoSnippetEdit
        Plug 'Shougo/neosnippet-snippets',  Cond(HasPlug('deoplete.nvim') && Mode(['editor',]) && has('nvim'))
        Plug 'huawenyu/vim-snippets.local', Cond(HasPlug('deoplete.nvim') && Mode(['editor',])  && Mode(['snippet',]) && has('nvim'))

        "Plug 'SirVer/ultisnips', Cond(HasPlug('deoplete.nvim') && Mode(['editor',]) && has('nvim'))        | " c-k apply code, c-n next, c-p previous, :NeoSnippetEdit
        "Plug 'honza/vim-snippets', Cond(HasPlug('deoplete.nvim') && Mode(['editor',]) && Mode(['snippet',]))

        Plug 'reedes/vim-wordy', Cond(Mode(['writer',]) && Mode(['snippet',]))

        " :LspInfo
        Plug 'neovim/nvim-lspconfig',           Cond(Mode(['coder',]))
        Plug 'williamboman/nvim-lsp-installer', Cond(Mode(['coder',]))

        "Plug 'glepnir/lspsaga.nvim',            Cond(Mode(['coder',]) && LINUX(), {'branch': 'main'})
        Plug 'ojroques/nvim-lspfuzzy',          Cond(Mode(['editor',]))  | " Sink lsp-result to fzf-float-windows, Select-All<c-aa> sink again to quickfix(<enter>)
        "Plug 'gfanto/fzf-lsp.nvim',            Cond(Mode(['editor',]))
        "Plug 'VonHeikemen/lsp-zero.nvim',      Cond(Mode(['editor',]))

        " Backend using node.js and eat too much memory/CPU
        "Plug 'neoclide/coc.nvim',      Cond(Mode(['coder',]) && LINUX(), {'branch': 'release'})
            "Plug 'neoclide/coc.nvim',  Cond(Mode(['coder',]) && LINUX(), {'do': 'yarn install --frozen-lockfile'})  | " sometimes find references fail
            "Plug 'neoclide/coc.nvim',  Cond(Mode(['coder',]) && LINUX(), {'on': ['<Plug>(coc-definition)', '<Plug>(coc-references)'], 'do': 'yarn install --frozen-lockfile'})  | " Increase stable by only load the plugin after the 1st command call.
            "Plug 'neoclide/coc-rls',   Cond(Mode(['coder',]) && LINUX())

        " Seem it's take too much CPU/memory, just comment out.
        "Plug 'hrsh7th/nvim-cmp',                Cond(Mode(['editor',]))
        "Plug 'hrsh7th/cmp-nvim-lsp',            Cond(Mode(['editor',]))
        "" Plug 'hrsh7th/cmp-buffer',            Cond(Mode(['editor',]))
        "" Plug 'hrsh7th/cmp-path',              Cond(Mode(['editor',]))
        "" Plug 'hrsh7th/cmp-cmdline',           Cond(Mode(['editor',]))
        "Plug 'hrsh7th/cmp-vsnip',               Cond(Mode(['editor',]))
        "Plug 'hrsh7th/vim-vsnip',               Cond(Mode(['editor',]))
        "Plug 'lukas-reineke/cmp-rg',            Cond(Mode(['editor',]))
    "}}}

    " Text objects? {{{2
    " https://blog.carbonfive.com/vim-text-objects-the-definitive-guide/
        Plug 'wellle/targets.vim',              Cond(Mode(['editor']))           | " number-repeat/`n`ext/`l`ast: quota `,`, comma `,`, `(` as n
        Plug 'kana/vim-textobj-user',           Cond(Mode(['editor']))
        Plug 'michaeljsmith/vim-indent-object', Cond(Mode(['editor',]))     | " <count>ai, aI, ii, iI
        Plug 'glts/vim-textobj-indblock',       Cond(Mode(['coder',]))           | " vao, Select a block of indentation whitespace before ascii
        Plug 'kana/vim-textobj-entire',         Cond(Mode(['coder',]))             | " vae, Select entire buffer
        Plug 'kana/vim-textobj-function',       Cond(Mode(['coder',]))            | " vaf, Support: c, java, vimscript
        Plug 'mattn/vim-textobj-url',           Cond(Mode(['editor',]))               | " vau
        Plug 'kana/vim-textobj-diff',           Cond(Mode(['coder',]))                | " vdh, hunk;  vdH, file;  vdf, file
        Plug 'glts/vim-textobj-comment',        Cond(Mode(['coder',]))             | " vac, vic
        Plug 'Julian/vim-textobj-brace',        Cond(Mode(['editor',]))            | " vaj
        Plug 'whatyouhide/vim-textobj-xmlattr', Cond(Mode(['coder',]))      | " vax
        "Plug 'kana/vim-textobj-indent',        Cond(Mode(['editor',]))            | " vai, vaI
        "Plug 'machakann/vim-textobj-functioncall', Cond(Mode(['coder',]))
        "Plug 'thinca/vim-textobj-between', Cond(Mode(['editor',]))          | " vaf, break the vim-textobj-function
    "}}}

"}}}

" Tools {{{2
    " Terminal/shell  {{{3
        Plug 'tpope/vim-eunuch', Cond(Mode(['admin',]))  | " Support unix shell cmd: Delete,Unlink,Move,Rename,Chmod,Mkdir,Cfind,Clocate,Lfind,Wall,SudoWrite,SudoEdit
        Plug 'tpope/vim-dotenv', Cond(Mode(['admin',]))  | " Basic support for .env and Procfile
        "Plug 'kassio/neoterm',   Cond(Mode(['admin',]) && has('nvim'))        | " Not work after update, a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>
        Plug 'akinsho/toggleterm.nvim',   Cond(Mode(['admin',]) && has('nvim'))| " a terminal for neovim; :T ls, # exit terminal mode by <c-\\><c-n>

        Plug 'chrisbra/NrrwRgn',    Cond(Mode(['editor',]))        | " focus on a selected region. <leader>nr :NR - Open selected into new window; :w - (in the new window) write the changes back
        Plug 'jamessan/vim-gnupg',  Cond(Mode(['extra']) && Mode(['admin']))         | " implements transparent editing of gpg encrypted files.
        Plug 'huawenyu/vim-tabber', Cond(Mode(['editor',]))        | " Tab management for Vim: the orig-version have no commands
    "}}}

    " Presentation? draw? pencil  {{{3
        Plug 'sk1418/blockit',       Cond(Mode(['editor',]))       | " :Block -- Draw a Box around text region
        Plug 'sk1418/HowMuch',       Cond(Mode(['editor',]))       | " V-Select, then get summary by: <Leader><Leader>?s

        Plug 'sotte/presenting.vim', Cond(Mode(['editor',]), {'for': 'markdown'})    | " n-next, p-prev, q-quit
        Plug 'jbyuki/venn.nvim',     Cond(Mode(['editor',]))       | " Draw pencil, seem require neovim version > 0.5
    "}}}

    " Project {{{3
        Plug 'tpope/vim-projectionist',         Cond(Mode(['editor']) && Mode(['extra']))  | " MVC like project, used when our project have some fixed struct map rule
        Plug 'c-brenn/fuzzy-projectionist.vim', Cond(Mode(['coder'])  && Mode(['extra']))  | " Change the prefixChar from E to F, we can get fuzzy feature
    "}}}

    " File/Explore {{{3
        Plug 'preservim/nerdtree',      Cond(Mode(['editor',]), { 'on':  ['NERDTreeToggle', 'NERDTreeTabsToggle'] })   | " :NERDTreeToggle; <Enter> open-file; '?' Help, and remap 'M' as menu
        Plug 'jistr/vim-nerdtree-tabs', Cond(Mode(['editor',]), { 'on':  'NERDTreeTabsToggle' })   | " :NERDTreeTabsToggle, Just one NERDTree, always and ever. It will always look the same in all tabs, including expanded/collapsed nodes, scroll position etc.

        " Plugin 'defx' {{{4
        if has('nvim')
            Plug 'Shougo/defx.nvim',         Cond(Mode(['editor']) && Mode(['extra']), { 'do': ':UpdateRemotePlugins' })
        else
            Plug 'Shougo/defx.nvim',         Cond(Mode(['editor']) && Mode(['extra']))
            Plug 'roxma/nvim-yarp',          Cond(Mode(['editor']) && Mode(['extra']))
            Plug 'roxma/vim-hug-neovim-rpc', Cond(Mode(['editor']  && Mode(['extra'])))
        endif

        Plug 'kristijanhusak/defx-git',      Cond(Mode(['editor',]) && Mode(['extra']))
        Plug 'kristijanhusak/defx-icons',    Cond(Mode(['editor',]) && Mode(['extra']))

    "}}}
    "

    " Outline/Context {{{3
        Plug 'huawenyu/VOoM',        Cond(Mode(['editor', 'log', ]))
        "Plug 'vim-voom/VOoM_extras',Cond(Mode(['editor']))  | " Seems no use at all, but slow/frozen when read large file (>100M)
        Plug 'roosta/fzf-folds.vim', Cond(Mode(['editor']))
    "}}}

"}}}

" Integration {{{2
    " git {{{3
        Plug 'tpope/vim-fugitive',     Cond(Mode(['editor']) && Mode(['git']))   | " git blame:  :Gblame, help-g?  close-gq  key: -,~,P
        Plug 'airblade/vim-gitgutter', Cond(Mode(['editor']) && HasPlug('vim-fugitive'), { 'on':  ['GitGutterToggle'] })  | " Heavy Shows a git diff
        Plug 'junegunn/gv.vim',        Cond(Mode(['editor']) && HasPlug('vim-fugitive'))  | " Awesome git wrapper

        " Troubleshooting :SignifyDebug
        " Diff by commit: export GitSHA=76748de92fa
        Plug 'mhinz/vim-signify',      Cond(Mode(['editor',]))   | " Light/Quicker then vim-gitgutter to show git diff

        Plug 'rbgrouleff/bclose.vim',       Cond(Mode(['editor']) && Mode(['extra']) && executable('tig'))
        Plug 'iberianpig/tig-explorer.vim', Cond(Mode(['editor']) && Mode(['extra']) && HasPlug('bclose.vim') && executable('tig'))         | " tig for vim (https://github.com/jonas/tig): should install tig first.

        Plug 'tpope/vim-rhubarb', Cond(Mode(['editor']) && Mode(['extra']) && Mode(['hub']))   | " fugitive.vim is the Git, rhubarb.vim is the Hub.
        Plug 'mattn/gist-vim',    Cond(Mode(['editor']) && Mode(['extra']))              | " :'<,'>Gist -e 'list-sample'
    "}}}

    Plug 'wlemuel/vim-tldr', Cond(executable('tldr') && Mode(['editor',]))    | " :Tldr <linux-cmd>
    Plug 'yuratomo/w3m.vim', Cond(executable('w3m') && Mode(['admin',]) && Mode(['tool',]))
    Plug 'szw/vim-dict',     Cond(Mode(['editor',]) && Mode(['tool',]))
    Plug 'szw/vim-g',        Cond(Mode(['editor',]) && Mode(['tool',]))
"}}}

" Thirdpart Library {{{2
    Plug 'vim-jp/vital.vim',   Cond(Mode(['coder']) && Mode(['library']))  | " promise?
    Plug 'google/vim-maktaba', Cond(Mode(['coder']) && Mode(['library']))
    Plug 'tomtom/tlib_vim',    Cond(Mode(['coder']) && Mode(['library']))
"}}}

" Debug {{{2
    Plug 'gu-fan/doctest.vim', Cond(Mode(['admin',]))     | " doctest for language vimscript, :DocTest
    Plug 'huawenyu/vimlogger', Cond(Mode(['admin',]))
"}}}

call plug#end()


" Keymap fzf {{{2
" If don't source it directly, looks this plugin not works.
if HasPlug('vim-shortcut')
    " Shortcut! keys description
    let thedir = PlugGetDir('vim-shortcut')
    exec "source ". thedir. "plugin/shortcut.vim"

    silent! Shortcut! ;;    [.vimrc] Show this Shortcuts-list
endif


if g:vim_confi_option.debug && HasPlug('vimlogger')
    echomsg "Enable debug mode, please try 'tail -f /tmp/vim.log'."
    " troubleshooting?
    "silent! call logger#init('ALL', ['/dev/stdout', '/tmp/vim.log'])
    silent! call logger#init('ALL', ['/tmp/vim.log'])
endif


" END-setting {{{1
    " Only here works {{{2
    if Mode(['coder',])
        augroup ugly_set
            autocmd!
            autocmd BufEnter * call cscope#LoadCscope()
            autocmd BufEnter * set nolazyredraw lazyredraw
            autocmd BufEnter * redraw!

            autocmd BufRead,BufNewFile * setlocal signcolumn=yes
            autocmd FileType tagbar,nerdtree,voomtree,qf setlocal signcolumn=no
        augroup end
    endif
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

