# Profile zsh
# -> https://blog.askesis.pl/post/2017/04/how-to-debug-zsh-startup-time.html
# zmodload zsh/zprof

source "$HOME/.zsh-opts"
source "$HOME/.zsh-histories"
source "$HOME/.zsh-completions"
source "$HOME/.zsh-keybinds"
source "$HOME/.zsh-aliases"
source "$HOME/.zsh-functions"
source "$HOME/.zsh-widgets"
source "$HOME/.zsh-prompt"


export LESS_TERMCAP_md=
export LESS_TERMCAP_se=
export LESS_TERMCAP_ue=
export LESSHISTFILE=
export LESS_TERMCAP_mbLESS_TERMCAP_me=
export LESS_TERMCAP_so=
export LESS_TERMCAP_us=


if ! [ "$TERM_PROGRAM" = "vscode" ]; then
    # echo "( .-.)"

    [ $(tput cols) -lt 80 ] && width=$(( $(tput cols) - 4 ))
    # # Wikidates
    # printf "%s\n" \
    #     "$(
    #         cat ~/.wikidates/$(LC_ALL=en_US.utf8 date +%B_%d) |
    #             shuf -n 1 |
    #             fold -s -w ${width:-76} |
    #             sed -e 's/^/    /'
    #     )"
    unset width

    # Idiom pracitce
    pick_idioms

fi


export _ZO_ECHO=1
eval "$(zoxide init zsh)"


# End profile zsh
# zprof


# TMP


export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"

PLAN9=/Users/ali/code/opt/plan9port
export PLAN9
PATH=$PATH:$PLAN9/bin
export PATH

# libxml2 for emacs build

  export PATH="/usr/local/opt/libxml2/bin:$PATH"

# For compilers to find libxml2 you may need to set:
  export LDFLAGS="-L/usr/local/opt/libxml2/lib"
  export CPPFLAGS="-I/usr/local/opt/libxml2/include"

# For pkg-config to find libxml2 you may need to set:
  export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"


#! Emacs
export PATH="/Applications/Emacs.app/Contents/MacOS/bin/:$PATH"
