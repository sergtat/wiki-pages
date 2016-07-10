#!/bin/bash

IFS=';'

DIRS=$(find ./pages -type d | grep -v 'pages$' | sed 's@./@/home/serg/repo/sites/wiki/@' )

# echo ${DIRS}

for dir in ${DIRS}
do
	cd ${dir} && echo "[**«**](/index.md)\n" > index.md
done

unset IFS
