# Настройка Nginx с Let's Encrypt.
Наверно, многие уже в курсе, что компания Let's Encrypt раздает бесплатные SSL-сертификаты на https://letsencrypt.org. Как же его получить и настроить на своем сервере под управлением CentOS 7 и Nginx?

## Введение

Давайте его получим. Let's Encrypt это новый центр сертификации (CA), который позволяет простым способом бесплатно получить и установить TLS / SSl сертификат, позволяя нам шифровать HTTPS трафик на ваших веб-серверах. Этот процесс уже автоматизирован программой letsencrypt, но, к сожалению, только под управлению веб-серверами Apache.

В этом уроке я покажу вам, как получить SSL сертификат под Nginx, CentOS 7. Также настроим автоматическое продление сертификата, так как он дается на 90 дней.

### Шаг 1 — Установка клиента Letsencrypt

Итак, что мы имеем:

- Веб сервер под управлением CentOS, Nginx;
- Установленные программы Git, Bc.

На всякий случай:

    sudo yum -y install git bc

После того, как git и bc установлены, переходим к клонированию проекта letsencrypt из GitHub.

    sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt

Теперь у вас должна быть копия проекта в /opt/letsencrypt.

### Шаг 2 — Получение сертификата

Letsencrypt предоставляет множество способов получения SSL-сертификатов с помощью различных плагинов. В отличии от плагина Apache, который устанавливается автоматически, нам придется ставить сертификат вручную.

#### Установка сертификата SSL

Переходим к проекту Letsencrypt, куда мы клонировали файлы. И запускаем генерацию сертификатов командой letsencrypt-auto certonly, используя плагин webroot.

    -d example.com -d www.example.com — наши домены
    --webroot-path=/usr/share/nginx/html директория, где лежит наш проект

    cd /opt/letsencrypt
    ./letsencrypt-auto certonly -a webroot --webroot-path=/usr/share/nginx/html -d example.com -d www.example.com

> Примечание: запускаем приложение letsencrypt-auto без sudo

После того, как letsencrypt инициализирует, нам необходимо будет вести дополнительные данные. Предложенные вопросы могут варьироваться в зависимости от того, как давно вы использовали letsencrypt раньше, но мы запускаем первый раз.

В командной строке введите адрес электронной почты, который будет использоваться для информативных сообщений, а также будет возможность восстановить ключи:

![](/images/Webd/nginx_ssl_LetsEncrypt_01.png)

Соглашайтесь с условиями пользования Letsencrypt.

![](/images/Webd/nginx_ssl_LetsEncrypt_02.png)

Если все прошло успешно, тогда в консоли вы должны увидеть примерно это:

    Output:
    IMPORTANT NOTES:
    - If you lose your account credentials, you can recover through
      e-mails sent to sammy@digitalocean.com
    - Congratulations! Your certificate and chain have been saved at
      /etc/letsencrypt/live/example.com/fullchain.pem. Your
      cert will expire on 2016-03-15. To obtain a new version of the
      certificate in the future, simply run Let's Encrypt again.
    - Your account credentials have been saved in your Let's Encrypt
      configuration directory at /etc/letsencrypt. You should make a
      secure backup of this folder now. This configuration directory will
      also contain certificates and private keys obtained by Let's
      Encrypt so making regular backups of this folder is ideal.
    - If like Let's Encrypt, please consider supporting our work by:

      Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
      Donating to EFF:                    https://eff.org/donate-le

Мы видим, куда сохранились созданные сертификаты /etc/letsencrypt/live/example.com/ и дату истечения действия сертификата 2016-03-15.

**Возможные ошибки:**

> Если вы получили ошибки, типа: **Failed to connect to host for DVSNI challenge**, настройте firewall вашего сервера, что бы TCP трафик проходил по портам 80 и 443.

После получения сертификата, вы будете иметь следующие PEM-закодированных файлы:

    cert.pem: сертификат для вашего домена
    chain.pem: Let's Encrypt цепь сертификатов
    fullchain.pem: cert.pem и chain.pem
    privkey.pem: Сертификат с приватным ключом

В целях дальнейшего повышения уровня безопасности, мы сформируем ключ по алгоритму шифрования Диффи-Хеллмана. Чтобы создать 2048-битный ключ, используйте следующую команду:

    sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

Это нужно, чтобы у нас заработал Forward Secrecy. Прямая секретность означает, что если третья сторона узнает какой-либо сеансовый ключ, то она сможет получить лишь доступ к данным, защищенным лишь этим ключом. Для сохранения совершенной прямой секретности ключ, используемый для шифрования передаваемых данных, не должен использоваться для получения каких-либо дополнительных ключей.

Процесс может занять несколько минут, но когда ключ создастся, он будет помещен в каталог в /etc/ssl/certs/dhparam.pem.

### Шаг 3 — Настройка TLS/SSl на веб-сервере Nginx

Настройка конфигурации Nginx, используя SSl — сертификаты.
```nginx
server {
    # перенаправление с 80 порта, а также с www
    server_name example.com www.example.com
    listen 80;
    return 301 https://www.example.com$request_uri;
}


server {
        listen 443 ssl;

        server_name example.com www.example.com;

        # Указываем пути к сертификатам
        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem; 
        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_prefer_server_ciphers on;

        ssl_dhparam /etc/ssl/certs/dhparam.pem;
        ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
        ssl_session_timeout 1d;
        ssl_session_cache shared:SSL:50m;

        # позволяем серверу прикреплять OCSP-ответы, тем самым уменьшая время загрузки страниц у пользователей
        ssl_stapling on;
        ssl_stapling_verify on;
        add_header Strict-Transport-Security max-age=15768000;

        location ~ /.well-known {
                allow all;
        }

        # The rest of your server block
        root /usr/share/nginx/html;
        index index.html index.htm;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }
}
```

Перезагружаем Nginx

    sudo systemctl reload nginx

### Шаг 4 — Настройка автопродление

Сертификаты действительный 90 дней, но рекомендуется продлевать сертификаты каждые 60 дней. Мы это автоматизируем с помощью cron.

Чтобы запустить процесс обновления для всех установленных доменов, выполните следующую команду:

    /opt/letsencrypt/letsencrypt-auto renew

Так как мы недавно установили сертификат, то команда будет проверять только дату истечения срока действия и распечатает сообщение, информирующее о том, что сертификат не нуждается в продлении. Вы увидите примерно следующие в консоли:

    Checking for new version...
    Requesting root privileges to run letsencrypt...
      /root/.local/share/letsencrypt/bin/letsencrypt renew
    Processing /etc/letsencrypt/renewal/example.com.conf

    The following certs are not due for renewal yet:
      /etc/letsencrypt/live/example.com/fullchain.pem (skipped)
    No renewals were attempted.

Обратите внимание, что если вы создали сертификат в комплекте с несколькими доменами, тогда только базовое имя домена будет отображено в консоли, но вы не пугайтесь, продлены будут все домены, включенные в этот сертификат.

Давайте отредактируем crontab, что бы наши сертификаты обновлялись автоматически. Проверку на обновления мы будем делать каждую неделю. Для редактирования crontab от root пользователя выполните команду:

    sudo crontab -e

Добавим следующие строки:

    30 2 * * 1 /opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log
    35 2 * * 1 /usr/bin/systemctl reload nginx

Этак команда создаст cron, который каждый понедельник будет выполнять автоматическое продление letsencrypt сертификатов в 2:30 и перезагружать Nginx в 2:35. Вся информация об обновлении будет логироваться в /var/log/le-renew.log.

### Шаг 5 — Обновление Let’s Encrypt (не обязательно)

Всякий раз, когда новые обновления доступны для клиента Let’s Encrypt, вы можете обновить локальную копию, запустив git pull из каталога /opt/letsencrypt:

    cd /opt/letsencrypt
    sudo git pull

Это позволит загрузить все последние изменения из хранилище для обновления клиента Let’s Encrypt.

Финиш! Ваш веб-сервер теперь использует шифрование TLS / SSL, и все это бесплатно. Давайте шифровать HTTPS контент, стоять на страже неприкосновенности частной жизни. Также это повысит видимость сайта в выдаче Google.

## Источники

https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-centos-7

https://habrahabr.ru/post/252821/

> Источник: https://.habrahabr.ru

---
Вместо костыля с перезапуском через 5 минут, я бы рекомендовал использовать встроенные в certbot хуки: в данном случае post-hook, который описан [тут](https://certbot.eff.org/docs/using.html#renewal)

Т.е. вместо строк в crontab'e:

    30 2 * * 1 /opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log
    35 2 * * 1 /usr/bin/systemctl reload nginx

достаточно использовать:

    30 2 * * 1 /opt/letsencrypt/letsencrypt-auto renew --post-hook "service nginx reload" >> /var/log/le-renew.log

---
Я вместо cron писал systemd-target который отрабатывал каждую неделю. Так оно и в journalctl отображатся будет и при падении можно прислает на email уведомление.

---
https://caddyserver.com/ Сам все делает за вас

---
 А почему именно такой набор настроек SSL а не [другой](https://mozilla.github.io/server-side-tls/ssl-config-generator/)?

---
две хороших ссылочки,

https://cipherli.st/

https://mozilla.github.io/server-side-tls/ssl-config-generator/
