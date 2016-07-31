# Пример правильного bash-скрипта.
Правильный bash-скрипт - это тот, который не запускается по ошибке
дважды, хорошо логирует что делает, и при прерывании не оставляет
мусора. Каркас такого скрипта может быть таким, как представлено ниже:

```bash
#/bin/bash

pidfile=./script.pid
logfile=./`date "+%Y-%m-%d"`.log
[ $# -eq 0 ] && dir=`pwd` || dir=$@

OnClose()
{
    echo "OK"
}
trap OnClose TERM INT

if [ ! -e $pidfile ]
then
    echo $$ > $pidfile
    date "+RUN %Y-%m-%d %H:%M $0" >> $logfile
    sleep 10
    date "+END %Y-%m-%d %H:%M $0" >> $logfile
    rm $pidfile
else
    echo "Error - check $pidfile"
fi
```
