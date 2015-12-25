#  Локальный postfix c релеем на GMail
Почтовые сервера категорически не хотят принимать письма с локальной машины, из-за отсутствия обратной зоны и даже не кладут эти письма в спам – мочат на корню. Решил использовать GMail в качестве SMTP а для отправки postfix. Приступим.

При подключении к gmail используется протокол TLS.

Воспользуемся сертификатом сервера, созданным postfix (`/etc/ssl/postfix/*`).

Теперь редактируем файл /etc/postfix/main.cf, а именно – добавляем следующие строки:
```
relayhost = [smtp.gmail.com]:587

#auth
smtp_sasl_auth_enable=yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd

#tls
smtp_use_tls = yes
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
smtp_tls_note_starttls_offer = yes
tls_random_source = dev:/dev/urandom
smtp_tls_scert_verifydepth = 5
smtp_tls_key_file = /etc/ssl/postfix/server.key
smtp_tls_cert_file = /etc/ssl/postfix/server.pem
smtpd_tls_ask_ccert = yes
smtpd_tls_req_ccert =no
smtp_tls_enforce_peername = no
```

В /etc/postfix/sasl_passwd необходимо добавить данные для авторизации на GMail вида
```
gmail-smtp.l.google.com user@gmail.com:password
smtp.gmail.com user@gmail.com:password
```
и выполнить
```
# postmap hash:/etc/postfix/sasl_passwd
# /etc/init.d/postfix reload
```
В принципе все – почта должна уходить из скриптов. Единственный нюанс – GMail в качестве отправителя подставит учетную запись, которая использовалась при авторизации для отправки.

Есть еще вариант настройки разных релеев, в зависимости от какого аккаунта отправляется почта, подробнее [здесь:](http://ubuntu-tutorials.com/2009/03/13/configure-postfix-for-multiple-isp-client-smtp-authentication/|Configure Postfix for Multiple ISP Client SMTP Authentication, ubuntu-tutorials.com) (на английском)
