#  Настройка логов iptables в syslog-ng
##  Настройка
Настроим логирование iptables в отдельные файлы.

На примере правила
  iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j LOG --log-prefix "SSH-connect: "

/etc/syslog-ng/syslog-ng.conf
```
...
#filter f_kern { facility(kern); };
filter f_kern { facility(kern) and not filter(f_iptables); };
...
## правила iptables
destination iptables { file("/var/log/iptables/iptables.log" owner(root) group(root) perm(0600) dir_perm(0700) create_dirs(yes)); };
filter f_iptables { message("^(\\[.*\..*\] |)SSH-connect:.*"); };
log { source(kernsrc); filter(f_iptables); destination(iptables); };
```
Обязательно указываем префикс в правилах -j LOG
```-j LOG --log-prefix "SSH-connect: "```
Называть можно как угодно, вести логи для разных префиксов в отдельных файлах, не забывать добавлять соответствующие фильтры в конфиг syslog-ng.

Изменяем фильтр f_kern, что бы не дублировать логи iptables в kern.log

##  Ротация логов
/etc/logrotate.d/syslog-ng.my
```
/var/log/iptables/*.log {
    sharedscripts
    missingok
    postrotate
        /etc/init.d/syslog-ng reload > /dev/null 2>&1 || true
    endscript
}
```