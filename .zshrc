# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Add in snippets
#zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

# Aliases
alias ls='ls --color'
alias ip='ip -color=auto'
alias vim='nvim'
alias ttytheme='ttyscheme "$(ttyscheme -l | fzf)"'

# dotfile manager
alias lagoon='git --git-dir=$HOME/.lagoon --work-tree=$HOME'
alias lagoon-update='lagoon add -u | lagoon commit -m "$(date +%y%m%d-%H%M) $(fortune -s)" | lagoon push -u origin main'


# path stuff
export EDITOR="nvim"
PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"

#pacman
fzpac(){
	case "$1" in
		-R) pacman -Qq | fzf --multi --preview-window=up --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns ;;
		-aur|-yay) yay -Slaq | fzf --multi --preview-window=up --preview 'yay -Si {1}' | tr -d 'AUR' | xargs -ro yay -S ;;
		-S|*) pacman -Ssq | fzf --multi --preview-window=up --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S ;;
	esac
}

if [[ "${TERM}" != "" && "${TERM}" == "xterm-256color" ]]
then
    precmd()
    {
        # output on which level (%L) this shell is running on.
        # append the current directory (%~), substitute home directories with a tilde.
        # "\a" bell (man 1 echo)
        # "print" must be used here; echo cannot handle prompt expansions (%L)
        print -Pn "\e]0;%~\a"
        #print -Pn "\e]0;$(id --user --name)@$(hostname): zsh[%L] %~\a"
    }

    preexec()
    {
        # output current executed command with parameters
        echo -en "\e]0;${1}\a"
    }
fi

fzf_hands() {
	path_choice="$(find ~/ -type f -o -type d 2> /dev/null | fzf --color="bg+:-1,fg:gray,prompt:gray,pointer:cyan,fg+:cyan" --preview-window=70%,border-bottom,top --preview='
	case {} in
		*.png) catimg {} ;;
		*.pdf) pdftotext -f 1 -l 2 -q {} - ;;
		*.mp3) exiftool {} - ;;
		*) bat --color always -p {} 2> /dev/null || ls --color --group-directories-first -w 1 {} ;;
	esac
	')"
	
	file_handler(){
		case "$path_choice" in
			*.pdf) nohup zathura "$path_choice" &>/dev/null &	;;
			*.png) sxiv "$path_choice"	;;
			*.mp3|*.opus) mpv --vo=null --video=no --no-video --term-osd-bar "$path_choice"	;;
			*.mp4|*.webm) mpv "$path_choice"	;;
			*.torrent) aria2c "$path_choice"	;;
			"") echo "\033[0;31m<3"				;;
			*) nvim "$path_choice"		;;
		esac
	}
	
	if [ -d "$path_choice" ]
	then 
		cd $path_choice ; ls --color --group-directories-first -w 1 "$path_choice"
	#	cd $path_choice
	else
		file_handler
	fi
}

fzf_hands_keybind() {
	fzf_hands
	zle reset-prompt
	zle redisplay
}
zle -N fzf_hands_keybind
bindkey '^_' fzf_hands_keybind

export FZF_COMPLETION_OPTS="--preview-window=60%,border-bottom,right --color='bg+:-1,fg:gray,prompt:gray,pointer:cyan,fg+:cyan' --preview 'bat --color always -p {}'"
# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
