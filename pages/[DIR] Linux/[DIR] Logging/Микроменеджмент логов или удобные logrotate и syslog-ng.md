# Микроменеджмент логов или удобные logrotate и syslog-ng.
Заголовок слегка отдает желтизной, но Бог бы с ним. А суть вот в чем: ничто не сравнится с запахом свежих логов по утрам. Особенно если эти логи рассортированны по категориям (в моем простейшем случае по демонам, которые эти самые логи генерят), и еще хорошо если оно все само падает в почтовый ящик – только открыть и наслаждаться. Рассказывать как настроить авторассылку логов не буду. И про синтаксис конфигов тоже не буду распинаться. А просто, по совему обыкновению, предложу скрипт, который позволяет выделить некоторую маску имени демона в отдельный лог-файл, который будет усердно вращаться и слаться куда надо в соответствии с настройками logrotate. Все рассчитано на gentoo, как можно догадаться.

Итак, собственно, сам скрипт вот он

```bash
#!/bin/bash
#    Syslogrotate-gen v. 1.0
#    
#    This program is meant to minimize effort in simple yet efficent
#    sorting of logs from various daemons to separate log files. It 
#    was designed to work with logroatate and syslog-ng on Gentoo
#    Linux baselayout-2.
#
#    (c) by Nikolay "Livid" Yakimov 2010 (root@livid.pp.ru)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see .

# In orger for this to work, you need to change
# /etc/syslog-ng/syslog-ng.conf according to diff:
# ---------------------------------------------
# -log { source(src); destination(messages); };
#  log { source(src); destination(console_all); };
# +include "/etc/syslog-ng/individual-daemons.inc";
# +log { source(src); destination(messages); };
# ---------------------------------------------
# PLEASE DO NOT SET $SYSLOGCONF TO
# /etc/syslog-ng/syslog-ng.conf -- it will break things horribly.
SYSLOGCONF="/etc/syslog-ng/individual-daemons.inc"
LOGROTATEDIR="/etc/logrotate.d"

logfile() {
   [ -d "/var/log/${@}" ] || (echo "Making /var/log/${@}" >&2; mkdir "/var/log/${@}")
 echo "/var/log/${@}/${@}.log"
}

usage() {
 echo "$0 (add|del) match_str [match_str...]"
   exit 1
}

localn() {
   echo -n "${1//[^A-Za-z0-9-]/_}"
}

syslog-conf() {
local N=`localn "$1"`
cat << CONF
# {{{ $1
destination ${N} { file("`logfile ${N}`"); };
filter $N { program("$1"); };
log { source(src); filter($N); destination($N); flags(final); };
# }}} $1
CONF
}

logrotate-conf() {
local N=`localn "$1"`
cat << CONF
`logfile ${N}` {
    missingok
    sharedscripts
    postrotate
        /etc/init.d/syslog-ng reload > /dev/null 2>&1 || true
    endscript
}
CONF
}

toLower() {
 echo -n "$@" | tr "[:upper:]" "[:lower:]" 
} 

add_daemon(){
   local N=`localn "$1"`
  if grep -e "^# {{{ ${1}$" "$SYSLOGCONF" > /dev/null; then
      echo "Daemon ${1} entry already exists in $SYSLOGCONF. Skipping" >&2
   else
       echo "Writing daemon ${1} entry into $SYSLOGCONF" >&2
      syslog-conf "$1" >> $SYSLOGCONF
    fi
 local LOGROTNAME="${LOGROTATEDIR}/${N}"
    if [ -e "$LOGROTNAME" ]; then
      if diff "$LOGROTNAME" <(logrotate-conf "$1") >/dev/null; then #files match
         echo "Logrotate file for daemon $1 exists and matches stock. Skipping" >&2
     else
           echo "Logrotate file for daemon $1 exists and reads as follows:" >&2
           cat "$LOGROTNAME" >&2
          while true; do
             local REPLACE=""
               read -p "Replace? (yes/no/diff)" REPLACE
               case `toLower $REPLACE` in
             y|yes)
                 echo "Writing daemon ${1} entry into $LOGROTNAME" >&2
                  logrotate-conf "$1" > "$LOGROTNAME"
                    break
                  ;;
             n|no)
                  echo "Skipping" >&2
                    break
                  ;;
             d|diff)
                    echo "Differences:" >&2
                    diff "$LOGROTNAME" <(logrotate-conf "$1") | colordiff
                  ;;
             *) echo "Sorry, reply not understood: '$REPLACE'" >&2 ;
                esac
           done
       fi
 else
       echo "Writing daemon ${1} entry into $LOGROTNAME" >&2
      logrotate-conf "$1" > "$LOGROTNAME"
    fi
}

del_daemon(){
    local N=`localn "$1"`
  if grep -e "^# {{{ ${1}$" "$SYSLOGCONF" > /dev/null; then
      echo "Removing daemon ${1} entry from $SYSLOGCONF" >&2
     sed -i "/^# {{{ ${1}$/,/^# }}} ${1}$/ d" "$SYSLOGCONF"
 else
       echo "There is no daemon ${1} entry in $SYSLOGCONF" >&2
    fi
 local LOGROTNAME="${LOGROTATEDIR}/${N}"
    if [ -e "$LOGROTNAME" ]; then
      echo "Removing $LOGROTNAME" >&2
        rm -v "$LOGROTNAME"
    else
       echo "There is no daemon ${1} entry in $LOGROTATEDIR" >&2
  fi
}

arg_unwind() {
# arg1: function
# argN: args to unwind    
   local cmd=$1
   shift
  while [ $# -gt 0 ]; do
     "$cmd" "$1"
        shift
  done
}

list_daemons() {
   local daemon=""
    echo -e "daemon\t\tlogrotate"
  sed -n 's:^# {{{ ::p' "$SYSLOGCONF" | while read daemon; do
        local N=`localn "$daemon"`
     local LOGROTNAME="${LOGROTATEDIR}/${N}"
        local logrotate=""
     if [ -e "$LOGROTNAME" ]; then
          if diff "$LOGROTNAME" <(logrotate-conf "$daemon") >/dev/null; then #files match
                logrotate="ok"
         else
               logrotate="diff"
           fi
     else
           logrotate="ne"
     fi
     echo -e "$daemon\t\t$logrotate"
    done
}


[ -e "$SYSLOGCONF" ] || echo "# vim: set filetype=conf foldmethod=marker :" > "$SYSLOGCONF"

ACTION=$1
shift

case "$ACTION" in
   add) arg_unwind add_daemon $@;;
    del) arg_unwind del_daemon $@;;
    list) list_daemons;;
   *) usage;;
esac

```
Безусловно, тут полно велосипедов и прочей радости, но в целом качество кода удовлетворительное, даже, можно сказать, приличное. Чтобы воспользоваться скриптом требуется одна модификация конфига syslog-ng, а именно в файле /etc/syslog-ng/syslog-ng.conf перенести строчку

```bash
log { source(src); destination(messages); };
```
в конец файла и над ней добавить

```bash
include "/etc/syslog-ng/individual-daemons.inc";
```
Для энтузиастов вот diff:

```bash
--- /etc/syslog-ng/syslog-ng.conf.dist    2009-09-07 15:35:33.000000000 +0400
+++ /etc/syslog-ng/syslog-ng.conf   2010-02-24 13:42:42.000000000 +0300
@@ -28,5 +28,6 @@
 # and uncomment the line below.
 #destination console_all { file("/dev/console"); };
 
-log { source(src); destination(messages); };
 log { source(src); destination(console_all); };
+include "/etc/syslog-ng/individual-daemons.inc";
+log { source(src); destination(messages); };
```
Используется сей продукт воспаленного мозга следующим образом: `$0 (add|del) match_str [match_str…]`

Переводя на русский, если скрипт называется syslogrotate, и лежит в текущей директории, то делаем так:

```bash
./syslogrotate add 'expression' #добавляем фильтр 'expression'
```
Теперь логи, которые пишет (через syslog) демон с именем, попадающем под expression (regex, подробности в манах syslog-ng), будут сохраняться в файл /var/log/expression/expression.log Имя файла старательно приводится в божеский вид – все не альфанумерики аккуратно так заменяются на символ нижнего подчеркивания. ВАЖНО, что коллизии имен не проверяются – так что именно вам придется за этим следить. Желающие могут доработать этот недостаток, пока этого не сделал я сам (что, вообще говоря, не обязательно скоро произойдет).

```bash
./syslogrotate del 'expression' #удаляем, все вернется на круги своя
```
При запуске с параметром list выводит список текущих фильтров и соответсвтуют ли они последней версии logrotate-овского конфига.
