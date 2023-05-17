if status is-interactive
    # Commands to run in interactive sessions can go here
    atuin init fish | source
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
set -Ux fish_tmux_config $HOME/.config/tmux.conf
set -Ux fish_greeting # disable fish greeting

fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/opt/openjdk@11/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.maestro/bin
fish_add_path $HOME/bin

# Kanagawa
set -x FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS'
 --color=fg:#dcd7ba,bg:#1f1f28,hl:#54546d
 --color=fg+:#c8c093,bg+:#223249,hl+:#957fb8
 --color=info:#658594,prompt:#e46876,pointer:#FFA066
 --color=marker:#98bb6c,spinner:#ffa066,header:#7e9cd8'

# Rose pine
# export FZF_DEFAULT_OPTS="
# 	--color=fg:#908caa,bg:#191724,hl:#ebbcba
# 	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
# 	--color=border:#403d52,header:#31748f,gutter:#191724
# 	--color=spinner:#f6c177,info:#9ccfd8,separator:#403d52
# 	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

# Catppuccin Mocha
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
