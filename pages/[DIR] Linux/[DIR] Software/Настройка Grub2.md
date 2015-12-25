#  Настройка Grub2
Как загрузиться с оптического привода грубом — в последний раз я это делал примерно так:
```
root(cd0,0)
makeactive
chainloader + 1
boot
```
иногда еще chainloader --force + 1 помогает

----
Ссылки:  
[]()[http://linuxnow.ru/view.php?id=95|Настройка Grub2]()  
[]()[http://ru.wikibooks.org/wiki/Grub_2|Grub 2 ВикиУчебник]()  
[]()[https://wiki.archlinux.org/index.php/GRUB2_(Русский)|Grub 2 ArchWiki]()  
