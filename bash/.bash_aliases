#/usr/bin/env bash

alias cd="z"

# -----------------------------------------------------------------------------
# Disable "spell-correction" for this commands:
alias \
    cp="cp -iv"                                                               \
    mv="mv -iv"                                                               \
    rm="rm -v"                                                                \
    mkd="mkdir -pv"                                                           \
    ln="ln -iv"

# -----------------------------------------------------------------------------
# Colorize commands
alias \
    grep="grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"           \
    egrep="egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"         \
    fgrep="fgrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}"         \
    diff="diff"                                                               \

# ----------------------------------------------------------------------------
# ls
alias \
    ls='ls -hFG --color=auto'                                                 \
    l='ls'                                                                    \
    la='ls -A'                                                                \
    lla='ls -Al'                                                              \
    ll='ls -Ali'                                                              \
    sl='ls'

# -----------------------------------------------------------------------------
# Long commands
alias \
    bc='bc -ql'                                                               \
    df='df -h'                                                                \
    v="$EDITOR"                                                               \
    g="git"                                                                   \
    ka="killall"                                                              \
    type="type -a"                                                            \
    free='free -m'                                                            \
    chbin='chmod 755'                                                         \
    chreg='chmod 644'                                                         \
    wget="wget --hsts-file ~/.cache/wget-hsts"                                \
    myip="curl http://myip.dnsomatic.com && echo ''"                          \

# -----------------------------------------------------------------------------
# Directories
alias \
    cd..='cd ..'                                                              \
    cf="cd ${XDG_CONFIG_HOME:-$HOME/.config}"                                 \
    dl="cd ${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"                              \
    dt="cd ${XDG_DATA_HOME:-$HOME/.local/share}"                              \
    bin="cd $HOME/.local/bin"                                                 \
    doc="cd ${XDG_DOCUMENTS_DIR:-$HOME/Documents}"                            \
    pic="cd ${XDG_PICTURES_DIR:-$HOME/Pictures}"                              \
    vid="cd ${XDG_VIDEOS_DIR:-$HOME/Movies}"                                  \

# -----------------------------------------------------------------------------
# Config files
alias \
    cfz="$EDITOR $HOME/.zshrc"                                                \
    cfb="$EDITOR $HOME/.bashrc"                                               \
    cfzp="$EDITOR $HOME/.zprofile"                                            \
    cfbp="$EDITOR $HOME/.bash_profile"                                        \
    cfp="$EDITOR $HOME/.profile"                                              \
    cft="$EDITOR $HOME/.tmux.conf"                                            \
    cfa="$EDITOR ${HOME}/.bash_aliases"                                       \
    cfza="$EDITOR ${HOME}/.zsh-aliases"                                       \
    cfzf="$EDITOR ${HOME}/.zsh-functions"

# -----------------------------------------------------------------------------
# youtube-dl / yt-dlp

alias yt="yt-dlp --add-metadata -ci --external-downloader aria2c --external-downloader-args '-c -x 5 -k 2M '"    \
    yta="yt -x -f bestaudio/best"                                             \
    ytb="yt -f bestvideo+bestaudio"                                           \
    yt7="yt -f 'bestvideo[height<=?720]+bestaudio/best' "                     \
    yts="yt-dlp --all-subs --skip-download"                                   \
    ytas="yt-dlp --skip-download --write-auto-sub --convert-subs=srt"         \
    yt7pl="yt7 -o '%(playlist_index)s-%(title)s.%(ext)s'"                     \
    ytbpl="ytb -o '%(playlist_index)s-%(title)s.%(ext)s'"

# -----------------------------------------------------------------------------
# Other

# vim and neovim config
alias cfv="$EDITOR ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/init.lua"

# ascii table
alias ascii='man ascii | grep -m 1 -A 63 --color=never Oct | less'

# special regex
alias reg_mac='echo ^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$'
alias reg_git_hash='echo \b[0-9a-f]{5,40}\b'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Use nevim for vim if present.
command -v nvim >/dev/null && alias vimdiff="nvim -d"


alias v=nvim
alias of2112='. ~/OpenFOAM/OpenFOAM-v2112/etc/bashrc'
alias sz='. ~/.bashrc'
alias cfb='$EDITOR ~/.bashrc'

# enable color support of ls and also add handy aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

echo -ne '\e[2 q'

alias \
  cft="$EDITOR $HOME/.tmux.conf"                                             \
  cfA="$EDITOR ${XDG_CONFIG_HOME:-$HOME/.config}/alacritty/alacritty.toml"   \

alias mkd='mkdir -p'

# VPNs
alias vpn="export https_proxy=http://localhost:8081 http_proxy=http://localhost:8081"
alias vtor="export https_proxy=http://localhost:9080 http_proxy=http://localhost:9080"
alias vsocks="export https_proxy=socks5://localhost:9050 http_proxy=socks5://localhost:9050"
alias unvpn="unset http_proxy https_proxy"

# Homebrew
alias brew='HOMEBREW_NO_VERIFY_ATTESTATIONS=1 command brew'

# Ping
alias pg='ping -o google.com'
alias pgg='ping google.com'

# Wget
alias wget='wget --hsts-file ~/.cache/wget-hsts'
alias wgetc='wget -c'
alias rwget='wget -c --read-timeout=5 --timeout=5 --tries=0'
alias wwget='wget -c --read-timeout=0 --timeout=0 --tries=0'  # wait infintely (useful when it takes a long time to make connection)
alias wgeturls='wget -c -i urls'
alias wgetclip='wget -c "$(pbpaste)"'

# Latexmk and Pdftex
alias pdfmk='latexmk -dvi- -pdf -verbose -file-line-error -synctex=1 -interaction=nonstopmode -shell-escape -output-directory=build'

# OpenFOAM
of2412() {
    source ~/code/OpenFOAM-v2412/etc/bashrc || return 1
    [ -d ~/.OpenFOAM ] || return 1
    echo "$WM_PROJECT_VERSION" > ~/.OpenFOAM/currentSourceVersion
}
of2312() {
    source ~/code/opt/OpenFOAM/OpenFOAM-v2312/etc/bashrc || return 1
    [ -d ~/.OpenFOAM ] || return 1
    echo "$WM_PROJECT_VERSION" > ~/.OpenFOAM/currentSourceVersion
}
of9() {
    source ~/code/opt/OpenFOAM/OpenFOAM-9/etc/bashrc || return 1
    [ -d ~/.OpenFOAM ] || return 1
    echo "$WM_PROJECT_VERSION" > ~/.OpenFOAM/currentSourceVersion
}
of() {
    if ! [ -e ~/.OpenFOAM/currentSourceVersion ]; then
        echo "~/.OpenFOAM/currentSourceVersion Not found."
        echo "Please source one OpenFOAM version first manually."
        return 1
    fi
    currentSourceVersion="$(cat ~/.OpenFOAM/currentSourceVersion)"
    if [ -z "$currentSourceVersion" ]; then
        echo "No OpenFOAM environment was previously loaded."
        echo "~/.OpenFOAM/currentSourceVersion is empty."
        return 1
    fi
    source ~/code/opt/OpenFOAM/OpenFOAM-${currentSourceVersion}/etc/bashrc
    echo "OpenFOAM-$currentSourceVersion"
}
