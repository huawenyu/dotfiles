#!/bin/zsh

function lock {
    while ! ln ${HOME}/.zshrc ${HOME}/.zshrc.lock 2>/dev/null
    do
        sleep 1
    done
    # Lock obtained
}

function unlock {
    rm -f ${HOME}/.zshrc.lock
    # Lock released
}

#lock
#trap unlock EXIT

# Update dotfiles
function dotfiles-update() {
    # Update dotfiles
    local DOTFILES
    DOTFILES=$HOME/.dotfiles

    if [ -x /usr/bin/git -a -d $DOTFILES/.git -a -n "$SSH_AUTH_SOCK" ]; then
        (cd $DOTFILES && /usr/bin/git pull)
        (cd $DOTFILES && ./bootstrap.sh)
        source ~/.zshrc
    fi
}

setopt extendedglob
setopt promptsubst
setopt menu_complete
setopt list_ambiguous
set completion-ignore-case on

# Install zplugin if not present: https://github.com/zdharma/zplugin
if [[ ! -d ${HOME}/.zplugin ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zplugin/master/doc/install.sh)"
fi


# Initialize zplugin
source "${HOME}/.zplugin/bin/zplugin.zsh"
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

# Initialize completion
autoload -Uz compinit

case $SYSTEM in
  Darwin)
    if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' ${ZDOTDIR:-$HOME}/.zcompdump) ]; then
      compinit;
    else
      compinit -C;
    fi
    ;;
  Linux)
    # not yet match GNU & BSD stat
  ;;
esac


# Some defaults values
#zplugin light "oconnor663/zsh-sensible"
zplugin light "huawenyu/zsh-local"

# speed git dir prompt
function git_prompt_info() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

#zplugin ice wait lucid
#zplugin snippet OMZ::lib/git.zsh

#zplugin ice wait atload"unalias grv" lucid
#zplugin snippet OMZ::plugins/git/git.plugin.zsh
#zplugin snippet PZT::modules/helper/init.zsh
##zplugin snippet PZT::modules/git

PS1="READY >" # provide a nice prompt till the theme loads
zplugin ice wait'!' lucid
zplugin snippet OMZ::themes/robbyrussell.zsh-theme

#zplugin ice wait lucid
#zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

#zplugin ice wait as"completion" lucid
#zplugin snippet OMZ::plugins/docker/_docker

#zplugin ice atclone"dircolors -b dircolors.jellybeans > c.zsh" atpull'%atclone' pick"c.zsh"
#zplugin light peterhellberg/dircolors-jellybeans

# Semigraphical interface to zplugin
zplugin light "zdharma/zui"
zplugin light "zdharma/zplugin-crasis"

# Add 256color if terminal the current terminal supports it.
zplugin light "chrissicool/zsh-256color"

# Vi-mode improved
#zplugin ice wait as"completion" lucid
#zplugin snippet OMZ::plugins/vi-mode
## Implement the history substring search by arrow key
zplugin load softmoth/zsh-vim-mode

## A command tool helps navigating faster with learning
## @note:z.lua https://github.com/skywind3000/z.lua
#zplugin load skywind3000/z.lua
#export _ZL_EXCLUDE_DIRS=1
#export _ZL_MATCH_MODE=1  # enhanced matching mode
#export _ZL_ECHO=1  # display the path after cd
#export _ZL_ADD_ONCE=1  # only add path if the $PWD is changed
## alias for z.lua
#alias zi="z -i"  # interactive selection
#alias zb="z -b"  # jump backward
#alias zh='z -I -t .'	# using fzf to search mru

# Some completions
zplugin ice wait"0" blockf lucid
zplugin light "zsh-users/zsh-completions"
zplugin light "zsh-users/zsh-history-substring-search"

# Suggestions for zsh
#zplugin ice wait"0" atload"_zsh_autosuggest_start" lucid
#zplugin light "zsh-users/zsh-autosuggestions"

# ZSH utilities
# #############

# Jump to bookmarks
#zplugin light "jocelynmallon/zshmarks"

# Autoenv
#zplugin light "zpm-zsh/autoenv"

## ZSH navigation tools
#zplugin light "psprint/zsh-navigation-tools"
#
## Use n-history widget
#autoload znt-history-widget
#zle -N znt-history-widget
#bindkey "^R" znt-history-widget

# Notifies
#zplugin light "t413/zsh-background-notify"

# Miscelaneous plugins
# ####################

# Enable terminal multiplexing related plugins
#zplugin ice load'![[ -z "$TMUX" ]]'
#zplugin light "mdsn/zsh-tmux"

# Agents
#zstyle ':omz:plugins:ssh-agent' identities 'id_rsa' 'xals.rsa' 'xals-old.rsa' 'alexis@sysnove.fr'
#zplugin light "hkupty/ssh-agent"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Syntax highlighting plugin. Must be last.
#zplugin ice wait"0" atinit"zpcompinit; zpcdreplay" lucid
#zplugin light "zdharma/fast-syntax-highlighting"

#zplugin light "jreese/zsh-titles"

# Enable colorgcc, colormake, colordiff and ccache
[[ -x /usr/bin/colorgcc ]] && export PATH="/usr/lib/colorgcc/bin/:$PATH"

if [[ -d /usr/lib/ccache ]]; then
    export PATH="/usr/lib/ccache/bin/:$PATH"
fi

# bin directory in $HOME
[ -x "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -x "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Some aliases and defaults.
[ -x "$(which aptitude)" ] && alias aptitude="aptitude --disable-columns"
[ -x "$(which vim)" ] && export EDITOR="vim"
[ -x "$(which nvim)" ] && export EDITOR="nvim"
[ -x "$(which most)" ] && export PAGER="most"

# Some colors
#alias ls='ls --group-directories-first --color=auto'
alias ls='ls --color=auto'
#alias grep='grep --color'

# Venv commands
#alias khal='pew in pim khal'
#alias khard='pew in pim khard'

# Define aliases for command with disabled flow control
#alias vim="stty stop '' -ixoff ; vim"
#alias neomutt="stty stop '' -ixoff ; neomutt"

# Freeze tty to reset it after each command.
#ttyctl -f

#alias tmuxp='pew in tmuxp tmuxp'
#
#function _zsh_tmux_plugin_preexec(){
#    eval $(tmux show-environment -s)
#    unset TERMINFO
#}
#
## Automatically refresh tmux environments if tmux is running.
#if [[ -n "$TMUX" ]]; then
#    autoload -U add-zsh-hook
#    add-zsh-hook preexec _zsh_tmux_plugin_preexec
#fi

# Handle GPG agent manually.
local GPG_AGENT_BIN=/usr/bin/gpg-agent
local GPG_AGENT_ENV="$HOME/.gnupg/gpg-agent.env"
local GPG_CONNECT_AGENT_ERR_MSG="gpg-connect-agent: no gpg-agent running in this session"

if [[ "$(LC_ALL=C gpg-connect-agent --no-autostart --quiet /bye 2>&1)" == "$GPG_CONNECT_AGENT_ERR_MSG" ]]; then
    # Starting GPG agent.
    ${GPG_AGENT_BIN} --quiet --daemon 2> /dev/null > "${GPG_AGENT_ENV}"
    chmod 600 "${GPG_AGENT_ENV}"
fi

if [[ -f "${GPG_AGENT_ENV}" ]]; then
    . "${GPG_AGENT_ENV}" > /dev/null
fi

export GPG_TTY=$(tty)
# End of GPG agent handling.

export CSCOPE_DB=$PWD/cscope.out
#
#unlock

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
