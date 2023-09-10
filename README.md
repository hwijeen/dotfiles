## Basics

* [System preferences](https://subicura.com/2017/11/22/mac-os-development-environment-setup.html)
* ssh configs, [ssh-copy-id](https://itzone.tistory.com/694)


## Oh-my-zsh

```bash
# oh-my-zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# chsh -s $(which zsh)

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM1:-$ZSH/custom}/plugins/alias-tips
# export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
```


## Homebrew for MacOS
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
brew doctor
brew update
brew bundle --file=dotfiles/.brewfile
```


## Etc for Ubuntu

```bash
# mamba
# https://mamba.readthedocs.io/en/latest/installation.html#fresh-install
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh

# fzf  # TODO maybe through mamba or something..
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```


## Misc

* 한컴오피스
* Goodnotes
* Toggl
* Spark
* Magnet
* Amphetamine
* Grammarly for Safari


## Notes
Apptivate
* option+a: Chrome
* option+s: Notion
* option+p: iTerm2
* option+[: Safari
* option+]: Slack
