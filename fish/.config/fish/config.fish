

# Enable vi key bindings
fish_vi_key_bindings

# Fix control-F issue: https://stackoverflow.com/questions/32037197/ctrl-f-no-longer-works-to-accept-suggestions-why
bind -M insert \cf accept-autosuggestion

alias t='tmux'
alias ff='fzf'
alias http='python3 -m http.server'
alias copy='xclip -sel clip'

# Fzf aliases
alias sd='cd (fd --type directory | fzf)' # search directories
alias sf='cd (fd | fzf)' # search files and directories
alias sh='fish (history | fzf)' # search history


# Navigation aliases
alias home='cd ~'
alias back='cd ..'
alias dots='cd ~/.dotfiles'
alias dev='cd ~/dev'
alias downloads='cd ~/Downloads'
alias docs='cd ~/Documents'
alias pics='cd ~/Pictures'
alias music='cd ~/Music'
