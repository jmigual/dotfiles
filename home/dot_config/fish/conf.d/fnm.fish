# Loads after 00_variables.fish (alphabetical order), so it survives the
# PATH reset in variables.fish. No-op on machines without fnm.
if command -vq fnm
    fnm env --use-on-cd --shell fish | source
end
