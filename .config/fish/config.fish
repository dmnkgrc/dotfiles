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
set -x RUST_BACKTRACE full
set -x RUST_MIN_STACK 16777216
set -x PRETTIERD_LOCAL_PRETTIER_ONLY 1
set -x SRC_ACCESS_TOKEN sgp_0fca7b77df0062eba238b680cd623f83c7f0b7f4
set -x SRC_ENDPOINT "https://sourcegraph.com"
set -x FLAVOURS_CONFIG_FILE ~/.config/flavours/config.toml
set -x NO_FLIPPER 1
set -x GITHUB_PACKAGES_TOKEN (op read "op://Private/GitHub Personal Access Token/token")
set -x OPENAI_API_KEY (op read "op://Private/OpenAI/credential")
set -x BAT_THEME kanagawa

fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/opt/openjdk@11/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.maestro/bin
fish_add_path $HOME/bin
fish_add_path $HOME/go/bin
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

set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
status --is-interactive; and rbenv init - fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
