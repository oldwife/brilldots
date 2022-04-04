##########################
###enviroment variables###
##########################
export EDITOR="nvim"
export TERM="st"
#export MANPAGER="nvim -c 'set ft=man' -"
PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

###########
###alias###
###########
alias vim='nvim'
alias ls='ls --color --group-directories-first -w 1'
alias smi='sudo make install'
alias xrdbset='[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources &'
alias keys='xmodmap ~/.Xmodmap ; xset r rate 300 50 ; xcape -e 'Super_L=Escape' ; xcape -e 'Super_R=Escape''

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[blue]%}{%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[magenta]%}%M%{$fg[red]%}%~%{$fg[cyan]%}}%{$fg[yellow]%}# "

###############
###functions###
###############

#copies file/folder path to xclip
yy() {
[ $# -eq 0 ] && echo "no file/folder in arg" || echo $(pwd)"/"$1 | xclip -selection c
}

#cp -r from xclip, see yy ^
p() {
[ $# -eq 0 ] && cp -r $( xclip -selection c -o ) $( xclip -selection c -o | awk -F/ '{print $NF}') || cp -r $( xclip -selection c -o ) $1
}

#this runs ls when you cd into directory
function chpwd() {
    emulate -L zsh
    ls --color --group-directories-first -w 1
}

#uses fzf to cd into dir
cds() {
	cd "$( find -type d | fzf)" 
}

#opens files using default program
open() {
	xdg-open "$(find -type f | fzf)"
}

#searches for file and edits in vim
fvi() {
	nvim "$(find -type f | fzf)"
}

#pacman/yay fzf tui
fzpac(){
	case "$1" in
		-R) pacman -Qq | fzf --multi --preview-window=up --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns ;;
		-aur|-yay) yay -Pc | fzf --multi --preview-window=up --preview 'yay -Si {1}' | tr -d 'AUR' | xargs -ro yay -S ;;
		-S|*) pacman -Ssq | fzf --multi --preview-window=up --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S ;;
	esac
}


#############
###options###
#############

#cmdhistoryfile
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

#############
###vi-mode###
#############

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
        vicmd) echo -ne '\e[1 q' ;;      # block
        viins|main) echo -ne '\e[5 q' ;; # beam
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

#changes cursor shape and prompt
oldPS1="$PS1"
function zle-line-init zle-keymap-select {

    case $KEYMAP in
        vicmd) echo -ne '\e[1 q' ;;      # block
        viins|main) echo -ne '\e[5 q' ;; # beam
    esac

    VIM_NORMAL_PROMPT="%B%{$fg[blue]%}{%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[magenta]%}%M%{$fg[red]%} %~%{$fg[cyan]%}}%{$fg[yellow]%}# "
    VIM_INSERT_PROMPT="%B%{$fg[blue]%}{%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[magenta]%}%M%{$fg[green]%} %~%{$fg[cyan]%}}%{$fg[yellow]%}# "
    PS1="${${KEYMAP/vicmd/$VIM_NORMAL_PROMPT}/(main|viins)/$VIM_INSERT_PROMPT}"
    PS2=$PS1
    RPS1=""
    RPS2=""
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

##########
###misc###
##########
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sailfish/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

########################
###syntaxhighlighting###
########################
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
