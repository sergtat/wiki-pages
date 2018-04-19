#  Переходим на systemd

##  Установка

1. Сделать BackUp следующих файлов:
    ```
    /var/lib/portage/world
    /etc/portage
    /etc/runlevels
    /etc/init.d
    /etc/conf.d
    ```
2. Включаем следующие опции в ядре:
    ```
        General setup  --->
          [*] Control Group support
    [*] Enable the block layer  --->
          [*]   Block layer SG support v4
        Device Drivers --->
                Generic Driver Options  --->
                      [*] Maintain a devtmpfs filesystem to mount at /dev
        File systems --->
          [*] Filesystem wide access notification
          < > Kernel automounter support
          <*> Kernel automounter version 4 support (also supports v3)
    [*] Networking support --->
              Networking options --->
                  TCP/IP networking --->
                      <*> The IPv6 protocol
    ```
3. ```layman -a systemd```
4. Создать:
    ```
    mkdir /run
    ln -sf /proc/self/mounts /etc/mtab
    ```
5. Добавляем глобальный флаг **systemd**.
    ```
    USE="systemd"
    ```
    ```
    -systemd
    consolekit
    ```
6.
    ```
    sys-apps/systemd
    sys-apps/baselayout-systemd
    sys-apps/systemd-units
    sys-apps/dbus
    sys-fs/udev
    sys-kernel/linux-headers
    >=sys-apps/kmod-5
    ```
    ```
    sys-apps/systemd-units server
    ```
    ```
    emerge -av sys-apps/systemd sys-apps/baselayout-systemd sys-apps/systemd-units
    emerge -avuDN @world
    ```
7. Поправить в /etc файлы hostname, locale.conf, vconsole. Сделать копии, удалить sys-apps/baselayout-systemd, вернуть копии на место.
8. Добавляем в grub.cfg параметр загрузки init=/usr/bin/systemd (для genkernel real_init). Пока убираем quiet.  
9. Перезагружаем, пробуем.

##  Загрузка сервисов

1. Поднимаем сеть:
    ```
    [Unit]
    Description=Network Connectivity

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    ExecStart=/sbin/ifconfig eth0 192.168.1.2 mtu 1496
    ExecStart=/sbin/route add default gw 192.168.1.1
    ExecStop=/sbin/ifconfig eth0 down

    [Install]
    WantedBy=network.target
    ```

        systemctl enable network.service

    Или через **dhcpcd** (с версии 5.2.12-r1 содержит service-файл)

    ```
    interface eth0
    static ip_address=192.168.1.2/24
    static routers=192.168.1.1
    static domain_name_servers=192.168.1.1
    ```

        systemctl enable dhcpcd.service

    Если поставить **dhcpcd-ui** будет значок сети в трее.

2. Поднимаем **sshd**
    ```
    [Unit]
    Conflicts=sshd.service

    [Socket]
    ListenStream=22
    # Uncomment the next line to also listen on port 2200
    # ListenStream=2200
    Accept=yes

    [Install]
    WantedBy=sockets.target
    ```

        systemctl enable sshd.socket

3. Гуглим и поднимаем остальные сервисы. В крайнем случае пишем свой service-файл Type=forking на основе init-файлов. Или в моей коллекции [[https://github.com/sergtat/systemd-units-for-gentoo]().

##  Удаляем OpenRC SysVinit

1. 
    ```
    sys-apps/kmod
    ```

        emerge --unmerge --verbose sys-apps/module-init-tools
        emerge --oneshot --verbose sys-apps/kmod
2. 

        git clone git://github.com/canek-pelaez/gentoo-systemd-only.git

    ```
    PORTDIR_OVERLAY="/path/to/gentoo-systemd-only"
    ```
    ```
    -*>=sys-apps/baselayout-2
    *>=sys-apps/systemd-baselayout-10
    ```
3. 

    ```
    =sys-apps/systemd-sysv-utils-37
    =sys-apps/sysvinit-tools-2.88-r4
    =sys-apps/systemd-baselayout-10.0
    >=sys-apps/util-linux-2.22
    ```
    ```
    =sys-apps/systemd-sysv-utils-37
    ```
    ```
    USE="-openrc"
    ```

        emerge --unmerge --verbose sys-apps/openrc sys-apps/baselayout sys-apps/sysvinit
        equery d openrc
        emerge --unmerge --verbose Все Зависимости (init-скрипты)
        emerge --newuse --deep --update --verbose --pretend @world
        emerge --newuse --deep --update --verbose @world
4. 

        cp -f /path/to/gentoo-systemd-only/no-openrc-scripts/fix_libtool_files.sh /usr/sbin
        cp -f /path/to/gentoo-systemd-only/no-openrc-scripts/flocale-gen /usr/sbin

5. На любителя.

    ```
    INSTALL_MASK="/etc/init.d
                  /etc/conf.d
                  /etc/runlevels"
    ```
