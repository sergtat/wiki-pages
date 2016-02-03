#  Набор пакетов для разработки с помощью NodeJS
##  Инсталлятор пакетов
[]()[https://npmjs.org|npm]() — менеджер пакетов для node. Устанавливается вместе с node (в последних версиях так точно).  
Аналог в Ruby: Rubygems+Bundler. Аналог в PHP: Composer.

###  Поиск пакетов
[]()[https:_npmjs.org/|Официальный регистр]]. Не официальные: [https:_github.com/spion/npmsearch|npmsearch](https:_github.com/spion/npmsearch|npmsearch), [http:_packagefinder1-enome.dotcloud.com/|packagefinder](http:_packagefinder1-enome.dotcloud.com/|packagefinder), [[http:_eirikb.github.com/nipster/|nipster]()

##  Веб стек технологий
###  Веб-сервер
[]()[https://github.com/senchalabs/connect|connect]() это расширяемый HTTP сервер фреймворк для Node, с поддержкой высокопроизводительных плагинов так же известных как middleware.  
[]()[https:_github.com/senchalabs/connect#middleware|Список встроенных]] и [[https:_github.com/senchalabs/connect/wiki|третесторонних]() плагинов.  
Аналог в Ruby: Rack.

### Веб-фреймворк
[]()[http://expressjs.com/|express]() минималистичный гибкий node фреймворк для веб приложений, предоставляющий широкий набор фич для построения одно-, много- страничных и гибридных веб приложений.  
[]()[http://stackoverflow.com/questions/8144214/learning-express-for-node-js|Подборка материалов для изучения]()  
Аналог в Ruby: Sinatra. Аналог в PHP: Silex.

Есть еще geddy. Вроде бы это аналог Rails. Но что это за зверь не знаю.

### База
[]()[http://mongoosejs.com/|mongoose](). Элегантное объектное моделирование для mongodb для node.  
[]()[http:_mongoosejs.com/docs/guide.html|Документация]] и [[http:_plugins.mongoosejs.com/|плагины]()  
В других ЯП обычно в этом месте встречается термин ORM (Object-relational mapping), но mongoose это ODM (Object-document mapping). Конечно такое бывает не только в node, например в Ruby есть mongoid.

### Темплейты
[]()[http://jade-lang.com/|Jade]() высокопроизводительный движок темплейтов для node, сильное влияние на который оказал Haml.  
[]()[http:_naltatis.github.com/jade-syntax-docs/|Документация]], [[https:_github.com/visionmedia/jade#readme-contents|оф. документация]()  
Аналог в Ruby: Slim (akzhan), Haml.

### Замена CSS
[]()[http://learnboost.github.com/stylus/|stylus](). Выразительный, динамичный, надежный CSS

[]()[http://lesscss.org/|less](). LESS расширяет CSS переменными, миксинами, операциями и функциями  
Аналоги в Ruby: Sass, less.

### Аутентификация
[]()[https://github.com/bnoguchi/everyauth|everyauth](). Аутентификация и авторизация (по паролю, через facebook и т.п.) для ваших Connect и Express приложений.  
[Связка для mongoose и everyauth — [[https://github.com/bnoguchi/mongoose-auth|mongoose-auth]().  
Аналоги в Ruby: OmniAuth.

[]()[http://passportjs.org/|passportjs](). Passport это middleware для node. Очень гибкое и модулярное решение. Passport без проблем может быть подключен к любому Express приложению.

### Хранение сессий
[]()[https://github.com/kcbanner/connect-mongo|connect-mongo](). MongoDB в качестве хранилища сессий для Connect приложений

### mail
[]()[https://github.com/andris9/Nodemailer|Nodemailer]() простой в использовании модуль для отправки электронной почты с помощью node (с использованием SMTP или Sendmail или Amazon SES) и Unicode поддерживается.

### Хеширование паролей
[]()[https://github.com/ncb000gt/node.bcrypt.js/|bcrypt](). Библиотека для хеширования паролей.

### Валидация
[]()[https://github.com/chriso/node-validator|node-validator]() представляет собой библиотеку для проверки, фильтрация и санитизации строк.

[Связка для node-validator и Express — [[https://github.com/ctavan/express-validator|express-validator]()

### 18n
[]()[https://github.com/mashpie/i18n-node|i18n-node]() легковесный простой модуль для интернационализации с динамическим json хранилищем.

### Логирование
[]()[https://github.com/flatiron/winston|winston](). Мульти-транспортная асинхронная библиотека для логирования

[]()[http://logio.org/|log.io]() позволяет просматривать потоки сообщений логов в едином пользовательский интерфейс.

### Выполнение тасков
[]()[https://github.com/gruntjs/grunt|grunt]() утилита для командной строки, для исполнения тасков. Наподобие make, rake. Изначально заточена под фронтенд разработку (таски для минификаци, запуск тестов в браузере и т.п.).  
[]()[https://npmjs.org/browse/keyword/gruntplugin|Список плагинов]().

## Реалтайм (сокеты, pub-sub)
### Сокеты
[]()[http://socket.io/|socket.io]() стремится сделать realtime приложения возможными в любом браузере и мобильном устройстве, стирая различия между разными транспортными механизмами.

### edis
[]()[https://github.com/mranney/node_redis|node_redis](). Это полный клиент для Redis для node. Он поддерживает все Redis команды, в том числе многие недавно добавленные команды, как EVAL из экспериментальных бранчей Redis.

## Тестирование
### Фреймворк для тестирования
[]()[http://visionmedia.github.com/mocha/|mocha]() это многофункциональный тестовый JavaScript фреймворк, работающий и в node и в браузере, что делает асинхронное тестирование простым и веселым. Mocha тесты выполняются последовательно, обеспечивая гибкую и точную отчетность, обрабатывает не перехваченные исключения.

### DD style
[]()[http://chaijs.com/|chai](). Это BDD / TDD assertion библиотека для node и браузера, которая может быть использована с любым тестовым фреймворком.

### TTP моки
[]()[https://github.com/flatiron/nock|nock]() — библиотека HTTP моков и ожиданий(expectations) для node

### Моки
[]()[http://sinonjs.org/|sinonjs](). Автономные тест «шпионы», заглушки и моки для JavaScript.

### Покрытие
[]()[https://github.com/Migrii/blanket|blanket]() Плавное покрытия кода для JavaScript  
Аналог Ruby: RCov

### Симулирование браузера
[]()[http://zombie.labnotes.org/|zombie]() легкий фреймворк для тестирования клиентского JavaScript кода в симулированной среде. Браузер не нужен.  
Аналог Ruby: Capybara

## Разработка
### Дебаг
[]()[https:_github.com/dannycoates/node-inspector|node-inspector]] интерфейс отладчика для node использующий WebKit Web Inspector. [[http:_gaeproxyhttp.appspot.com/post/114825/|Статья на Хабре]()

### Горячая перезагрузка кода
[]()[https://github.com/remy/nodemon|nodemon]() будет следить за изменениями файлов в каталоге, в котором nodemon был запущен, и если они изменятся, он будет автоматически рестартовать node приложение.

[Альтернатива: [[https://github.com/isaacs/node-supervisor|supervisor]()

### Дебаг + Горячая перезагрузка кода
[]()[https://github.com/ericvicenti/nodev|nodev]() помогает с запуском и отладкой node приложений при разработке. nodev запускает node-inspector вместе с вашим приложением, и будет все перезагружать при изменении файлов.
nodev — форк nodemon.

### Инспектор переменных
[]()[https://github.com/cloudhead/eyes.js|eyes]() — настраиваемый инспектор значение для node  
Аналог в Ruby: Awesome Print.

## Утилиты
### Управление потоком (Control-Flow)
[]()[https://github.com/creationix/step|step](). Простая библиотека для управления потоком для node. Делает параллельное и последовательное исполнение, а также обработку ошибок безболезненным.

[]()[https://github.com/caolan/async|async]() — модуль предоставляющий простые и мощные функции для работы с асинхронным JavaScript.

[]()[http:_dailyjs.com/2011/11/14/popular-control-flow/|Сравнение популярных библиотек]] для управления потоками и еще [[http:_dailyjs.com/2012/02/20/new-flow-control-libraries/|список новых библиотек]()

### ools
[]()[http://underscorejs.org/|underscore]() это невероятно удобная JavaScript библиотека, этакий швейцарский нож для js-разработчика, набор функций-утилит, которые так привычны любителям Prototype.js (или Ruby). Однако, в отличие, от Prototype.js, underscore не модифицирует прототипы встроенных объектов JavaScript.

[]()[https://github.com/bestiejs/lodash|lodash](). Он как underscore, но лучше.

### Монитор процесса
[]()[https://github.com/nodejitsu/forever|forever]() — простой инструмент для обеспечения того, чтобы данный скрипт работает непрерывно (т.е. вечно).

### TTP клиент
[]()[https://github.com/mikeal/request|request]() самый простой способ делать HTTP-запросы.

### Работа с изображениями
[]()[https://github.com/aheckmann/gm|gm]() — GraphicsMagick для node

## Построение консольных приложений
### Цвета в консоли
[]()[https://github.com/Marak/colors.js|colors]() — цвета и стили в консоли для вашего node приложения.

### Для написания консольных приложений
[]()[https://github.com/visionmedia/commander.js|commander.js](). Полноценное решение для командной строки для node приложений

[]()[https://github.com/substack/node-optimist|node-optimist]() — библиотека для парсинга опций

## offescript
[]()[https:_github.com/jashkenas/coffee-script|coffee-script]]. Удобно будет разрабатывать вместе с [[https:_github.com/remy/nodemon|nodemon]()

## Немного магии вместо послесловия
[]()[http://meteor.com/|meteor]() — платформа с открытым исходным кодом для построения высококачественных веб приложений в мгновения ока, независимо от того опытный вы разработчик или только начинаете.  
[Обязательно посмотрите скринкасты: [http:_meteor.com/screencast|1](http:_meteor.com/screencast|1), [http:_meteor.com/authcast|2](http:_meteor.com/authcast|2). Или почитайте, что пишут про метеор на [[http://gaeproxyhttp.appspot.com/search/?q=%5BMeteor%5D&amp;target_type=posts|Хабре]().  
Ближайшие конкуренты: derby, socketstream
