## dotfiles

linux config files: zsh, tmux, vim, script, ...
- editor: nvim
- tmux: multiple shell with share support
- [sub](https://github.com/qrush/sub): a delicious way to organize programs/scripts/tools
- vimplug: update this dotfiles
- xsel: clipboard tool

## Install

### Only once at first time

```sh
    $ cd <the-perfer-dir>
    $ git clone https://github.com/huawenyu/dotfiles.git
    $ cd dotfiles/script
    $ ./up-dot.sh -a pull
```

## Usage

For your convenience, please add the `<your-download-dir>/dotfiles/script` to `$PATH` by
`export PATH=$HOME/dotfiles/script:$PATH` to our `.bashrc` or `.zshrc`

