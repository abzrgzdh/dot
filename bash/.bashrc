# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

EDITOR=nvim
# test -f $HOME/.bash_profile && source $HOME/.bash_profile
test -f $HOME/.bash_aliases && source $HOME/.bash_aliases
test -f "$HOME/.bash_functions" && source "$HOME/.bash_functions"


# -->-- Shell Options --<--

# checks term size when bash regains control
shopt -s checkwinsize

# change to named directory
shopt -s autocd

# autocorrects cd misspellings
shopt -s cdspell

# save multi-line commands in history as single line
shopt -s cmdhist

# If set, Bash replaces directory names with the results of word expansion when
# performing filename completion.
#shopt -s direxpand

# Wildcards match dotfiles ("*.sh" => "foo.sh")
shopt -s dotglob

# append to the history file, do not overwrite history
shopt -s histappend

# expand aliases. use C-A-e for expantion
shopt -s expand_aliases

shopt -s no_empty_cmd_completion

# Allow ** for recursive matches ('lib/**/*.sh' => 'lib/a/b/c.sh')
shopt -s globstar


# -->-- History --<--

# Ignore duplicate and line starting space
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# Size of the history file
HISTSIZE=""
HISTFILESIZE=""
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"


# --*-- Other --*--

# Disable ctrl-s and ctrl-q.
stty -ixon

# Idiom of the shell
command pick_idioms
