# RTK

When `rtk` is on PATH, prefix shell commands with it yourself to compress their output; Claude Code
has no RTK hook because auto mode denies commands a hook rewrites. Examples: `rtk git status`,
`rtk gh pr view`, `rtk ls`, `rtk find`, `rtk grep`/`rtk rg`, `rtk read <file>` (instead of `cat`),
`rtk cargo test`, `rtk pytest`, `rtk dotnet build`, `rtk docker ps`, `rtk curl`. `rtk --help` lists
the rest. Use the plain command, or `rtk proxy <cmd>`, when you need exact, unfiltered output.
