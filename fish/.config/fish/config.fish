

# Enable vi key bindings
fish_vi_key_bindings

# Cursor shape 
set fish_cursor_default block
set fish_cursor_insert line
set fish_cursor_replace_one underscore
set fish_cursor_visual block

# Fix control-F issue: https://stackoverflow.com/questions/32037197/ctrl-f-no-longer-works-to-accept-suggestions-why
bind -M insert \cf accept-autosuggestion

# Aliases
alias t='tmux'
alias ff='fzf'
alias http='python3 -m http.server'
alias copy='xclip -sel clip'
alias btm='btm --mem_as_value -r 2000 --battery'

# Git aliases
alias gits='git status'
alias gitd='git diff'
alias gita='git add'
alias gitc='git commit'
alias gitp='git push'

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
