#!/bin/sh -e

word="`fzf </usr/share/dict/words`"
def "$word"
