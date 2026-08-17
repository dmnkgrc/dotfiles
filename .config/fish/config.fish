if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end
starship init fish | source
set -gx EDITOR nvim
set -gx _ZO_EXCLUDE_DIRS "$HOME/google-cloud-sdk"
set -gx _ZO_MAXAGE 50000
zoxide init fish | source

source $HOME/.config/fish/conf.d/abbr.fish

if test -f ~/.config/fish/conf.d/secrets.fish
    source ~/.config/fish/conf.d/secrets.fish
end

set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git'"
set -x FZF_CTRL_T_COMMAND 'ag --hidden --ignore .git -g ""'
set -x LC_COLLATE "en_US.UTF-8"
set -x LC_CTYPE "en_US.UTF-8"
set -x LC_MESSAGES "en_US.UTF-8"
set -x LC_MONETARY "en_US.UTF-8"
set -x LC_NUMERIC "en_US.UTF-8"
set -x LC_TIME "en_US.UTF-8"
set -x LC_ALL "en_US.UTF-8"
set -x MYVIMRC "~/dotfiles/.config/nvim/init.vim"
set -gx GPG_TTY (tty)
set -x NODE_OPTIONS "--max-old-space-size=9216"
# Cache V8 compiled bytecode across runs so big CLIs (pi, tsc) skip re-parsing.
set -gx NODE_COMPILE_CACHE $HOME/.cache/node-compile-cache
set -gx PNPM_HOME /Users/dominikgarciabertapelle/Library/pnpm
set -x PRETTIERD_LOCAL_PRETTIER_ONLY 1
set -x FLAVOURS_CONFIG_FILE ~/.config/flavours/config.toml
set -x NO_FLIPPER 1
set -x BAT_THEME gruvbox-dark

# Nix/Home Manager packages are automatically added to PATH
# If you need to use Homebrew alongside Nix temporarily, uncomment:
# fish_add_path /opt/homebrew/bin
# fish_add_path /opt/homebrew/sbin
fish_add_path $PNPM_HOME
fish_add_path $HOME/bin
set -gx FNM_DIR "$HOME/Library/Application Support/fnm"
set -gx FNM_LOGLEVEL info
set -gx FNM_ARCH arm64
set -gx FNM_VERSION_FILE_STRATEGY local
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
# Per-project node: `fnm env` sets up a per-shell multishell dir so `fnm use` works,
# and --use-on-cd switches version on entering a dir with .node-version / .nvmrc.
# Falls back to the `default` alias so a missing fnm can't strip node from PATH.
if type -q fnm
    fnm env --use-on-cd | source
else
    set -gx PATH "$FNM_DIR/aliases/default/bin" $PATH
end
set -gx GOPATH /Users/dominikgarciabertapelle/code/go
set -gx AIDER_CODE_THEME nord-darker
set -gx AIDER_DARK_MODE true
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
set -gx VITE_POSTHOG_HOST https://eu.i.posthog.com
set -gx PATH ~/.npm-global/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dominikgarciabertapelle/google-cloud-sdk/path.fish.inc' ]
    . '/Users/dominikgarciabertapelle/google-cloud-sdk/path.fish.inc'
end

set -gx TERM xterm-256color
set -gx COLORTERM truecolor

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

alias lazygit 'lazygit --use-config-dir ~/.config/lazygit'
# pyenv. $PYENV_ROOT/bin is deliberately not on PATH: pyenv itself comes from nix and
# that directory does not exist. `pyenv init -` adds the shims, which is what matters.
set -gx PYENV_ROOT $HOME/.pyenv
pyenv init - | source
pyenv virtualenv-init - | source

# opencode
fish_add_path /Users/dominikgarciabertapelle/.opencode/bin
source "$HOME/.cargo/env.fish"  # For fish

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/dominikgarciabertapelle/.lmstudio/bin
# End of LM Studio CLI section
