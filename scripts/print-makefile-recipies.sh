#!/bin/sh

if [ -z "$1" ]; then
    makefile=Makefile
else
    makefile="$1"
fi

# Find all lines with words at the very beginning of the line,
# no comment mark or whitespace, and which ends with a colon ":"
grep -E '^\w+:' $makefile

