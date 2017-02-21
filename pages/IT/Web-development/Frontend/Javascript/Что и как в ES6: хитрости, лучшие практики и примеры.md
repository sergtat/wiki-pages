# Что и как в ES6: хитрости, лучшие практики и примеры.
**_Шпаргалка для повседневного использования, содержащая подборку советов по ES2015 [ES6] с примерами._**

## var против let / const

Кроме `var` нам теперь доступны 2 новых идентификатора для хранения значений — `let` и `const`. В отличие от `var`, `let` и `const` обладают блочной областью видимости.

**Пример использования `var`:**

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

**А вот что происходит при замене `var` на `let`:**

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

> **Примечание**: `let` и `const` видимы лишь в своём блоке. Таким образом, попытка вызвать их до объявления приведёт к `ReferenceError`.

```javascript
console.log(x); // ReferenceError: x is not defined

let x = 'hi';
```

> **Лучшая практика**: Оставьте `var` в legacy-коде для дальнейшего тщательного рефакторинга. При работе с новым кодом используйте `let` для переменных, значения которых будут изменяться, и `const` — для неизменных переменных.

## Замена немедленно вызываемых функций (IIFE) на блоки (Blocks)

Обычно **немедленно вызываемые функции** используют для ограждения значений в их областях видимости. В ES6 можно создавать блочные области видимости.

```javascript
(function () {
    var food = 'Meow Mix';
}());

console.log(food); // Reference Error
```

**Пример ES6 Blocks:**

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

> **Лучшая практика**: используйте **стрелочные функции** всегда, когда вам нужно сохранить лексическое значение this.

**Стрелочные функции** также более понятны, когда используются для написания функций, просто возвращающих значение:

```javascript
var squares = arr.map(function (x) { return x * x }); // Function Expression
```

```javascript
const arr = [1, 2, 3, 4, 5];
const squares = arr.map(x => x * x); // Arrow Function for terser implementation
```

> **Лучшая практика**: используйте **стрелочные функции** вместо функциональных выражений, когда это уместно.

## Строки

С приходом `ES6` стандартная библиотека сильно увеличилась. Кроме предыдущих изменений появились строчные методы, такие как `.includes()` и `.repeat()`.

**.includes( )**

```javascript
var string = 'food';
var substring = 'foo';

console.log(string.indexOf(substring) > -1);
```

Вместо проверки возвращаемого значения `> -1` для проверки на наличие подстроки можно использовать `.includes()`, возвращающий логическую величину:

```javascript
const string = 'food';
const substring = 'foo';

console.log(string.includes(substring)); // true
```

**.repeat( )**

```javascript
function repeat(string, count) {
    var strings = [];
    while(strings.length < count) {
        strings.push(string);
    }
    return strings.join('');
}
```

В `ES6` всё намного проще:

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

В `ES5` мы обрабатывали переносы строк так:

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

```bash
let text = ( `cat
dog
nickelodeon`
);
```

**Шаблонные литералы** также могут обрабатывать выражения:

```bash
let today = new Date();
let text = `The time and date is ${today.toLocaleString()}`;
```

## Деструктуризация

**Деструктуризация** позволяет нам извлекать значения из массивов и объектов (даже вложенных) и помещать их в переменные более удобным способом.

**Деструктуризация массивов**

```bash
var arr = [1, 2, 3, 4];
var a = arr[0];
var b = arr[1];
var c = arr[2];
var d = arr[3];
```

```bash
let [a, b, c, d] = [1, 2, 3, 4];

console.log(a); // 1
console.log(b); // 2
```

**Деструктуризация объектов**

```bash
var luke = { occupation: 'jedi', father: 'anakin' };
var occupation = luke.occupation; // 'jedi'
var father = luke.father; // 'anakin'
```

```bash
let luke = { occupation: 'jedi', father: 'anakin' };
let {occupation, father} = luke;

console.log(occupation); // 'jedi'
console.log(father); // 'anakin'
```

## Модули

До `ES6` нам приходилось использовать библиотеки наподобие `Browserify` для создания модулей на клиентской стороне, и `require` в `Node.js`. С `ES6` мы можем прямо использовать модули любых типов (`AMD` и `CommonJS`).

### Экспорт в CommonJS

```bash
module.exports = 1;
module.exports = { foo: 'bar' };
module.exports = ['foo', 'bar'];
module.exports = function bar () {};
```

### Экспорт в ES6

В `ES6` мы можем использовать разные виды экспорта.

**Именованный экспорт:**

```bash
export let name = 'David';
export let age  = 25;
```

**Экспорт списка объектов:**

```bash
function sumTwo(a, b) {
    return a + b;
}

function sumThree(a, b, c) {
    return a + b + c;
}

export { sumTwo, sumThree };
```

Также мы можем экспортировать функции, объекты и значения, просто используя ключевое слово `export`:

```bash
export function sumTwo(a, b) {
    return a + b;
}

export function sumThree(a, b, c) {
    return a + b + c;
}
```

И наконец, можно экспортировать связывания по умолчанию:

```bash
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

> **Лучшая практика**: всегда используйте метод export default в конце модуля. Это чётко покажет, что именно экспортируется, и сэкономит время.

### Импорт в ES6

`ES6` предоставляет различные виды импорта. Мы можем импортировать целый файл:

```bash
import 'underscore';
```

> Важно заметить, что импортирование всего файла приведёт к исполнению всего кода на внешнем уровне этого файла.

Как и в `Python`, есть именованный импорт:

```bash
import { sumTwo, sumThree } from 'math/addition';
```

Который можно переименовывать:

```bash
import {
    sumTwo as addTwoNumbers,
    sumThree as sumThreeNumbers
} from 'math/addition';
```

Кроме того, можно импортировать пространство имён:

```bash
import * as util from 'math/addition';
```

И наконец, список значений из модуля:

```bash
import * as additionUtil from 'math/addition';
const { sumTwo, sumThree } = additionUtil;
```

Импорт из связывания по умолчанию выглядит так:

```bash
import api from 'math/addition';
// Same as: import { default as api } from 'math/addition';
```

Экспортирование лучше упрощать, но иногда можно смешивать импорт по умолчанию с чем-то ещё. Когда мы экспортируем так:

```bash
// foos.js
export { foo as default, foo1, foo2 };
```

Импортировать их можно так:

```bash
import foo, { foo1, foo2 } from 'foos';
```

При импортировании модуля, экспортированного с использованием синтаксиса CommonJS (как в React), можно сделать:

```bash
import React from 'react';
const { Component, PropTypes } = React;
```

Это можно упростить:

```bash
import React, { Component, PropTypes } from 'react';
```

> Примечание: экспортируемые значения — это связывания, не ссылки. Поэтому изменение в одном модуле повлечёт за собой изменение в другом.

## Параметры

В `ES5` было несколько способов обработки функций со значениями по умолчанию, неопределёнными аргументами и именованными параметрами. В `ES6` всё это реализуется, причём с понятным синтаксисом.

**Параметры по умолчанию**

```bash
function addTwoNumbers(x, y) {
    x = x || 0;
    y = y || 0;
    return x + y;
}
```

В `ES6` можно просто указать параметры функции по умолчанию:

```bash
function addTwoNumbers(x=0, y=0) {
    return x + y;
}
```

```bash
addTwoNumbers(2, 4); // 6
addTwoNumbers(2); // 2
addTwoNumbers(); // 0
```

**Остаточные параметры**

В `ES5` неопределённое количество аргументов обрабатывалось так:

```bash
function logArguments() {
    for (var i=0; i < arguments.length; i++) {
        console.log(arguments[i]);
    }
}
```

Используя **остаточный** оператор, можно передавать неопределённое число аргументов:

```bash
function logArguments(...args) {
    for (let arg of args) {
        console.log(arg);
    }
}
```

**Именованные параметры**

Одним из шаблонов `ES5` для работы с именованными параметрами был шаблон `options object`, взятый из `jQuery`.

```bash
function initializeCanvas(options) {
    var height = options.height || 600;
    var width  = options.width  || 400;
    var lineStroke = options.lineStroke || 'black';
}
```

Тоже самое можно получить, используя деструктор в качестве формального параметра функции:

```bash
function initializeCanvas(
    { height=600, width=400, lineStroke='black'}) {
        // Use variables height, width, lineStroke here
    }
```

Если мы хотим сделать всё значение опциональным, можно деструктурировать пустой объект:

```bash
function initializeCanvas(
    { height=600, width=400, lineStroke='black'} = {}) {
        // ...
    }
```

## Оператор расширения

В `ES5` можно было найти максимум массива, используя метод `apply` над `Math.max`:

```bash
Math.max.apply(null, [-1, 100, 9001, -32]); // 9001
```

В `ES6` можно использовать оператор расширения для передачи массива значений в качестве параметров функции:

```bash
Math.max(...[-1, 100, 9001, -32]); // 9001
```

Также можно интуитивно конкатенировать массивы литералов:

```bash
let cities = ['San Francisco', 'Los Angeles'];
let places = ['Miami', ...cities, 'Chicago']; // ['Miami', 'San Francisco', 'Los Angeles', 'Chicago']
```

## Классы

До `ES6` классы нужно было создавать, добавляя к функции-конструктору свойства, расширяя прототип:

```bash
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

```bash
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

```bash
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

```bash
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
