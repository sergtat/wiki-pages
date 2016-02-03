#  Node.js работа с MySQL
Для начала поставим модуль работы с базой:
  npm install mysql
Получаем объект модуля:
  var mysql = require('mysql');
Создаем соединение:
```
var client = mysql.createClient();
client.host='127.0.0.1';
client.port= '3306';
client.user='someuser';
client.password='userpass';
client.database='node';
```
Теперь можем посылать запросы к базе используя метод  client.query(), который имеет следующий синтаксис:
  client.query(query, [params, callback])
например выполним запрос на выборку данных:
```
client.query('SELECT * FROM users', function(error, result, fields){
    console.log(result);
});
```
чтобы завершить соединение делаем:
  client.end();