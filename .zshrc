# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

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

# Put device specific contents into bash_profile
if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile;
fi

# User configuration
# Personal aliases
alias py="python"
alias mv="mv -i"
alias cp="cp -i"
alias jobs="jobs -l"
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

# Personal variables
export RPROMPT="%(1j.✦.) %D{%K:%M} " # background job indicator
export LSCOLORS=Gxfxcxdxbxegedabagacad
export PYTHONDONTWRITEBYTECODE=1 # Don't write .pyc files
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

# https://chemicloud.com/blog/download-google-drive-files-using-wget/
gdrive_download(){
    echo "gdrive_download FILEID FILENAME"
    echo "e.g. gdrive_download 1uBtlaggVyWshwcyP6kEI-y_W3P8D26sz foo.tar.gz"
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=$1 ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$1" -O $2 && rm -rf /tmp/cookies.txt
}

drive_download_small(){
    echo "drive_download_small FILEID FILENAME"
    echo "e.g. drive_download_small 1uBtlaggVyWshwcyP6kEI-y_W3P8D26sz foo.tar.gz"
    wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=FILEID' -O FILENAME
}
