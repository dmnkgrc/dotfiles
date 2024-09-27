function fzf --wraps="fzf"
    # Paste contents of preferred variant here
    set -Ux FZF_DEFAULT_OPTS "
    --color=fg:#f8f8f2,bg:#2a212c,hl:#544158
    --color=fg+:#c6c6c2,bg+:#544158,hl+:#a2ff99
    --color=border:#9f70a9,header:#3e8fb0,gutter:#9580ff
    --color=spinner:#ffaa99,info:#99ffee,separator:#544158
    --color=pointer:#aa99ff,marker:#ff80bf,prompt:#9f70a9"
    command fzf
end
