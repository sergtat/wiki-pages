#  Статистика nginx
Для начала нужно установить **nginx** с модулем **http_stub_status_module**. И включить его, для этого добавляем строчки в **/etc/nginx/nginx.conf**:
```
location /nginx_status {
   stub_status on;
   # disable access_log if requared
   access_log   off;
   allow XX.YY.AA.ZZ; лучше разрешить только для 127.0.0.1
   deny all;
}
```
[Теперь при запросе [[http://localhost/nginx_status]() сервер выведет примерно такой текст:
```
Active connections: 1
server accepts handled requests
2 2 4
Reading: 0 Writing: 1 Waiting: 0
```
[Теперь cкачаем скрипт для **cacti** отсюда: [[http://forums.cacti.net/download.php?id=12676]().
Разархивируем и кладем в **/usr/local/share/cacti/scripts/** файлы **get_nginx_clients_status.pl** и **get_nginx_socket_status.pl**.
Теперь открываем **cacti**, заходим в **Import Templates** и импортируем **cacti_graph_template_nginx_clients_stat.xml** и **cacti_graph_template_nginx_sockets_stat.xml**. Должно было появится 2 новых шаблона для графиков:
- Nginx_clients_stat
- Nginx_sockets_stat
Требуется модуль PERL 'LWP::UserAgent', ставится просто:
  perl -MCPAN -e 'install "LWP::UserAgent"'
Создаем графики, прописываем URL с которого будет браться статистика и наблюдаем за ними =)  
![](:graphimagenginxclientss.png '')  
_**Легенда к первому графику**_:  
**Active connections** — сколько обслуживается клиентов.  
**Reading** — сколько соединений находится в состоянии чтения.  
**Writing** — сколько соединений находится в состоянии записи.  
**Waiting** — keep-alive соединения или же в состоянии обработки запроса  

![](:graphimagenginxsocketss.png '')  
_**Легенда ко второму графику**_:  
**server accepts** — сколько соединений было допущено;  
**handled** — сколько из них было обработано, а не закрыто сразу, соединение сразу же закрывается, если таблица соединений переполняется.  
**requests** — сколько облужено запросов. При keep-alive в одном соединении может быть несколько запросов.
