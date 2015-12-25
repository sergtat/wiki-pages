#  Делаем HTTPS на Node.js используя express
Модули которые необходимо подключить:
  var express = require('express');  // сам фреймворк
  var https = require( "https" );  // для организации https
  var fs = require( "fs" );   // для чтения ключевых файлов

Задать опции ключевой информации:
  httpsOptions = {
      key: fs.readFileSync("server.key"), // путь к ключу
      cert: fs.readFileSync("server.crt") // путь к сертификату
  }

Открыть порт
  https.createServer(httpsOptions, app).listen(433);

*app – это объект полученый от express().
