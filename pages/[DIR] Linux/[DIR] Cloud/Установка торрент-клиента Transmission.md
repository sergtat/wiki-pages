#  Установка торрент-клиента Transmission
После того как вы установили Optware (и midnight commander) можно установить torrent-клиент Transmission

1. Идем в консоль, даем команду
  ipkg install transmission
успешная установка завершается выводом фразы Successfully terminated.

2. Создаем каталоги для transmission
  mkdir /opt/etc/transmission
  mkdir /opt/etc/init.d
  mkdir /opt/usr/sbin
(физически например /mnt/data/Optware/etc/transmission или /mnt/sda1/etc/transmission)

3. Скачать в созданный каталог файл настроек transmission командой:
  wget http://tomatousb.ru/opt/settings.json wget -O /opt/etc/transmission/settings.json

4. Скачиваем скрипт запуска,проверки и остановки торрента:
  wget http://tomatousb.ru/opt/S99trans wget -O /opt/etc/init.d/S99trans
  wget http://tomatousb.ru/opt/signal_and_wait.inc.sh wget -O /opt/usr/sbin/signal_and_wait.inc.sh
  wget http://tomatousb.ru/opt/trans.sh wget -O /opt/usr/sbin/trans.sh

5. Даем права на запуск:
  chmod 755 /opt/etc/init.d/S99trans
  chmod 755 /opt/usr/sbin/signal_and_wait.inc.sh
  chmod 755 /opt/usr/sbin/trans.sh

6. Редактируем основные настройки transmission в файле settings.json
  "download-dir": "/mnt/data/torrent"
указываем путь по умолчанию, куда будут загружаться файлы с торрентов
  "incomplete-dir": "/mnt/data/Optware/etc/transmission/Incomplete"
путь где будут лежать незаконченные закачку торренты
  "rpc-password": "jfut7t87tufr687r87"
укажите свой пароль для доступа к интерфейсу transmission (автоматически зашифруется при запуске)

7. Ставим автозапуск transmission при загрузке роутера и завершение при выключении:  
идем в web-интерфейс tomato - USB и NAS - Поддержка USB и в окошке "Выполнить после подключения добавляем команды:
  sleep 25
  /opt/etc/init.d/S99trans start
В окошке Выполнить перед отключением добавляем:
  /opt/etc/init.d/S99trans stop
  sleep 2
не забываем сохранить.

8. Настраиваем межсетевой экран:  
идем Администрирование - скрипты переходим на вкладку Межсетевой экран и вставлям следующие команды:
  iptables -I INPUT -p tcp --dport 65534 -j ACCEPT
  iptables -I INPUT -p udp --dport 65534 -j ACCEPT
  iptables -I INPUT -p tcp --dport 51413 -j ACCEPT
  iptables -I INPUT -p tcp --dport 9091 -j ACCEPT
не забываем сохранить.

9. Запуск  
Можно запустить перезагрузкой роутера либо из консоли командой
  /opt/etc/init.d/S99trans start
Помимо команд start и stop есть еще 2 команды - restart, соответственно перезапустить трансмишн и force-reload - насильный перезапуск трансмишн (видимо для случаев, когда висит в процессах и не завершается)

ими можно пользоваться например для остановки торрента перед извлечением по кнопке ez-setup (wds):
  /opt/etc/init.d/S99trans stop
  sleep 2
  umount /opt
  sleep 2

или в планировщике ежечасно перезапускать трансмишн (если падает)
  /opt/etc/init.d/S99trans restart

Проверяем - по адреcу http://192.168.1.1:9091 (IP роутера + порт 9091 либо DynDNS + порт 9091)
  логин root
  и пароль который вы указали в файле settings.json

10. Остановка Transmission перед выключением роутера  
Администрирование - скрипты - вкладка завершение:
  /opt/etc/init.d/S99trans stop
  sleep 2

11. Проверка работы Transmission:  
Идем администрирование - планировщик - выбираем свободное задание команды пользователя, дальше по вашему усмотрению, хоть раз в минуту, хоть раз в день проверять наличие запущенного трансмишина командой:
  /opt/usr/sbin/trans.sh
Срипт при отсутствии в памяти процесса трансмишн - перезапускает его, при этом в системном журнале будет запись - примерно такого содержания:
  Jul 16 16:22:01 unknow user.notice root: *** Проверка торрента *** Transmission запущен!^M

12. Внимание! Новые версии трансмишена более требовательны к памяти, нужно разрешить использовать больше, для этого идем Администрирование-скрипты-инициализация и добавляем следующие 3 строки:
  echo 16384 >/proc/sys/vm/min_free_kbytes
  echo 4194304 >/proc/sys/net/core/rmem_max
  echo 1048576 >/proc/sys/net/core/wmem_max
Не забываем сохранить.

[Рекомендую к использованию интерфейс transgui - [[http://code.google.com/p/transmisson-remote-gui/downloads/list]()

В андроид маркете есть версия для устройств на андроиде.

Обновить до последней версии:
  ipkg update && ipkg install transmission