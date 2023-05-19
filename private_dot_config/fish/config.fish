if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
    set -x BASE16_SHELL_PATH "$HOME/.config/base16-shell"
    if test -s "$BASE16_SHELL_PATH"
        source "$BASE16_SHELL_PATH/profile_helper.fish"
    end
end
starship init fish | source
set -gx EDITOR nvim
zoxide init fish | source
rvm default

source $HOME/.config/fish/conf.d/abbr.fish
source /Users/dominikgarciabertapelle/.config/op/plugins.sh

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
set -Ux fish_tmux_config $HOME/.config/tmux/tmux.conf
set -Ux fish_greeting # disable fish greeting
set -x BASE16_TMUX_PLUGIN_PATH "$HOME/.config/tmux/plugins/base16-tmux"

fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/opt/openjdk@11/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.maestro/bin
fish_add_path $HOME/bin
