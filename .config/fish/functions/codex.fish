function codex
    set -gx OPENAI_API_KEY (op read "op://Personal/nmohiqxp53cvozhn4hbcdb5vxy/credential")
    command codex "$argv"
end
