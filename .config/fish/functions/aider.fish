function aider
    set -gx OPENAI_API_KEY (op read "op://Personal/nmohiqxp53cvozhn4hbcdb5vxy/credential")
    set -gx GEMINI_API_KEY (op read "op://Personal/h7bbugyis5nu5u5ze5l7l47yge/credential")
    command aider "$argv"
end
