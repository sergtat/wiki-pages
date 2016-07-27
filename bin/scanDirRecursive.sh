#!/bin/bash
start() {
  local fullname="$1"
  local filename=`basename "$1"`
  local fileext="${filename##*.}"
  local ext2lower=`echo "$ext" | tr A-Z a-z`
  echo $fullname
}

scan() {
  local x;
  for e in "$1"/*; do
    x=${e##*/}
    if [ -d "$e" -a ! -L "$e" ]
    then
      echo $e
      scan "$e"
    # else
    #   start "$e"
    fi
  done
}

[ $# -eq 0 ] && dir=`pwd` || dir=$@

scan "$dir"

