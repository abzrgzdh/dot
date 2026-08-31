# Disable icon jumping in macos
# https://github.com/alacritty/alacritty/issues/2950#issuecomment-706610878
printf "\e[?1042l"

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export BROWSER=open
export READER="Skim"
export PAGER="less"
export TERM="tmux-256color" #xterm-256color

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export LESSHISTFILE='-' # no history file for less

export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_ANALYTICS=1
# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS='604800'
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_CURLRC=1 # ?

# python startup file
export PYTHONSTARTUP=~/.pystartup

# Colorful googletest in CMake
export GTEST_COLOR=1

# PATH
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.local/bin/scripts" ] ; then
    PATH="$HOME/.local/bin/scripts:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
    PATH="$HOME/go/bin:$PATH"
fi

# Python 3.13 environment as the base environment without prompt
#VIRTUAL_ENV_DISABLE_PROMPT=1 source ~/opt/py/3.13/bin/activate

# Neomutt
# On mac, probably for dns lookups, it opens with a 5-7 seconds startup delay,
# so, I bulid from source, with an extra flag: --with-domain
export PATH="$PATH:$HOME/opt/neomutt/bin"

# OpenCL cpp headers
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/opencl-clhpp-headers/share/pkgconfig"

# rust
export PATH="$PATH:$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin"

# haskell
export PATH="$HOME/.ghcup/bin:$PATH"

# (macos) Turn off icon bouncing (alacritty)
# https://github.com/alacritty/alacritty/issues/2950#issuecomment-706610878
printf "\e[?1042l"

# PETSC
export PETSC_DIR=/opt/homebrew/Cellar/petsc/3.*
# export PETSC_ARCH=arch-darwin-c-opt
# export PETSC_DIR=/Users/ali/code/opt/petsc

# Create some issues with Openfoam+Petsc
export HWLOC_COMPONENTS=-opencl

# PLANS
export PLANFILE="$HOME/..plann"

# C
# export LD_LIBRARY_PATH=/opt/homebrew/lib/:$LD_LIBRARY_PATH

# Necessary for OpenFOAM-esi on M1 Mac
# export CPATH="/opt/homebrew/include:$CPATH"
# export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"

# Enable memory leak detection for clang sanitizers
export ASAN_OPTIONS=detect_leaks=1

# curl
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
#export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/curl/lib"
#export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/curl/include"

# For pkg-config to find curl you may need to set:
export PKG_CONFIG_PATH="/opt/homebrew/opt/curl/lib/pkgconfig"

# GNU's version of info (texinfo)
export PATH="/opt/homebrew/opt/texinfo/bin:$PATH"

# GNU coreutils
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"

# GNU ed
export PATH="/opt/homebrew/opt/ed/bin:$PATH"

# GNU sed (needed by openfoam)
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"

# GNU awk
PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"

# GNU find, xargs
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"

# GNU make
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

# Paraview and friends
export PATH="/Applications/ParaView-5.10.1.app/Contents/bin:$PATH"

# Java (keg-only)
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# Dotnet
export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"

# M4
export PATH="/opt/homebrew/opt/m4/bin:$PATH"

# libxml2
export PATH="/opt/homebrew/opt/libxml2/bin:$PATH"
#export LDFLAGS="-L/opt/homebrew/opt/libxml2/lib $LDFLAGS"
#export CPPFLAGS="-I/opt/homebrew/opt/libxml2/include $CPPFLAGS"

# LAMMPS
export DYLD_LIBRARY_PATH="$HOME/.local/lib:$DYLD_LIBRARY_PATH"  # Macos

# PKG config
PKG_CONFIG_PATH="/opt/homebrew/lib/pkgconfig:$PKG_CONFIG_PATH"
PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
export PKG_CONFIG_PATH

# Temporary Testing at /var/tmp/local
export CMAKE_PREFIX_PATH="/var/tmp/local/lib/cmake:$CMAKE_PREFIX_PATH"
export PKG_CONFIG_PATH="/var/tmp/local/lib/pkgconfig:$PKG_CONFIG_PATH"
export DYLD_LIBRARY_PATH="/var/tmp/local/lib:$DYLD_LIBRARY_PATH"
export PATH="/var/tmp/local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"
# eval "$(mise activate zsh)"

# mpich
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/mpich/lib/pkgconfig"

# TensorforceFoam
export CPPFLOW_LIBRARIES=/opt/cppflow/
export TF_LIBRARIES="$(brew --prefix libtensorflow)"

# Macos minimum version
export MACOSX_DEPLOYMENT_TARGET="$(sw_vers | grep 'ProductVersion:' | awk '{print $2}')"  # man clang

# ffmpeg
#     ffmpeg-full includes additional tools and libraries that are not included
#     in the regular ffmpeg formula.
#
#     ffmpeg-full is keg-only, which means it was not symlinked into
#     /opt/homebrew, because this is an alternate version of another formula.
#
#     If you need to have ffmpeg-full first in your PATH, run:
#       echo 'export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"' >> ~/.zshrc
#
#     For compilers to find ffmpeg-full you may need to set:
#       export LDFLAGS="-L/opt/homebrew/opt/ffmpeg-full/lib"
#       export CPPFLAGS="-I/opt/homebrew/opt/ffmpeg-full/include"
#
#     For pkgconf to find ffmpeg-full you may need to set:
#       export PKG_CONFIG_PATH="/opt/homebrew/opt/ffmpeg-full/lib/pkgconfig"
export PATH="/opt/homebrew/opt/ffmpeg-full/bin:$PATH"
