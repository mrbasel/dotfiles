#!/bin/bash
#
# Start home tmux session if not already running, otherwise attach to last session

tmux=$(pgrep -l tmux)

if [[ -z "$tmux" ]]; then
    tmux new -A -s 'home'
else
    tmux attach
fi
