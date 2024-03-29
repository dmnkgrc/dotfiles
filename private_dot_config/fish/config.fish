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
set -x MYVIMRC "~/.config/nvim/init.vim"
set -gx GPG_TTY (tty)
set -x NODE_OPTIONS "--max-old-space-size=9216"
set -x TURBO_TEAM nxt-dev1
set -gx PNPM_HOME /Users/dominikgarciabertapelle/Library/pnpm
set -x RUST_BACKTRACE full
set -x RUST_MIN_STACK 16777216
set -x JOSHUTO_CONFIG_HOME "$HOME/.config/joshuto"
set -x PRETTIERD_LOCAL_PRETTIER_ONLY 1
set -x SRC_ACCESS_TOKEN sgp_0fca7b77df0062eba238b680cd623f83c7f0b7f4
set -x SRC_ENDPOINT "https://sourcegraph.com"
set -x FLAVOURS_CONFIG_FILE ~/.config/flavours/config.toml
set -x NO_FLIPPER 1
set -x GITHUB_PACKAGES_TOKEN (op read "op://Private/GitHub Personal Access Token/token")
set -x OPENAI_API_KEY (op read "op://Private/OpenAI/credential")


fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
fish_add_path /usr/local/opt/openjdk@11/bin
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $HOME/.cargo/bin
fish_add_path $PNPM_HOME
fish_add_path $HOME/.maestro/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.tmux/plugins/t-smart-tmux-session-manager/bin
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

set -x JAVA_HOME /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
status --is-interactive; and rbenv init - fish | source

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
# Start flavours
# Base16 Kanagawa
# Scheme author: Originally by rebelot (Ported by montdor [https://github.com/montdor/])
# Template author: Tinted Theming (https://github.com/tinted-theming)

set -l color00 '#1f1f28'
set -l color01 '#2a2a37'
set -l color02 '#223249'
set -l color03 '#727169'
set -l color04 '#c8c093'
set -l color05 '#dcd7ba'
set -l color06 '#938aa9'
set -l color07 '#363646'
set -l color08 '#c34043'
set -l color09 '#ffa066'
set -l color0A '#dca561'
set -l color0B '#98bb6c'
set -l color0C '#7fb4ca'
set -l color0D '#7e9cd8'
set -l color0E '#957fb8'
set -l color0F '#d27e99'

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
# End flavours
