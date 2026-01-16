# fish completion for branchops

function __fish_branchops_using_command
    set -l cmd (commandline -opc)
    if [ (count $cmd) -eq 1 -a "$cmd[1]" = 'branchops' ]
        return 0
    end
    return 1
end

# Commands
complete -c branchops -f -n '__fish_branchops_using_command' -a 'create new' -d 'Create a new worktree'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'remove rm' -d 'Remove a worktree'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'ls list' -d 'List all worktrees'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'go' -d 'Navigate to a worktree'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'run' -d 'Run command in worktree'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'editor' -d 'Open in editor'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'ai' -d 'Start AI tool'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'copy' -d 'Copy files'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'dashboard status' -d 'Show status'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'ui' -d 'Open UI'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'hooks' -d 'Manage hooks'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'sync' -d 'Sync worktree'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'exec' -d 'Execute in all'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'backup restore' -d 'Config backup'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'clean doctor' -d 'Maintenance'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'config' -d 'Manage config'
complete -c branchops -f -n '__fish_branchops_using_command' -a 'completions' -d 'Shell completions'

# Flags for create/new
set -l create_cmds create new
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l from -d 'Base reference' -r
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l from-current -d 'From current'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l track -d 'Tracking mode' -xa 'auto true false'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l no-copy -d 'Skip copy'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l no-fetch -d 'Skip fetch'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l yes -d 'Non-interactive'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l force -d 'Force'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l name -d 'Custom name' -r
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l editor -d 'Open in editor'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l ai -d 'Start AI'
complete -c branchops -n "__fish_seen_subcommand_from $create_cmds" -l preset -d 'Apply preset' -r

# Branch completion
complete -c branchops -n '__fish_seen_subcommand_from remove rm go run editor ai hooks sync backup restore' \
    -a '(git branch --format=\'%(refname:short)\' 2>/dev/null)' -f

# Completions subcommand
complete -c branchops -n '__fish_seen_subcommand_from completions' -a 'bash zsh fish' -f

# Config subcommand
complete -c branchops -n '__fish_seen_subcommand_from config' -a 'get set list unset' -f
