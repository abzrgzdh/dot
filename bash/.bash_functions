#!/bin/bash

# FUNCTIONS
# -----------------------------------------------------------------------------

# Dictionary (sdcv)
# Data in ~/.local/share/stardict/dic/
d() {
    [ $(tput cols) -lt 80 ] && local width=$(tput cols)
    sdcv -n --utf8-output --color "$@" 2>&1 \
        | sed 's/<br>/\n/g' \
        | sed 's/<BR>/\n/g' \
        | sed -e 's/<[^>]*>//g' \
        | fold -s -w ${width:-80} | less -FRX
}

# Extract everything
ex() {
    # -- ARCHIVE EXTRACTION
    # usage: ex <file>
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# b - browse chrome bookmarks (dependency: jq)
bk() {
     bookmarks_path=~/.config/BraveSoftware/Brave-Browser/Default/Bookmarks

     jq_script='
        def ancestors: while(. | length >= 2; del(.[-1,-2]));
        . as $in | paths(.url?) as $key | $in | getpath($key) | {name,url, path: [$key[0:-2] | ancestors as $a | $in | getpath($a) | .name?] | reverse | join("/") } | .path + "/" + .name + "\t" + .url'

    jq -r "$jq_script" < "$bookmarks_path" \
        | sed -E $'s/(.*)\t(.*)/\\1\t\x1b[36m\\2\x1b[m/g' \
        | fzf --layout=reverse --ansi \
        | cut -d$'\t' -f2 \
        | xargs xdg-open &>/dev/null
}

# go to the root of the project seamlessly
cdp() {
    TEMP_PWD=`pwd`
    while ! [ -d .git ]; do
        cd ..
    done
    OLDPWD=$TEMP_PWD
}

# go to the directory of a background job
# source: https://unix.stackexchange.com/a/82217/419393
cdjob () {
    pid=$(jobs -p $1);
    d=$(readlink /proc/$pid/cwd);
    cd "$d"
}

# Download papers from scihub
shdl1() { curl -O $(curl -s https://sci-hub.se/"$@" | grep location.href | grep -o http.*pdf) ;}
shdl2() { curl -O "https:"$(curl -s https://sci-hub.se/"$@" | grep location.href | grep -o '//.*pdf') ;}

# Create a directory and take me there
take() { mkdir $1 && cd $1 ;}

# LLVM tools environment
llvm_load () {
	export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
	export CC="/opt/homebrew/opt/llvm/bin/clang"
	export CXX="/opt/homebrew/opt/llvm/bin/clang++"
	export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/llvm/lib"
	export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/llvm/include -Wall -Wextra"
	export CFLAGS="$CFLAGS -I/opt/homebrew/opt/llvm/include -Wall -Wextra"
}


# Then use y instead of yazi to start, and press q to quit, you'll see the CWD changed. Sometimes,
# you don't want to change, press Q to quit.
function lf() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
