# Инструкция по сборке модулей NFS
Инструкция написана для ОС Ubuntu

1. Устанавливаем компилятор и необходимые библиотеки
  sudo apt-get install make gcc libncurses-dev
2. Создаем папку, в которой будем работать
  mkdir /home/user/build
3. Скачиваем кросс-компилятор от сюда http://dl.google.com/Android/ndk/Android-n...nux-x86.tar.bz2 и разархивируем в папку build
4. Смотрим, какое у нас ядро на телефоне (в настройках или командой uname -a в терминале на телефоне) и скачиваем его исходники, к примеру, от сюда ftp://ftp.kernel.org/pub/Linux/kernel/
5. Разархивируем исходники в папку build и переименуем получившуюся папку в kernel для удобства
6. Копируем с телефона файл с настройками ядра /proc/config.gz на компьютер, разархивируем и копируем в ~/build/kernel. Далее его необходимо переименовать в .config
7. Переходим в каталог kernel
  cd /home/user/build/kernel
8. Запускаем Linux Kernel Configuration (параметр -jN задает количество N используемых ядер процессора при компиляции)
  make -j2 ARCH=arm CROSS_COMPILE=/home/user/build/Android-ndk-r8b/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi- menuconfig
Заходим в File systems -> Network File Systems и отмечаем NFS client support пробелом <M>. Внутри NFS client support отмечаем все пункты кроме NFSv4.1
Далее выходим в главное меню и сохраняем настройки, выбрав Save an alternate configuration file. Выходим из конфигуратора
9.Компилируем модули
  make modules -j2 ARCH=arm CROSS_COMPILE=/home/user/build/Android-ndk-r8b/toolchains/arm-linux-androideabi-4.6/prebuilt/linux-x86/bin/arm-linux-androideabi-
10. Делаем поиск в папке /home/user/build/kernel файлов *.ko. Выбираем среди найденных файлы sunrpc.ko, lockd.ko, auth_rpcgss.ko, nfs_acl.ko, nfs.ko и копируем их в телефон
