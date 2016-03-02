# Добавляем swap-file.
1. Операции производим от root:

    ```
    $ su -
    ```

    or
    ```
    $ sudo -s
    ```
2. Создаем файл:

    ```
    # dd if=/dev/zero of=<swapfile> bs=1024 count=<count>
    ```

    где

    - \<swapfile\> - имя swapfile;
    - \<count\> - количество блоков по 1024b (1Gb = 1024 * 1024, 10Gb = 1024 *
        1024 * 10)
3. Права на файл:

    ```
    # chown root:root <swapfile>
    # chmod 600 <swapfile>
    ```
4. Создаем swap-filesystem

    ```
    # mkswap <swapfile>
    ```
5. Подключаем:

    ```
    # swapon <swapfile>
    ```
6. Запись в /etc/fstab:

    ```
    <swapfile> none swap sw 0 0
    ```
7. Проверка:

    ```
    # swapon -s
    ```
    Вывод (пример):

    ```
    Filename                Type        Size    Used    Priority
    /dev/sda6                               partition   4194296 0   0
    /swapfile1                              file        524280  0   -1
    ```
    or

    ```
    $ less /proc/meminfo
    $ grep -i --color swap /proc/meminfo 
    ```
