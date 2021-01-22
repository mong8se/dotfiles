#!/bin/sh
unset COLORTERM
case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *.md) mdcat "$1";;
    *) highlight -O ansi --base16="$BASE16_THEME" "$1" || bat --plain --color always "$1" || cat "$1";;
esac
