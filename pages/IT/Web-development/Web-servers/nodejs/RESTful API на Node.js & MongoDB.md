# RESTful API на Node.js + MongoDB.
Я, будучи разработчиком мобильных приложений, часто нуждаюсь в backend-сервисах для хранения пользовательских данных, авторизации и прочего. Конечно, для подобных задач можно использовать BaaS (Parse, Backendless, etc…). Но свое решение — это всегда более удобно и практично.

И я все же решил изучить совершенно неизвестные для меня технологии, которые сейчас весьма популярны и позиционируются, как легко осваиваемые новичками и не требующие глубоких знаний и опыта для реализации масштабных проектов. Вот и проверим вместе, может ли неспециалист написать свой эффективный и правильный бэкенд.

В данной статье будет рассмотрено построение REST API для мобильного приложения на Node.js с использованием фреймворка Express.js и модуля Mongoose.js для работы с MongoDB. Для контроля доступа прибегнем к технологии OAuth 2.0 с помощью модулей OAuth2orize и Passport.js.

Пишу с позиции абсолютного новичка. Рад любым отзывам и поправкам по коду и логике!

Основы Node.js почерпнул в [скринкастах Ильи Кантора](http://learn.javascript.ru/nodejs-screencast), крайне рекомендую! (А вот и [пост](http://habrahabr.ru/post/193158/) про них на хабре)

Готовый проект на последней стадии можно взять на [GitHub](https://github.com/ealeksandrov/NodeAPI). Для установки всех модулей, выполните команду npm install в папке проекта.

## 1. Node.js + Express.js, простой web-сервер

Node.js обладает неблокирующим вводом-выводом, это круто для API, к которому будет обращаться множество клиентов. Express.js — развитый, легковесный фреймворк, позволяющий быстро описать все пути (API endpoints), которые мы будет обрабатывать. Так же к нему можно найти множество полезных модулей.

Создаем новый проект с единственным файлом server.js. Так как приложение будет целиком полагаться на Express.js, установим его. Установка сторонних модулей происходит через Node Package Manager выполнением команды npm install modulename в папке проекта.

    cd NodeAPI
    npm i express

Express установится в папку node_modules. Подключим его к приложению:
```javascript
var express         = require('express');
var app = express();

app.listen(1337, function(){
    console.log('Express server listening on port 1337');
});
```
Запустим приложение через IDE или консоль (node server.js). Данный код создаст веб-сервер на localhost:1337. Если попробовать его открыть — он выведет сообщение Cannot GET /. Это потому что мы еще не задали ни одного пути (route). Далее создадим несколько путей и произведем базовые настройки Express.

```javascript
var express         = require('express');
var path            = require('path'); // модуль для парсинга пути
var app = express();

app.use(express.favicon()); // отдаем стандартную фавиконку, можем здесь же свою задать
app.use(express.logger('dev')); // выводим все запросы со статусами в консоль
app.use(express.bodyParser()); // стандартный модуль, для парсинга JSON в запросах
app.use(express.methodOverride()); // поддержка put и delete
app.use(app.router); // модуль для простого задания обработчиков путей
app.use(express.static(path.join(__dirname, "public"))); // запуск статического файлового сервера, который смотрит на папку public/ (в нашем случае отдает index.html)

app.get('/api', function (req, res) {
    res.send('API is running');
});

app.listen(1337, function(){
    console.log('Express server listening on port 1337');
});
```
Теперь localhost:1337/api вернет наше сообщение. localhost:1337 отобразит index.html.

Тут мы переходим к обработке ошибок.

## 2. Error handling

Сперва подключим удобный модуль для логгинга [Winston](https://github.com/flatiron/winston). Использовать мы его будем через свою обертку. Установим в корне проекта npm i winston, затем создадим папку libs/ и там файл log.js.

```javascript
var winston = require('winston');

function getLogger(module) {
    var path = module.filename.split('/').slice(-2).join('/'); //отобразим метку с именем файла, который выводит сообщение

    return new winston.Logger({
        transports : [
            new winston.transports.Console({
                colorize:   true,
                level:      'debug',
                label:      path
            })
        ]
    });
}

module.exports = getLogger;
```
Мы создали 1 транспорт для логов — в консоль. Так же мы можем отдельно сортировать и сохранять сообщения, например, в базу данных или файл. Подключим логгер в наш server.js.

```javascript
var express         = require('express');
var path            = require('path'); // модуль для парсинга пути
var log             = require('./libs/log')(module);
var app = express();

app.use(express.favicon()); // отдаем стандартную фавиконку, можем здесь же свою задать
app.use(express.logger('dev')); // выводим все запросы со статусами в консоль
app.use(express.bodyParser()); // стандартный модуль, для парсинга JSON в запросах
app.use(express.methodOverride()); // поддержка put и delete
app.use(app.router); // модуль для простого задания обработчиков путей
app.use(express.static(path.join(__dirname, "public"))); // запуск статического файлового сервера, который смотрит на папку public/ (в нашем случае отдает index.html)

app.get('/api', function (req, res) {
    res.send('API is running');
});

app.listen(1337, function(){
    log.info('Express server listening on port 1337');
});
```
Наше информационное сообщение теперь красиво отдельно выводится в консоль. Добавим обработку ошибок 404 и 500.

```javascript
app.use(function(req, res, next){
    res.status(404);
    log.debug('Not found URL: %s',req.url);
    res.send({ error: 'Not found' });
    return;
});

app.use(function(err, req, res, next){
    res.status(err.status || 500);
    log.error('Internal error(%d): %s',res.statusCode,err.message);
    res.send({ error: err.message });
    return;
});

app.get('/ErrorExample', function(req, res, next){
    next(new Error('Random error!'));
});
```
Теперь, если нет доступных путей, Express вернет наше сообщение. При внутренней ошибке приложения сработает так же наш обработчик, это можно проверить, обратившись по адресу localhost:1337/ErrorExample.

## 3. RESTful API endpoints, CRUD

Добавим пути для обработки неких «статей»(articles). На хабре есть прекрасная [статья](http://habrahabr.ru/post/181988/), объясняющая, как правильно делать удобное API. Логикой их наполнять пока не будем, сделаем это в следующем шаге, с подключением базы данных.

```javascript
app.get('/api/articles', function(req, res) {
    res.send('This is not implemented now');
});

app.post('/api/articles', function(req, res) {
    res.send('This is not implemented now');
});

app.get('/api/articles/:id', function(req, res) {
    res.send('This is not implemented now');
});

app.put('/api/articles/:id', function (req, res){
    res.send('This is not implemented now');
});

app.delete('/api/articles/:id', function (req, res){
    res.send('This is not implemented now');
});
```
Для тестирования post/put/delete посоветую замечательную обертку над cURL — [httpie](https://github.com/jkbr/httpie). Далее я буду приводить примеры запросов именно с использованием этого инструмента.

## 4. MongoDB & Mongoose.js

Выбирая СУБД, я руководствовался опять-таки стремлением изучить что-то новое. [MongoDB](http://www.mongodb.org/) — самая популярная NoSQL документ-ориентированная СУБД. [Mongoose.js](http://mongoosejs.com/) — обертка, позволяющая создавать удобные и функциональные схемы документов.

Скачиваем и устанавливаем [MongoDB](http://www.mongodb.org/downloads). Устанавливаем mongoose: npm i mongoose. Работу с бд я выделил в файл libs/mongoose.js.

```javascript
var mongoose    = require('mongoose');
var log         = require('./log')(module);

mongoose.connect('mongodb://localhost/test1');
var db = mongoose.connection;

db.on('error', function (err) {
    log.error('connection error:', err.message);
});
db.once('open', function callback () {
    log.info("Connected to DB!");
});

var Schema = mongoose.Schema;

// Schemas
var Images = new Schema({
    kind: {
        type: String,
        enum: ['thumbnail', 'detail'],
        required: true
    },
    url: { type: String, required: true }
});

var Article = new Schema({
    title: { type: String, required: true },
    author: { type: String, required: true },
    description: { type: String, required: true },
    images: [Images],
    modified: { type: Date, default: Date.now }
});

// validation
Article.path('title').validate(function (v) {
    return v.length > 5 && v.length < 70;
});

var ArticleModel = mongoose.model('Article', Article);

module.exports.ArticleModel = ArticleModel;
```
В данном файле выполняется подключение к базе, а так же объявляются схемы объектов. Статьи будут содержать объекты картинок. Разнообразные сложные валидации можно описать так же здесь.

На данном этапе предлагаю подключить модуль [nconf](https://github.com/flatiron/nconf) для хранения пути к БД в нем. Так же в конфиг сохраним порт, по которому создается сервер. Модуль устанавливается командой npm i nconf. Оберткой будет libs/config.js.

```javascript
var nconf = require('nconf');

nconf.argv()
    .env()
    .file({ file: './config.json' });

module.exports = nconf;



Отсюда следует, что мы должны создать config.json в корне проекта.

{
    "port" : 1337,
    "mongoose": {
        "uri": "mongodb://localhost/test1"
    }
}
```
Изменения mongoose.js (только в шапке):

```javascript
var config      = require('./config');

mongoose.connect(config.get('mongoose:uri'));
```
Изменения server.js:

```javascript
var config          = require('./libs/config');

app.listen(config.get('port'), function(){
    log.info('Express server listening on port ' + config.get('port'));
});
```
Теперь добавим CRUD actions в наши существующие пути.

```javascript
var log             = require('./libs/log')(module);
var ArticleModel    = require('./libs/mongoose').ArticleModel;

app.get('/api/articles', function(req, res) {
    return ArticleModel.find(function (err, articles) {
        if (!err) {
            return res.send(articles);
        } else {
            res.statusCode = 500;
            log.error('Internal error(%d): %s',res.statusCode,err.message);
            return res.send({ error: 'Server error' });
        }
    });
});

app.post('/api/articles', function(req, res) {
    var article = new ArticleModel({
        title: req.body.title,
        author: req.body.author,
        description: req.body.description,
        images: req.body.images
    });

    article.save(function (err) {
        if (!err) {
            log.info("article created");
            return res.send({ status: 'OK', article:article });
        } else {
            console.log(err);
            if(err.name == 'ValidationError') {
                res.statusCode = 400;
                res.send({ error: 'Validation error' });
            } else {
                res.statusCode = 500;
                res.send({ error: 'Server error' });
            }
            log.error('Internal error(%d): %s',res.statusCode,err.message);
        }
    });
});

app.get('/api/articles/:id', function(req, res) {
    return ArticleModel.findById(req.params.id, function (err, article) {
        if(!article) {
            res.statusCode = 404;
            return res.send({ error: 'Not found' });
        }
        if (!err) {
            return res.send({ status: 'OK', article:article });
        } else {
            res.statusCode = 500;
            log.error('Internal error(%d): %s',res.statusCode,err.message);
            return res.send({ error: 'Server error' });
        }
    });
});

app.put('/api/articles/:id', function (req, res){
    return ArticleModel.findById(req.params.id, function (err, article) {
        if(!article) {
            res.statusCode = 404;
            return res.send({ error: 'Not found' });
        }

        article.title = req.body.title;
        article.description = req.body.description;
        article.author = req.body.author;
        article.images = req.body.images;
        return article.save(function (err) {
            if (!err) {
                log.info("article updated");
                return res.send({ status: 'OK', article:article });
            } else {
                if(err.name == 'ValidationError') {
                    res.statusCode = 400;
                    res.send({ error: 'Validation error' });
                } else {
                    res.statusCode = 500;
                    res.send({ error: 'Server error' });
                }
                log.error('Internal error(%d): %s',res.statusCode,err.message);
            }
        });
    });
});

app.delete('/api/articles/:id', function (req, res){
    return ArticleModel.findById(req.params.id, function (err, article) {
        if(!article) {
            res.statusCode = 404;
            return res.send({ error: 'Not found' });
        }
        return article.remove(function (err) {
            if (!err) {
                log.info("article removed");
                return res.send({ status: 'OK' });
            } else {
                res.statusCode = 500;
                log.error('Internal error(%d): %s',res.statusCode,err.message);
                return res.send({ error: 'Server error' });
            }
        });
    });
});
```
Благодаря Mongoose и описанным схемам — все операции предельно понятны. Теперь, кроме node.js следует запустить mongoDB командой mongod. mongo — утилита для работы с БД, сам сервис — mongod. Создавать предварительно в базе ничего не нужно.

Примеры запросов с помощью httpie:

```bash
http POST http://localhost:1337/api/articles title=TestArticle author='John Doe' description='lorem ipsum dolar sit amet' images:='[{"kind":"thumbnail", "url":"http://habrahabr.ru/images/write-topic.png"}, {"kind":"detail", "url":"http://habrahabr.ru/images/write-topic.png"}]'

http http://localhost:1337/api/articles

http http://localhost:1337/api/articles/52306b6a0df1064e9d000003

http PUT http://localhost:1337/api/articles/52306b6a0df1064e9d000003 title=TestArticle2 author='John Doe' description='lorem ipsum dolar sit amet' images:='[{"kind":"thumbnail", "url":"http://habrahabr.ru/images/write-topic.png"}, {"kind":"detail", "url":"http://habrahabr.ru/images/write-topic.png"}]'

http DELETE http://localhost:1337/api/articles/52306b6a0df1064e9d000003
```
 Проект на данном этапе можно взглянуть на [GitHub](https://github.com/ealeksandrov/NodeAPI/tree/e8764a97f9c70fb6eae102fda7237e745d9e99ac).

##  5. Access control — OAuth 2.0, Passport.js

Для контроля доступа я прибегну к OAuth 2. Возможно, это избыточно, но в дальнейшем такой подход облегчает интеграцию с другими OAuth-провайдерами. К тому же, я не нашел рабочих примеров user-password OAuth2 flow для Node.js.

Непосредственно за контролем доступа будет следить [Passport.js](http://passportjs.org/). Для OAuth2-сервера пригодится решение от того же автора — [oauth2orize](https://github.com/jaredhanson/oauth2orize). Пользователи, токены будут храниться в MongoDB.

Сперва нужно установить все модули, которые нам потребуются:

- Faker
- oauth2orize
- passport
- passport-http
- passport-http-bearer
- passport-oauth2-client-password

Затем, в mongoose.js нужно добавить схемы для пользователей и токенов:

```javascript
var crypto      = require('crypto');

// User
var User = new Schema({
    username: {
        type: String,
        unique: true,
        required: true
    },
    hashedPassword: {
        type: String,
        required: true
    },
    salt: {
        type: String,
        required: true
    },
    created: {
        type: Date,
        default: Date.now
    }
});

User.methods.encryptPassword = function(password) {
    return crypto.createHmac('sha1', this.salt).update(password).digest('hex');
    //more secure - return crypto.pbkdf2Sync(password, this.salt, 10000, 512);
};

User.virtual('userId')
    .get(function () {
        return this.id;
    });

User.virtual('password')
    .set(function(password) {
        this._plainPassword = password;
        this.salt = crypto.randomBytes(32).toString('base64');
        //more secure - this.salt = crypto.randomBytes(128).toString('base64');
        this.hashedPassword = this.encryptPassword(password);
    })
    .get(function() { return this._plainPassword; });

User.methods.checkPassword = function(password) {
    return this.encryptPassword(password) === this.hashedPassword;
};

var UserModel = mongoose.model('User', User);

// Client
var Client = new Schema({
    name: {
        type: String,
        unique: true,
        required: true
    },
    clientId: {
        type: String,
        unique: true,
        required: true
    },
    clientSecret: {
        type: String,
        required: true
    }
});

var ClientModel = mongoose.model('Client', Client);

// AccessToken
var AccessToken = new Schema({
    userId: {
        type: String,
        required: true
    },
    clientId: {
        type: String,
        required: true
    },
    token: {
        type: String,
        unique: true,
        required: true
    },
    created: {
        type: Date,
        default: Date.now
    }
});

var AccessTokenModel = mongoose.model('AccessToken', AccessToken);

// RefreshToken
var RefreshToken = new Schema({
    userId: {
        type: String,
        required: true
    },
    clientId: {
        type: String,
        required: true
    },
    token: {
        type: String,
        unique: true,
        required: true
    },
    created: {
        type: Date,
        default: Date.now
    }
});

var RefreshTokenModel = mongoose.model('RefreshToken', RefreshToken);

module.exports.UserModel = UserModel;
module.exports.ClientModel = ClientModel;
module.exports.AccessTokenModel = AccessTokenModel;
module.exports.RefreshTokenModel = RefreshTokenModel;
```
Виртуальное свойство password — пример, как mongoose может в модели встроить удобную логику. Про хэши, алгоритмы и соль — не эта статья, не будем вдаваться в подробности реализации.

Итак, объекты в БД:

1. User — пользователь, который обладает именем, хэшем пароля и солью своего пароля.
2. Client — клиент-приложение, которому выдается доступ от имени пользователя. Обладают именем и секретным кодом.
3. AccessToken — токен (тип bearer), выдаваемый клиентским приложениям, ограничен по времени.
4. RefreshToken — другой тип токена, позволяет запросить новый bearer-токен без повторного запроса пароля у пользователя.

В config.json добавим время жизни токена:

```json
{
    "port" : 1337,
    "security": {
        "tokenLife" : 3600
    },
    "mongoose": {
        "uri": "mongodb://localhost/testAPI"
    }
}
```
Выделим в отдельные модули сервер OAuth2 и логику авторизации. В oauth.js описаны «стратегии» passport.js, мы подключаем 3 из них — 2 на OAuth2 username-password flow, 1 на проверку токена.

```javascript
var config                  = require('./config');
var passport                = require('passport');
var BasicStrategy           = require('passport-http').BasicStrategy;
var ClientPasswordStrategy  = require('passport-oauth2-client-password').Strategy;
var BearerStrategy          = require('passport-http-bearer').Strategy;
var UserModel               = require('./mongoose').UserModel;
var ClientModel             = require('./mongoose').ClientModel;
var AccessTokenModel        = require('./mongoose').AccessTokenModel;
var RefreshTokenModel       = require('./mongoose').RefreshTokenModel;

passport.use(new BasicStrategy(
    function(username, password, done) {
        ClientModel.findOne({ clientId: username }, function(err, client) {
            if (err) { return done(err); }
            if (!client) { return done(null, false); }
            if (client.clientSecret != password) { return done(null, false); }

            return done(null, client);
        });
    }
));

passport.use(new ClientPasswordStrategy(
    function(clientId, clientSecret, done) {
        ClientModel.findOne({ clientId: clientId }, function(err, client) {
            if (err) { return done(err); }
            if (!client) { return done(null, false); }
            if (client.clientSecret != clientSecret) { return done(null, false); }

            return done(null, client);
        });
    }
));

passport.use(new BearerStrategy(
    function(accessToken, done) {
        AccessTokenModel.findOne({ token: accessToken }, function(err, token) {
            if (err) { return done(err); }
            if (!token) { return done(null, false); }

            if( Math.round((Date.now()-token.created)/1000) > config.get('security:tokenLife') ) {
                AccessTokenModel.remove({ token: accessToken }, function (err) {
                    if (err) return done(err);
                });
                return done(null, false, { message: 'Token expired' });
            }

            UserModel.findById(token.userId, function(err, user) {
                if (err) { return done(err); }
                if (!user) { return done(null, false, { message: 'Unknown user' }); }

                var info = { scope: '*' }
                done(null, user, info);
            });
        });
    }
));
```
За выдачу и обновление токена отвечает oauth2.js. Одна exchange-стратегия — на получение токена по username-password flow, еще одна — на обмен refresh_token.

```javascript
var oauth2orize         = require('oauth2orize');
var passport            = require('passport');
var crypto              = require('crypto');
var config              = require('./config');
var UserModel           = require('./mongoose').UserModel;
var ClientModel         = require('./mongoose').ClientModel;
var AccessTokenModel    = require('./mongoose').AccessTokenModel;
var RefreshTokenModel   = require('./mongoose').RefreshTokenModel;

// create OAuth 2.0 server
var server = oauth2orize.createServer();

// Exchange username & password for access token.
server.exchange(oauth2orize.exchange.password(function(client, username, password, scope, done) {
    UserModel.findOne({ username: username }, function(err, user) {
        if (err) { return done(err); }
        if (!user) { return done(null, false); }
        if (!user.checkPassword(password)) { return done(null, false); }

        RefreshTokenModel.remove({ userId: user.userId, clientId: client.clientId }, function (err) {
            if (err) return done(err);
        });
        AccessTokenModel.remove({ userId: user.userId, clientId: client.clientId }, function (err) {
            if (err) return done(err);
        });

        var tokenValue = crypto.randomBytes(32).toString('base64');
        var refreshTokenValue = crypto.randomBytes(32).toString('base64');
        var token = new AccessTokenModel({ token: tokenValue, clientId: client.clientId, userId: user.userId });
        var refreshToken = new RefreshTokenModel({ token: refreshTokenValue, clientId: client.clientId, userId: user.userId });
        refreshToken.save(function (err) {
            if (err) { return done(err); }
        });
        var info = { scope: '*' }
        token.save(function (err, token) {
            if (err) { return done(err); }
            done(null, tokenValue, refreshTokenValue, { 'expires_in': config.get('security:tokenLife') });
        });
    });
}));

// Exchange refreshToken for access token.
server.exchange(oauth2orize.exchange.refreshToken(function(client, refreshToken, scope, done) {
    RefreshTokenModel.findOne({ token: refreshToken }, function(err, token) {
        if (err) { return done(err); }
        if (!token) { return done(null, false); }
        if (!token) { return done(null, false); }

        UserModel.findById(token.userId, function(err, user) {
            if (err) { return done(err); }
            if (!user) { return done(null, false); }

            RefreshTokenModel.remove({ userId: user.userId, clientId: client.clientId }, function (err) {
                if (err) return done(err);
            });
            AccessTokenModel.remove({ userId: user.userId, clientId: client.clientId }, function (err) {
                if (err) return done(err);
            });

            var tokenValue = crypto.randomBytes(32).toString('base64');
            var refreshTokenValue = crypto.randomBytes(32).toString('base64');
            var token = new AccessTokenModel({ token: tokenValue, clientId: client.clientId, userId: user.userId });
            var refreshToken = new RefreshTokenModel({ token: refreshTokenValue, clientId: client.clientId, userId: user.userId });
            refreshToken.save(function (err) {
                if (err) { return done(err); }
            });
            var info = { scope: '*' }
            token.save(function (err, token) {
                if (err) { return done(err); }
                done(null, tokenValue, refreshTokenValue, { 'expires_in': config.get('security:tokenLife') });
            });
        });
    });
}));

// token endpoint
exports.token = [
    passport.authenticate(['basic', 'oauth2-client-password'], { session: false }),
    server.token(),
    server.errorHandler()
]
```
Для подключения этих модулей, следует добавить в server.js:

```javascript
var oauth2          = require('./libs/oauth2');

app.use(passport.initialize());

require('./libs/auth');

app.post('/oauth/token', oauth2.token);

app.get('/api/userInfo',
    passport.authenticate('bearer', { session: false }),
        function(req, res) {
            // req.authInfo is set using the `info` argument supplied by
            // `BearerStrategy`.  It is typically used to indicate scope of the token,
            // and used in access control checks.  For illustrative purposes, this
            // example simply returns the scope in the response.
            res.json({ user_id: req.user.userId, name: req.user.username, scope: req.authInfo.scope })
        }
);
```
Для примера защита стоит на адресе localhost:1337/api/userInfo.

Чтобы проверить работу механизма авторизации — следует создать пользователя и клиента в БД. Приведу приложение на Node.js, которое создаст необходимые объекты и удалит лишние из коллекций. Помогает быстро очистить базу токенов и пользователей при тестировании, вам, думаю, достаточно будет одного запуска :)

```javascript
var log                 = require('./libs/log')(module);
var mongoose            = require('./libs/mongoose').mongoose;
var UserModel           = require('./libs/mongoose').UserModel;
var ClientModel         = require('./libs/mongoose').ClientModel;
var AccessTokenModel    = require('./libs/mongoose').AccessTokenModel;
var RefreshTokenModel   = require('./libs/mongoose').RefreshTokenModel;
var faker               = require('Faker');

UserModel.remove({}, function(err) {
    var user = new UserModel({ username: "andrey", password: "simplepassword" });
    user.save(function(err, user) {
        if(err) return log.error(err);
        else log.info("New user - %s:%s",user.username,user.password);
    });

    for(i=0; i<4; i++) {
        var user = new UserModel({ username: faker.random.first_name().toLowerCase(), password: faker.Lorem.words(1)[0] });
        user.save(function(err, user) {
            if(err) return log.error(err);
            else log.info("New user - %s:%s",user.username,user.password);
        });
    }
});

ClientModel.remove({}, function(err) {
    var client = new ClientModel({ name: "OurService iOS client v1", clientId: "mobileV1", clientSecret:"abc123456" });
    client.save(function(err, client) {
        if(err) return log.error(err);
        else log.info("New client - %s:%s",client.clientId,client.clientSecret);
    });
});
AccessTokenModel.remove({}, function (err) {
    if (err) return log.error(err);
});
RefreshTokenModel.remove({}, function (err) {
    if (err) return log.error(err);
});

setTimeout(function() {
    mongoose.disconnect();
}, 3000);
```
Если вы создали данные скриптом, до следующие команды для авторизации вам так же подойдут. Напомню, что я использую httpie.

```bash
http POST http://localhost:1337/oauth/token grant_type=password client_id=mobileV1 client_secret=abc123456 username=andrey password=simplepassword

http POST http://localhost:1337/oauth/token grant_type=refresh_token client_id=mobileV1 client_secret=abc123456 refresh_token=TOKEN

http http://localhost:1337/api/userinfo Authorization:'Bearer TOKEN'
```
**Внимание!** На production-сервере обязательно используйте HTTPS, это подразумевается спецификацией OAuth 2. И не забудьте про правильное хэширование паролей. Реализовать https на данном примере несложно, в сети много примеров.

Напомню, что весь код содержится в репозитории на [GitHub](https://github.com/ealeksandrov/NodeAPI).

Для работы необходимо выполнить npm install в директории, запустить mongod, node dataGen.js (дождаться выполнения), а затем node server.js.

Если какую-то часть статьи стоит описать более подробно, пожалуйста, укажите на это в комментариях. Материал будет перерабатываться и дополняться по мере поступления отзывов.

Подводя итог, хочу сказать, что node.js — классное, удобное серверное решение. MongoDB с документ-ориентированным подходом — очень непривычный, но несомненно полезный инструмент, большинства возможностей которого я еще не использовал. Вокруг Node.js — очень большое коммьюнити, где есть множество open-source разработок. Например, создатель oauth2orize и passport.js — Jared Hanson сделал замечательне проекты, которые максимально облегчают реализацию правильно защищенных систем.

> Источник: https://habrahabr.ru

---
# Комментарии:

    app.use(express.static(path.join(__dirname, "public"))); // отдаем статический index.html из папки public/

это не просто отдаёт статический index.html, а запускает статический файловый сервер, который смотрит на папку public/
может я и придираюсь, просто тех, кто только начал изучение Express, это может ввести в заблуждение. Мне так кажется во всяком случае

---
В статье выделена обработка ошибок. Если вкратце, то все необработанные ошибки Express направит в наш обработчик:
```javascript
app.use(function(err, req, res, next){
    res.status(err.status || 500);
    log.error('Internal error(%d): %s',res.statusCode,err.message);
    res.send({ error: err.message });
    return;
});
```
А вот и пример вызова ошибки. Так же можно выполнить throw new Error('my silly error');, все прекрасно обработается, сервер не упадет.
```javascript
app.get('/ErrorExample', function(req, res, next){
    next(new Error('Random error!'));
});
```

---
Очень удобно использовать app.param. Плюс бонус, один хендлер вместо двух на обновление и добавление статьи.
```javascript
var underscore = require('underscore');
app.param(":articleId", function(req, res, next, articleId){
    ArticleModel.findById(articleId, function(err, article){
        if(err || !article) {
            return next('route');
        }
        req.dbArticle = article;
        next();
    });
});

app.post("/api/articles/:articleId?", function(req, res, next){
    if(!req.dbArticle) {
        req.dbArticle = new ArticleModel();
    }
    req.dbArticle.set(underscore.pick(req.body, 'title', 'description', 'author', 'images'));
    req.dbArticle.save(function(err, article){
        // ..............
    })
});
```

---
Еще скажу про сам принцип REST API. Дело в том, что он пришел в ноду из каменного века тяжеловесных веб серверов (как Apache и IIS), которые каждый раз запускают внешние (по отношению к ним) приложения, передавая им запросы HTTP протокола через CGI. Такое приложение порождает новый процесс, он должен провести инициализацию рабочей среды, т.е. установить соединения с базой, развернуть все свои данные, прочитать себе из файловой системы что-то (если нужно) и т.д. и все это лишь для того, чтобы через несколько мил миллисекунд завершить работу и освободить память, отключиться от базы. До веба я писал на языках, в которых принято STATEful API, такого типа, как RPC (COM, DCOM, Corba...), и для меня REST в вебе всегда представлялся маразмом. И вот, наконец, после перехода в вероисповедание ноды, мне было счастье. Теперь опять можно разворачивать в памяти данные и они ни куда не деваются от запроса к запросу, можно хранить увесистые сессии в оперативной памяти и не делать сериализацию/десериализацию оных при завершении и повторном запуске процессов. И мне было видение, что REST ушел в прошлое вместе с ублюдочными заплатками типа viewstate и серверами состояний. Понял я, что STATEful API есть величайшее благо, дарованное Всевышним каждому живому существу, познавшему ноду.

---
REST — есть род болезненного отказа от хранения состояния объектов во всех компонентах системы, кроме постоянного хранилища (БД, диска). Первейший симптом REST, это STATEless, когда между парой запрос/ответ ни на сервере, ни на клиенте, не сохраняется состояние объекта. В противоположность RPC, на котором основаны клиент-серверные приложения с толстыми клиентами или STATEful серверами приложений, в которых принято создавать модель в клиенте и создавать модель в сервере, связывая их интерфейсы по сети и транслируя между этими моделями события и вызовы. Вот нода позволяет развернуть модель на двух концах провода и синхронизировать через AJAX вызовы, что конечно более удобно для прикладных приложений.

---
Так решалась проблема масштабируемости в каменном веке, теперь не нужно отказываться от состояния STATEful возможностей, ради высоких нагрузок, а можно использовать асинхронный ввод/вывод, балансировщики в ip-sticky и cookie-sticky режимах, межпроцессовое взаимодействие через ØMQ, много оперативной памяти, и это работает гораздо эффективнее.

---
Со statefull опасно довольно. Особенно для мобильных приложений с падучим интернетом.

Вот держите вы открытое подключение, на сервере стейт. Человек заехал в туннель в метро, коннект отвалился — стейт подвис, клиент будет переподключаться и получается тот же REST практически.

Да и выкатывать новую версию ПО снова проблема. Вот висит у вас 1000 подключенных клиентов, вам нужно апдейт выкатить. Получается всех клиентов придётся отрубать (в Erlang это более-менее ещё можно обойти). То же самое, но в меньшей степени, можно сказать про вылеты серверов. Сервер упал-стейт потерял.

Да и REST на месте не стоит. Есть keep-alive, большинство современных серверов приложений умеют держать подключения к БД, кешам и т.п. открытыми, некоторые ещё и часть данных хранят или просто какие то объекты/настройки и т.п.

---
Поддерживаю. Только что сбежали с socket.io в сторону REST API.

Но у нас еще и наложилось, что socket.io нивкакую не хотел скейлится на несколько серверов.

---
Скейлиться совершенно не сложно, для взаимодействия между серверами в рамках одной машины, можно использовать IPC, а если машин несколько, то есть ZeroMQ и его аналоги, которые решают проблему обмена сообщениями полностью. Но обмен сообщениями нужен только если нужно наладить взаимодействие между пользователями или разными клиентами. Если такой задачи не стоит, то можно реализовать «IP sticky» (приклеивание по IP) или «cookie sticky» (приклеивание по кукизу). И то и другое для ноды — не проблема, есть кучу реализаций, что позволяет все соединения с одного IP или c одним и тем же кукизом при разрыве и восстановлении опять направлять в тот же процесс, от которого они отвалились и который хранит их сессию.

---
Решение есть и это не мое изобретение, это известные все вещи. В нестабильном интернете с разрывом соединений нет ни какой проблемы, такие случаи нужно и можно правильно обрабатывать:

1. Не нужно присоединять состояние к открытому сокету, а нужно разделить состояние на три типа: состояние сессии, состояние пользователя и состояние объекта (с которым работает пользователь). Таким образом, одна сессия может иметь множество не закрытых (подвисших) соединенией, которые через какой-то таймаут умрут, но у них всех есть общее состояние сессии, обращение к которому происходит по идентификатору сессии (например, кукизу или другому выдаваемому ключу). Состояние пользователя общее для всех его сесиий, а состояние информационного объекта общее для всех пользователей, которые с ним работают.
2. Правильно настраивать таймауты, обработку ошибок и выделение/освобождение памяти. Для ноды, в которой память выделяется и освобождается не явно, нужно просто заботиться, чтобы удалялись ссылки на ненужные данные из соответствующих хешей, делать это нужно или по ошибке или по таймауту или по событию отключения (что-то из этого все же случится).
3. Нода достаточно хорошо справляется с большими нагрузками, и много открытых соединений ей не страшно, лишь бы только память выделялась не на соединения, а на сессии: [Миллион одновременных соединений на Node.js](http://habrahabr.ru/post/123154/).

Про вылеты серверов: стейт нужно сохранять в базу, просто сохранение это не все же время происходит, а «ленивым» способом, отложенным, что не мешает обработке запросов. Сохранение происходит только при изменении стейта. Если упал сервер, то из базы подымается все, проблем нет.

Про обновление кода, все решено уже в Impress, можно изменять код без разрушения структуры данных, без перестартовывания ноды. А если в момент изменения обрабатывались запросы старой версией кода, то некоторое время в памяти хранятся 2 версии кода, потом старая удаляется.

---
Насчёт обновления кода сомневаюсь что всё так гладко, но не очень хочу эту тему развивать (типа трансформация структур данных состояния под работу с новой версией кода).

Ещё — в stateless системах, говорят, проще делать балансировку. Один запрос пришел на один сервер, второй на совсем другой. В statefull нужно следить, чтобы юзер был приклеен к одному серверу (хотя при постоянных подключениях это несколько легче по понятным причинам).

Ну и сложность системы повышается (разделение состояния на 3 типа, приклеивание юзеров к серверам).

Ну и главное — не понимаю в чём собственно профит? В том, что не нужно делать сериализацию / десериализацию состояния? Так вроде решили что это опасно в случае вылета железа/софта.

У меня на statefull работает хобби-проект сервис временной почты на Erlang и я уже временами сомневаюсь нужен ли мне этот геморрой, или стоит перейти на тупой long-polling. И это при том, что в Erlang проблема обновления кода под живыми пользователями решена лучше, чем у кого либо.

---
Трансформация структур данные — это уже бред, если стурктура данных меняется, то нужно менять не только код, но и сбрасывать состояние. Но тут ничего страшного, один разок система поработает медленно, додтянет данные, как это делает STATEless при каждом запросе.

На вопрос приклеивания я уже ответил тут.

Профит: скорость разворачивания среды и подгрузка данных. На сохранении данных особо не сэкономишь, разве что, можно сохранять данные уже после того, как запрос обработан и ответ клиенту отослан. То есть, делать это в отложенном режиме. По опыту могу сказать, что максимальное использование памяти — это конечно сложнее, но скорость возрастает так же круто, как и от применения неблокирующей обработки. То есть, возможность хранить состояние считаю одним из ключевых преимуществ ноды. В Impress мы храним в памяти не только состояние, но и всю статику (картинки, css, js, шаблоны), да еще в кеш сразу преобразуем в минифицированный вид и храним сразу сжатое gzip, что при отдаче только буфер нужный подставляем.

---
У меня вопросы по методам апи.

Первое есть список элементов со свойством, которое зависит от других елементов.

Допустим есть список вероятностных событий и мы им можем менять вероятность их наступления, но общая их сумма должна быть 100%.

Таким образом на клиенте мы меняем минимум 2 элемента, максимум — все.

Как сохранять изменения?

Второе мы создаем новую сущность пост запросом тру вей не возвращать сущность в запоросе. Значит нам надо делать всегда гет запрос после создания?

---
Если я правильно понял вопрос — предлагаю присваивать все доступные в запросе параметры в схему mongoose, а затем вызвать метод схемы, который расставит по особому правилу все остальные, незаполненные атрибуты. А затем уже можно сохранить.

В примере по полю password заполняются сразу хэш и соль, но это не метод схемы, а виртуальное поле.

Почему так не следует делать? Я в примере возвращаю созданную сущность. В принципе можно только id новой записи возвращать, а в случае необходимости — делать по данному id GET запрос.

---
Если я правильно понял вопрос

Не совсем. Меняются поля не одной сущности а несколько. Еще раз, есть список с вероятностными событиями у них по 2 поля имя и %. Сумма всех процентов должна быть 100%, таким образом меняя % у одной сущности мы по какому-то алгоритму меняем у других, что б сумма была 100. В итоге получаем список, у которого у всез лементов изменился параметр и его надо созранить.
```
list of events:
event1:
name:«событие 1»
percent: 20

event2:
name:«событие 2»
percent: 30

event3:
name:«событие 3»
percent: 40

event4:
name:«событие 4»
percent: 10
```
Я в примере возвращаю созданную сущность

Каноничный REST на пост должен вернуть 201 и идентификатор новой записи (ссылку) по кторой клиент гетом уже забирает. Многие клиентские либы на пост сами разгребают запрос и гетом забирают данные об объекте, прозрачно для юезра, но 2 запроса это 2 запроса

---
1. Если это разные сущности — в чем проблема после изменения n сущностей (с помощью, например, bulk data update через PUT) найти в базе все неизмененные, отредактировать по нужному алгоритму и сохранить?

  P.S. Изменение/удаление/создание сразу нескольких сущностей сделать несложно, но в моем примере не отражено. Пример можно найти в этой [этой статье](http://pixelhandler.com/blog/2012/02/09/develop-a-restful-api-using-node-js-with-express-and-mongoose/) (тоже Express & Mongoose) под заголовком Bulk Actions for UPDATE and DELETE.
2. Возвращать ли созданную сущность? — я предпочитаю возвращать сразу, если это не займет много траффика.

---
А зачем возвращать вновь созданную сущность? Ведь клиент только что передал все данные, которые были необходимы для создания сущности, значит, у клиента они и так есть. Разве что вернуть айдишник, как выше отметил BenderRodriguez. Или если сервер дозаполняет некоторые важные поля сущности, тогда можно рассмотреть — либо вернуть только их (для уменьшения трафика), либо всё-таки возвращать всю сущность (для удобства).

---
Для CRUD есть отличный модуль [github.com/visionmedia/express-resource](https://github.com/visionmedia/express-resource)

---
Хэши, алгоритмы и соли — это чрезвычайно обширная и спорная тема. Советую всем интересующимся внимательно ознакомится с данной областью на специализированных ресурсах. Ну или в предметных топиках, здесь же.

Кстати, в процессе изучения этих вопросов открыл для себя http://security.stackexchange.com/ — там есть дискуссии с описаниями, плюсами и минусами различных алгоритмов.

---
Вот этот кусок кода у самого автора oauth2orize есть:
```javascript
server.serializeClient(function(client, done) { return done(null, client.id); }); server.deserializeClient(function(id, done) { db.clients.find(id, function(err, client) { if (err) { return done(err); } return done(null, client); }); });
```
а у вас его нету

можете объяснить почему?

---
Этот код используется для сохранения в сессии объекта «клиент». Сессия используется для хранения транзакции в процессе аутентификации, состоящего из нескольких http-запросов. В примере из статьи сессии не используются, авторизация происходит только через username-password flow, в 1 запрос.

---
Извините за глупый вопрос, но авторизация у меня не получается: в oauth.js базовая стратегия обмена юзернейма и пароля на токен, вот только поиск идёт по клиенту, у которого нет пароля:
```javascript
...
passport.use(new BasicStrategy(
    function(username, password, done) {
        ClientModel.findOne({ clientId: username }
...
```
Кроме того, в коде, предоставленном в статье, нигде не создаётся и не записывается ClientModel.

---
Поиск идет по клиенту, у которого есть client_secret. Клиент вполне создается и сохраняется в [dataGen.js](https://github.com/ealeksandrov/NodeAPI/blob/master/dataGen.js#L26). 2 стратегии я использую, потому что в [oauth2orize example](https://github.com/jaredhanson/oauth2orize/blob/master/examples/express2/auth.js) они так используются:

    ClientPasswordStrategy
    http POST http://localhost:1337/oauth/token grant_type=password client_id=mobileV1 client_secret=abc123456 username=andrey password=simplepassword

    BasicStrategy
    http -a mobileV1:abc123456 POST http://localhost:1337/oauth/token grant_type=password username=andrey password=simplepassword

Для простой авторизации, без использования OAuth — нужно применять passport-local.
