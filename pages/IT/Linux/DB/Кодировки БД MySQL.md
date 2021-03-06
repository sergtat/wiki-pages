#  Кодировки БД MySQL
Кодировки БД MySQL – бывают правильные – те которые нам подходят и неправильные – которые нам не надо. Если у вас сайт на русском языке, а для вашей базы данных выставлена кодировка latin1, значить это второй вариант – нас эта кодировка не устраивает. То есть нам нужна другая кодировка – cp1251 (родная кодировка виндовса) или utf-8 (в настоящее время быстро набирающая оборотов в использовании). Почему в большинстве случаев используется latin1 – а причина наверное в том, что MySQL при установке по умолчанию указывает кодировку latin1 для вновь созданных БД и скорей всего потому, что разработчики живут и кодят в Швеции. И если при установке и/или настройке не удосужились изменить, то такой она и останется по умолчанию (кстати можно наверное взять на заметку – если ваш хостер создает вам БД с кодировкой по умолчанию в latin1 то можно предположить что он не изменял умолчания, а это в свою очередь может свидетельствовать о невысоком уровне квалификации или ему просто лень, что кстати тоже есть очень плохо…). Но дело не в умолчании и хостинге, а в возможных проблемах. Да сайт будет работать и текст будет показываться нормально – но например при поиске будет выдавать совсем не то что просиш.

Я столкнулся с проблемой неправильной кодировки при настройке joomla, также при переносе с одного сервера на другой БД торрент трекера, ну и собственно везде где она изначально неправильно настроена.

Если пойти почитать документацию, то можно предположить что нам надо вот это

  If you want to change the table default character set and all character columns (CHAR, VARCHAR, TEXT) to a new character set, use a statement like this:
  ALTER TABLE tbl_name CONVERT TO CHARACTER SET charset_name;

Но если почитать дальше

  Warning: The preceding operation converts column values between the character sets. This is not what you want if you have a column in one character set (like latin1) but the stored values actually use some other,
  incompatible character set (like cp1251). In this case, you have to do the following for each such column:

  ALTER TABLE t1 CHANGE c1 c1 BLOB;
  ALTER TABLE t1 CHANGE c1 c1 TEXT CHARACTER SET cp1251;

То есть просто сконвертировать у нас не получится, надо сначала привести к двоичным данным. То есть все таки можно. Но! Надо выполнить этот запрос для каждого столбца в каждой таблице. Если это делать вручную то можно сломать клавиши так долго придется писать запросы.

После долгих поисков и мучений окончательный вариант выглядит так:

1. **Узнаем в какой кодировке лежать наши данные в БД.**  
Открываем phpmyadmin, выбираем нашу БД и смотрим на столбец Сравнение для таблиц – в моем случае это – latin1_swedish_ci. То есть у меня стоит latin1_swedish_ci (Шведский, нечувствительный к регистру) – спрашивается зачем мне для русскоязычного сайта хранить данные в шведской кодировке?
1. **Сохранение дампа (бэкапа) в кодировке latin1.** Это надо провернуть так что бы не получилось не читаемое мясо. Делается в консоли сервера: ```mysqldump -uuser -ppassword bdname --allow-keywords --create-options --complete-insert --default-character-set=latin1 --add-drop-table > dump_bdname.sql``` user – имя пользователя для доступа к БД  
password – пароль этого юзера  
bdname – имя базы для которой мы делаем дамп  
–default-character-set=latin1 к этому ключу особое внимание – после знака равно надо писать кодировку вашей БД.
1. **Перекодировка дампа в нужную кодировку и с нужными параметрами.**  
```iconv -f ISO-8859-1 -t UTF-8 dump_bdname.sql > dump_bdname_utf8.sql``` Назначение ключей следующее:\\-f ISO-8859 – конвертировать из кодировки  
ISO-8859 (вы можете спросить почему iso-8859-1 а не latin1, потому что это одно и тоже, да и учтите что у вас может быть другая кодировка)  
-t UTF-8 – в кодировку UTF-8  
dump_bdname.sql – файл который мы будем конвертировать  
dump_bdname_utf8.sql – результаты запишутся в этот файл.  
Этой командой мы все что есть в latin1 переделываем в utf8. Также в случае проблем можно запустить с ключем -c (пропускать на выводе недопустимые знаки). ```iconv -c -f ISO-8859-1 -t UTF-8 dump_bdname.sql > dump_bdname_utf8.sql```(вариант для виндовса - можно открыть например через Notepad++ нажать выделить все (Ctrl+A), вырезать (Ctrl+X), потом выбрать Кодировки - convert to UTF-8 и вставить (Ctrl+V). )
1. **Расстановка правильного DEFAULT CHARSET**  
Итак у нас есть дамп, причем в нужной нам кодировке. Но в нем так же есть записанные директивы SET NAMES codepage; и DEFAULT CHARSET codepage;  
Запуск следующей команды заменяет в дампе все упоминания latin1 на utf8 ```cat dump_bdname_utf8.sql | replace "latin1" "utf8" > dump_bdname_utf8_replace.sql``` (вариант для виндовса - опять таки в Notepad++ через поиск найти и заменить все latin1 на utf8)
1. **Восстановление базы данных из сконвертированного дампа.**  
Этой командой мы заливаем такой как нам надо дамп в нашу новую таблицу (которую предварительно надо создать) ```mysql -uuser -ppassword newbdname --default-character-set=utf8 < dump_bdname_utf8_replace.sql```

После этого можно спокойно пользоваться нашей базой, которая теперь в правильной кодировке.

PS:
Но это все осуществимо если у вас есть доступ к shell сервера.
Надо будет еще или поискать вариант решения с помощью PHP (вернее я его видел и даже пробовал – но как всегда оно не заработал, а разбираться не было времени и сил) или попробовать наваять самому.
Так что народ если будет острая необходимость и много желающих можно будет вернутся к этому вопросу.
----
##  Comments

Все это замечательно, но если рассматривать статью как пособие для человека неопытного, лучше все же сузить условия поиска в строке:
  cat dump_bdname_utf8.sql | replace «latin1″ «utf8″ > dump_bdname_utf8_replace.sql
минимум до
  cat dump_bdname_utf8.sql | replace «CHARSET=latin1″ «CHARSET=utf8″ > dump_bdname_utf8_replace.sql
Иначе, легко представить, что бы было, например, при обработке куска дампа с этой статьей :)

P.S. Хотя в идеале конечно просматривать что именно ты меняешь и не пользоваться командой в таком виде.