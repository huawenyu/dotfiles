% VimCheat(1) | NeoVim Manual: `LD-leader` is \<space\>
% Wilson  wilson.yuu@gmail.com
% 2024-12-21

NAME
===
**Vim_cheat** - A man page for `neovim` + plug-`vimConfig`

**vim_maps(1)**, **vim(1)**

# DESCRIPTION {{{1}}}

Windows: `#` - Use Numbers choose Win/Tab
---
:    <C-#>-Terminal Tab  <A-#>-Tmux Tab  <C-hjkl>-Win|Pane  `;#`-Vim Tab

Motion    `<C-*>`
---
    `<C-]>`-tag  `<C-io>`-history  `<C-np>`-QF  `<C-/>`-Comment  `<C-\>`-Terminal

QuickFix  `-QF-`
---
    `<c-q><cr>`-Fzf to quickfix  `mf`-filterQF  `mc`-callerQF

Option    `o[*`
---
    <space>-add blank lines  `e`-exchange lines  `n`-conflict

Object    `v*`
---
    `vie`-buffer  `vif`-function  `vi'`-fence  `vi'`-Quota `viu`-URL  `vij`-Brace  `vic`-Comment  `vib`-Block

Mode      `-GDB-`
---
    `F4`-Cont  `F5`-next(S-skip)  `F6`-stepIn(S-Finish)  `F7`-RunToHere  `F8`-Evaluate(S-Watch)  `F9`-ToggleBreak

Mode      `Search`
---
    `;#`-Count  `;^`-Popup  `;*`-ToQF

Misc      `-note-`
---
    : `<LD>w;` - buf Swap
    : `<LD>ee` - Execute current file
    : `<LD>ga` - Load Easy Align
    : `:e ++ff=dos`| `:set ff=unix`| `:C0|C2|C4|C08`
    : `:verbose map|function *`|
    : `1G`-file path|
    : Diff(env $VimGit)


Debug log/troubleshooting: {{{2}}}
---
1. Enable log from global config:
        "let g:vim_confi_option.debug = 1
        # <or> specify from command line
        debug=1 vim <file>
2. Ensure the log instance existed:
        " Insert this line to the front of our vimscript:
        silent! let s:log = logger#getLogger(expand('<sfile>:t'))
3. Debug/print:
        silent! call s:log.info(l:__func__, 'enter')
4. Check log:    (LinuxPC) $ tail -f /tmp/vim.log

Install:  help 'K' on the topic {{{1}}}
---

## Install OS - Windows {{{2}}}

- Doc: https://jdhao.github.io/2018/11/15/neovim_configuration_windows/
- Install neovim, https://github.com/neovim/neovim/wiki/Installing-Neovim
- Install Git (available at https://git-scm.com/downloads)
- Copy the plug.vim and place it in "autoload" directory of vim.
- In your .vimrc, include the plugins that you need to install.
- Save and source the .vimrc.
- Run ":PlugInstall"

## Install OS - Debian/Ubuntu {{{2}}}

### Auto setup/install env {{{3}}}

```bash
        wget --no-check-certificate -O ~/chk-ubuntu  https://raw.githubusercontent.com/huawenyu/zsh-local/master/bin/chk-ubuntu
        chmod +x ~/chk-ubuntu
        ~/chk-ubuntu
```

### Install neovim: {{{3}}}

```bash
        sudo apt-get install neovim
        sudo update-alternatives --config vi
        sudo update-alternatives --config vim

    ### 1. Update latest vim config:
        curl -fLo ~/.vim/init.vim --create-dirs \
           https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/huawenyu/vim-plug/master/plug.vim
    ### 2.1 Update vim from repo:
        #sudo add-apt-repository ppa:neovim-ppa/unstable -y
        sudo add-apt-repository ppa:neovim-ppa/stable -y
        sudo apt-get install neovim
    ### 2.2 [OR] Update vim from binary:
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
        chmod u+x nvim.appimage
        sudo mv /usr/bin/nvim /usr/bin/nvim.old
        sudo mv nvim.appimage /usr/bin/nvim
    ### 3. Take `.vimrc` as Config [Reference: vi -c 'help nvim-from-vim']
        ### oneline version
        $ mkdir -p ~/.vim && rm -fr ~/.vim/init.vim && ln -s ~/.vimrc ~/.vim/init.vim && mkdir -p ~/.config && rm -fr ~/.config/nvim && ln -s ~/.vim ~/.config/nvim

        ### Split into multiple lines
        $ mkdir ~/.vim
        $ ln -s ~/.vimrc ~/.vim/init.vim
        $ mkdir ~/.config
        $ ln -s ~/.vim ~/.config/nvim

    $ vi -c 'PlugInstall'
```

### [Optional] - other config/tool {{{3}}}


```bash
neo-tree require beaty icon, we can download from here: 
I prefer DejaVuSansMono.zip
https://www.nerdfonts.com/font-downloads
https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/DejaVuSansMono.zip
So we only install for our Terminal, for Windows11, only require for windows 11:
  unzip the downloaded font, then right-click::"Install for all-users", Done!
```


```bash
+ zshrc -- Simpler zshrc for oh-my-zsh
  $ sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
  $ wget --no-check-certificate -O ~/.zshrc https://raw.githubusercontent.com/huawenyu/dotfiles/master/.zshrc
+ oh-my-bash
  $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
    OSH_THEME="robbyrussell"
    DISABLE_AUTO_UPDATE="true"
+ tmux.conf -- Simpler zshrc for oh-my-zsh
  $ wget --no-check-certificate -O ~/.tmux.conf https://raw.githubusercontent.com/huawenyu/dotfiles/master/.tmux.conf
+ [neovim-remote](https://github.com/mhinz/neovim-remote)
- [QuickStart]
    - checkhealth
```
# icon

```
Separator Options
1. Powerline Arrows
Left-facing: , , , 
Right-facing: , , , 
2. Curves
,  (double curves)
,  (round edges)
,  (wavy curves)
3. Minimal Separators
| (straight bar)
/ (forward slash)
‖ (double bar)
⋮ (vertical ellipsis)
4. Decorative Lines
═, ─, ━ (horizontal bars)
║, ┃ (vertical bars)
╲, ╱ (diagonals)
★, ✦, ❖ (symbols for decorative purposes)
5. Unique Symbols
», « (angled quotes)
›, ‹ (single angles)
⮂, ⮃ (loop arrows)
➤, ➥ (chevrons)


. Bold Arrows
⟶, ⟵ (bold single arrows)
⇢, ⇠ (curved arrows)
➔, ➜, ➙ (sharp arrows)
2. Chevrons
», « (double chevrons)
›, ‹ (single chevrons)
⯈, ⯇ (rounded chevrons)
3. Blocks and Bars
▐, ▌ (half-blocks)
```

# SEE ALSO {{{1}}}

**vim_maps(1)**, **vim(1)**

- Small IDE: https://neovimcraft.com/plugin/wuelnerdotexe/nvim/

For more information, see the **GNU Coreutils documentation**:
<https://raw.githubusercontent.com/huawenyu/dotfiles/master/.vimrc>.
