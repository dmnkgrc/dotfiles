function wta
    git branch -a | fzf | sed 's/remotes\/origin\///' | xargs -I {} git worktree add ../{} {}
end