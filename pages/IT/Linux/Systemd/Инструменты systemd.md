#  Инструменты systemd

##  Измерение скорости загрузки системы: systemd-analyze

Показать время загрузки:

    $ systemd-analyze

Вывод времени загрузки различными сервисов:

    $ systemd-analyze blame

Построение графика:

    $ systemd-analyze plot > plot.svg

Открыть полученное в Firefox:

    $ firefox plot.svg

з.ы. При желании, полученный svg файл можно сконвертировать в png формат командой:

    $ rsvg-convert plot.svg -o plot.png

##  Монтирование разделов внутренних жёстких дисков с помощью udisks

Создать файл:

```
[org.freedesktop.udisks.filesystem-mount-system-internal]
Identity=unix-group:*
Action=org.freedesktop.udisks.filesystem-mount-system-internal
ResultAny=auth_admin
ResultInactive=auth_admin
ResultActive=yes
```
