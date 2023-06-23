if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
end
starship init fish | source
set -gx EDITOR nvim
zoxide init fish | source

source $HOME/.config/fish/conf.d/abbr.fish
source $HOME/.config/fish/conf.d/nightfox.fish
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
set -x MYVIMRC "~/.config/nvim/init.vim"
set -gx GPG_TTY (tty)
set -x NODE_OPTIONS "--max-old-space-size=9216"
set -x TURBO_TEAM nxt-dev1
set -gx PNPM_HOME /Users/dominikgarciabertapelle/Library/pnpm
set -x RUST_BACKTRACE full
set -x RUST_MIN_STACK 16777216
set -x JOSHUTO_CONFIG_HOME "$HOME/.config/joshuto"
set -Ux fish_tmux_autostart true
set -Ux fish_tmux_config $HOME/.config/tmux/tmux.conf
set -Ux fish_greeting # disable fish greeting
set -x PRETTIERD_LOCAL_PRETTIER_ONLY 1

fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/opt/openjdk@11/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.maestro/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/go/bin
set -gx PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/41941_1685363240445/bin $PATH
set -gx FNM_MULTISHELL_PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/41941_1685363240445
set -gx FNM_DIR "/Users/dominikgarciabertapelle/Library/Application Support/fnm"
set -gx FNM_LOGLEVEL info
set -gx FNM_ARCH arm64
set -gx FNM_VERSION_FILE_STRATEGY local
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
set -gx PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/48671_1685363413320/bin $PATH
set -gx FNM_LOGLEVEL info
set -gx FNM_NODE_DIST_MIRROR "https://nodejs.org/dist"
set -gx FNM_ARCH arm64
set -gx FNM_VERSION_FILE_STRATEGY local
set -gx FNM_DIR "/Users/dominikgarciabertapelle/Library/Application Support/fnm"
set -gx FNM_MULTISHELL_PATH /Users/dominikgarciabertapelle/Library/Caches/fnm_multishells/48671_1685363413320

# opam configuration
source /Users/dominikgarciabertapelle/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
status --is-interactive; and rbenv init - fish | source
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home