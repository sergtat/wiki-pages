# Настройка шлюза (HOWTO)
Задумал я включить второй компьютер (на самом деле пятый) к первому. Причём так, что-бы у меня всё работало (ну вообще всё). На первом компьютере у меня был интернет, а на втором тоже естественно хотелось. Причём второй был задуман как вспомогательная тестовая машинка (хотя с другой стороны, обычно все делают наоборот). Итак, для начала определимся с оборудованием, нужно:

##Шлюз.
- Процессор пойдёт Pentium (наверное любой, но я использовал третий).
- Оперативная память - думаю достаточно будет 128Мб, однако у меня было 256Мб.
- HDD - вполне достаточно 500Мб, однако лучше использовать хотя-бы 2Гб диск.

##Клиент.
В принципе любая машина с одной сетевой картой. Я использовал Celeron 400MHz+RAM-128Mb+HDD-10Gb+Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8139/8139C/8139C+ (rev 10).

###Операционная Система
Какая ОС будет на клиенте - решать вам, думаю вполне можно использовать Windows, однако я использовал Slackware 13. Настройка клиента тривиальна:
В Slackware для настройки сети имеется скрипт netconfig (в пакете n/network-scripts*, этот пакет конечно надо поставить), и настраивать клиента можно именно этим скриптом. Скрипт задаёт вопросы:

- hostname: выбираете имя своего хоста (имя компьютера-клиента).
- domainname: выбираете имя домена(имя вашей сети).

желательно выбирать и то, и другое маленькими нерусскими буквами, и только ими (что-бы не было проблем в дальнейшем).

Дальше будет выбор - пишете USE DHCP

DHCP HOSTNAME - пусто

###Список пакетов.
Ну и конечно необходимо установить ПО:

- Slackware Linux. Я использовал предпоследнюю версию, но (как я уже отметил) можно использовать хоть венду. Но как настраивать венду я не помню (впрочем там просто, сами разберётесь. Принцип прост: всё брать в DHCP. Кроме DHCP_HOSTNAME, его брать там не надо).

Далее следует список пакетов для шлюза. (OPT) означает - не обязательный пакет.

- (REC)dhcpcd-3.2.3-i486-1
Это DHCP-клиент. Его задача, обратится к DHCP серверу на шлюзе, и получить IP адрес. Запускается из /etc/rc.d/rc.inet1, настраивается в /etc/rc.d/rc.inet1.conf, в принципе я его без всяких настроек использую.
- (REC)dialog-1.1_20080819-i486-2
вспомогательный пакет для псевдографики. используется скриптом netconfig.
- (OPT)inetd-1.79s-i486-8
Супер-демон сети. Запускает другие демоны. На самом деле, я его не использую, ну пусть будет...
- (OPT)iptraf-3.0.0-i486-2
Монитор состояния сети:
ну я не знаю, удобная вообще-то штука. Но НЕ необходимая.
- (REC)iputils-s20070202-i486-2
разные утилиты. в том числе программа ping
- (OPT)lftp-3.7.14-i486-1
консольный FTP клиент.
- (REC)lsof-4.78-i486-1
программа для мониторинга файлов и интернет соединений.
- (OPT)mc-20090714_git-i486-1 *заменён на mc-4.7.4
Командная строка рулит, однако можно использовать и mc.
- (REC)net-tools-1.60-i486-2
Разные сетевые утилиты. Тут базовые утилиты, без них сеть не настроить.
- (REC)network-scripts-13.0-noarch-2
Настроечные скрипты. Необходимо поставить.
- (OPT)ntp-4.2.4p7-i486-1
Система настройки времени по сети. Её я ещё не настроил...
- (REC)openssh-5.2p1-i486-1
SSH. Защищённая командная строка. Позволяет управлять клиентом со шлюза (и наоборот).
- (OPT)proftpd-1.3.2-i486-1 *заменён на 1.1.3b
FTP сервер. Вообще-то файлы можно передавать на клиент и по ssh (команда scp), однако это не очень удобно - для внутренней передачи шифрование не нужно, и если компьютеры слабые, то шифрование может их тормозить. Передавать гигабайты удобнее и быстрее именно по FTP. Кроме того, по FTP протоколу можно смотреть кино.
- (OPT)screen-4.0.3-i486-1
Эта утилитка используется для удалённого администрирования. Фактически это тоже командная строка, но от неё можно отключатся и подключатся. Т.е. можно будет выключать сервер, но сеанс на клиенте сохраняется (в данном случае клиент является сервером). Необходима при неустойчивой связи, например без проводов. Для витой пары - иногда удобно.
- (REC)glibc-2.9-i486-3
Библиотека. Содержит огромное количество разных функций и утилит. Без неё ничего не работает.
- (REC)sed-4.1.5-i486-1
Потоковый редактор. Нужная программка.
- (REC)sudo-1.6.8p12-i486-1
Настраивать сеть мы будем под рутом, но вот пользоваться конечно под обычным юзером. Некоторые вещи обычный юзер не может делать принципиально (например монтировать устройства), потому на понадобится эта утилитка, что-бы юзеру дать возможность этим всем пользоваться.
- (OPT)vim-7.2.245-i486-1
Удобный и мощный текстовый редактор. Нужен для правки конфигов. Ну конечно можно и заменить... Но лучше не надо.

##Настройка шлюза.
На шлюзе используются несколько другие программы, или по другому настроены. Для начала разберёмся с самим понятием "шлюз". Шлюзом я называю компьютер, имеющий более одного IP адреса. Шлюз связывает как минимум две сети. Подразумевается, что у нас уже есть настроенный и подключённый к Сети компьютер, в моём случае я использовал обычный компьютер с Slackware Linux, и инетом через мобильный телефон. Сеть у меня включается утилиткой kppp, причём настройка сети примитивна - всё по умолчанию. Единственное, что надо настраивать у моего опсоса(tele2) - номер телефона. Конечно нужно указать и интерфейс (его можно узнать выполнив dmesg после подключения девайса. Работает это всё через USB, но этот USB эмулирует COM интерфейс. Т.о. в железе это USB, но ПО работает с файлом /dev/tty* так, как будто это древний COM порт. Сама мобила тоже эмулирует некий древний дайлапный модем, т.е. туда можно отправлять разные команды и получать на них ответы. Правда смысл имеют всего 2 команды: Во первых ATZ (сброс), во вторых ATDPномер - набор номера телефона. Как только связь установится, сетевой интерфейс будет видно в ifconfig, в моём случае это ppp0. Ещё мне какой-нить IP дают, не обращал внимание какой именно. Сам адрес видимо постоянно меняется (динамический), и кроме того - "серый", т.е. входящие ко мне соединения невозможны. По этой (в частности) причине и такое наплевательское отношение к безопасности.

###Настройка второго сетевого интерфейса.
Второй интерфейс у нас будет смотреть в нашу локальную сеть из двух компьютеров (шлюза и клиента). Подключив карточку и включив оба компьютера (глобальную сеть можно нужно не включать) надо прежде всего узнать командой ifconfig -a номер нашего интерфейса, у меня это eth1. Теперь правим /etc/rc.d/rc.inet1.conf - изменяем значение переменных соответствующего индекса (у меня eth1, потому индекс 1)
```
# Config information for eth1:
IPADDR[1]="192.168.1.1"
NETMASK[1]="255.255.255.0"
USE_DHCP[1]=""
DHCP_HOSTNAME[1]=""
```
Тут адрес жёстко задан, потому-что шлюз у нас будет иметь вполне конкретный адрес (впрочем можно и плавающий адрес сделать, всё равно клиенты найдут шлюз, вот только - зачем?)

Перезапускаем сеть:

`/etc/rc.d/rc.inet1 restart`

И смотрим наш интерфейс:
```
# ifconfig
eth1      Link encap:Ethernet  HWaddr 00:80:ad:8c:cc:f1
          inet addr:192.168.1.1  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::280:adff:fe8c:ccf1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:83967 errors:1 dropped:0 overruns:0 frame:1
          TX packets:2788372 errors:6 dropped:0 overruns:0 carrier:6
          collisions:0 txqueuelen:1000
          RX bytes:10069550 (9.6 MiB)  TX bytes:4169453506 (3.8 GiB)
          Interrupt:12 Base address:0x6000
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:29792 errors:0 dropped:0 overruns:0 frame:0
          TX packets:29792 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:2928900 (2.7 MiB)  TX bytes:2928900 (2.7 MiB)
```
Как видите интерфейс удачно поднялся и ему присвоился IP 192.168.1.1. Можно также и ручками подымать опускать интерфейсы той-же ifconfig. До клиента нам пока не достучатся, ибо у него ещё нет IP, что-бы он его получил нам надо поднять DHCP сервер.

###Настройка DHCP
Я использовал стандартный сервер из пакета dhcp-3.1.2p1-i486-1. Сначала его надо настроить, для нашего случая настройки такие:
```
# sed 's/^#.*//;/^$/d' /etc/dhcpd.conf
ddns-update-style ad-hoc;
option domain-name "bx";
option domain-name-servers 192.168.1.1;
default-lease-time 600;
max-lease-time 7200;
authoritative;
subnet 192.168.1.0 netmask 255.255.255.0 {
        option domain-name "bx";
        option broadcast-address 192.168.1.254;
        option domain-name-servers 192.168.1.1;
        option subnet-mask 255.255.255.0;
        option routers 192.168.1.1;
        range 192.168.1.50 192.168.1.60;
        default-lease-time 600;
        max-lease-time 7200;
        host aranei {
                hardware ethernet 00:80:48:46:98:15;
                fixed-address 192.168.1.10;
        }
}
```
смысл данного конфига такой:

- приходит клиент, и запрашивает IP адрес (используется широковещательный запрос на фиктивный IP .255)
- сервер имеет пул IP от .50, до .60, он выдаёт первый свободный IP из этого пула.
- имеется исключение: если MAC адрес клиента равен 00:80:48:46:98:15, то сервер выдаёт такому клиенту IP .10

Для запуска демона используется специальный скрипт (не помню где взял надеюсь он под GPL...)
```
# cat /etc/rc.d/rc.dhcpd
    #!/bin/sh
    #
    # /etc/rc.d/rc.dhcpd
    #      This shell script takes care of starting and stopping
    #      the ISC DHCPD service
    #
    # Put the command line options here that you want to pass to dhcpd:
    #DHCPD_OPTIONS="-q eth0"
    DHCPD_OPTIONS="-q eth1"
    [ -x /usr/sbin/dhcpd ] || exit 0
    [ -f /etc/dhcpd.conf ] || exit 0
    start() {
          # Start daemons.
          echo -n "Starting dhcpd:  /usr/sbin/dhcpd $DHCPD_OPTIONS "
          /usr/sbin/dhcpd $DHCPD_OPTIONS
          echo
    }
    stop() {
          # Stop daemons.
          echo -n "Shutting down dhcpd: "
          killall -TERM dhcpd
          echo
    }
    status() {
      PIDS=$(pidof dhcpd)
      if [ "$PIDS" == "" ]; then
        echo "dhcpd is not running!"
      else
        echo "dhcpd is running at pid(s) ${PIDS}."
      fi
    }
    restart() {
          stop
          start
    }
    # See how we were called.
    case "$1" in
      start)
            start
            ;;
      stop)
            stop
            ;;
      restart)
            stop
            start
            ;;
      status)
            status
            ;;
      *)
            echo "Usage: $0 {start|stop|status|restart}"
            ;;
    esac
    exit 0
```
В принципе вся настройка скрипта сводится (при необходимости) к смене номера интерфейса в первой не закомментированной строке.

Создадим скрипт, установим его права 700, и запустим. Запускается он молча, но можно посмотреть его работу в /var/log/messages
```
Sep  9 08:33:01 bx dhcpd: Wrote 0 deleted host decls to leases file.
Sep  9 08:33:01 bx dhcpd: Wrote 0 new dynamic host decls to leases file.
Sep  9 08:33:01 bx dhcpd: Wrote 2 leases to leases file.
```
а теперь проверим его работу. вместе с DHCP сервером в комплекте идёт и клиент, причём в клиентском компе я использовал dhcpcd, а здесь у нас dhclient (это разные вещи на самом деле). Запустим его:
```
dhclient
Internet Systems Consortium DHCP Client V3.1.2p1
Copyright 2004-2009 Internet Systems Consortium.
All rights reserved.
For info, please visit http://www.isc.org/sw/dhcp/
Listening on LPF/eth1/00:80:ad:8c:cc:f1
Sending on   LPF/eth1/00:80:ad:8c:cc:f1
Sending on   Socket/fallback
DHCPDISCOVER on eth1 to 255.255.255.255 port 67 interval 7
DHCPOFFER from 192.168.1.1
DHCPREQUEST on eth1 to 255.255.255.255 port 67
DHCPACK from 192.168.1.1
bound to 192.168.1.51 -- renewal in 256 seconds.
```
вот... что-то произошло. ifconfig пишет, что:
```
# ifconfig
eth1      Link encap:Ethernet  HWaddr 00:80:ad:8c:cc:f1
          inet addr:192.168.1.51  Bcast:192.168.1.254  Mask:255.255.255.0
          inet6 addr: fe80::280:adff:fe8c:ccf1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:83984 errors:1 dropped:0 overruns:0 frame:1
          TX packets:2788393 errors:6 dropped:0 overruns:0 carrier:6
          collisions:0 txqueuelen:1000
          RX bytes:10072626 (9.6 MiB)  TX bytes:4169457736 (3.8 GiB)
          Interrupt:12 Base address:0x6000
lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:16436  Metric:1
          RX packets:33483 errors:0 dropped:0 overruns:0 frame:0
          TX packets:33483 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:3272154 (3.1 MiB)  TX bytes:3272154 (3.1 MiB)
```
как видно, сервер выдал новый адрес (в данном случае самому себе, что конечно приведёт к нарушению работы шлюза). Этот клиент тоже настраивается, но нам он нужен лишь для проверки, потому мы обойдёмся пустым конфигом по умолчанию.

**Важно!** не забудьте выключить этот клиент, а то он каждые несколько минут IP переписывает.
```
root@bx:~# ps uax | grep "dhcl"
root      4956  0.0  0.2   2208   596 ?        Ss   09:12   0:00 dhclient
root      6072  0.0  0.3   2412   832 pts/2    S+   09:48   0:00 grep --color dhcl
root@bx:~# kill 4956
root@bx:~# ps uax | grep "dhcl"
root      6075  0.0  0.3   2412   832 pts/2    S+   09:48   0:00 grep --color dhcl
```
Теперь нужно прописать запуск dhcpd я это сделал в скрипте /etc/rc.d/rc.inet1

> Примечание: по замыслу Патрика, сеть в слаке подымается двумя скриптами:

1. Скрипт /etc/rc.d/rc.inet1 подымает саму сеть.
2. А скрипт /etc/rc.d/rc.inet2 подымает сетевые демоны.
3. Есть ещё опциональный скрипт /etc/rc.d/rc.inetd, этот поднимает одноимённый демон суперсервера, который запускает не слишком нужные сетевые серверы. К примеру так обычно запускается FTP, если этот FTP нужен раз в году.

Я решил, что для DHCP сервера самое место именно в /etc/rc.d/rc.inet1. Впрочем, вы можете это изменить.

Вот отличия нового файла от старого:
```
root@bx:~#diff etc/rc.d/rc.inet1.new /etc/rc.d/rc.inet1 -c
*** etc/rc.d/rc.inet1.new       2009-08-25 08:37:21.000000000 +0400
--- /etc/rc.d/rc.inet1  2010-09-09 09:33:10.000000000 +0400
***************
*** 211,220 ****
--- 211,226 ----
      if_up $i
    done
    gateway_up
+       if [ -x /etc/rc.d/rc.dhcpd ]; then
+               /etc/rc.d/rc.dhcpd start
+       fi
  }
  # Function to stop the network:
  stop() {
+       if [ -x /etc/rc.d/rc.dhcpd ]; then
+               /etc/rc.d/rc.dhcpd stop
+       fi
    gateway_down
    for i in ${IFNAME[@]} ; do
      if_down $i
```
Подразумевается, что клиент подключён. Теперь опять рестартанём сеть, и посмотрим что получилось:

(в /var/log/messages)
```
    Sep  9 09:52:20 bx dhcpd: DHCPREQUEST for 192.168.1.10 from 00:80:48:46:98:15 via eth1
    Sep  9 09:52:20 bx dhcpd: DHCPACK on 192.168.1.10 to 00:80:48:46:98:15 via eth1
```
Видно, что наш DHCP сервер принял запрос от клиента, и выдал ему адрес .10.

Набрав
```
root@bx:~# ping 192.168.1.10
PING 192.168.1.10 (192.168.1.10) 56(84) bytes of data.
64 bytes from 192.168.1.10: icmp_seq=1 ttl=64 time=0.442 ms
64 bytes from 192.168.1.10: icmp_seq=2 ttl=64 time=0.277 ms
64 bytes from 192.168.1.10: icmp_seq=3 ttl=64 time=0.305 ms
64 bytes from 192.168.1.10: icmp_seq=4 ttl=64 time=0.281 ms
^C
--- 192.168.1.10 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2999ms
rtt min/avg/max/mdev = 0.277/0.326/0.442/0.068 ms
```
убеждаемся в нормальной работе сети.

**А если не работает?**

Не работать может по многим причинам (я всю ночь не мог сделать - выяснилось, что просто сетевая карта не рабочая). Самое простое, ИМХО, идти к клиенту, останавливать там сеть, и поднимать её ручками:
```
root@bx:~# /etc/rc.d/rc.inet1 stop
Shutting down dhcpd:
root@bx:~# ifconfig
# нет ответа - интерфейсы не подняты
root@bx:~# ifconfig eth1 up 192.168.1.10
root@bx:~# ifconfig
eth1      Link encap:Ethernet  HWaddr 00:80:ad:8c:cc:f1
          inet addr:192.168.1.10  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::280:adff:fe8c:ccf1/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:84467 errors:1 dropped:0 overruns:0 frame:1
          TX packets:2788575 errors:6 dropped:0 overruns:0 carrier:6
          collisions:0 txqueuelen:1000
          RX bytes:10224282 (9.7 MiB)  TX bytes:4169487324 (3.8 GiB)
          Interrupt:12 Base address:0x6000
# поднял интерфейс (только я это на сервере делал - ходить к клиенту мне лень
# теперь пропингуем клиентом самого себя - это я могу сделать и отсюда:
root@aranei:~# ping 192.168.1.10
PING 192.168.1.10 (192.168.1.10) 56(84) bytes of data.
64 bytes from 192.168.1.10: icmp_seq=1 ttl=64 time=0.176 ms
64 bytes from 192.168.1.10: icmp_seq=2 ttl=64 time=0.117 ms
64 bytes from 192.168.1.10: icmp_seq=3 ttl=64 time=0.103 ms
^C
--- 192.168.1.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.103/0.132/0.176/0.031 ms
# сам себя пингует, и если провода и сетевухи нормальные, то должен пинговаться и с сервера:
root@bx:~# ping 192.168.1.10
PING 192.168.1.10 (192.168.1.10) 56(84) bytes of data.
64 bytes from 192.168.1.10: icmp_seq=1 ttl=64 time=0.430 ms
64 bytes from 192.168.1.10: icmp_seq=2 ttl=64 time=0.276 ms
64 bytes from 192.168.1.10: icmp_seq=3 ttl=64 time=0.293 ms
^C
--- 192.168.1.10 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 1999ms
rtt min/avg/max/mdev = 0.276/0.333/0.430/0.068 ms
```
Если не получается, посмотрите журналы (и на сервере и на клиенте), возможно процесс какой-то мешает, или ещё что. Должно получится

Как я уже писал, внешнюю сеть подключать пока НЕ надо, что-бы она не мешалась.

Итого: мы подняли сеть, и она даже работает Конечно этого мало, ведь кроме ping больше ничего пока не работает.

##Настройка роутинга и файрвола на шлюзе.
###Клиент.
С клиентом всё понятно: фаервол там не нужен (в нашем случае. Клиент-то мой, кто его атаковать будет? Только шлюз... Или через шлюз), а с роутингом вопросов нет - у нас всего один интерфейс, и именно туда мы будем роутить все пакеты:
```
root@aranei:~# route -n -e
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth0
169.254.0.0     0.0.0.0         255.255.0.0     U         0 0          0 eth0
127.0.0.0       0.0.0.0         255.0.0.0       U         0 0          0 lo
0.0.0.0         192.168.1.1     0.0.0.0         UG        0 0          0 eth0
```
Как видите, таблица роутинга очень простая. UG это не [CENSORED], а путь по умолчанию  Он задаётся в скрипте /etc/rc.d/rc.inet1, точнее этот скрипт запускает dhcpcd, и если клиент получит себе IP, он ещё и прописывает в таблицу роутинга путь к шлюзу. Причём как путь по умолчанию.

###Шлюз.
На шлюзе всё сложнее.

Таблица роутинга без глобальной сети такая:
```
root@bx:~# route -n -e
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth1
127.0.0.0       0.0.0.0         255.0.0.0       U         0 0          0 lo
```
А когда подключается глобальная Сеть, kppp добавляет в таблице путь по умолчанию к шлюзу провайдера.

Кроме того я использую фаервол. Фаервол стандартный, взятый с известной доки по настройке iptables:
вот с вырезанными комментами:

`DHCP_NOIPV4LL[0]="yes"`

Скрипт представляет собой слегка переделанный скрипт от Copyright (C) 2001  Oskar Andreasson <bluefluxATkoffeinDOTnet>

1. я слегка изменил загрузку модулей. (в оригинале они просто загружались, а у меня в цикле).
2. я определяю сервер DNS. (об этом ниже)

Как указывает сам Оскар, включение forwarding'а (строчка echo "1" > /proc/sys/net/ipv4/ip_forward) следует перенести в конец скрипта по соображениям безопасности (существует момент, между включением форвардинга и записью правил, когда злоумышленник может пробраться в нашу сеточку).  Но мне лень менять...

PS: поменял-таки.
```
INET_IFACE="ppp0"
DHCP="no"
DHCP_SERVER=`sed -rn 's/^nameserver ([0-9.]+).*$/\1/;T;p;q' /etc/resolv.conf`
if [ -n "$DHCP_SERVER" ]; then
        echo "Found DHCP_SERVER=$DHCP_SERVER"
        DHCP="yes"
        sed -ri "/^\s*forwarders \{$/{; N; s/(\n\s*)([0-9.]{7,16})/\1$DHCP_SERVER/; }" /etc/named.conf
fi
PPPOE_PMTU="no"
LAN_IP="192.168.1.1"
LAN_IP_RANGE="192.168.1.0/24"
LAN_IFACE="eth1"
LO_IFACE="lo"
LO_IP="127.0.0.1"
IPTABLES="/usr/sbin/iptables"
MOD_INIT=""
for MOD in ip_conntrack ip_tables iptable_filter iptable_mangle iptable_nat ipt_LOG     ipt_limit ipt_MASQUERADE
do
        /sbin/lsmod | grep -q "$MOD"
        if [ $? != 0 ]; then
                echo "load $MOD"
                if [ -z "MOD_INIT" ]; then
                        /sbin/depmod -a
                        MOD_INIT="yes"
                fi
                /sbin/modprobe $MOD
        fi
done
echo "1" > /proc/sys/net/ipv4/ip_forward
$IPTABLES -P INPUT DROP
$IPTABLES -P OUTPUT DROP
$IPTABLES -P FORWARD DROP
$IPTABLES -N bad_tcp_packets
$IPTABLES -N allowed
$IPTABLES -N tcp_packets
$IPTABLES -N udp_packets
$IPTABLES -N icmp_packets
$IPTABLES -A bad_tcp_packets -p tcp --tcp-flags SYN,ACK SYN,ACK \
-m state --state NEW -j REJECT --reject-with tcp-reset
$IPTABLES -A bad_tcp_packets -p tcp ! --syn -m state --state NEW -j LOG \
--log-prefix "New not syn:"
$IPTABLES -A bad_tcp_packets -p tcp ! --syn -m state --state NEW -j DROP
$IPTABLES -A allowed -p TCP --syn -j ACCEPT
$IPTABLES -A allowed -p TCP -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A allowed -p TCP -j DROP
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 21 -j allowed
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 22 -j allowed
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 80 -j allowed
$IPTABLES -A tcp_packets -p TCP -s 0/0 --dport 113 -j allowed
$IPTABLES -A udp_packets -p UDP -s 0/0 --source-port 53 -j ACCEPT
if [ $DHCP == "yes" ] ; then
        $IPTABLES -A udp_packets -p UDP -s $DHCP_SERVER --sport 67 \
        --dport 68 -j ACCEPT
fi
$IPTABLES -A icmp_packets -p ICMP -s 0/0 --icmp-type 8 -j ACCEPT
$IPTABLES -A icmp_packets -p ICMP -s 0/0 --icmp-type 11 -j ACCEPT
$IPTABLES -A INPUT -p tcp -j bad_tcp_packets
$IPTABLES -A INPUT -p ALL -i $LAN_IFACE -s $LAN_IP_RANGE -j ACCEPT
$IPTABLES -A INPUT -p ALL -i $LO_IFACE -j ACCEPT
$IPTABLES -A INPUT -p UDP -i $LAN_IFACE --dport 67 --sport 68 -j ACCEPT
$IPTABLES -A INPUT -p ALL -i $INET_IFACE -m state --state ESTABLISHED,RELATED \
-j ACCEPT
$IPTABLES -A INPUT -p TCP -i $INET_IFACE -j tcp_packets
$IPTABLES -A INPUT -p UDP -i $INET_IFACE -j udp_packets
$IPTABLES -A INPUT -p ICMP -i $INET_IFACE -j icmp_packets
$IPTABLES -A INPUT -m limit --limit 3/minute --limit-burst 3 -j LOG \
--log-level DEBUG --log-prefix "IPT INPUT packet died: "
$IPTABLES -A FORWARD -p tcp -j bad_tcp_packets
$IPTABLES -A FORWARD -i $LAN_IFACE -j ACCEPT
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -m limit --limit 3/minute --limit-burst 3 -j LOG \
--log-level DEBUG --log-prefix "IPT FORWARD packet died: "
$IPTABLES -A OUTPUT -p tcp -j bad_tcp_packets
$IPTABLES -A OUTPUT -p ALL -s $LO_IP -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -s $LAN_IP -j ACCEPT
$IPTABLES -A OUTPUT -p ALL -o $INET_IFACE -j ACCEPT
$IPTABLES -A OUTPUT -m limit --limit 3/minute --limit-burst 3 -j LOG \
--log-level DEBUG --log-prefix "IPT OUTPUT packet died: "
if [ $PPPOE_PMTU == "yes" ] ; then
        $IPTABLES -t nat -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN \
        -j TCPMSS --clamp-mss-to-pmtu
fi
$IPTABLES -t nat -A POSTROUTING -o $INET_IFACE -j MASQUERADE
```
###Настройка SSH.
Вообще говоря, SSH нужно настроить в первую очередь, что-бы не бегать от компьютера к компьютеру. SSH сервер нужно подымать на том компьютере, который удалённый (не важно, шлюз это или клиент), а SSH клиент ставится на локальный компьютер (в Linux это openssh-5.2p1-i486-1 (это сервер и клиент сразу), для венды есть клиент - putty). Ну про настройку ssh я уже подробно расписал здесь. Для начала(когда мы только начали настраивать, и у клиента не было даже IP) просто чутка подредактируем /etc/ssh/sshd_config:

`PasswordAuthentication yes`

теперь для входа достаточно лишь пароля. И теперь локально создаём ключи (если они конечно ещё не созданы) - ssh-keygen. Далее:
```
doc@bx:~$ scp .ssh/id_rsa.pub aranei:
aranei@aranei's password:
id_rsa.pub  100%  395     0.4KB/s   00:00
doc@bx:~$ ssh aranei
aranei@aranei's password:
Last login: Thu Sep  9 06:34:32 2010 from 192.168.1.1
Linux 2.6.29.6-smp.
aranei@aranei:~$ mkdir .ssh
aranei@aranei:~$ mv id_rsa.pub .ssh/authorized_keys
aranei@aranei:~$ logout
Connection to aranei closed.
doc@bx:~$ ssh aranei
Enter passphrase for key '/home/doc/.ssh/id_rsa':
Last login: Thu Sep  9 14:01:24 2010 from 192.168.1.1
Linux 2.6.29.6-smp.
```
тут я отправил свой ключ со шлюза на клиент, и перелогинился. Теперь вместо пароля меня просят набирать парофразу. Осталось запретить вход по паролю, что-бы никто кроме нас не смог войти:
```
aranei@aranei:~$ su -
Password:
root@aranei:~# vim /etc/ssh/sshd_config
# нужно перезагрузить sshd демон. Т.к. мы вошли по ssh, нас выкинет:
root@aranei:~# /etc/rc.d/rc.sshd restart
WARNING: killing listener process only.  To kill every sshd process, you must
         use 'rc.sshd stop'.  'rc.sshd restart' kills only the parent sshd to
         allow an admin logged in through sshd to use 'rc.sshd restart' without
         being cut off.  If sshd has been upgraded, new connections will now
         use the new version, which should be a safe enough approach.
# в данном случае рестарта не получилось, о чём нас и предупреждают.
# задаём stop и start в одной команде, что-бы потом можно было войти.
root@aranei:~# /etc/rc.d/rc.sshd stop; /etc/rc.d/rc.sshd start
Connection to aranei closed by remote host.
Connection to aranei closed.
# выкинули
```
Теперь нужно проверить, пустят-ли кого-то другого. Например root'а с bx (выше показано, что doc'а с bx пускают).
```
doc@bx:~$ su -
Password: *******
# для рута не прописана конфигурация хоста aranei, приходится явно всё писать
root@bx:~# ssh -p66666 aranei@192.168.1.10
The authenticity of host '[192.168.1.10]:66666 ([192.168.1.10]:66666)' can't be established.
RSA key fingerprint is 08:cb:e9:d1:75:df:c8:34:9d:96:79:32:c5:38:ba:84.
Are you sure you want to continue connecting (yes/no)? yes
# я впервые захожу как рут, на этот хост, потому меня спрашивают, уверен-ли я, что это именно тот хост?
# злоумышленник может подменить хосты, и я введу пароль/публичный ключ
# не туда. Если аутенофикация по паролю - то я уже взломан.
# Но у нас по ключу. Соглашаемся, врагов вроде нет...
Warning: Permanently added '[192.168.1.10]:66666' (RSA) to the list of known hosts.
Permission denied (publickey,keyboard-interactive).
# облом. доступ закрыт. Что и требовалось.
root@bx:~# logout
doc@bx:~$ ssh aranei
Enter passphrase for key '/home/doc/.ssh/id_rsa':
Last login: Thu Sep  9 14:03:29 2010 from 192.168.1.1
Linux 2.6.29.6-smp.
aranei@aranei:~$
# а вот doc'а с bx'а пускают...
```
Советую сразу задать какой-нить нестандартный порт, что-бы боты не долбились и не пачкали логи. Ну и естественно следует запретить вход для root'а.

Теперь можно настраивать удалённо, хоть с Америки

PS: на самом деле - неудобно. Мой идентификационный файл используется для связи с боевыми серверами, и естественно защищён сложной парафразой. Конечно нет никакого смысла вводить такую парафразу для связи со своим-же компом, который рядом (и со своего). Потому я сделал вторую пару ключей, написав
```
ssh-keygen -f aranei
```
После чего я отправил публичный ключ на второй комп, и встроил его в файл ~/.ssh/authorized_keys. Теперь можно отредактировать конфиг на клиенте ssh, указав там, что используется другой ключ:
```
$ cat ~/.ssh/config
Host aranei
                                Hostname aranei
                                Port 66666
                                User aranei
                                IdentityFile ~/.ssh/aranei
```
Теперь можно входить без паролей и парафраз.

###ftp
По умолчанию proftpd (а именно его я и буду использовать в качестве сервера, а конкретно proftpd-1.3.2-i486-1 (вышла новая версия)) поставляется настроенным в качестве сервера который вызывается супер-сервером. Это достаточно долго, я предпочитаю что-бы сервер сразу работал. Впрочем, это дело вкуса. Я опишу процесс настройки именно как постоянно висящего процесса.

Вот конфиг - я вырезал из него комментарии, и почти ничего не осталось  :wink:
```
aranei@aranei:~$ sed -r 's/\s*#.*//; /^\s*$/d' /etc/proftpd.conf
ServerName                      "LISM station"
ServerType                      standalone
DefaultServer                   on
UseIPv6                         off
Port                            21
Umask                           022
DefaultRoot                     ~
MaxInstances                    30
User                            nobody
Group                           nogroup
SystemLog                       /var/log/proftpd.log
TransferLog                     /var/log/xferlog
<Directory /*>
        AllowOverwrite          on
</Directory>
```
Имеется 2 основных отличия от конфига по умолчанию: во первых standalone (постоянно висит, а не подгружается когда необходимо), во вторых DefaultRoot ~, что-бы все юзвери были заперты в домашнем каталоге. Секцию анонимуса я вырезал, ибо мне это не нужно. Доступ к серверу имеют все юзеры, НЕ перечисленные в
```
$ cat /etc/ftpusers
ftp
root
uucp
news
```
Юзверь ftp - это тот-же ананимус. Рута надо суда вбить ОБЯЗАТЕЛЬНО. Во избежание...

Сам демон я запускаю вот таким скриптом /etc/rc.d/rc.proftpd:
```
#!/bin/sh

FTPD="/usr/sbin/proftpd"
FTPD_OPTIONS=""

function ftpd_start()
{
        echo "$FTPD starting..."
        $FTPD $FTPD_OPTIONS
}

function ftpd_stop()
{
        echo "$FTPD stopping..."
        FTPD_PID=`ps uax|sed -rn 's~^(\S+\s+)([0-9]+)\s+(\S+\s+){8}(proftpd:\s+.*)$~\2~p'`
        if [ -z "$FTPD_PID" ]; then
                echo "$FTPD not runing."
        else
                echo "PID=$FTPD_PID"
                kill $FTPD_PID
        fi
}

case $1 in
        start)
                ftpd_start
                ;;
        stop)
                ftpd_stop
                ;;
        restart)
                ftpd_stop
                sleep 1
                ftpd_start
                ;;
        status)
                ps uax|sed -rn 's~^(\S+\s+)([0-9]+)\s+(\S+\s+){8}(proftpd:\s+.*)$~&~p'
                ;;
        *)
                echo "Usage: "`basename $0`" start|stop|restart|status."
                ;;
esac
```
ничего интересного... А запуск этого скрипта я прописал в /etc/rc.d/rc.inet2:
```
if [ -x /etc/rc.d/rc.proftpd ]; then
        /etc/rc.d/rc.proftpd start
fi
```
(в самый конец).

В первый раз вызывать нужно ручками, а потом оно работает само.

Попробуем локально (используя lftp-3.7.14-i486-1):
(конечно я не совсем локально делал, а по ssh)
```
aranei@aranei:~$ lftp
lftp :~> open -u aranei localhost
Пароль:
lftp aranei@localhost:~> ls
-rwxr-xr-x   1 aranei   users       58265 Sep  8 23:06 htop-0.8-i486-1ant.tgz
-rwxr-xr-x   1 aranei   users        1222 Sep  9 00:07 lang.sh
-rwxr-xr-x   1 aranei   users         213 Sep  9 00:06 rc.font
-rwxr-xr-x   1 aranei   users         658 Sep  9 00:06 rc.keymap
drwxr-xr-x   8 aranei   users        4096 Sep  9 00:01 slackware
-rw-r--r--   1 0        0              45 Sep  8 23:11 welcome.msg
lftp aranei@localhost:/> exit
```
Работает. Если не работает, или нефиг делать, первой командой наберите debug 10 - будет много букв.

Теперь можно попробовать и удалённо:
```
doc@bx:~$ lftp]lftp :~> open -u aranei aranei
lftp aranei@aranei:~> ls
-rwxr-xr-x   1 aranei   users       58265 Sep  8 23:06 htop-0.8-i486-1ant.tgz
-rwxr-xr-x   1 aranei   users        1222 Sep  9 00:07 lang.sh
-rwxr-xr-x   1 aranei   users         213 Sep  9 00:06 rc.font
-rwxr-xr-x   1 aranei   users         658 Sep  9 00:06 rc.keymap
drwxr-xr-x   8 aranei   users        4096 Sep  9 00:01 slackware
-rw-r--r--   1 0        0              45 Sep  8 23:11 welcome.msg
lftp aranei@aranei:/>
```
вот, даже пароля не спросила. Это не дыра, у вас спросят - просто я его вбил в ~/.netrc, чтоб по 20 раз не набирать:
```
machine aranei
login aranei
password мой_пароль
```
PS: да, FTP, это единственный нормальный протокол, который поддерживает Windows для обмена файлами. Ежели придёт друг с ноутом, это самый быстрый и простой способ обменяться файлами - поднимать samba-сервер ИМХО не рационально, да и весит он сотни мегабайт... А в венде даже проводник умеет FTP, хотя конечно и жутко криво.

###Настройка NFS.
Вторая машина у меня служит файлопомойкой (в т.ч.), в частности там у меня лежит музыка. И тут ВНЕЗПНО выяснилось, что мой плеер не умеет играть с FTP (анализ показал, что виноват в этом я сам... я-же его собирал...). Пересобирать мне было лениво, потому я поднял NFS. Вот что сказано в букваре.
####Что такое NFS?
Ну это общие папки. Прямо как в маздае. Только древние. Проблема в NFS в том, что любой может зайти на хост прикинувшись тем, кому это можно - просто устанавливаем имя компьютера как у легального юзера, и свободно заходим и качаем (и даже правим/удаляем, если легальному это разрешено). Для домашней локальной сети - самое отличное решение (конечно необходимо прикрыть снаружи это фаерволом, а точнее - не открывать).
####Настройка сервера.
Сервером NFS называется тот компьютер, на котором лежат доступные (с других компов) каталоги. Настраивается на сервере всё очень просто:

1. Ставим nfs-utils-1.1.4-i486-1 и portmap-6.0-i486-1.
2. Редактируем  /etc/exports  
```
# See exports(5) for a description.
# This file contains a list of all directories exported to other computers.
# It is used by rpc.nfsd and rpc.mountd.
/home/aranei/music      bx(rw,root_squash,subtree_check)
/home/aranei/video      bx(rw,root_squash,subtree_check)`
```  
т.е. добавляем открытые каталоги. Здесь всё довольно просто: первым идёт полное имя каталога, затем имя компа (HOSTNAME) которому можно, затем опции. root_squash для того, что-бы рут с bx не имел прав рута на сервере.  
3. ставим права доступа 700 на /etc/rc.d/rc.rpc и /etc/rc.d/rc.nfsd.  
4. Запускаем
```
/etc/rc.d/rc.nfsd start
```  
5. Сервер настроен  
####Настройка клиента.
Настроить клиент для меня было несколько сложнее, чем обычно. Проблема в том, что клиент у меня поставлен на шлюзе, а шлюз является сервером. Т.е. всё перепутано. Ну да ладно, вот как я сделал:

1. На клиенте устанавливаются те же пакеты nfs-utils-1.1.4-i486-1 и portmap-6.0-i486-1.
2. ставим права доступа 700 на /etc/rc.d/rc.rpc. А на rc.nfsd не надо (если вам не нужно шарить папки и там и там. Если нужно, то у вас будет и там и там и сервер и клиент).
3. теперь правим /etc/fstab, добавляем туда расшаренные каталоги.
```
aranei:/home/aranei/music /home/doc/music/aranei nfs             noauto 0 0
aranei:/home/aranei/video /home/doc/video        nfs             noauto 0 0
```
Как обычные каталоги, только перед источником ставится имя машины ОТКУДА каталог, и тип - nfs.
Отдельно стоит отметить noauto - этот атрибут для того, что-бы в /etc/rc.d/rc.inet2 НЕ происходило монтирование каталогов - ибо в данный момент сеть поднята "не до конца". А смонтируются наши каталоги уже в самом конце загрузки,  
4. В файле /etc/rc.d/rc.local
Добавленны сл. строки:
```
mount /home/doc/music/aranei
mount /home/doc/video
```
Примечание: это не нужно в том случае, если сеть на NFS сервере подымается ДО сети на клиенте. Например в моём случае я мог-бы расшарить файлы на шлюзе, который и раздаёт сеть на клиента. Но я вот так вот извратился. В данном случае видимо невозможно (точнее сложно) будет сделать общую папку /usr, если конечно она не на шлюзе.

Вот. Теперь музыку спокойно слушаю...
