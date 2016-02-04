# Portage TMPDIR on tmpfs.
> Собирать пакеты можно в `tmpfs` (в памяти) вместо использования Вашего HDD или SSD. Сборка пакетов в `tmpfs` увеличивает скорость вводо-выводы и снижает изнашиваемость `HDD/SSD`. Для систем с `SSD` это снизит нагрузку на диски и сбережет драгоценные циклы записи `SSD`.

## Настройка.
Для монтирования `PORTAGE_TMPDIR` добавте в `/etc/fstab` следующие строки:
```bash
tmpfs	/var/tmp/portage	tmpfs	size=2G,uid=portage,gid=portage,mode=775,noatime	0 0
```
Выбирайте значение параметра `size` до нужного объема оперативной памяти.

После внесения исправлений примонтируйте `PORTAGE_TMPDIR` в память:
```bash
sudo mount /var/tmp/portage
```
## О размерах `tmpfs`.
Размеры `tmpfs` должны быть достаточно большими, что бы могли компилироваться пакеты системы. Если при сборке отведенное место будет полностью заполнено, вознинет ошибка. Для бльшинства пакетов достаточно 1M памяти, но есть несколько особенно больших пакетов, которым требуется больше. Если Вы хотите собирать такие программы, убедитесь, чтто у Вас достаточно места в `tmpfs`. Вот примерные требования пакетов.

| Package                | Memory usage                                                                     |
|------------------------|----------------------------------------------------------------------------------|
| www-client/chromium    | 10 GBs or so with 3 GBs of extra system memory.                                  |
| www-client/firefox     | Around 4 GBs; or 8 GBs if the pgo, debug, or test USE flag is enabled.           |
| sys-devel/gcc          | Around 4 GBs, but should be much lesser if Java and Objective C is not included. |
| app-office/libreoffice | 6 GBs or so with 512 MBs extra system memory.                                    |

## Выбор PORTAGE_TMPDIR во время компиляции.
`Portage` может быть настроен на сборку больших пакетов за пределами `tmpfs`.

Создайте файл, в котором укажите расположения `PORTAGE_TMPDIR` не в `tmpfs`.
```bash
# /etc/portage/env/notmpfs.conf

PORTAGE_TMPDIR="/var/tmp/notmpfs"
```
Создайте указанную  директорию.
```bash
sudo mkdir /var/tmp/notmpfs
sudo chown portage:portage /var/tmp/notmpfs
sudo  chmod 775 /var/tmp/notmpfs 
```

Создайте файл [package.env](https://wiki.gentoo.org/wiki//etc/portage/package.env) в `/etc/portage` и укажите список пакетов, которые не следует собирать с применением `tmpfs`.
```bash
app-office/libreoffice notmpfs.conf
mail-client/thunderbird notmpfs.conf
www-client/chromium notmpfs.conf
www-client/firefox notmpfs.conf
```

## Tips
### Resizing tmpfs

To resize the current tmpfs instance in /var/tmp/portage, run:

	root #mount -o remount,size=N /var/tmp/portage

Where N is in the form of bytes. It can also be suffixed with k, m, or g to respectively have the form of (k)ilobytes, (m)egabytes or (g)igabytes. It can also be suffixed with a % to limit the tmpfs instance to the percentage of current physical RAM, the default being 50% when the parameter is not specified.

The resized tmpfs will not persist to the next boot unless the size parameter is modified in /etc/fstab. This is not necessary since a larger tmpfs is only needed during large package compilations.

It is recommended to leave-out at least 1 GB of space for the system to prevent out-of-memory problems. Using swap-disks for some heavy compile-time and link-time instances which are unexpected may also be helpful. Now even if swap-disks are used, reads and writes to it would only be minimal compared to having a physical filesystem behind /var/tmp/portage.

Here is a note about the size parameter in Linux kernel's documentation which can be found in /usr/src/linux/Documentation/filesystems/tmpfs.txt as long as a kernel has been emerged:
```bash
FILE tmpfs.txtTMPFS information

size: The limit of allocated bytes for this tmpfs instance.
The default is half of your physical RAM without swap.
If you oversize your tmpfs instances the machine will deadlock
since the OOM handler will not be able to free that memory.
```
Besides the obvious danger of choking the system by allocating too much memory for tmpfs space, it should be generally safe to enlarge the tmpfs during an emerge as this would only increase the size limit of the tmpfs without destroying any data from the emerge process.

For example, if a system has 12 GB of RAM and 3 disks with 2 GB of swap space working in parallel on each disk, then it would be pretty safe to choose size limit equal to 16G. 16 GB size is usually enough to compile Libreoffice and Chromium in parallel (usual emerge -1uDN @world) while reading Internet in a web browser.

It's not often that you'll ever have to do it and emerge would tell you that tmpfs is too small however there are instances that the package's ebuild would be not accurate at estimating the amount of disk space necessary for building the package. Newer packages may end up allocating more space, whereas using lesser USE flags would make it allocate less.

The solution for this is to either enlarge tmpfs, or add the exception to /etc/portage/package.env, and then run emerge again.

### Save an emerge and resume later
> Note: This is experimental. ebuild experts should be queried about how reliable this command is; when to use it and when not to.

**Example:** emerging webkit-gtk can take a long time. I want to reboot into another OS and resume this ebuild later.

_Optional:_ I use app-portage/genlop to inspect the current emerge session. I like using it to remind me of the ebuild version number or hopefully to get an estimated time remaining.
```bash
user $ genlop -c

Currently merging 1 out of 2

 * net-libs/webkit-gtk-2.4.8 

       current merge time: 4 hours, 27 minutes and 35 seconds.
       ETA: unknown.
```
Press Ctrl+C to quit the current emerge session.

Since I am rebooting, I'll have to use cp -a or tar -cpf to save /var/tmp/portage/* while preserving permissions. Otherwise the tmpfs contents will be lost; You may want to inspect the memory size of /var/tmp/portage by using du:

```
root #du -sh /var/tmp/portage/

251M	/var/tmp/portage/
```
Reboot, do other stuff, come back later.

Restore /var/tmp/portage/*.

Resume the ebuild with ebuild <repository_directory>/<category>/<package_name>-<version>.ebuild merge:
root #ebuild /usr/portage/net-libs/webkit-gtk/webkit-gtk-2.6.5.ebuild merge

```
>>> Existing ${T}/environment for 'webkit-gtk-2.6.5' will be sourced. Run
>>> 'clean' to start with a fresh environment.
>>> Checking webkitgtk-2.6.5.tar.xz's mtime...
>>> WORKDIR is up-to-date, keeping...
 * checking ebuild checksums ;-) ...                                                                                                                   [ ok ]
 * checking auxfile checksums ;-) ...                                                                                                                  [ ok ]
 * checking miscfile checksums ;-) ...                                                                                                                 [ ok ]
>>> It appears that 'setup' has already executed for 'webkit-gtk-2.6.5'; skipping.
>>> Remove '/var/tmp/portage/net-libs/webkit-gtk-2.6.5/.setuped' to force setup.
>>> It appears that 'unpack' has already executed for 'webkit-gtk-2.6.5'; skipping.
>>> Remove '/var/tmp/portage/net-libs/webkit-gtk-2.6.5/.unpacked' to force unpack.
>>> It appears that 'prepare' has already executed for 'webkit-gtk-2.6.5'; skipping.
>>> Remove '/var/tmp/portage/net-libs/webkit-gtk-2.6.5/.prepared' to force prepare.
>>> Configuring source in /var/tmp/portage/net-libs/webkit-gtk-2.6.5/work/webkitgtk-2.6.5 ...
>>> Working in BUILD_DIR: "/var/tmp/portage/net-libs/webkit-gtk-2.6.5/work/webkit-gtk-2.6.5_build"
..
..
.
```
If you're using other repository sources besides gentoo like layman overlays, make sure that you're using the correct repository directory of the ebuild as one package can also belong to other repositories and be chosen to be installed over the one in gentoo. You can get the repository name of the current package by reading the last action entry in /var/log/emerge.log or reading the build.log file in the package's build directory with a command like fgrep Repository: /var/tmp/portage/net-libs/webkit-gtk-2.6.5/temp/build.log.

Do not use the .ebuild file found in /var/tmp/portage/<category>/<package_name>-<version>/build-info/<package_name>-<version>.ebuild as it seems to be only a reference. Perhaps there's a way to use it, but one would have to thoroughly understand how ebuild and ebuild.sh work.

Happy hacking :)

## Troubleshooting
No space left on device

If you encounter a not-enough space error or anything similar, there are basically two things to do:

- Check the /var/tmp/portage directory for old package directories from previously failed compiles. Any packages found therein should be deleted; with exceptions made for any failed packages the user would like to resume compiling later.
- Resize the tmpfs.
