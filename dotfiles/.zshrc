# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)
plugins=(vi-mode)
plugins=(fasd)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='kak'
# else
#   export EDITOR='kak'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# My Custom Prompt
local ret_status="%(?:%{$fg_bold[green]%}⤜ :%{$fg_bold[red]%}⤜ %s)"
PROMPT='${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}%{$fg_bold[green]%}➛%{$reset_color%}  '

ZSH_THEME_GIT_PROMPT_PREFIX="@%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}✍ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"

# Regular Aliases
alias v=nvim
alias beet='beet -c ~/.beets_config.yaml'
alias mkdr=mkdir
alias say='say -v Samantha'
alias wifi='sudo spoof randomize Wi-Fi;networksetup -setairportpower en0 off;networksetup -setairportpower en0 on'

# Dotfiles
export PATH=/usr/local/bin/rsync:$PATH
export PATH=~/.dotfiles/pathfiles:$PATH

# Put ZSH in vi mode
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode

# Key timeout faster
export KEYTIMEOUT=40

# Android Dev
export PATH=~/Developer/android-sdk-macosx/tools:$PATH
export PATH=~/Developer/android-sdk-macosx/platform-tools:$PATH

# BREW before System
export PATH="/usr/local/bin:$PATH"

# Yarn install global packages
export PATH=~/.config/yarn/global/node_modules/.bin:$PATH

# fzf default command
export FZF_DEFAULT_COMMAND="fd --type f"
# Open files in kak from fzf
of() {
local files
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && kak "${files[@]}"
}

# AWS cli
export PATH=~/Library/Python/2.7/bin:$PATH

# ASDF https://github.com/asdf-vm/asdf
export PATH=~/.asdf/installs:$PATH
export PATH=~/.asdf/installs/python:$PATH
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# ENV
export EDITOR=kak

# Kill a named kak session
kak-kill() {
  if [ -z "$1" ]
  then
    echo "You must specify a session name"
  else
    echo kill | kak -p $1
  fi
}

# Rust Path
export PATH="$HOME/.cargo/bin:$PATH"
