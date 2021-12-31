# Luke's config for the Zoomer Shell

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# path stuff
PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

function chpwd() {
    emulate -L zsh
    ls --color --group-directories-first -w 1
}

alias vim='nvim'
alias lsa='ls --color --group-directories-first -w 1'
alias lsaa='ls --color --group-directories-first -w 1 -a'
alias smi='sudo make install'
alias fd='cd'
alias xrdbset='[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &'
#cool cd command using fzf
#stole from bugswriter
#https://www.youtube.com/watch?v=_xxTcKJMnWQ
cds() {
	cd "$( find -type d | fzf)" 
}

fds() {
	cd "$( find -type d | fzf)" 
}
#cool opening command also stolen from 
#bugswriter
#https://www.youtube.com/watch?v=_xxTcKJMnWQ
open() {
	devour xdg-open "$(find -type f | fzf)"
}

fvi() {
	nvim "$(find -type f | fzf)"
}

f() {
    fff "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}

keys() {
xmodmap ~/.Xmodmap &
xset r rate 300 50 &
xcape -e 'Super_L=Escape' &
xcape -e 'Super_R=Escape'
}

#bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sailfish/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#irohbonsaiold
#fortune
# Load syntax highlighting; should be last.



#source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh



