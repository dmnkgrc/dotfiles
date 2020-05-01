#!/bin/sh

for branch in $(git branch -a | sed 's/^\s*//' | sed 's/^remotes\///' | grep -v 'master$'); do
  last_commit_msg="$(git log --oneline --format=%f -1 $branch)"
  if [[ "$(git log --oneline --format=%f | grep $last_commit_msg | wc -l)" -eq 1 ]]; then
    if [[ "$branch" =~ "origin/" ]]; then
      local_branch_name=$(echo "$branch" | sed 's/^origin\///')
      echo "git push origin :$local_branch_name"
    else
      git branch -D $branch
    fi
  fi
done
