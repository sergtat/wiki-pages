#  Gentoo. Автоматизация обновления мира

Написал такой вот скрипт:
```
#!/bin/sh
# myupdate-world
# Скрипт обновления мира по утрам

LOG="/var/log/myupdate-world.log"
# log-файл
date >> $LOG
MIRROR=$(sed -n 's/^GENTOO_MIRRORS="\(.*\) .*/\1/p' /etc/make.conf)
# Задаем зеркало обновления
while ! $(wget --spider $MIRROR/snapshots/portage-$(date -d yesterday +%Y%m%d).tar.bz2.md5sum &>/dev/null); do sleep 300; done
# Проверяем наличие обновления, если не найдено, ждем 5 минут
EIX_CACHEFILE=/var/cache/eix.remote eix-remote update
# делаем снимок дерева удаленных layman-репозиториев
eix-sync -Wq
# синхронизируем наше дерево PORTAGE
echo "============ eix-diff ==============" >> $LOG
eix-diff /var/cache/eix.previous >> $LOG
# смотрим изменения в дереве
echo "============ emerge world =============" >> $LOG
emerge @world -pvquDN >> $LOG
emerge @world -uDNq
# смотрим что обновляем и зупускаем обновление мира
echo "============ emerge --depclean =============" >> $LOG
emerge --depclean -pq >> $LOG
emerge --depclean -q
# удаляем лишние пакеты
echo "=========== revdep-rebuild ===============" >> $LOG
revdep-rebuild -p >> $LOG
revdep-rebuild
# проверяем зависимости
echo "============ glsa-chech =============" >> $LOG
glsa-check --test affected >> $LOG
glsa-check --fix affected
# проверяем пакеты на безопасность
echo "========= eix-test-obsolete =========" >> $LOG
eix-test-obsolete -cd | grep -v "^No" >> $LOG
# проверяем корректность записей в /etc/portage/*
echo "========= perl-cleaner =========" >> $LOG
perl-cleaner --all -- -q
echo "============ End ============= " >> $LOG
export DISPLAY=":0.0"
export XAUTHORITY="/var/run/slim.auth"
# у меня slim, как в [gkx]dm не знаю, можно еще проверять $HOME/.Xauthority
/sbin/shutdown -h +5 "Achtung!" "Shutdown system after 5m\nFor canceled enter\n'sudo shutdown -c'" &
# выводим сообщение через zenity, что комьютер выключится через 5 минут, если нужно отменяем
echo "============ Halt ============= " >> $LOG
if ! $(/usr/bin/zenity --question --text="System shutdown after 5 minutes.\nNow $(date)."); then `sudo /sbin/shutdown -c`; fi
# если не отменили выключаем
```

Далее вставляем в cron от root:
```
# crontab -e
0 6 * * * /usr/local/sbin/myupdate-world
```

Включаем в BIOS авоматическое включение на 5.55 ежедневно.

Теперь можно не беспокоиться об обновлении уходя на работу. Осталось посмотреть вечером лог и поправить, если что-то пошло не так (маскировки, конфликты), что бывает редко. Это занимает времени совсем немного (можно раз в неделю).
Таким образом избегаем упреков домашних, бережем нервы, спасаем семью.

P.S. строчка
  # EIX_CACHEFILE=/var/cache/eix.remote eix-remote update
сохраняет снимок дерева layman-overlays в /var/cache/eix.remote .

Теперь делаем алиас:
  # alias eix-cache='EIX_CACHEFILE=/var/cache/eix.remote eix'

Смотрим наличие пакетов в оверлеях по команде eix-cache.
