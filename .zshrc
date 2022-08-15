# Path to your oh-my-zsh installation.
export ZSH="/Users/hwijeen/.oh-my-zsh"

ZSH_THEME="simple"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
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

ZSH_DISABLE_COMPFIX="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

plugins=(git docker alias-tips zsh-autosuggestions zsh-syntax-highlighting fzf)

source $ZSH/oh-my-zsh.sh

# User configuration
# Personal aliases
alias typora="open -a typora"
alias py="python"
alias mv="mv -i"
alias cp="cp -i"
alias jobs="jobs -l"
alias vim="/usr/local/bin/vim"
alias ruby="/usr/local/Cellar/ruby/2.7.2/bin/ruby"
alias gem="/usr/local/Cellar/ruby/2.7.2/bin/gem"

# Personal variables
export PATH="/usr/local/anaconda3/bin:$PATH"
export RPROMPT="%(1j.✦.) %D{%K:%M} " # background job indicator
export LSCOLORS=Gxfxcxdxbxegedabagacad
export PYTHONDONTWRITEBYTECODE=1 # Don't write .pyc files
export blog="/Users/hwijeen/Documents/Documents - hwiipro/hwijeen.github.io"
export cmu="/Users/hwijeen/school/cmu"
export gre="/Users/hwijeen/project abroad/gre"
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "

# Personal functions
notebook(){
    echo "jupyter notebook --no-browser --port "$1" --ip 0.0.0.0 &>/dev/null &"
    jupyter notebook --no-browser --port "$1" --ip 0.0.0.0 &>/dev/null &
}

tb(){
    echo "tensorboard --logdir runs --port $1 &>/dev/null &"
    tensorboard --logdir runs --port $1 &>/dev/null &
}

pf(){
    if [[ "$#" -eq 3 ]];then
        # pf 230 nipa 9999
        echo "ssh -f -N -L "$3":localhost:$3 -J $1 $2"
        ssh -f -N -L "$3":localhost:$3 -J $1 $2
    else
        # pf 230 9999
        echo "ssh -f -N -L "$2":localhost:$2 $1"
        ssh -f -N -L "$2":localhost:$2 $1
    fi
}

gdrive(){
    echo "Downloading gdrive file as $2"
    # wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$1' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2 && rm -rf /tmp/cookies.txt
    curl -c /tmp/cookies "https://drive.google.com/uc?export=download&id=$1" > /tmp/intermezzo.html
    curl -L -b /tmp/cookies "https://drive.google.com$(cat /tmp/intermezzo.html | grep -Po 'uc-download-link" [^>]* href="\K[^"]*' | sed 's/\&amp;/\&/g')" > $2
}

