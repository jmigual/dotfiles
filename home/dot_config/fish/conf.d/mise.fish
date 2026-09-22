# Loads after 00_variables.fish (alphabetical order), so it survives the
# PATH reset in variables.fish. No-op on machines without mise.
if command -vq mise
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end
