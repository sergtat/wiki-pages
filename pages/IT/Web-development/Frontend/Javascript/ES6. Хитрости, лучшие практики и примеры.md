# ES6. Хитрости, лучшие практики и примеры.
_Шпаргалка для повседневного использования, содержащая подборку советов по ES2015 [ES6] с примерами._

## var против let / const

Кроме `var` нам теперь доступны 2 новых идентификатора для хранения значений — `let` и `const`. В отличие от `var`, `let` и `const` обладают блочной областью видимости.

Пример использования `var`:

```javascript
var snack = 'Meow Mix';

function getFood(food) {
    if (food) {
        var snack = 'Friskies';
        return snack;
    }
    return snack;
}

getFood(false); // undefined
```
А вот что происходит при замене `var` на `let`:

```javascript
let snack = 'Meow Mix';

function getFood(food) {
    if (food) {
        let snack = 'Friskies';
        return snack;
    }
    return snack;
}

getFood(false); // 'Meow Mix'
```

Такое изменение в поведении показывает, что нужно быть осторожным при рефакторинге старого кода, в котором используется `var`. Простая замена `var` на `let` может привести к непредсказуемому поведению программы.

> **Примечание:** `let` и `const` видимы лишь в своём блоке. Таким образом, попытка вызвать их до объявления приведёт к `ReferenceError`.

```javascript
console.log(x); // ReferenceError: x is not defined

let x = 'hi';
```
> **Лучшая практика:** Оставьте var в legacy-коде для дальнейшего тщательного рефакторинга. При работе с новым кодом используйте let для переменных, значения которых будут изменяться, и const — для неизменных переменных.

## Замена немедленно вызываемых функций (IIFE) на блоки (Blocks)

Обычно **немедленно вызываемые функци**и используют для ограждения значений в их областях видимости. В ES6 можно создавать блочные области видимости.

```javascript
(function () {
    var food = 'Meow Mix';
}());

console.log(food); // Reference Error
```
Пример ES6 Blocks:

```javascript
{
    let food = 'Meow Mix';
};

console.log(food); // Reference Error
```
## Стрелочные функции

Часто при использовании вложенных функций бывает нужно отделить контекст `this` от его лексической области видимости. Пример приведён ниже:

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.prefixName = function (arr) {
    return arr.map(function (character) {
        return this.name + character; // Cannot read property 'name' of undefined
    });
};
```
Распространённым решением этой проблемы является хранение контекста `this` в переменной:

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.prefixName = function (arr) {
    var that = this; // Store the context of this
    return arr.map(function (character) {
        return that.name + character;
    });
};
```

Также мы можем передать нужный контекст `this`:

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.prefixName = function (arr) {
    return arr.map(function (character) {
        return this.name + character;
    }, this);
};
```

Или привязать контекст:

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.prefixName = function (arr) {
    return arr.map(function (character) {
        return this.name + character;
    }.bind(this));
};
```

Используя **стрелочные функции**, лексическое значение `this` не скрыто, и вышеприведённый код можно переписать так:

```javascript
function Person(name) {
    this.name = name;
}

Person.prototype.prefixName = function (arr) {
    return arr.map(character => this.name + character);
};
```

> **Лучшая практика**: используйте **стрелочные функции** всегда, когда вам нужно сохранить лексическое значение `this.`

Стрелочные функции также более понятны, когда используются для написания функций, просто возвращающих значение:

```javascript
var squares = arr.map(function (x) { return x * x }); // Function Expression
```

```javascript
const arr = [1, 2, 3, 4, 5];
const squares = arr.map(x => x * x); // Arrow Function for terser implementation
```

> **Лучшая практика**: используйте **стрелочные функции** вместо функциональных выражений, когда это уместно.

## Строки

С приходом ES6 стандартная библиотека сильно увеличилась. Кроме предыдущих изменений появились строчные методы, такие как `.includes()` и `.repeat()`.
### .includes( )

```javascript
var string = 'food';
var substring = 'foo';

console.log(string.indexOf(substring) > -1);
```
Вместо проверки возвращаемого значения `> -1` для проверки на наличие подстроки можно использовать `.includes(`), возвращающий логическую величину:

```javascript
const string = 'food';
const substring = 'foo';

console.log(string.includes(substring)); // true
```
### .repeat( )

```javascript
function repeat(string, count) {
    var strings = [];
    while(strings.length < count) {
        strings.push(string);
    }
    return strings.join('');
}
```

В ES6 всё намного проще:

```javascript
// String.repeat(numberOfRepetitions)
'meow'.repeat(3); // 'meowmeowmeow'
```
## Шаблонные литералы

Используя **шаблонные литералы**, мы можем спокойно использовать в строках специальные символы.

```javascript
var text = "This string contains \"double quotes\" which are escaped.";
```

```javascript
let text = `This string contains "double quotes" which don't need to be escaped anymore.`;
```

**Шаблонные литералы** также поддерживают интерполяцию, что делает задачу конкатенации строк и значений:

```javascript
var name = 'Tiger';
var age = 13;

console.log('My cat is named ' + name + ' and is ' + age + ' years old.');
```

Гораздо проще:

```javascript
const name = 'Tiger';
const age = 13;

console.log(`My cat is named ${name} and is ${age} years old.`);
```

В ES5 мы обрабатывали переносы строк так:

```javascript
var text = (
    'cat\n' +
    'dog\n' +
    'nickelodeon'
);
```

Или так:

```javascript
var text = [
    'cat',
    'dog',
    'nickelodeon'
].join('\n');
```

**Шаблонные литералы** сохраняют переносы строк:

```javascript
let text = ( `cat
dog
nickelodeon`
);
```

**Шаблонные литералы** также могут обрабатывать выражения:

```javascript
let today = new Date();
let text = `The time and date is ${today.toLocaleString()}`;
```

## Деструктуризация

Деструктуризация позволяет нам извлекать значения из массивов и объектов (даже вложенных) и помещать их в переменные более удобным способом.

**Деструктуризация массивов**

```javascript
var arr = [1, 2, 3, 4];
var a = arr[0];
var b = arr[1];
var c = arr[2];
var d = arr[3];
```

```javascript
let [a, b, c, d] = [1, 2, 3, 4];

console.log(a); // 1
console.log(b); // 2
```
**Деструктуризация объектов**

```javascript
var luke = { occupation: 'jedi', father: 'anakin' };
var occupation = luke.occupation; // 'jedi'
var father = luke.father; // 'anakin'
```

```javascript
let luke = { occupation: 'jedi', father: 'anakin' };
let {occupation, father} = luke;

console.log(occupation); // 'jedi'
console.log(father); // 'anakin'
```
## Модули

До ES6 нам приходилось использовать библиотеки наподобие [Browserify](http://browserify.org/) для создания модулей на клиентской стороне, и [require](https://nodejs.org/api/modules.html#modules_module_require_id) в **Node.js**. С ES6 мы можем прямо использовать модули любых типов (AMD и CommonJS).

**Экспорт в CommonJS**

```javascript
module.exports = 1;
module.exports = { foo: 'bar' };
module.exports = ['foo', 'bar'];
module.exports = function bar () {};
```
**Экспорт в ES6**

В ES6 мы можем использовать разные виды экспорта.

**Именованный экспорт:**

```javascript
export let name = 'David';
export let age  = 25;
```

**Экспорт списка объектов:**

```javascript
function sumTwo(a, b) {
    return a + b;
}

function sumThree(a, b, c) {
    return a + b + c;
}

export { sumTwo, sumThree };
```

Также мы можем **экспортировать функции, объекты и значения**, просто используя ключевое слово `export`:

```javascript
export function sumTwo(a, b) {
    return a + b;
}

export function sumThree(a, b, c) {
    return a + b + c;
}
```

И наконец, можно **экспортировать связывания по умолчанию:**

```javascript
function sumTwo(a, b) {
    return a + b;
}

function sumThree(a, b, c) {
    return a + b + c;
}

let api = {
    sumTwo,
    sumThree
};

export default api;

/* Which is the same as
 * export { api as default };
 */
```

> **Лучшая практика:** всегда используйте метод `export default` **в конце** модуля. Это чётко покажет, что именно экспортируется, и сэкономит время.

## Импорт в ES6

ES6 предоставляет различные виды импорта. Мы можем импортировать целый файл:

```javascript
import 'underscore';
```

> **Важно заметить**, что импортирование всего файла приведёт к исполнению всего кода на внешнем уровне этого файла.

Как и в `Python`, есть именованный импорт:

```javascript
import { sumTwo, sumThree } from 'math/addition';
```

Который можно переименовывать:

```javascript
import {
    sumTwo as addTwoNumbers,
    sumThree as sumThreeNumbers
} from 'math/addition';
```

Кроме того, можно импортировать пространство имён:

```javascript
import * as util from 'math/addition';
```

И наконец, список значений из модуля:

```javascript
import * as additionUtil from 'math/addition';
const { sumTwo, sumThree } = additionUtil;
```

Импорт из связывания по умолчанию выглядит так:

```javascript
import api from 'math/addition';
// Same as: import { default as api } from 'math/addition';
```

Экспортирование лучше упрощать, но иногда можно смешивать импорт по умолчанию с чем-то ещё. Когда мы экспортируем так:

```javascript
// foos.js
export { foo as default, foo1, foo2 };
```

Импортировать их можно так:

```javascript
import foo, { foo1, foo2 } from 'foos';
```

При импортировании модуля, экспортированного с использованием синтаксиса `CommonJS` (как в `React`), можно сделать:

```javascript
import React from 'react';
const { Component, PropTypes } = React;
```

Это можно упростить:

```javascript
import React, { Component, PropTypes } from 'react';
```

> **Примечание**: экспортируемые значения — это связывания, не ссылки. Поэтому изменение в одном модуле повлечёт за собой изменение в другом.

## Параметры

В `ES5` было несколько способов обработки функций со значениями по умолчанию, неопределёнными аргументами и именованными параметрами. В `ES6` всё это реализуется, причём с понятным синтаксисом.

**Параметры по умолчанию**

```javascript
function addTwoNumbers(x, y) {
    x = x || 0;
    y = y || 0;
    return x + y;
}
```

В `ES6` можно просто указать параметры функции по умолчанию:

```javascript
function addTwoNumbers(x=0, y=0) {
    return x + y;
}
```

```javascript
addTwoNumbers(2, 4); // 6
addTwoNumbers(2); // 2
addTwoNumbers(); // 0
```

**Остаточные параметры**

В `ES5` неопределённое количество аргументов обрабатывалось так:

```javascript
function logArguments() {
    for (var i=0; i < arguments.length; i++) {
        console.log(arguments[i]);
    }
}
```

Используя остаточный оператор, можно передавать неопределённое число аргументов:

```javascript
function logArguments(...args) {
    for (let arg of args) {
        console.log(arg);
    }
}
```

**Именованные параметры**

Одним из шаблонов `ES5` для работы с именованными параметрами был шаблон `options object`, взятый из `jQuery`.

```javascript
function initializeCanvas(options) {
    var height = options.height || 600;
    var width  = options.width  || 400;
    var lineStroke = options.lineStroke || 'black';
}
```

Тоже самое можно получить, используя деструктор в качестве формального параметра функции:

```javascript
function initializeCanvas(
    { height=600, width=400, lineStroke='black'}) {
        // Use variables height, width, lineStroke here
    }
```

Если мы хотим сделать всё значение опциональным, можно деструктурировать пустой объект:

```javascript
function initializeCanvas(
    { height=600, width=400, lineStroke='black'} = {}) {
        // ...
    }
```

## Оператор расширения

В `ES5` можно было найти максимум массива, используя метод `apply` над `Math.max`:

```javascript
Math.max.apply(null, [-1, 100, 9001, -32]); // 9001
```

В `ES6` можно использовать оператор расширения для передачи массива значений в качестве параметров функции:

```javascript
Math.max(...[-1, 100, 9001, -32]); // 9001
```

Также можно интуитивно конкатенировать массивы литералов:

```javascript
let cities = ['San Francisco', 'Los Angeles'];
let places = ['Miami', ...cities, 'Chicago']; // ['Miami', 'San Francisco', 'Los Angeles', 'Chicago']
```

## Классы

До `ES6` классы нужно было создавать, добавляя к функции-конструктору свойства, расширяя прототип:

```javascript
function Person(name, age, gender) {
    this.name   = name;
    this.age    = age;
    this.gender = gender;
}

Person.prototype.incrementAge = function () {
    return this.age += 1;
};
```

А **расширенные классы** — так:

```javascript
function Personal(name, age, gender, occupation, hobby) {
    Person.call(this, name, age, gender);
    this.occupation = occupation;
    this.hobby = hobby;
}

Personal.prototype = Object.create(Person.prototype);
Personal.prototype.constructor = Personal;
Personal.prototype.incrementAge = function () {
    Person.prototype.incrementAge.call(this);
    this.age += 20;
    console.log(this.age);
};
```

`ES6` предоставляет весьма удобный синтаксический сахар. Классы можно создавать таким образом:

```javascript
class Person {
    constructor(name, age, gender) {
        this.name   = name;
        this.age    = age;
        this.gender = gender;
    }

    incrementAge() {
      this.age += 1;
    }
}
```

А расширять — используя ключевое слово `extends`:

```javascript
class Personal extends Person {
    constructor(name, age, gender, occupation, hobby) {
        super(name, age, gender);
        this.occupation = occupation;
        this.hobby = hobby;
    }

    incrementAge() {
        super.incrementAge();
        this.age += 20;
        console.log(this.age);
    }
}
```

> **Лучшая практика**: хотя такой синтаксис и скрывает реализацию, новичкам в нём будет проще разобраться, да и написанный код будет чище.

## Мэпы

**Мэпы** — это очень полезная структура данных. До ES6 хеш-мэпы создавались через объекты:

```javascript
var map = new Object();
map[key1] = 'value1';
map[key2] = 'value2';
```

Однако это не защищает от случайной перегрузки функций с конкретными именами свойств:

```javascript
> getOwnProperty({ hasOwnProperty: 'Hah, overwritten'}, 'Pwned');
> TypeError: Property 'hasOwnProperty' is not a function
```

Настоящие **мэпы** позволяют устанавливать значения (set), брать их (get), искать их (search) и многое другое.

```javascript
let map = new Map();
> map.set('name', 'david');
> map.get('name'); // david
> map.has('name'); // true
```

Самое замечательное — это то, что теперь мы не обязаны использовать только строки. Можно использовать любой тип как ключ, и он не будет приведён к строковому виду.

```javascript
let map = new Map([
    ['name', 'david'],
    [true, 'false'],
    [1, 'one'],
    [{}, 'object'],
    [function () {}, 'function']
]);

for (let key of map.keys()) {
    console.log(typeof key);
    // > string, boolean, number, object, function
}
```

> **Примечание**: использование сложных величин (функций, объектов) невозможно при проверке на равенство при использовании методов наподобие `map.get()`. Поэтому используйте простые величины: строки, логические переменные и числа.

Также по **мэпам** можно итерироваться через `.entries()`:

```javascript
for (let [key, value] of map.entries()) {
    console.log(key, value);
}
```

## Слабые мэпы

В версиях младше `ES6` было несколько способов хранения приватных данных. Например, можно было использовать соглашения по именованию:

```javascript
class Person {
    constructor(age) {
        this._age = age;
    }

    _incrementAge() {
        this._age += 1;
    }
}
```

Но такие соглашения могут запутать, да и не всегда их придерживаются. Вместо этого можно использовать `WeakMaps`:

```javascript
let _age = new WeakMap();
class Person {
    constructor(age) {
        _age.set(this, age);
    }

    incrementAge() {
        let age = _age.get(this) + 1;
        _age.set(this, age);
        if (age > 50) {
            console.log('Midlife crisis');
        }
    }
}
```

Фишкой `WeakMaps` является то, что ключи приватных данных не выдают имена свойств, которые можно увидеть, используя `Reflect.ownKeys()`:

```javascript
> const person = new Person(50);
> person.incrementAge(); // 'Midlife crisis'
> Reflect.ownKeys(person); // []
```

Практическим примером использования `WeakMaps` является хранение данных, связанных с элементом DOM, при этом сама DOM не захламляется:

```javascript
let map = new WeakMap();
let el  = document.getElementById('someElement');

// Store a weak reference to the element with a key
map.set(el, 'reference');

// Access the value of the element
let value = map.get(el); // 'reference'

// Remove the reference
el.parentNode.removeChild(el);
el = null;

// map is empty, since the element is destroyed
```

Как видно выше, когда объект уничтожается сборщиком мусора, `WeakMap` автоматически удаляет пару ключ-значение, которая идентифицировалась этим объектом.

## Обещания

**Обещания**, о которых мы подробно рассказывали в отдельной статье, позволяют превратить «горизонтальный» код:

```javascript
func1(function (value1) {
    func2(value1, function (value2) {
        func3(value2, function (value3) {
            func4(value3, function (value4) {
                func5(value4, function (value5) {
                    // Do something with value 5
                });
            });
        });
    });
});
```

В вертикальный:

```javascript
func1(value1)
    .then(func2)
    .then(func3)
    .then(func4)
    .then(func5, value5 => {
        // Do something with value 5
    });
```

До `ES6`, приходилось использовать `bluebird` или `Q`. Теперь `Promises` реализованы нативно:

```javascript
new Promise((resolve, reject) =>
    reject(new Error('Failed to fulfill Promise')))
        .catch(reason => console.log(reason));
```

У нас есть два обработчика, `resolve` (функция, вызываемая при выполнении обещания) и `reject` (функция, вызываемая при невыполнении обещания).

> **Преимущества Promises**: обработка ошибок с кучей вложенных коллбэков — это ад. Обещания же выглядят гораздо приятнее. Кроме того, значение обещания после его разрешения неизменно.

Вот практический пример использования `Promises`:

```javascript
var request = require('request');

return new Promise((resolve, reject) => {
  request.get(url, (error, response, body) => {
    if (body) {
        resolve(JSON.parse(body));
      } else {
        resolve({});
      }
  });
});
```

Мы также можем распараллеливать обещания для обработки массива асинхронных операций, используя `Promise.all()`:

```javascript
let urls = [
  '/api/commits',
  '/api/issues/opened',
  '/api/issues/assigned',
  '/api/issues/completed',
  '/api/issues/comments',
  '/api/pullrequests'
];

let promises = urls.map((url) => {
  return new Promise((resolve, reject) => {
    $.ajax({ url: url })
      .done((data) => {
        resolve(data);
      });
  });
});

Promise.all(promises)
  .then((results) => {
    // Do something with results of all our promises
 });
```

## Генераторы

Подобно обещаниям, позволяющим нам избежать ада коллбэков, генераторы позволяют сгладить код, придавая асинхронному коду синхронный облик. **Генераторы** — это функции, которые могут приостановить своё выполнение и впоследствии вернуть значение выражения.

Простой пример использования приведён ниже:

```javascript
function* sillyGenerator() {
    yield 1;
    yield 2;
    yield 3;
    yield 4;
}

var generator = sillyGenerator();
> console.log(generator.next()); // { value: 1, done: false }
> console.log(generator.next()); // { value: 2, done: false }
> console.log(generator.next()); // { value: 3, done: false }
> console.log(generator.next()); // { value: 4, done: false }
```

`next` позволяет передать генератор дальше и вычислить новое выражение. Пример выше предельно прост, но на самом деле генераторы можно использовать для написания асинхронного кода в синхронном виде:

```javascript
// Hiding asynchronousity with Generators

function request(url) {
    getJSON(url, function(response) {
        generator.next(response);
    });
}
```

А вот функция-генератор, которая возвращает наши данные:

```javascript
function* getData() {
    var entry1 = yield request('http://some_api/item1');
    var data1  = JSON.parse(entry1);
    var entry2 = yield request('http://some_api/item2');
    var data2  = JSON.parse(entry2);
}
```

Благодаря силе `yield` мы можем быть уверены, что в `entry1` будут нужные данные, которые будут переданы в `data1`.

Тем не менее, для обработки ошибок придётся что-то придумать. Можно использовать `Promises`:

```javascript
function request(url) {
    return new Promise((resolve, reject) => {
        getJSON(url, resolve);
    });
}
```

И мы пишем функцию, которая будет проходить по генератору, используя `next`, который в свою очередь будет использовать метод `request`:

```javascript
function iterateGenerator(gen) {
    var generator = gen();
    (function iterate(val) {
        var ret = generator.next();
        if(!ret.done) {
            ret.value.then(iterate);
        }
    })();
}
```

Дополняя обещанием наш генератор, мы получаем понятный способ передачи ошибок путём `.catch` и `reject`. При этом использовать генератор всё так же просто:

```javascript
iterateGenerator(function* getData() {
    var entry1 = yield request('http://some_api/item1');
    var data1  = JSON.parse(entry1);
    var entry2 = yield request('http://some_api/item2');
    var data2  = JSON.parse(entry2);
});
```

## Async Await

Хотя эта функция появится только в `ES2016`, `async await` позволяет нам делать то же самое, что и в предыдущем примере, но с меньшими усилиями:

```javascript
var request = require('request');
 
function getJSON(url) {
  return new Promise(function(resolve, reject) {
    request(url, function(error, response, body) {
      resolve(body);
    });
  });
}

async function main() {
  var data = await getJSON();
  console.log(data); // NOT undefined!
}

main();
```

По сути, это работает так же, как и генераторы, но использовать лучше именно эту функцию.

## Геттеры и сеттеры

`ES6` привнесла поддержку геттеров и сеттеров. Вот пример:

```javascript
class Employee {

    constructor(name) {
        this._name = name;
    }

    get name() {
      if(this._name) {
        return 'Mr. ' + this._name.toUpperCase();  
      } else {
        return undefined;
      }  
    }

    set name(newName) {
      if (newName == this._name) {
        console.log('I already have this name.');
      } else if (newName) {
        this._name = newName;
      } else {
        return false;
      }
    }
}

var emp = new Employee("James Bond");

// uses the get method in the background
if (emp.name) {
  console.log(emp.name);  // Mr. JAMES BOND
}

// uses the setter in the background
emp.name = "Bond 007";
console.log(emp.name);  // Mr. BOND 007
```

Свежие браузеры также позволяют использовать **геттеры / сеттеры** в объектах, и тогда их можно использовать для вычисленных свойств, добавляя слушатели перед ними:

```javascript
var person = {
  firstName: 'James',
  lastName: 'Bond',
  get fullName() {
      console.log('Getting FullName');
      return this.firstName + ' ' + this.lastName;
  },
  set fullName (name) {
      console.log('Setting FullName');
      var words = name.toString().split(' ');
      this.firstName = words[0] || '';
      this.lastName = words[1] || '';
  }
}

person.fullName; // James Bond
person.fullName = 'Bond 007';
person.fullName; // Bond 007
```

## Символы

Символы существовали и до `ES6`, но теперь стал доступен публичный интерфейс для их прямого использования. Символы неизменяемы и уникальны, и их можно использовать в качестве ключей любого хеша.

**Symbol( )**

Вызов `Symbol()` или `Symbol(description)` создаст уникальный символ, недоступный глобально. `Symbol()` обычно используется для добавления своей логики в сторонние объекты или пространства имён, но нужно быть осторожным с дальнейшими обновлениями этих библиотек. Например, если вы хотите добавить метод `refreshComponent` в класс `React.Component`, убедитесь, что он не совпадёт с методом, добавленном в следующем обновлении:

```javascript
const refreshComponent = Symbol();
 
React.Component.prototype[refreshComponent] = () => {
    // do something
}
```

**Symbol.for(key)**

`Symbol.for(key)` создаст символ, который по-прежнему будет неизменяемым и уникальным, но доступным глобально. Два идентичных вызова `Symbol.for(key)` вернут одну и ту же сущность `Symbol`.

> **Примечание**: это неверно для Symbol(description):

```javascript
Symbol('foo') === Symbol('foo') // false
Symbol.for('foo') === Symbol('foo') // false
Symbol.for('foo') === Symbol.for('foo') // true
```

Символы, в частности, `Symbol.for(key)`, обычно используют для интероперабельности, производя поиск символьного поля в аргументах стороннего объекта с известным интерфейсом, например:

```javascript
function reader(obj) {
    const specialRead = Symbol.for('specialRead');
    if (obj[specialRead]) {
        const reader = obj[specialRead]();
        // do something with reader
    } else {
        throw new TypeError('object cannot be read');
    }
}
```

А в другой библиотеке:

```javascript
const specialRead = Symbol.for('specialRead');

class SomeReadableType {
    [specialRead]() {
        const reader = createSomeReaderFrom(this);
        return reader;
    }
}
```

> В качестве примера использования символов для интероперабельности стоит отметить `Symbol.iterator`, существующий во всех итерируемых типах `ES6`: массивах, строках, генераторах и т.д. При запуске метода возвращается объект с интерфейсом итератора.

Кстати, познакомиться с примерами использования всех новых возможностей можно, пройдя [обучающий видеокурс по JavaScript](https://tproger.ru/news/learn-modern-javascript/), о котором мы писали ранее.

**Источник**: https://tproger.ru
