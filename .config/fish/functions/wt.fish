function wt
    git worktree list | fzf --preview 'git -C {1} log --oneline -10' | awk '{print $1}' | xargs cd
end