# AGENTS.md — environment setup & conventions

Purpose: an agent can read this file and **set up this user's environment from
scratch on a new machine**, then keep editing it correctly afterwards. It has
two parts: the **setup sequence** (run this to bootstrap) and the
**conventions** (invariants to respect when changing anything later).

Home (`/mnt/home`) is shared NFS on the cluster, so on Linux compute nodes most
of this only needs doing once and is then visible from every node.

---

## How the agent should use this doc

1. **Detect the platform** and pick the matching commands:
   - macOS laptop (`uname` = `Darwin`, has `sudo`, system Homebrew), or
   - Linux compute node (`uname` = `Linux`, **no sudo**, Homebrew under `~/.local`).
2. **Run the Setup sequence in order.** Steps are idempotent — re-running is
   safe; skip a step if its verify check already passes.
3. **Never do the Manual steps yourself** (GUI/permissions/credentials). Collect
   them and hand them to the human at the end.
4. **Put secrets / host-specific config in `~/.bash_profile`** (untracked), never
   in the tracked `.zshrc`. See Convention §1.
5. After each step, **verify** with the given check before moving on.

Prereqs: `curl`, `git`. macOS: from Xcode CLT (`xcode-select --install` — Manual
if missing). Linux nodes: usually already present.

---

## Setup sequence (agent-executable)

### 0. Get the repo
```bash
[ -d ~/dotfiles ] || git clone https://github.com/hwijeen/dotfiles.git ~/dotfiles
```

### 1. zsh + oh-my-zsh + plugins
`.zshrc` needs `ZSH_THEME="simple"` and
`plugins=(git docker alias-tips zsh-autosuggestions zsh-syntax-highlighting fzf)`.
```bash
# zsh present? (macOS ships zsh; Linux may need sudo -> Manual step)
command -v zsh || echo "MANUAL: install zsh (needs sudo on Linux)"

# oh-my-zsh (idempotent) — same on mac & linux
[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended

ZC=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
[ -d "$ZC/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZC/plugins/zsh-syntax-highlighting"
[ -d "$ZC/plugins/zsh-autosuggestions" ]     || git clone https://github.com/zsh-users/zsh-autosuggestions       "$ZC/plugins/zsh-autosuggestions"
[ -d "$ZC/plugins/alias-tips" ]              || git clone https://github.com/djui/alias-tips.git                 "$ZC/plugins/alias-tips"
```
Verify: `ls ~/.oh-my-zsh "$ZC"/plugins`.

### 2. Homebrew + CLI tools + fzf + git-lfs
Homebrew install and fzf setup **differ by platform**. The `.brewfile` mixes
formulae (CLI tools) with macOS-only casks (GUI apps) — on Linux install only
the formulae.

**macOS** (system Homebrew; path differs Apple Silicon vs Intel):
```bash
command -v brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# detect brew path (Apple Silicon: /opt/homebrew, Intel: /usr/local)
BREW="$(command -v brew || echo /opt/homebrew/bin/brew)"; [ -x "$BREW" ] || BREW=/usr/local/bin/brew
grep -q 'brew shellenv' ~/.bash_profile || echo "eval \"\$($BREW shellenv)\"" >> ~/.bash_profile
eval "$($BREW shellenv)"
brew bundle install --file=~/dotfiles/.brewfile   # formulae + casks (iterm2, nerd-font, apps)
# fzf keybindings/completion -> generates ~/.fzf.zsh (sourced by .zshrc)
[ -f ~/.fzf.zsh ] || "$(brew --prefix)/opt/fzf/install" --all --no-update-rc
git lfs install
```

**Linux compute node** (no sudo — Homebrew unpacked under `~/.local`):
```bash
if [ ! -x ~/.local/Homebrew/bin/brew ]; then
  mkdir -p ~/.local/Homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.local/Homebrew
  mkdir -p ~/.local/bin && ln -sf ~/.local/Homebrew/bin/brew ~/.local/bin/brew
fi
# ensure brew (and its shims) are found in fresh shells
grep -q '.local/bin' ~/.bash_profile || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
export PATH="$HOME/.local/bin:$PATH"
# install only the FORMULAE from the brewfile (skip macOS casks)
brew bundle install --file=<(grep '^brew ' ~/dotfiles/.brewfile)
git lfs install
# fzf from git (not brew) -> generates ~/.fzf.zsh (sourced by .zshrc)
[ -f ~/.fzf.zsh ] || { [ -d ~/.fzf ] || git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf; ~/.fzf/install --all; }
# (optional) mambaforge for Python envs — ask the human before installing.
```
Verify: `brew --version` (Linux: `~/.local/bin/brew --version`),
`command -v fzf rg git-lfs`, `[ -f ~/.fzf.zsh ]`, `git lfs version`.

### 3. Symlink the tracked dotfiles
```bash
bash ~/dotfiles/create_link.sh   # ln -sf ~/.vimrc ~/.zshrc ~/.gitconfig ~/.tmux.conf
```
Verify: `ls -l ~/.zshrc` is a symlink into `~/dotfiles/.zshrc`. Must run before
step 4 (vim/tmux read the symlinked configs). `.gitconfig` already sets
user.name/email + `credential.helper=store` + the git-lfs filters.

### 4. Editor + tmux plugins (same on mac & linux; needs vim/tmux from step 2)
`.vimrc` uses **vim-plug** (auto-installs itself via curl); `.tmux.conf` uses
**TPM**, which must be cloned.
```bash
# vim plugins — synchronous so it doesn't race/hang
vim +'PlugInstall --sync' +qa

# tmux TPM + plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins
```
Verify: `ls ~/.vim/plugged` (nerdtree, vim-airline, …) and `ls ~/.tmux/plugins`
(tpm). Inside tmux, plugins can also be (re)installed with `prefix + I`.

Note: `.vimrc` ALE config references linters/formatters (`ruff`, `shellcheck`,
`shfmt`, `prettier`, `pandoc`) that are NOT in the brewfile — vim works without
them; install on demand (brew / uv tool / npm) if you use those workflows.

### 5. Personal scripts (`~/bin`) — do this before step 6 sources them
```bash
mkdir -p ~/bin   # PATH is added from ~/dotfiles/.zshrc
```
Populate with the user's executable scripts (e.g. `gpu-quota`, …) plus the
sourced libraries `fast-fs.sh` / `cache-redirect.sh` — copy from another
node/backup. Verify (fresh zsh): `command -v gpu-quota` resolves under `~/bin`.

### 6. Machine-specific shell config (`~/.bash_profile`, untracked)
Add host-specific loaders (see §1). Guard every `source` so a missing file never
breaks shell startup:
```bash
[ -f "$HOME/bin/cache-redirect.sh" ] && source "$HOME/bin/cache-redirect.sh"
[ -f "$HOME/bin/fast-fs.sh" ]        && source "$HOME/bin/fast-fs.sh"
```
Also here (machine/user-specific, as needed): `brew shellenv` (macOS, added in
step 2), `~/.local/bin` PATH (Linux, added in step 2), NVM loader, the MAI Agents
environment loader, and any tokens/credentials. Do NOT put these in the tracked
`.zshrc`.

### Optional runtimes (only if you use MAI/yolo workflows)
Not needed for a bare shell, but several helpers assume them:
- **uv** (used by `fast-fs.sh` / yolo): `curl -LsSf https://astral.sh/uv/install.sh | sh`
- **NVM + Node** (loaded from `~/.bash_profile`):
  `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash` then `nvm install --lts`
- **conda / miniforge** for Python: cluster nodes use
  `/mnt/vast/python/miniconda3`; on a laptop install miniforge (see README).
  This is yolo/cluster-specific — treat as a prerequisite, not part of the base
  shell.

### Final: reload
```bash
exec zsh   # confirm no errors and PATH includes ~/bin
```

---

## Manual steps (agent must NOT do — hand these to the human)

Require GUI interaction, admin rights, or credentials the agent lacks:

- **Xcode Command Line Tools** (macOS, if `git`/`curl` missing): `xcode-select --install`.
- **macOS Homebrew install** may prompt for a sudo password — if so, becomes Manual.
- **Install zsh on Linux** if absent (needs `sudo`).
- **Set zsh as the default shell**: `chsh -s $(which zsh)` (needs the shell in
  `/etc/shells`; may need admin).
- **macOS system preferences**: https://subicura.com/2017/11/22/mac-os-development-environment-setup.html
- **iTerm2** (macOS):
  - Import profile: Settings → Profiles → Other Actions → *Import JSON Profiles*
    → `~/dotfiles/hwijeen_iterms.json`.
  - Import colors: Settings → Profiles → Colors → Color Presets → *Import* →
    `~/dotfiles/Nord.itermcolors`, then select **Nord**.
  - Set font to the installed Nerd Font (`font-hack-nerd-font`) under Profiles → Text.
- **GUI app permissions** (brewfile casks): grant Accessibility/Input access to
  Karabiner-Elements, Rectangle, MonitorControl, OpenInTerminal, Caffeine.
- **SSH keys**: generate + `ssh-copy-id` to your hosts (https://itzone.tistory.com/694).
- **Secrets/tokens**: host LiteLLM credentials, API tokens, etc. — provide them,
  then they load via `~/.bash_profile`.

---

## Known caveats

- `.tmux.conf` hardcodes `set -g default-shell /usr/bin/zsh` (and
  `default-command`). That path is correct on the Linux nodes but wrong on macOS
  (`/bin/zsh`). On a Mac, override it in a machine-local tmux include or adjust
  the path; otherwise new panes may fail.
- The Homebrew tarball install (Linux) and `install.sh` (macOS) pull `HEAD` /
  latest; pin versions only if reproducibility matters.

---

## Conventions (invariants — respect when changing anything later)

### §1. `.zshrc` vs `.bash_profile`
- **`~/.zshrc` is a symlink to `~/dotfiles/.zshrc`** (git-tracked, created by
  `create_link.sh`). Keep it **portable and clean**: generic config, aliases,
  functions, PATH additions valid on any machine. Editing it edits the tracked
  file — commit in `~/dotfiles`.
- **`~/.bash_profile` is machine-specific and NOT tracked.** `~/.zshrc` sources
  it early, so its exports apply in zsh too. Host-specific loaders/secrets go
  here: NVM, MAI Agents env loader, `brew shellenv`, `~/.local/bin` PATH,
  `fast-fs.sh` sourcing, etc.
- **Rule:** machine-specific / secret / host-path-bound → `~/.bash_profile`.
  Portable → tracked `~/dotfiles/.zshrc`. Never put machine-specific blocks in
  the tracked `.zshrc`.

### §2. Custom bins vs Homebrew-owned bins
- **`~/bin` = hand-written personal scripts** (the place for custom tools). Added
  to PATH from `~/dotfiles/.zshrc`. Contents: personal executables (e.g.
  `gpu-quota`), the `node`/`npm`/`npx` symlinks, and the sourced libraries
  `fast-fs.sh` / `cache-redirect.sh`.
- **`~/.local/bin` = Homebrew-managed** (~130 symlinks into
  `~/.local/Homebrew/Cellar`/`Caskroom`, incl. `brew` and other brew-installed
  CLIs). **Do not** hand-place scripts here — they get lost among managed
  symlinks and `brew` may disturb them.
- **Rule:** author a script → `~/bin`. Never hand-place files in `~/.local/bin`.
- Note: `~/bin` also holds sourced shell **function libraries**
  (`fast-fs.sh`, `cache-redirect.sh` — defining `mkfast`/`syncfast`/`lsfast`).
  These are NOT executables; they're `source`d from `~/.bash_profile`, not run
  as commands. They self-resolve their own path (`BASH_SOURCE`), so they work
  from `~/bin`. Keep them non-executable (`-rw-r--r--`) to signal "source me,
  don't exec me".
