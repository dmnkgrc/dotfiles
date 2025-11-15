if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end
starship init fish | source
set -gx EDITOR nvim
zoxide init fish | source

source $HOME/.config/fish/conf.d/abbr.fish
source $HOME/.config/op/plugins.sh

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
set -gx PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/41941_1685363240445/bin $PATH
set -gx FNM_MULTISHELL_PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/41941_1685363240445
set -gx FNM_DIR "/Users/dominikgarciabertapelle/Library/Application Support/fnm"
set -gx FNM_LOGLEVEL info
set -gx FNM_ARCH arm64
set -gx FNM_VERSION_FILE_STRATEGY local
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
set -gx GOPATH /Users/dominikgarciabertapelle/code/go
set -gx PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/48671_1685363413320/bin $PATH
set -gx FNM_LOGLEVEL info
set -gx AIDER_CODE_THEME nord-darker
# set -gx OPENROUTER_API_KEY (op read "op://Personal/OpenRouter/credential")
set -gx AIDER_DARK_MODE true
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
set -gx VITE_POSTHOG_KEY phc_cz3O8sw5qCHsv2ZUOjOaD9DupP8STFMu1b3WvOrN48N
set -gx VITE_POSTHOG_HOST https://eu.i.posthog.com
set -gx PATH ~/.npm-global/bin $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -Ux PYENV_ROOT $HOME/.pyenv
set -U fish_user_paths $PYENV_ROOT/bin $fish_user_paths

# Load pyenv automatically by appending
# the following to ~/.config/fish/config.fish:

pyenv init - | source

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/dominikgarciabertapelle/google-cloud-sdk/path.fish.inc' ]
    . '/Users/dominikgarciabertapelle/google-cloud-sdk/path.fish.inc'
end

set -gx TERM xterm-256color
set -gx COLORTERM truecolor

# Added by Windsurf
fish_add_path /Users/dominikgarciabertapelle/.codeium/windsurf/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

alias lazygit 'lazygit --use-config-dir ~/.config/lazygit'
alias claude="/Users/dominikgarciabertapelle/.claude/local/claude"
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

# Initialize pyenv
pyenv init - | source

# Initialize pyenv-virtualenv
pyenv virtualenv-init - | source

# opencode
fish_add_path /Users/dominikgarciabertapelle/.opencode/bin
