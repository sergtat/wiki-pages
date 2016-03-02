# Создание мультизагрузочного USB-диска из нескольких liveCD.
_Июль 3, 2010 Автор: qq_

Идея данной статьи возникла пару месяцев назад, когда я пересоздавал свой multiboot раздел... Сложного здесь ничего нет, и существует множество статей на эту тему, но есть несколько тонкостей, которые пришлось вспомнить/заново открыть для себя. Чтобы не вспоминать потом в третий раз:) напишу то, что еще не забыл с тех пор.

Методов создания multiboot-дисков существует несколько: использование [syslinux/extlinux/isolinux](http://syslinux.zytor.com/), [grub](http://www.gnu.org/software/grub), [bcdw](http://bootcd.narod.ru/) и прочие. Некоторое время назад я использовал bcdw для LiveCD, потом перешел на syslinux, а в этот раз, столкнувшись с тем, что несколько live-дистрибутивов собраны на базе Ubuntu и желают видеть свой casper в корне, задумался, не перейти ли на grub (особенно после прочтения на opennet'e новости/заметки про то, что в grub'e можно подключать iso-шники напрямую)? Но, как оказалось, не все так просто и настройка multiboot grub'a для usb-диска не так проста, как хотелось бы (по крайней мере в первый раз),  а передача  управления загрузчику из iso-образа возможна только в grub4dos (при этом образ целиком грузится в память, что достаточно расточительно, да и FAT-разделов я стараюсь избегать), а в обычном grub'е iso-образ монтируется в процессе загрузки, и все равно нужно прописывать параметры ядра и пр., что не сильно проще быстрее, чем с syslinux. Поэтому, после того, как с помощью Нигмы было найдено решение для дружбы casper'ов, я решил остаться на syslinux.

У меня используется жесткий диск на 120Gb, разбитый следующим образом: 1Gb -- swap-раздел, 10Gb -- раздел для live-дистрибутивов (ext3), а все остальное под носимые данные. Т.к. для live-раздела была выбрана файловая система ext3, в качестве загрузчика  используется extlinux, для cd/dvd дисков  нужно использовать isolinux, при этом конфигурационные файлы останутся теми же (разве что  нужно будет убрать параметры для сохранения измененных во время live-работы файлов, а также используется другая команда для установки загрузчика)

Команды установки загрузчика описаны для версии syslinux 3.8x и могут несколько отличаться от команд недавно вышедшей версии 4.0.

Сначала нужно записать загрузчик mbr.bin, идущий в составе syslinux на диск (пусть диск в системе имеет имя sdd, в моем случае раздел 2, т.к. первый раздел это swap)

	dd if=mbr.bin of=/dev/sdd2

Меню для загрузок будем хранить в каталоге boot выделенного раздела, а файлы extlinux'a в boot/extlinux. Для установки загрузчика нужно создать каталоги и выполнить следующую команду (раздел должен быть примонтирован, например, на `/mnt/hd`)

	extlinux -i /mnt/hd/boot/extlinux

Также в boot поместим следующие файлы из дистрибутива syslinux:

- chain.c32 - используется для передачи управления следующему  загрузчику (дискета, загрузочный раздел диска)
- menu.c32 - используется для отображения загрузочного меню
- vesamenu.c32 - используется для отображения загрузочного меню

Загрузчик будет искать параметры в файле `/boot/extlinux/extlinux.conf` (syslinux -- в файле `syslinux.conf`) на загрузочном разделе. Конфигурационные файлы для все утилит семейства syslinux имеют один формат, и позволяют подключать другие файлы. Это заметно облегчает жизнь, т.к. мы можем вести отдельный файл для каждого дистрибутива, а в extlinux.conf только ссылку на него. Сам же файл переделывается из соответствующего syslinux.conf (isolinux.conf), идущего в iso-образе с livecd.

Параметры конфигурационного файла я подробно рассматривать не буду (см. man syslinux), лишь приведу краткий шаблон для extlinux.conf и процесс адаптации isolinux.conf от livecd. Полные версии моих загрузочных файлов прикреплены к статье.
```
extlinux.conf

DEFAULT /boot/menu.c32      #используем меню как загрузчик по умолчанию
PROMPT 0                    #запускаем меню сразу

MENU SEPARATOR              #разделитель в меню.
                            #Стоит первым, т.к. используется "заворот" меню

LABEL test                  #метка, по которой можно вызвать этот пункт
MENU LABEL TEST             #имя, отображаемое в меню для этого пункта
  KERNEL /boot/menu.c32     #загрузчик menu, т.к. нужно обработать конфигурационный файл подменю
  APPEND /boot/test.cfg ~   #имя файла с подменю для для этого пункта.
                            #Тильда в конце обозначает, что в конец подменю
                            #нужно добавить корневое меню ("заворот")
TEXT HELP                   # Между TEXT HELP и ENDTEXT указывается подробное описание.
   Test v1.2.3 boot menu
ENDTEXT
```
Если нужна возможность загрузки с локальных носителей можно добавить следующие пункты:
```
LABEL floppy
MENU LABEL Boot from first floppy
  kernel /boot/chain.c32
  append fd0
  TEXT HELP
    Boot local floppy
  ENDTEXT

LABEL local1
MENU LABEL Boot from first hard disk
  kernel /boot/chain.c32
  append hd0
  TEXT HELP
    Boot local OS installed on first hard disk
  ENDTEXT

LABEL local2
MENU LABEL Boot from second hard disk
  kernel /boot/chain.c32
  append hd1
  TEXT HELP
    Boot local OS installed on second hard disk
  ENDTEXT
```
Для загрузки по сети с помощью [etherboot и/или gPXE](http://etherboot.org/wiki/index.php) нужно добавить соответствующие загрузочные образа и прописать их в меню
```
label etherboot
MENU LABEL Network boot via etherboot
  kernel /img/eb.zli
  TEXT HELP
    Run Etherboot to enable network (PXE) boot
  ENDTEXT

label gPXE
MENU LABEL Network boot via gPXE
  kernel /img/gpxe.lkn
  TEXT HELP
    Run gPXE to enable network (PXE) boot
  ENDTEXT
```
Далее схема следующая:

1. Монтируем iso-образ с нужным livecd (пусть это будет test.iso)

	`mount ./test.iso /mnt/cdrom -o loop`
2. Создаем на загрузочном разделе каталог с соответствующим названием и копируем туда содержимое образа
	`mkdir /mnt/hd/test && cp -R /mnt/cdrom /mnt/hd/test`
3. Находим внутри примонтированного образа isolinux.conf, и копируем его под другим именем в каталог boot на загрузочном разделе.
4. Добавляем пункт меню в extlinux.conf аналогично тому, как было описано выше.
5. Правим .cfg -файл и, если требуется, дистрибутив для загрузки из нового каталога.

Стандартные правки:

- изменение путей в параметре DEFAULT и справке (параметры F1, F2 и пр.)
- изменение путей в параметрах KERNEL (если раньше было /boot/vmlinuz, то после переноса содержимого в /test стало /test/boot/vmlinuz)
- изменение путей в параметрах APPEND, в частности initrd (если раньше было initrd=/boot/initrd, то после переноса содержимого в /test стало initrd=/test/boot/initrd)

Изменение/добавление прочих параметров зависит от livecd-дистрибутива. Ниже будут рассмотрены дистрибутивы, используемые у меня:

[BackTrack 3](http://www.backtrack-linux.org/)

Изменяются только стандартные вещи.

[BackTrack 4](http://www.backtrack-linux.org/)

Эта версия как раз основана на Ubuntu, поэтому кроме стандартных преобразований требуется переселение casper'a в initrd. Для этого можно использовать [скрипт с форума Hack from a cave](http://forum.hackfromacave.com/viewtopic.php?f=4&t=40). При запуске скрипту нужно указать путь к initrd-файлу (в BT4 их 3: boot/initrd.gz, boot/initrd800.gz, boot/initrdfr.gz) и новый путь к каталогу casper.

[Clonezilla-live](http://clonezilla.org/)

Кроме стандартных изменений, в APPEND нужно добавить параметр live-media-path, указывающий путь к каталогу live (например, `live-media-path=/clonezilla/live`)

[DrWeb Live CD](http://freedrweb.com/)

Не предназначен для загрузки из некорневого каталога. Но это можно исправить, пересобрав initrd. Initrd там собран [Squashfs'ом](http://squashfs.sourceforge.net/). Поэтому, нужно сначала примонтировать образ (если ядро собрано без поддержки squashfs, можно использовать утилиту unsquashfs), скопировать файлы в отдельный каталог, исправить загрузочные пути в файлах init, linuxrc, etc/init.d/linuxrc и собрать обратно используя mksquashfs.
```
mkdir -p ./init ./new_init
mount initrd ./init -o loop

cp -R ./init/* ./new_init
umount ./init

rm -r ./init
rm initrd

cd ./new_init
sed -i "s/\/boot\//\/new_drweb_dir\/boot\//g" ./init

cp ./init ./linuxrc
cp ./init ./etc/init.d/linuxrc

cd ../
mksquashfs ./new_init $INIT_FILE
rm -r ./new_init
```
Для себя я это дело оформил в виде скриптa, аналогично скриптам для исправления casper'a (в архиве называется fixDrweb.sh). Также при обновлении дистрибутива нужно не забывать исправлять значение параметра ID в APPEND'е (правильное значение лежит в файле boot/config в дистрибутиве DrWeb Live CD).

Кроме этого, у меня были некоторые проблемы с определением диска и желание сохранять изменения на диск. Поэтому был сделан патч, добавляющий параметр subdir, исправляющий определение дисков и реализующий запись изменений. Патч писался на скорую руку, поэтому на него нет никаких гарантий (patchDrweb.sh, drweb_linuxrc.patch).

[Helix 2008R1](http://distrowatch.com/?newsid=05102)

Основан на Ubuntu, поэтому исправляется аналогично BT4, но еще нужно исправить путь $mountpoint/.disk в scripts/casper. Для себя оформил в виде скриптa (в архиве называется fixHelix.sh). Кроме того, у меня возникли пролемы с определением образа, если есть lvm-разделы, поэтому пришлось удалить внутри initrd etc/udev/rules.d/85-lvm.rules (на выявление проблемы потратил достаточно много времени, поэтому желание исправлять работу с lvm пропало, т.к. пока нет необходимости монтировать из-под него lvm)

[KNOPPIX](http://www.knoppix.net/)

Только стандартные изменения

[Memtest86](http://www.memtest86.com/) и [Memtest86+](http://www.memtest.org/)

В принципе, здесь все стандартно: путь к файлу с загрузочным образом пишется прямо в параметр KERNEL
```
LABEL memtestp
MENU LABEL memtest86+
  KERNEL /img/memtestp
  TEXT HELP
      Memtest86+ 4.00
  ENDTEXT
```
главное переименовать файл! (ПО умолчанию файл имеет расширение bin, а такие файлы syslinux считает загрузочной записью. В свое время я потерял около часа, пока разобрался. почему у меня не работает memetest)

[FreeDOS](http://freedos.sourceforge.net/), MHDD и прочие дискетные дистрибутивы

Для загрузки используется memdisk (входит в состав syslinux, копируем в /boot), а путь к образу указывается в APPEND, где также указывается параметр floppy
```
LABEL mhdd
MENU LABEL mhdd
  kernel /boot/memdisk
  append initrd=/img/mhdd.img floppy
  TEXT HELP
    Low-level Hard-Disk disagnostic tool MHDD
  ENDTEXT
```
[Parted Magic](http://partedmagic.com/)

Только стандартные изменения

[Slax](http://www.slax.org/)

Стандартные изменения. Также можно добавить в APPEND параметр changes, в котором указать путь для сохранения изменений и файлов, созданных во время работы с livecd (changes=/slaxsave/).

[SystemRescueCD](http://www.sysresccd.org/)

Кроме стандартных изменений в APPEND нужно добавить параметр subdir, в котором указывает новый каталог, содержащий sysrcd.dat (например, subdir=sysrcd).

[Frenzy](http://frenzy.org.ua/)

Дистрибутив основан на FreeBSD, поэтому с syslinux просто так не срастается. Но есть пара статей ([1](http://frenzy.org.ua/forum.shtml?action=thread_show!0&section=005&thread=1211649218&page=2), [2](http://docs.freebsd.org/cgi/getmsg.cgi?fetch=107264+0+/usr/local/www/db/text/2006/freebsd-hackers/20060326.freebsd-hackers)), в которых описан метод их дружбы. Сам пока Frenzy не использовал, поэтому описанные там методы не проверял.

| Прикрепленный файл                                                                          | Размер   |
|---------------------------------------------------------------------------------------------|----------|
| [boot_scripts.tar_.bz2 Конфигурации загрузки и патчи (md5: 933017e162f2a4d5422192e0123cc2e1)][id1] | 11.56 кб |

[id1]: /files/boot_scripts.tar.bz2

> Источник http://tty.org.ru/
