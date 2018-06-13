#!/bin/bash

LLARR=$(ls -l --color=never| grep --color=never -v '^-rw' | tail -n+2)
# LLARR=$(echo -e ${LLARR} | sed 's/lrwxrwxrwx 11 serg serg \d\+ [^ ]\+ \d\+ \d\d:\d\d \(#.*\)$/\1/g')
echo -e ${LLARR}
