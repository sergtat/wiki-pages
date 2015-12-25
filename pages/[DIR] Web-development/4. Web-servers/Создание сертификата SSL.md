#  Создание сертификата SSL
##  Генерируем
Вот скрипт создания собственного самоподписанного сертификата с помощью OpenSSL:
```
#!/bin/bash
NAME="my"
echo "> Generate Key (with passwd)"
openssl genrsa -des3 -out ${NAME}.key
echo "> Generate Pem (remove password)"
openssl rsa -in ${NAME}.key -out ${NAME}.pem
echo "> Generage Csr"
openssl req -new -key ${NAME}.key -out ${NAME}.csr
echo "> Generage Certificate (enter empty password for CRT)"
openssl x509 -req -days 365 -in ${NAME}.csr -signkey ${NAME}.key -out ${NAME}.crt
```
Этот скрипт можно положить в /etc/ssl/apache2/ и от туда генерировать свой сертификат с именем my. По умолчанию в gentoo имя сертификата идет server, по этому рекомендую использовать другое имя, чтобы спокойно можно было перезатереть сертификат server при обновлении системы.
##  Прописываем
В конфиге apache (например /etc/apache2/vhosts.d/00_default_ssl_vhost.conf) Прописываем строки:
```
SSLEngine on
SSLCipherSuite ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP:+eNULL
SSLCertificateFile /etc/ssl/apache2/my.crt
SSLCertificateKeyFile /etc/ssl/apache2/my.pem
```
Обратите внимание! Именно pem (а не key) нужен для того, чтобы apache не запрашивал пароль каждый раз при старте.