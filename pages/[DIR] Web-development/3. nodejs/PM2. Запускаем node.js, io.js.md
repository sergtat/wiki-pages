# PM2. Запускаем node.js, io.js
> Для node замените везде iojs на node

1. Заводим пользователя www:

    ```bash
    # useradd -m -U www
    ```
2. Устанавливаем libcap и:

    ```bash
    # setcap cap_net_bind_service=+ep /usr/bin/iojs # (node)
    ```
3. Заходим в папку пользоателя и создаем проект, например test:

    ```bash
    $ mkdir test; cd test
    $ vim app.js
    ...
    app.listen(80);
    ```
4. Проверяем:

    ```bash
    $ iojs app.js
    ```
Выходим.
5. Устанавливаем PM2:

    ```bash
    $ sudo npm i pm2 -g
    ```
6. Создаем инициализационный скрипт и ставим в загрузку:

    ```bash
    $ sudo pm2 startup gentoo
    $ sudo chmod +x /etc/init.d/pm2-init.sh
    $ mv /etc/init.d/pm2{-init.sh,}
    $ rc-update add pm2 default
    ```
7. Редактируем инициализационный скрипт:

    ``` bash
    $ sudo vim /etc/init.d/pm2
    ...
    USER=www
    PM2_HOME="/home/www/"
    ```
8. Делаем dump рабочего сервера:

    ```bash
    $ cd /home/www/test
    $ pm2 start app.js -i 0 --watch --interpreter iojs # Для node --interpreter не нужно
    $ pm2 ls
    $ pm2 dump
    $ pm2 delete all; pm2 kill
    ```
9. Стартуем сервер:

    ```bash
    $ sudo /etc/init.d/pm2
    ```

Всё!

