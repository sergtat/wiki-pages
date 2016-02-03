#  Настройка conky. Индикация состояния системы в Linux.
Весьма удобно следить за состоянием своей системы, не слишком отрываясь от других задач. Здорово бросить взгляд на информативную панельку – и сразу получить всю информацию о работы системы, которая нужна. Именно для этих целей есть системные мониторы, например conky. Настроить conky в Linux очень просто, о чём и будет этот пост.

##  Умолчания, стиль и необходимость настройки conky
По умолчанию, установленный conky выглядит жутковато. Это такой тонкий намёк на то, что программу нужно подгонять под себя и свои представления об удобстве. Дело это до некоторой степени кропотливое, но сделав это раз, потом много раз экономим время.

Настраивается conky через свой конфиг, который нужно скопировать из /usr/share/doc/conky/examples/ в свой домашний каталог и переименовать в .conkyrc
Теперь открываем конфиг в своём любимом текстовом редакторе и начинаем его смотреть. Делится конфиг на две части: первая часть отвечает за то, как будет выглядеть системный монитор, а вторая – что он, собственно, будет отображать. Деление не строгое, и открыв конфиг, можно понять, почему.

##  Настраиваем conky под себя
В первой части конфиг довольно хорошо прокомментирован (во всяком случае, в Дебиане). Несколько наиболее важных параметров приведу ниже. Но прежде, чем вы начнёте запускать и пробовать, нужно кое-что учесть.

Во-первых, процесс это увлекательный и может отвлечь на долго (у меня это отняло вечер).

Во-вторых, процесс это исключительно интерактивный: меняете настройку – прибиваете текущий процесс conky – запускаете новый – смотрите – меняете настройку… и так далее. Лучше руководствоваться Первой Заповедью Радиотехники – “Не крути две ручки сразу“. Иначе потом трудно ловить ошибки в конфиге и думать, что привело к нежелательным последствиям.

Итак, первая часть параметров отвечает за то, как будет выглядеть системный монитор. Здесь можно выбрать, в частности, шрифт и его параметры:

```bash
# Xft font when Xft is enabled
xftfont Bitstream Vera Sans Mono:size=9
```

Время обновления, если в этом нет насущной необходимости, лучше ставить 1-2 секунды, хотя можно и меньше (тогда возрастает потребление ресурсов):

```bash
# Update interval in seconds
update_interval 2.0
```

Расположение по углам экрана, что тоже хорошо прокомментировано и потому понятно:

```bash
# Text alignment, other possible values are commented
#alignment top_left
#alignment top_right
#alignment bottom_left
alignment bottom_right
```

[Ещё подробностей можно прочитать в официальном FAQ conky](http://conky.sourceforge.net/faq.html) или, пользуясь своими знаниями английского, догадаться :-)

Это всё довольно просто – главное развлечение начинается при настройке переменных, которые и будут отображаться. Лучше всего за основу взять какой-нибудь образцовый конфиг отсюда и брать понравившиеся элементы. В этой замечательной статье (на русском!) есть много интересных идей – только читать её нужно с конца (пропуская философские отвлечения).
Короче говоря: вторая часть конфига выглядит примерно так

```bash
${переменная параметры}
$элемент оформления
${color цветтекста}
${переменная параметры}
…
```

Назначение переменных в основном понятно из их названий:

- `exec` выводит на экран текст, возвращаемый вызываемой программой;
- `execbar` и `execgraph` визуализируют вывод исполняемой команды в виде диаграммы или графика (выводимое значение должно лежать в пределах 0..100);
- `execi` и `texeci` запускают команду циклически с интервалом (`texeci` — с интервалом, заведомо большим времени исполнения).
- `execibar` и `execigraph` полностью аналогичны `execbar` и `execgraph`, но для циклического выполнения команд;
- `if_running`, `if_existing` и `if_mounted` — выводят всё вплоть до endif, если выполняется процесс, существует файл и монтирована точка монтирования, соответственно;
- `else` — выводить, если ложны все вышестоящие выражения.

Надо сказать, что применение `execi` особенно для скриптов – дело довольно затратное, и скрипты лучше отрабатывать таким образом не часто (раз в несколько секунд).

Ниже – несколько наиболее интересных решений для отображения данных в conky.

Показывать текущее время в формате часы:минуты:секунды
```bash
${time %k:%M:%S}
```

Отображение занимаемой приложениями памяти
```bash
$mem/$memmax
```
Вот тут у меня был лёгкий конфуз: часто значения отображаемой памяти были неприлично маленькими – это происходит оттого, что не учитывается память, занятая кэшем.

Вывести три самых охочих до процессора приложения:
```bash
${color #ddaa00} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
```

Несколько более сложным является отображение ACPI-данных о процессоре или питании системы. В этом нам помогут замечательные программы cat и cut. Вот как, например, вывести информацию о температуре на процессоре и включения троттлинга:

```bash
  ${color lightgrey} Core: $color ${execi 2 cat /proc/acpi/thermal_zone/THRM/temperature | cut -c26-} – critical 115 C – ${color lightgrey} Throttling state: $color ${execi 2 cat /proc/acpi/processor/CPU1/throttling | grep active | cut -c26-}
```
Более навороченные трюки, типа отображения степени зарядки батареи ноутбука, описываются опять-таки здесь ближе к концу статьи.

И текст конфига .conkyrc который это обеспечивает (внимание, для отображения заряда батарей используется обращение к скрипту, которого у вас может не быть). Вот образец конфигурационного файла conky

```bash
# Conky advanced configuration
background yes

# Use Xft?
use_xft yes

# Xft font when Xft is enabled
xftfont Bitstream Vera Sans Mono:size=9

# Text alpha when using Xft
xftalpha 0.8

# Update interval in seconds
update_interval 2.0

# This is the number of times Conky will update before quitting.
# Set to zero to run forever.
total_run_times 0

# Create own window instead of using desktop (required in nautilus)
own_window no

# If own_window is yes, you may use type normal, desktop or override
own_window_type normal

# Use pseudo transparency with own_window?
own_window_transparent yes

# If own_window is yes, these window manager hints may be used
#own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager

# Use double buffering (reduces flicker, may not work for everyone)
double_buffer yes

# Minimum size of text area
minimum_size 300 5

# Draw shades?
draw_shades yes

# Draw outlines?
draw_outline no

# Draw borders around text
draw_borders no

# Draw borders around graphs
draw_graph_borders no

# Stippled borders?
stippled_borders 8

# border margins
border_margin 40

# border width
border_width 1

# Default colors and also border colors
default_color white
default_shade_color black
default_outline_color black

# Text alignment, other possible values are commented
#alignment top_left
#alignment top_right
#alignment bottom_left
alignment bottom_right
#alignment none

# Gap between borders of screen and text
# same thing as passing -x at command line
gap_x 12
gap_y 12

# Subtract file system buffers from used memory?
no_buffers yes

# set to yes if you want all text to be in uppercase
uppercase no

# number of cpu samples to average
# set to 1 to disable averaging
cpu_avg_samples 2

# number of net samples to average
# set to 1 to disable averaging
net_avg_samples 2

# Force UTF8? note that UTF8 support required XFT
override_utf8_locale no

# Add spaces to keep things from moving about?  This only affects certain objects.
use_spacer no

# Maximum size of buffer for user text, i.e. below TEXT line.
#max_user_text 16384

# Allow for the creation of at least this number of port monitors (if 0 or not set, default is 16)
#min_port_monitors 16

# Allow each port monitor to track at least this many connections (if 0 or not set, default is 256)
#min_port_monitor_connections 256

# variable is given either in format $variable or in ${variable}. Latter
# allows characters right after the variable and must be used in network
# stuff because of an argument

# stuff after 'TEXT' will be formatted on screen

TEXT
$nodename - $sysname $kernel on $machine
$stippled_hr
${color lightgrey}Current time: $color ${time %k:%M:%S} - ${color lightgrey}Uptime:$color $uptime ${color lightgrey}- Load:$color $loadavg
${color lightgrey}CPU Usage:${color #cc2222} $cpu% ${cpubar}
${color blue}${cpugraph 0000ff 00ff00}
${color lightgrey}RAM Usage:$color $mem/$memmax  -  Swap Usage:$color $swap/$swapmax - $swapperc%
${color lightgrey}File systems: $color${fs_free /}/${fs_size /} ${fs_bar /}
${color lightgrey}Processes:$color $processes  ${color grey}Running:$color $running_processes
$stippled_hr
${color}Name              PID     CPU%   MEM%
${color #ddaa00} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
${color}Mem usage
${color #ddaa00} ${top_mem name 1} ${top_mem pid 1} ${top_mem cpu 1} ${top_mem mem 1}
${color lightgrey} ${top_mem name 2} ${top_mem pid 2} ${top_mem cpu 2} ${top_mem mem 2}
${color lightgrey} ${top_mem name 3} ${top_mem pid 3} ${top_mem cpu 3} ${top_mem mem 3}
$stippled_hr
${color blue}System health ${color lightgrey}
${color lightgrey} Core: $color ${execi 2 cat /proc/acpi/thermal_zone/THRM/temperature | cut -c26-} - critical 115 C - ${color lightgrey} Throttling state: $color ${execi 2 cat /proc/acpi/processor/CPU1/throttling | grep active | cut -c26-}
${color lightgrey} Core clock: $color ${execi 2 cat /proc/cpuinfo | grep 'cpu MHz' | cut -c12-}
$stippled_hr
${color red}Energy subsystem:
${color lightgrey}Power: $color${execi 2 cat /proc/acpi/ac_adapter/AC0/state | cut -c26-} - ${color lightgrey}Charging state:$color ${execi 2 cat /proc/acpi/battery/BAT0/state | grep charging | cut -c26-}
${color lightgrey}Present rate :$color ${execi 2 cat /proc/acpi/battery/BAT0/state | grep 'present rate' | cut -c26-} - ${color lightgrey}Battery energy:${color green} ${execi 2 /usr/bin/myscript/kmvbatterystate}%
$color $stippled_hr
${color #ddaa00}Port(s)${alignr}#Connections
$color Inbound: ${tcp_portmon 1 32767 count}  Outbound: ${tcp_portmon 32768 61000 count}${alignr}ALL: ${tcp_portmon 1 65535 count}
${color #ddaa00}Inbound Connection ${alignr} Local Service/Port$color
 ${tcp_portmon 1 32767 rhost 0} ${alignr} ${tcp_portmon 1 32767 lservice 0}
 ${tcp_portmon 1 32767 rhost 1} ${alignr} ${tcp_portmon 1 32767 lservice 1}
 ${tcp_portmon 1 32767 rhost 2} ${alignr} ${tcp_portmon 1 32767 lservice 2}
${color #ddaa00}Outbound Connection ${alignr} Remote Service/Port$color
 ${tcp_portmon 32768 61000 rhost 0} ${alignr} ${tcp_portmon 32768 61000 rservice 0}
 ${tcp_portmon 32768 61000 rhost 1} ${alignr} ${tcp_portmon 32768 61000 rservice 1}
 ${tcp_portmon 32768 61000 rhost 2} ${alignr} ${tcp_portmon 32768 61000 rservice 2}
```
Скрипт для отображения заряда батареи /usr/bin/myscript/kmvbatterystate
```bash
#!/bin/sh
  MAX=`cat /proc/acpi/battery/BAT0/info | grep 'design capacity:' | cut -b26-30`
  CUR=`cat /proc/acpi/battery/BAT0/state | grep remaining | cut -d':' -f2 | cut -d' ' -f7`
  PRC=$(( $CUR * 100 / $MAX ))
  echo $PRC
```
Ещё раз напомню, что у вас пути в /proc к информации об ACPI могут быть другими.

##Ссылки:
[Есть очень хорошая статья про conky](http:_www.linuxcenter.ru/lib/articles/soft/conky_as_example.phtml), и даже на русском, но там вначале довольно много философии.  
Полный список переменных есть [тут](http:_conky.sourceforge.net/variables.html).
