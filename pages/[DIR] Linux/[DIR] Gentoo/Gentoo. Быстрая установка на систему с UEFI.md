# Gentoo. Быстрая установка на систему с UEFI
## Вступление.

  Это руководство содержит все команды, которые вы должны использовать для выполнения установки stage3 из Gentoo. Вам нужно подключение к Интернету, чтобы скачать stage3 и Portage снимки.
>> **Важно:** Краткое руководство по установке предназначена для опытных пользователей, которые просто нуждаются в контрольный список, чтобы следовать. Новые пользователи должны прочитать [Handbook][1], поскольку это дает более полное представление о процессе установки.
##Быстрая установка.
###Загрузочный диск
Для установки используйте любой Live-CD, поддерживающий загрузку с UEFI, например SystemResquieCD->=3.0.0
###Network Configuration
Убедитесь, что у Вас есть сеть, или настройте ее.
###Опционально: зайдите через ssh
1. Запустите сервер sshd.
2. Установите root password на liveCD для того, чтобы зайти с другого компьютера.
3. Теперь Вы можете зайти через ssh.

### Подготовка дисков.
Используйте parted или gdisk.

Для загрузки с UEFI диск должен быть размечен как GPT и иметь первый раздел размером не менеее 100Mb и файловой системой FAT32, размеченный как `EFI System`(EF00).
```bash
gdisk /dev/sda

Command (? for help): n
Partition number (1-128, default 1): 1
First sector: (enter desired start sector and size, 100 MB should be plenty)
Command (? for help): t
Partition number (1-2): 1
Hex code or GUID (L to show codes, Enter = 8300): EF00
Command (? for help): w

mkfs.vfat -F 32 /dev/sda1
```
Если у Вас нет mkfs.vfat
```bash
busybox mkfs.vfat /dev/sda
```
Для boot-раздела выбираем BIOS boot patition (EF02).
```bash
gdisk /dev/sda

Command (? for help): n
Partition number (1-128, default 1): 2
First sector: (enter desired start sector and size, 100 MB should be plenty)
Command (? for help): t
Partition number (1-2): 2
Hex code or GUID (L to show codes, Enter = 8300): EF02
Command (? for help): w
```
Создайте раздел swap:
```bash
gdisk /dev/sda

Command (? for help): n
Partition number (1-128, default 1): 3
First sector: (enter desired start sector and size, 100 MB should be plenty)
Command (? for help): t
Partition number (1-2): 3
Hex code or GUID (L to show codes, Enter = 8300): 8200
Command (? for help): w
```
Остальные разделы по Вашему усмотрению.

Создайте файловые системы и подключите swap.

Монтируйте систему в /mnt/gentoo

```bash
mount /dev/sda4 /mnt/gentoo
mkdir /mnt/gentoo/boot
mount /dev/sda2 /mnt/gentoo/boot
mkdir /mnt/gentoo/boot/efi
mount /dev/sda1 /mnt/gentoo/boot/efi
mkdir -p /mnt/gentoo/boot/efi/EFI/gentoo
cd /mnt/gentoo
```
>Я использую следующую разбивку (/home на другом диске):
><table>
<tr><th>Раздел<th>Размер<th>Тип<th>fs<th>Описание
<tr><td>/boot/efi<td>256M<td>EF00<td>vfat<td>UEFI раздел
<tr><td>/boot<td>1G<td>EF02<td>ext2<td>GRUB2 раздел (место под доп. stuff)
<tr><td>swap<td>4G<td>8200<td>swap<td>SWAP
<tr><td>/<td>Ост.<td>8300<td>ext4<td>ROOT
<tr><td>/var<td>3.5G<td>8300<td>ext4<td>VAR
<tr><td>/var/log<td>0.5G<td>8300<td>ext4<td>LOG
<tr><td>/opt<td>1G<td>8300<td>ext4<td>OPT
<tr><td>/var/git<td>--<td>--<td>bind<td>GIT
<tr><td>/var/www<td>--<td>--<td>bind<td>WWW
<tr><td>/tmp<td>--<td>--<td>tmpfs<td>TMP
<tr><td>/var/tmp/portage<td>--<td>--<td>tmpfs<td>PORTAGE
<tr><td>/var/tmp/genkernel<td>--<td>--<td>tmpfs<td>GENKERNEL
</table>

###Установка Stage3
Сначала установите корректное время коммандой date, используя формат `MMDDhhmmYYYY`. Используйте `UTC time`.
```bash
# (Check the clock)
date
Mon Mar  6 00:14:13 UTC 2014

# (Set the current date and time if required)
date 030600162014 (Format is MMDDhhmmYYYY)
Mon Mar  6 00:16:00 UTC 2014
```
Теперь скачайте stage3, например с http://mirror.yandex.ru/gentoo-distfiles/releases/
```bash
wget http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/current-stage3/stage3-amd64-20131226.tar.bz2
wget http://mirror.yandex.ru/gentoo-distfiles/releases/amd64/current-stage3/stage3-amd64-20131226.tar.bz2.DIGESTS
sha512sum -c stage3*.tar.bz2.DIGESTS
tar xjpf stage3*
```
###Chrooting
Смонтируйте /proc, /dev, и /sys, скопируйте /etc/resolv.conf и затем chroot в Ваше новое окружение.
```bash
mount -t proc proc /mnt/gentoo/proc
mount --rbind /dev /mnt/gentoo/dev
mount --rbind /sys /mnt/gentoo/sys
cp -L /etc/resolv.conf /mnt/gentoo/etc/ 
chroot /mnt/gentoo /bin/bash
source /etc/profile
```
Скачайте последний `portage snapshot`, используя `emerge-webrsync`.
```bash
mkdir /usr/portage
emerge-webrsync
```
Установите Вашу `time`зону.
```bash
ls /usr/share/zoneinfo
# (Using Samara as an example)
cp /usr/share/zoneinfo/Europe/Samara /etc/localtime
echo "Europe/Samara" > /etc/timezone

date
Wed Mar  8 00:46:05 SAM 2014
```
###Выберите profile
Выберите profile используя eselect.
```bash
eselect profile list
Available profile symlink targets:
  [1]    default/Linux/x86/13.0 *
  [2]    default/Linux/x86/13.0/desktop
  [3]    default/Linux/x86/13.0/desktop/gnome
  [4]    default/Linux/x86/13.0/desktop/kde
  [5]    default/Linux/x86/13.0/server

eselect profile set 2
```
###Установите hostname and domainname.
Установите hostname в /etc/conf.d/hostname и /etc/hosts.
```bash
cd /etc
echo "127.0.0.1 <mybox.at.myplace> <mybox> <localhost>" > hosts
sed -i -e 's/hostname.*/hostname="<mybox>"/' conf.d/hostname
# (Use defined host name and check)
hostname
<mybox>
hostname -f
<mybox.at.myplace>
```
###Kernel Configuration
Установите kernel source, сконфигурируйте, скомпилируйте и установите в /boot.
```bash
USE=symlink emerge gentoo-sources
```
####Непосредственная сборка ядра
```bash
# cd /usr/src/linux
# make nconfig
(Configure your kernel)
```
> Ссылки:
http://www.gentoo.org/doc/ru/handbook/handbook-amd64.xml?part=1&chap=7
http://kmuto.jp/debian/hcl/

#####initramfs
UEFI не поддерживает отдельную initramfs. Так что если вам нужно initramfs, зто должно быть встроено в ядро через CONFIG_INITRAMFS_SOURCE. Это должен быть несжатый архив CPIO с расширением `.cpio`. Пример для Genkernel initramfs (заменить zcat с xzcat или bzcat если вы изменили алгоритм сжатия в конфигурации ядра):
```bash
zcat /boot/initramfs-genkernel-x86_64-3.6.11-gentoo > /boot/initramfs.cpio 
file /boot/initramfs.cpio
/boot/initramfs.cpio: ASCII cpio archive (SVR4 with no CRC)
```
В ядре
```bash
General setup  --->
    [*] Initial RAM filesystem and RAM disk (initramfs/initrd) support
    (/boot/initramfs.cpio) Initramfs source file(s)
```
Создание самого initramfs
```bash
emerge genkernel
genkernel --install --no-ramdisk-modules initramfs
```
####Сборка через genkernel
```bash
emerge genkernel
genkernel --no-splash --install --menuconfig all
```
> О загрузке ядра.
Загрузка может быть непосредственно через UEFI, тогда никакие загрузчики Вам больше не нужны. Или UEFI будет загружать grub, а grub будет загружать систему.
####Загрузка через UEFI
Чтобы загрузить ядро с UEFI, должна быть включена поддержка CONFIG_EFI_STUB
```bash
Processor type and features  --->
    [*] EFI runtime service support 
    [*]   EFI stub support
```
UEFI не поддерживает параметры ядра при загрузке, так что вы должны задать их через CONFIG_CMDLINE. Пример для корневого раздела на /dev/sda4:
```bash
Processor type and features  --->
    [*] Built-in kernel command line
    (root=/dev/sda4 ro)
```
Для GPT систем, использование `root=PARTUUID=...` может быть предпочтительнее. Найдите PARTUUID используя gdisk:
```bash
gdisk /dev/sda

Command (? for help): i
Partition number (1-5): 4
Partition unique GUID: (передайте ID, который показан здесь в ядро)
Command (? for help): q
```
> `Partition's UUID` отличается от `filesystem's UUID`.
```bash
make all modules_install install
cp /boot/vmlinuz-3.7.9-gentoo /boot/efi/EFI/BOOT/bootx64.efi
```

#### Множественная загрузка через UEFI.
Для конфигурирования UEFI загрузки Вы должны загрузиться в режиме UEFI.

> При желании можно сделать множественную загрузку. Это особенно полезно, если вы хотите иметь больше ядер или двойную загрузку с другой операционной системой. Это будет показано в меню выбора загрузки, как правило после нажатия горячей клавиши во время инициализации системы.

Убедитесь, что у вас включен CONFIG_EFI_VARS и установите sys-boot/efibootmgr.
```bash
Firmware Drivers  --->
    <*> EFI Variable Support via sysfs
```
```bash
emerge sys-boot/efibootmgr
cp /boot/vmlinuz-3.7.9-gentoo /boot/efi/EFI/Boot/vmlinuz.efi 
efibootmgr --create --part 1 --label "Gentoo" --loader '\efi\boot\vmlinuz.efi'
```
***EFI использует в качестве разделителя только \\.***
#### Загрузка через GRUB
***Система должна быть загружена в UEFI-режиме.***

Установим grub
```bash
echo GRUB_PLATFORMS="efi-64" >> /etc/portage/make.conf
emerge grub
grub2-install --target=x86_64-efi --efi-directory=/boot/efi --boot-directory=/boot
```
Это утановит grub в /boot/grub, скопирует дамп памяти в /boot/efi/EFI/gentoo/grubx64.efi, и вызовет efibootmgr для добавления загрузочной записи.
```bash
grub2-mkconfig -o /boot/grub/grub.cfg
```

###Конфигурирование системы

Отредактируйте /etc/fstab.
```bash
/dev/sda4   /         ext4    noatime            0 1
/dev/sda2   /boot     ext2    noauto,noatime     1 2
/dev/sda1   /boot/efi vfat    default            1 2
/dev/sda3   none      swap    sw                 0 0
```
Задайте конфигурацию Вашей сети в /etc/conf.d/net. Добавьте сценарий инициализации net.(имя карты) в уровень запуска по умолчанию. Если у вас несколько сетевых карт, добавьте символьные ссылки на них в сценарий net.lo инициализации и добавьте их в уровень запуска по умолчанию. Не забудьте установить имя хоста. 
```bash
cd /etc/init.d
ln -s net.lo net.enp4s0
cd /etc/conf.d
echo 'config_enp4s0="192.168.1.10 netmask 255.255.255.0 brd 192.168.1.255"' >> net
echo 'routes_enp4s0="default via 192.168.1.1"' >> net
echo 'hostname="myhostname"' > hostname
rc-update add net.enp4s0 default
# (If you compiled your network card driver as a module, add it to /etc/conf.d/modules
echo 'modules="r8169"' >> /etc/conf.d/modules
# (If you want to reconnect via ssh after you have rebooted your new box)
rc-update add sshd default
```
Установите пароль для rootа.
```bash
passwd
New UNIX password: type_the_password
Retype new UNIX password: type_the_password_again
passwd: password updated successfully
```
Отредактируйте /etc/conf.d/hwclock для установки опций времени.

Проверьте конфигурацию в /etc/rc.conf и отредактируйте по потребности.

В /etc/conf.d/keymaps
```bash
keymap="-u ru4"
dumpkeys_charset="koi8-r"
```
###Установка системных утилит
Установим syslog-ng и fcron и затем добавим в автозагрузку.
```bash
emerge syslog-ng fcron
rc-update add syslog-ng default
rc-update add fcron default
```
Установим утилиты файловых систем (xfsprogs, reiserfsprogs и т.д.) и сетевые утилиты (dhcpcd или ppp) если они нужны.
```bash
emerge xfsprogs       (If you use the XFS file system)
emerge jfsutils       (If you use the JFS file system)
emerge reiserfsprogs  (If you use the Reiser file system)
emerge dhcpcd         (If you need a DHCP client)
emerge ppp            (If you need PPPoE ADSL connectivity)
```
###Reboot
Закройте chroot-сессию, отмонтируйте все файловые системы и перезагрузитесь.
```bash
exit
umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -l /mnt/gentoo{/proc,/boot,/sys,}
reboot
```
##Завершение установки
Войдите как root и добавьте одного или нескольких пользователей для повседневных задач через useradd.

Вы можете зайти через ssh
```bash
# (Clean up your known_hosts file because your new box
# has generated a new definitive hostkey)
nano -w ~/.ssh/known_hosts
# (Look for the IP of your new PC and delete the line,
# then save the file and exit nano)

# (Use the IP address of your new box)
ssh root@192.168.1.10
The authenticity of host '192.168.1.10 (192.168.1.10)' can't be established.
RSA key fingerprint is 96:e7:2d:12:ac:9c:b0:94:90:9f:40:89:b0:45:26:8f.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.10' (RSA) to the list of known hosts.
Password: type_the_password
```
Добавление нового пользователя
```bash
useradd -g users -G lp,wheel,audio,cdrom,portage,cron -m john
passwd john
New UNIX password: Set John's password
Retype new UNIX password: Type John's password again
passwd: password updated successfully
```
###Последние этапы подготовки системы
Установите SYNC и GENTOO_MIRRORS переменные в /etc/portage/make.conf
```bach
echo 'SYNC="rsync://mirror.yandex.ru/gentoo-portage/"' >> /etc/portage/make.conf
echo 'GENTOO_MIRRORS="http://mirror.yandex.ru/gentoo-distfiles ${GENTOO_MIRRORS}"' >> /etc/portage/make.conf
```
Установите MAKEOPTS равной количеству ядер + 1.
```bash
echo 'MAKEOPTS="-j3"' >> /etc/portage/make.conf
```
Установите CFLAGS в make.conf для своей системы. Правильные CFLAGS можно найти по запросу 'gentoo safe cflags'

Например:
```bash
echo 'CFLAGS=”-O2 -march=athlon-xp -pipe”' >> /etc/portage/make.conf
echo 'CXXFLAGS="${CFLAGS}"' >> /etc/portage/make.conf
echo 'CHOST="x86_64-pc-linux-gnu"' >> /etc/portage/make.conf
```
####Локализация
Отредактируйте /etc/locale.gen и оставьте только нужные локали
```bash
en_US ISO-8859-1
en_US.UTF-8 UTF-8
ru_RU.UTF-8 UTF-8 

locale-gen
```
Для установки локали создайте /etc/env.d/02locale
```bash
LANG="ru_RU.UTF-8"

env-update
```
Для локализации консоли Вы должны установить в файле /etc/rc.conf переменную `unicode="YES"`. 

В файл /etc/conf.d/keymaps внесите следующие изменения:
```bash
KEYMAP="-u ru4"
DUMPKEYS_CHARSET="koi8-r"
```
Поставьте подходящий шрифт
```bash
echo media-fonts/terminus-font -X >> /etc/portage/package.use
emerge terminus-font
```
Отредактируйте /etc/conf.d/consolefont:
```bash
CONSOLEFONT="ter-k14n"
```
Добавьте флаг unicode в USE-флаги в make.conf

####Пересобрание "мира"
Теперь Вы должны пересобрать систему ("мир"), чтобы применить все изменения в конфигурации. 
```bash
emerge -avuDN @world
```
Пересоберите libtool для избежания потенциальных проблем.
```bash
emerge --oneshot libtool
```
Примите или отклоните изменения в конфигурационных файлах, используя dispatch-conf
```bash
dispatch-conf
```
Для окончания наведите порядок с perl и python
```bash
perl-cleaner all
python-updater
```
##Что дальше
Вы получили готовую Gentoo-систему. Далее Вы можете построить на ее основе какой-либо серевер или десктоп-систему. Как пример вы можете поставить gnome или kde или fluxbox. Или apache/nginx/nodejs web-server. Также можно устроить mail-serever, multimedia stream-server, log-server, video-server и т.д.

Находите документацию и устанавливайте приложения на Ваш вкус.

Удачи!

  [1]: http://www.gentoo.org/doc/en/handbook/index.xml
