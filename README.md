## 0. Basics

* [블로그 글](https://subicura.com/2017/11/22/mac-os-development-environment-setup.html) 참고해서 system prefrences 설정
* App store
* Dotfiles clone(`git clone https://github.com/hwijeen/dotfiles`)
* ssh configs, [ssh-copy-id](https://itzone.tistory.com/694)



## 1. Install managers

``bash
# homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew doctor

# oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# chsh -s $(which zsh)
``



## 2. Using Homebrew

``bash
brew install --cask iterm2

brew install git

brew install vim

brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

brew install fzf

brew install tmux

brew install --cask docker

brew install --cask anaconda
# export PATH="/usr/local/anaconda3/bin:$PATH"

brew install jq

brew install bat

brew install tldr

brew install ctags

brew install --cask openinterminal-lite

brew install --cask keka

brew install --cask sublime-text

brew install --cask vlc

brew install --cask google-chrome

brew install --cask typora

brew install --cask notion

brew install --cask appcleaner

brew install --cask zoom

brew install --cask microsoft-office

brew install --cask obsidian

brew install --cask monitorcontrol

brew install --cask karabiner-elements
``



## 3. Using Oh-my-zsh

``bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips
# export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
``


## 4. Misc
* fzf
``
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
``

* 한컴오피스
* Goodnotes
* Toggl
* Spark
* magnet
* Amphetamine
