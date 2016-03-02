# Создание multiboot HDD в linux (GRUB2+memdisk+grub4dos).
## Создание multiboot HDD в linux (GRUB2+memdisk+grub4dos)

В какой-то определённый момент мне надоело носить с собой с десяток загрузочных флешек. И создал я себе multiboot usb hdd.

**Нам понадобятся:**

- Установленный linux с grub2
- memdisk из [syslinux](https://www.kernel.org/pub/linux/utils/boot/syslinux/)
- grub.exe из [grub4dos](http://download.gna.org/grub4dos/)
- [Plop Boot Manager](http://www.plop.at/en/bootmanager/download.html)
- [firadisk](http://www.mediafire.com/download/zqbzl5sa77tlmpl/firadisk-driver-0.0.1.30-f6.7z)

Данный способ должен работать и для флешек, но тестирования не проводилось.

**Описано добавление:**

- Hiren's boot CD
- Dr.Web Live CD
- Debian Netinstall
- Ultimate Boot CD
- SystemRescue CD
- Clonezilla CD
- Memtest CD
- Ubuntu Live CD
- Lubuntu Live CD
- Windows XP CD

**Подготовка диска**

В первую очередь стоит разбить будущий загрузочный жёсткий диск на несколько разделов. Я решил разбить на два раздела: один загрузочный, второй для различных файлов.
После изменения таблицы разделов все данные, что есть на диске в данный момент будут потеряны!

**Создание разделов**
```
#fdisk /dev/sdX
```
Создадим пустую таблицу разделов.
```
Command (m for help): o
```
Создадим раздел для multiboot.
```
Command (m for help): n
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-XXXXXXXXX, default 2048):
Last sector, +sectors or +size{K,M,G} (2048-XXXXXXXXX, default XXXXXXXXX): +32G
```
Создадим раздел для данных.
```
Command (m for help): n
Select (default p): p
Partition number (1-4, default 2): 2
First sector (67110912-XXXXXXXXX, default 67110912):
Last sector, +sectors or +size{K,M,G} (67110912-XXXXXXXXX, default XXXXXXXXX):
```
Пометим первый раздел как загрузочный и запишем изменения на диск:
```
Command (m for help): a
Partition number (1-4): 1
Command (m for help): w
```

**Создание файловых систем**

Создадим файловые системы:

- на разделе для multiboot: FAT32
- на разделе для данных: NTFS

```
#mkfs.vfat -n boot /dev/sdX1
#mkfs.ntfs -f -L data /dev/sdX2
```

**Установка загрузчиков**

Смонтируем раздел для multiboot и установим на него grub2.
```
#mount /dev/sdX1 /mnt
#grub-install --no-floppy --root-directory=/mnt /dev/sdX
```
Извлечём из архива с syslinux файл «memdisk/memdisk», из архива с grub4dos файл «grub.exe», из архива с Plop файл «plpbt.bin», из архива с firadisk файл «firadisk.img».
```
$unzip -j -d /mnt/boot/ syslinux-X.X.zip memdisk/memdisk
$unzip -j -d /mnt/ grub4dos-X.X.X.zip grub4dos-X.X.X/grub.exe
$unzip -j -d /mnt/ grub4dos-X.X.X.zip grub4dos-X.X.X/grldr
$unzip -j -d /mnt/boot/ plpbt-X.X.X.zip plpbt-X.X.X/plpbt.bin
$7z x -o/mnt/boot/ firadisk-driver-0.0.1.30-f6.7z
```

**Подготовка образов**

Создадим каталог для iso файлов. Скопируем в каталог iso файлы для Ultimate Boot CD, SystemRescue CD, Clonezilla CD (clz16.iso — версия i486, clz32.iso — версия i686pae, clz64.iso — версия amd64), Memtest CD, Debian Netinstall, Ubuntu, Lubuntu, Windows XP.
```
$mkdir /mnt/iso
$cp ./iso/{clz16.iso,clz32.iso,clz64.iso,ubcd.iso,sysr.iso,memtest.iso,debian32.iso,debian64.iso,ubuntu32.iso,ubuntu64.iso,lbuntu32.iso,lbuntu64.iso,xp.iso} /mnt/iso/
```

**Hiren's Boot CD**

Распакуем каталог «HBCD» из iso файла. После этого извлечём файл «grub.exe» в корень раздела для multiboot.
```
$7z x ./iso/hiren.iso -o/mnt/ -ir\!HBCD
```

**Dr.Web Live CD**

Распакуем каталог «boot» из iso файла во временный каталог и переместим его содержимое в каталог «boot» на разделе для multiboot.
```
$mkdir /mnt/drweb
$7z x ./iso/drweb.iso -o/tmp -ir\!boot
$mv /tmp/boot/* /mnt/boot/
```
Так же узнаем BOOT_ID.
```
$cat /mnt/drweb/config|grep BOOT_ID
export BOOT_ID=xxxxxxxxxxxxxxxxxxxx
```
Создадим файл конфигурации "/mnt/boot/drweb.lst" для grub4dos и добавим в него следующее содержимое:
```
title 1. Dr.Web Russian
kernel /boot/vmlinuz ID=<Тут вставить BOOT_ID> root=/dev/ram0 init=/linuxrc init_opts=4 vga=791 splash=silent,theme:drweb CONSOLE=/dev/tty1 BOOT_LANG=ru_RU.UTF-8 quiet
initrd /boot/initrd

title 2. Dr.Web Advanced options
kernel /boot/vmlinuz ID=<Тут вставить BOOT_ID> root=/dev/ram0 init=/linuxrc init_opts=3 CONSOLE=/dev/tty1
```

**Debian Netinstall**

Создадим каталоги для установщиков debian и скачаем файлы «initrd.gz» и «vmlinuz» для загрузки с hd-media для соответствующих архитектур.
```
$mkdir /mnt/debian
$mkdir /mnt/debian/{amd64,i386}
$wget -cO /mnt/debian/i386/initrd.gz http://ftp.nl.debian.org/debian/dists/wheezy/main/installer-i386/current/images/hd-media/initrd.gz
$wget -cO /mnt/debian/i386/initrd.gz http://ftp.nl.debian.org/debian/dists/wheezy/main/installer-i386/current/images/hd-media/vmlinuz
$wget -cO /mnt/debian/amd64/initrd.gz http://ftp.nl.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/hd-media/initrd.gz
$wget -cO /mnt/debian/amd64/initrd.gz http://ftp.nl.debian.org/debian/dists/wheezy/main/installer-amd64/current/images/hd-media/vmlinuz
```

**Ultimate Boot CD**

Создадим файл конфигурации "/mnt/boot/ubcd.lst" для grub4dos и добавим в него следующее содержимое:
```
title Ultimate Boot CD
map (hd0,0)/iso/ubcd.iso (hd32)
map --hook
root (hd32)
chainloader (hd32)
```

**Windows XP CD**

Создадим файл конфигурации "/mnt/boot/win.lst" для grub4dos и добавим в него следующее содержимое:
```
title 1. Windows XP (1st)
map --mem /boot/firadisk.img (fd0)
map --mem /iso/xp.iso (hd32)
map --hook
chainloader (hd32)
 
title 2. Windows XP (2nd)
map --mem /boot/firadisk.img (fd0)
map --mem /iso/xp.iso (hd32)
map --hook
find --set-root --ignore-floppies --ignore-cd /ntldr
map () (hd0)
map (hd0) ()
map --rehook
find --set-root --ignore-floppies --ignore-cd /ntldr
chainloader /ntldr
```

**Конфигурационный файл для GRUB2**


/mnt/boot/grub/grub.cfg
```
have_grubenv=true
load_env
insmod part_msdos
insmod fat
set gfxmode=640x480
set locale_dir=/boot/grub/locale
set lang=ru_RU
set menu_color_highlight=yellow/dark-gray
set menu_color_normal=black/light-gray
set color_normal=yellow/black

submenu «1. AVP»{
menuentry «1. Dr.Web»{
linux /grub.exe --config-file=/boot/drweb.lst
}
}
submenu «2. Boot cd»{
menuentry «1. Hiren's boot cd»{
linux /grub.exe --config-file=/HBCD/menu.lst
}
menuentry «2. Ultimate Boot CD»{
linux /grub.exe --config-file=/boot/ubcd.lst
}
menuentry «3. SystemRescue CD (i586)» {
set isofile="/iso/sysr.iso"
loopback loop $isofile
linux (loop)/isolinux/rescue32 setkmap=ru isoloop=$isofile
initrd (loop)/isolinux/initram.igz
}
menuentry «4. SystemRescue CD (amd64)» {
set isofile="/iso/sysr.iso"
loopback loop $isofile
linux (loop)/isolinux/rescue64 setkmap=ru isoloop=$isofile
initrd (loop)/isolinux/initram.igz
}
menuentry «5. Clonezilla (i468)» {
set isofile="/iso/clz16.iso"
loopback loop $isofile
linux (loop)/live/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run=\«ocs-live-general\» ocs_live_extra_param=\"\" ocs_live_keymap=\"\" ocs_live_batch=\«no\» ocs_lang=\"\" vga=788 ip=frommedia nosplash noeject toram=filesystem.squashfs findiso=$isofile
initrd (loop)/live/initrd.img
}
menuentry «6. Clonezilla (i686pae)» {
set isofile="/iso/clz32.iso"
loopback loop $isofile
linux (loop)/live/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run=\«ocs-live-general\» ocs_live_extra_param=\"\" ocs_live_keymap=\"\" ocs_live_batch=\«no\» ocs_lang=\"\" vga=788 ip=frommedia nosplash noeject toram=filesystem.squashfs findiso=$isofile
initrd (loop)/live/initrd.img
}
menuentry «7. Clonezilla (amd64)» {
set isofile="/iso/clz64.iso"
loopback loop $isofile
linux (loop)/live/vmlinuz boot=live live-config noswap nolocales edd=on nomodeset ocs_live_run=\«ocs-live-general\» ocs_live_extra_param=\"\" ocs_live_keymap=\"\" ocs_live_batch=\«no\» ocs_lang=\"\" vga=788 ip=frommedia nosplash noeject toram=filesystem.squashfs findiso=$isofile
initrd (loop)/live/initrd.img
}
}
submenu «3. Parted Magic»{
menuentry «1. Parted Magic RAM (i586)»{
set isofile="/iso/pmagic.iso"
loopback loop $isofile
linux (loop)/pmagic/bzImage iso_filename=$isofile edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal loglevel=9 max_loop=256 vmalloc=384MiB keymap=ru ru_RU
initrd (loop)/pmagic/initrd.img
}
menuentry «2. Parted Magic RAM (amd64)»{
set isofile="/iso/pmagic.iso"
loopback loop $isofile
linux (loop)/pmagic/bzImage64 iso_filename=$isofile edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal loglevel=9 max_loop=256 vmalloc=384MiB keymap=ru ru_RU
initrd (loop)/pmagic/initrd.img
}
menuentry «3. Parted Magic Live (i586)»{
set isofile="/iso/pmagic.iso"
loopback loop $isofile
linux (loop)/pmagic/bzImage iso_filename=$isofile edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal loglevel=9 livemedia noeject max_loop=256 vmalloc=384MiB keymap=ru ru_RU
initrd (loop)/pmagic/initrd.img
}
menuentry «4. Parted Magic Live (amd64)»{
set isofile="/iso/pmagic.iso"
loopback loop $isofile
linux (loop)/pmagic/bzImage64 iso_filename=$isofile edd=off load_ramdisk=1 prompt_ramdisk=0 rw vga=normal loglevel=9 livemedia noeject max_loop=256 vmalloc=384MiB keymap=ru ru_RU
initrd (loop)/pmagic/initrd.img
}
}
submenu «4. Debian»{
menuentry «1. Debian netinstall (i368)» {
linux /debian/i386/vmlinuz priority=low vga=788 — initrd /debian/i386/initrd.gz
}
menuentry «2. Debian netinstall (amd64)» {
linux /debian/amd64/vmlinuz priority=low vga=788 — initrd /debian/amd64/initrd.gz
}
}
submenu «5. Ubuntu»{
menuentry «1. Ubuntu live (i386)»{
set isofile="/iso/ubuntu32.iso"
loopback loop $isofile
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile locale=ru_RU.UTF-8 console-setup/layoutcode=ru noeject noprompt — initrd (loop)/casper/initrd.lz
}
menuentry «2. Ubuntu live (amd64)»{
set isofile="/iso/ubuntu64.iso"
loopback loop $isofile
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile locale=ru_RU.UTF-8 console-setup/layoutcode=ru noeject noprompt — initrd (loop)/casper/initrd.lz
}
}
submenu «6. Lubuntu»{
menuentry «1. Lubuntu live (i386)»{
set isofile="/iso/lbuntu32.iso"
loopback loop $isofile
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile locale=ru_RU.UTF-8 console-setup/layoutcode=ru noeject noprompt — initrd (loop)/casper/initrd.lz
}
menuentry «2. Lubuntu live (amd64)»{
set isofile="/iso/lbuntu64.iso"
loopback loop $isofile
linux (loop)/casper/vmlinuz boot=casper iso-scan/filename=$isofile locale=ru_RU.UTF-8 console-setup/layoutcode=ru noeject noprompt — initrd (loop)/casper/initrd.lz
}
}
menuentry «7. Windows»{
linux /grub.exe --config-file=/boot/win.lst
}
submenu «8. Tools»{
menuentry «1. Memtest» {
set isofile="/iso/memtest.iso"
linux16 /boot/memdisk iso
initrd16 $isofile
}
menuentry «2. Plop Boot Manager» {
linux16 /boot/plpbt.bin
}
}
menuentry «9. First hdd»{
insmod ext2
insmod ntfs
set root=(hd1)
chainload+1
}
```

**Тестирование**

Для тестирования я использовал VirtualBox.

Прикрепить к виртуальной машине физический диск можно следующим способом:

VBoxManage internalcommands createrawvmdk -filename ./sdX.vmdk -rawdisk /dev/sdX

После этого просто прикрепить файл «sdX.vmdk» к виртуальной машине. Не забудьте размонтировать разделы перед запуском виртуальной машины.

## Комментарии:
Спасибо за статью!

Себе тоже делал такую штуку, только намного проще в плане реализации. В качестве загрузчика использовал только syslinux с минимальной конфигурацией. Например, чтобы грузить тот же Hiren, достаточно в своем конфиге кинуть ссылку на его «родной» конфиг
```
LABEL hiren
MENU LABEL Hiren's Boot CD 15.1
CONFIG /HBCD/isolinux.cfg
APPEND /HBCD
MENU SEPARATOR
```
Аналогично грузить и SystemRescueCD, только дистрибутивы у меня немножко структурированы и соответственно пути отличаются от стандартных,
```
LABEL sysrescuecd
MENU LABEL System Rescue CD 3.0.0
CONFIG /boot/linux/sysrcd/isolinux/isolinux.cfg
APPEND /boot/linux/sysrcd/isolinux
MENU separator
```
поэтому патчу оригинальный конфиг после распаковки обновленной версии.
```
sed -i .bak -e 's#scandelay=1#& subdir=/boot/linux/sysrcd#g' \ 
-e 's#/bootdisk#/boot/linux/sysrcd/bootdisk#g' \
-e 's#/ntpasswd#/boot/linux/sysrcd/ntpasswd#g' ./sysrcd/isolinux/isolinux.cfg
```

Маленькие самодостаточные загрузочные диски можно грузить прямо с исошников через memdisk, например mfsBSD
```
LABEL mfsbsd9_32
MENU LABEL mfsBSD 9
KERNEL /boot/syslinux/memdisk
APPEND iso raw
INITRD /boot/bsd/mfsbsd-9.iso

