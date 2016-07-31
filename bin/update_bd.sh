#!/bin/bash

cd ~/repo/sites/nnm_wiki2/public/pages

RD=(`ls -d */ | tr -d /`)
RL=${#RD[@]}

scanDirRecursive() {
  local x;
  for e in "$1"/*; do
    if [ -d "$e" -a ! -L "$e" ]
    then
      f="$e/index.md"

      echo "[**⇐**](../index.md)" > "$f"
      echo -e "[**⇑**](/index.md)\n" >> "$f"

      for ((i=0; i<${RL}; i++))  ; do
        echo -e "[**${RD[$i]}**](/${RD[$i]}/index.md)" >> "$f"
      done
      echo "" >> "$f"
      echo -e "# NoName Wiki" >> "$f"
      echo -e "##### ${e##*pages/}\n" >> "$f"
      
      if ls -d "${e}"/*/ > /dev/null 2>&1
      then
        echo -e "## Подразделы:" >> "$f"
      fi

      for d in "$e"/*; do
        if [ -d "$d" -a ! -L "$d" ]
        then
          echo "[**${d##${e}/}**](${d##*pages}/index.md)  " >> "$f"
        fi
      done

      echo "" >> "$f"

      if [[ $(ls -F -1 "$e" |egrep -v "index\.md|/$" | wc -l) -gt 0 ]]
      then
        echo -e "## Статьи:" >> "$f"
      fi

      for a in "$e"/*; do
        if [ -f "$a" ]
        then
          a1=${a##*/}
          if [[ $a1 = 'index.md' ]]; then  continue; fi
          echo -e "[${a1%.md}]("${a##*pages}")  " >> "$f"
        fi
      done

      scanDirRecursive "$e"
    # else
    #   scanDirRecursive "$e"
    fi
  done
}

[ $# -eq 0 ] && dir=`pwd` || dir=$@

scanDirRecursive "$dir"


echo -e "# NoName Wiki" > index.md
echo -e "## Разделы:" >> index.md
for ((i=0; i<${RL}; i++))  ; do
  echo -e "[**${RD[$i]}**](/${RD[$i]}/index.md)  " >> index.md
done

