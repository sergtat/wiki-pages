# JavaScript модули. Руководство для начинающих.
![JavaScript модули. Руководство для начинающих](/images/Webd/js.png 'JavaScript модули. Руководство для начинающих')

Если вы новичок в JavaScript, то такой жаргон как «modle bundlers vs. module loaders», «Webpack vs. Browserify» и «AMD vs. CommonJS» может поставить вас в тупик.

Система модулей в JavaScript может быть пугающей, но её понимание жизненно важно для разработчиков.

В этой статье я постараюсь объяснить всё простыми словами (с несколькими примерами кода). Надеюсь, что для вас эта статья окажется полезной.

> Примечание: Для удобства статья будет разделена на две части. В первой части мы рассмотрим, что такое модули и почему мы их используем. Во второй части мы рассмотрим различные способы объединения модулей в единое целое. 

## Кто-нибудь объясните, что такое модули ещё раз?

_**Хорошие авторы делят свои книги на разделы и главы. Хорошие программисты делят свои программы на модули.**_

Также как и главы книги, модули это просто кластеры слов (или кода, в зависимости от обстоятельств).

Хорошие модули обладают самодостаточными функциональными возможностями, поэтому они могут быть добавлены, перемещены или удалены по мере необходимости, не нарушив всю систему.

## Зачем вообще использовать модули?

На самом деле у модулей есть много преимуществ. Наиболее важными, на мой взгляд, являются следующие:

1. **Удобная поддержка (Maintainability)**: По определению, модуль является самодостаточным. Хорошо спроектированный модуль призван уменьшить зависимости частей вашей кодовой базы насколько это возможно, чтобы она могла расти и совершенствоваться не зависимо друг от друга. Обновить один модуль гораздо проще, когда он отделён от других частей кода.Возвращаясь к нашей книге, например, если вы захотите внести небольшое изменение в одну главу и это повлечёт за собой изменения какого-то другого раздела вашей книги, это будет кошмар. Поэтому главу нужно писать так, чтобы при внесении правок, не пришлось затрагивать другие главы.
2. **Пространства имён (Namespacing)**: В JavaScript переменные которые находятся за пределами функций верхнего уровня считаются глобальными (каждый может получить к ним доступ). Поэтому очень распространено «Загрязнение пространства имён (namespace pollution)», где совершенно не связанный между собой код, связывают глобальные переменные.Совместное использование глобальных переменных в коде, который между собой не связан [очень плохо в разработке](http://c2.com/cgi/wiki?GlobalVariablesAreBad). Дальше в этой статье мы увидим, что модули позволяют избежать загрязнения глобального пространства имён, путём создания приватных пространств для наших переменных.
3. **Повторное использование (Reusability)**: Давайте будем честными. Все мы копировали код в новые проекты, который писали раньше. Например, давайте представим, что вы скопировали в новый проект некоторые вспомогательные методы из предыдущего проекта.Хорошо, но если вы найдете наиболее хороший способ написать эту часть, вам придётся вспомнить все места где фигурировал этот код чтобы обновить его.Это безусловно огромная трата времени. Намного проще было бы написать модуль и использовать его повторно снова и снова.

## Как можно интегрировать модули?

Есть много способов интегрировать модули в свои программы. Давайте рассмотрим некоторые из них:

### Паттерн «Модуль»

Паттерн «Модуль» используется для имитации концепции классов (так как изначально JavaScript не поддерживал классы), поэтому мы можем хранить публичные и приватные методы (переменные) внутри одного объекта так, как делается это в классах других языков, таких как Java или Python. Это позволяет нам создать публичный API и предоставить возможность обращаться к публичным методам, в то время как приватные переменные и методы инкапсулированы в замыкании.

Есть несколько способов реализации паттерна «Модуль». В первом примере я буду использовать анонимные замыкания. Помещение кода в анонимную функцию поможет нам достичь цели. (**Помните, что в JavaScript функции — это единственный способ чтобы создать новую область видимости**).

**Пример 1: Анонимные замыкания**

```javascript
(function () {
  // We keep these variables private inside this closure scope

  var myGrades = [93, 95, 88, 0, 55, 91];

  var average = function() {
    var total = myGrades.reduce(function(accumulator, item) {
      return accumulator + item}, 0);

      return 'Your average grade is ' + total / myGrades.length + '.';
  }

  var failing = function(){
    var failingGrades = myGrades.filter(function(item) {
      return item < 70;});

    return 'You failed ' + failingGrades.length + ' times.';
  }

  console.log(failing());

}());
```

Таким образом, у нашей анонимной функции есть своя область видимости или «замыкание» и мы можем сразу её выполнить. Такой способ позволяет нам скрыть переменные из родительской (глобальной) области видимости.

Что действительно хорошо в таком подходе, дак это то что вы можете использовать локальные переменные внутри этой функции и не бояться случайно перезаписать глобальные переменные с таким же именем. Но доступ к глобальным переменным у вас по прежнему остаётся, например так:

```javascript
var global = 'Hello, I am a global variable :)';

(function () {
  // We keep these variables private inside this closure scope

  var myGrades = [93, 95, 88, 0, 55, 91];

  var average = function() {
    var total = myGrades.reduce(function(accumulator, item) {
      return accumulator + item}, 0);

    return 'Your average grade is ' + total / myGrades.length + '.';
  }

  var failing = function(){
    var failingGrades = myGrades.filter(function(item) {
      return item < 70;});

    return 'You failed ' + failingGrades.length + ' times.';
  }

  console.log(failing());
  console.log(global);
}());

// 'You failed 2 times.'
// 'Hello, I am a global variable :)'
```

Обратите внимание, что круглые скобки вокруг анонимной функции обязательны, потому что инструкция, которая начинается с ключевого слова function всегда считается объявлением функции (помните, что в JavaScript нельзя объявлять функции без имени). Следовательно окружающие инструкцию скобки, вызывают функцию вместо её объявления. Если вам интересно то больше вы сможете [прочитать здесь](http://stackoverflow.com/questions/1634268/explain-javascripts-encapsulated-anonymous-function-syntax).

### Пример 2: Глобальный импорт

Другим популярным подходом, который используют библиотеки такие как jQuery, является глобальный импорт. Он похож на замыкания, которые мы только что видели, только теперь мы передаём глобальные переменные в качестве параметров.

```javascript
(function (globalVariable) {

  // Keep this variables private inside this closure scope
  var privateFunction = function() {
    console.log('Shhhh, this is private!');
  }

  // Expose the below methods via the globalVariable interface while
  // hiding the implementation of the method within the 
  // function() block

  globalVariable.each = function(collection, iterator) {
    if (Array.isArray(collection)) {
      for (var i = 0; i < collection.length; i++) {
        iterator(collection[i], i, collection);
      }
    } else {
      for (var key in collection) {
        iterator(collection[key], key, collection);
      }
    }
  };

  globalVariable.filter = function(collection, test) {
    var filtered = [];
    globalVariable.each(collection, function(item) {
      if (test(item)) {
        filtered.push(item);
      }
    });
    return filtered;
  };

  globalVariable.map = function(collection, iterator) {
    var mapped = [];
    globalUtils.each(collection, function(value, key, collection) {
      mapped.push(iterator(value));
    });
    return mapped;
  };

  globalVariable.reduce = function(collection, iterator, accumulator) {
    var startingValueMissing = accumulator === undefined;

    globalVariable.each(collection, function(item) {
      if(startingValueMissing) {
        accumulator = item;
        startingValueMissing = false;
      } else {
        accumulator = iterator(accumulator, item);
      }
    });

    return accumulator;

  };

}(globalVariable));
```

В этом примере GlobalVariable единственная глобальная переменная. Преимущество такого подхода в том, что все глобальные переменные вы объявляете заранее, что делает ваш код прозрачным для остальных.

### Пример 3: Объектный интерфейс

Ещё один подход при создании модулей заключается в использовании автономных, объектных интерфейсов, например так:

```javascript
var myGradesCalculate = (function () {

  // Keep this variable private inside this closure scope
  var myGrades = [93, 95, 88, 0, 55, 91];

  // Expose these functions via an interface while hiding
  // the implementation of the module within the function() block

  return {
    average: function() {
      var total = myGrades.reduce(function(accumulator, item) {
        return accumulator + item;
        }, 0);

      return'Your average grade is ' + total / myGrades.length + '.';
    },

    failing: function() {
      var failingGrades = myGrades.filter(function(item) {
          return item < 70;
        });

      return 'You failed ' + failingGrades.length + ' times.';
    }
  }
})();

myGradesCalculate.failing(); // 'You failed 2 times.' 
myGradesCalculate.average(); // 'Your average grade is 70.33333333333333.'
```

Как вы могли заметить, такой подход позволяет решать какие переменные (методы) мы хотим сделать приватными (например, myGrades), а какие публичными поместив их в возвращаемый объект (например, average и failing).

### Пример 4: Паттерн «Раскрывающийся модуль»

Этот пример очень похож на предыдущий за исключением того, что все методы и переменные остаются приватными, пока их явно раскроют.

```javascript
var myGradesCalculate = (function () {

  // Keep this variable private inside this closure scope
  var myGrades = [93, 95, 88, 0, 55, 91];

  var average = function() {
    var total = myGrades.reduce(function(accumulator, item) {
      return accumulator + item;
      }, 0);

    return'Your average grade is ' + total / myGrades.length + '.';
  };

  var failing = function() {
    var failingGrades = myGrades.filter(function(item) {
        return item < 70;
      });

    return 'You failed ' + failingGrades.length + ' times.';
  };

  // Explicitly reveal public pointers to the private functions 
  // that we want to reveal publicly

  return {
    average: average,
    failing: failing
  }
})();

myGradesCalculate.failing(); // 'You failed 2 times.' 
myGradesCalculate.average(); // 'Your average grade is 70.33333333333333.'
```

Это может показаться большим объёмом информации, но это только верхушка айсберга, когда дело доходит до паттернов модулей. Вот некоторые полезные ресурсы, которые нашёл проводя свои исследования:

- [Learning JavaScript Design Patterns](https://addyosmani.com/resources/essentialjsdesignpatterns/book/#modulepatternjavascript) от Addy Osmani: это клад с деталями и выразительно кратким содержанием;
- [Adequately Good](http://www.adequatelygood.com/JavaScript-Module-Pattern-In-Depth.html) by Ben Cherry: полезный обзор с примерам расширенного использования паттерна «Модуль»;
- [Blog of Carl Danley](https://carldanley.com/js-module-pattern/): обзор паттерна «Модуль» и ресурсы для других JavaScript паттернов;

## CommonJS и AMD

У всех перечисленных выше подходов есть одно общее свойство: они все создают одну глобальную переменную, в которую помещают код функции, создавая тем самым приватное пространство имён и используют область видимости замыкания.

Хоть каждый из этих подходов и эффективен по своему, у них есть и свои недостатки.

Вы как разработчик должны знать правильный порядок загрузки файлов. Например, предположим, что вы используете Backbone в своём проекте, поэтому вы подключаете скрипт Backbone’а через тег в своём файле. Так как Backbone напрямую зависит от Underscore.js, вы не можете подключить скрипт Backbone.js перед Underscore.js.

Управление зависимостями для разработчика иногда доставляет головную боль.

Другой недостаток заключается в том, что всё ещё может произойти конфликт пространств имён. Например, у вас может быть два модуля с одинаковыми именами или две версии одного модуля и они обе вам нужны.

Исходя из этого возникает интересный вопрос: можем ли мы обращаться к интерфейсу модуля не через глобальную область видимости?

К счастью, ответ да.

**Есть два популярных и хорошо реализованных подхода: CommonJS и AMD.**

### CommonJS

CommonJS — это добровольная группа разработчиков, которая проектируют и реализует JavaScript API для объявления модулей.

Модуль CommonJS — это фрагмент JavaScript кода предназначенный для многократного использования. Он экспортирует специальные объекты, делая их доступными для других модулей, чтобы они могли включать их в свои зависимости. Если вы программировали на Node.js, то вам это будет очень хорошо знакомо.

С CommonJS в каждом JavaScript файле модуль хранится в своём собственном уникальном контексте (так же, как и в замыканиях). В этом пространстве мы используем объект module.exports чтобы экспортировать модули, и require чтобы подключить их.

Определение CommonJS модуля может выглядеть следующим образом:

```javascript
function myModule() {
  this.hello = function() {
    return 'hello!';
  }

  this.goodbye = function() {
    return 'goodbye!';
  }
}

module.exports = myModule;
```

Мы используем специальный объект module и размещаем ссылку на нашу функцию в module.exports. За счёт этого CommonJS знает, что мы хотим открыть модуль так, чтобы другие файлы могли его использовать.

После этого, когда кто-то захочет использовать наш myModule, он без проблем Тсможет его подключить следующим образом:

```javascript
var myModule = require('myModule');

var myModuleInstance = new myModule();
myModuleInstance.hello(); // 'hello!'
myModuleInstance.goodbye(); // 'goodbye!'
```

У данного подхода есть два очевидных преимущества над подходами, которые мы обсуждали раньше:

1. Отсутствие загрязнения глобального пространства имён;
2. Становление наших зависимостей более явными;

Кроме того, очень компактный синтаксис, я это очень люблю.

Нужно отметить, что CommonJS использует server-first подход и модули загружаются синхронно. Это важно потому что если у нас есть ещё три модуля, которые нам нужно подключить, он будет загружать их один за другим.

Сейчас это прекрасно работает на сервере, но к сожалению, это затрудняет написание браузерного JavaScript. На получение модуля из интернета уходит намного больше времени, чем на получение модуля с жёсткого диска. Пока скрипт загружает модуль, браузер блокируется и вы ничего не можете сделать, до тех пор, пока он не закончит загрузку. Он ведёт себя так потому что JavaScript поток останавливается, пока загружается код (Я расскажу вам как мы может обойти эту проблему во второй части статьи, когда мы будем рассматривать сборку модулей. На данный момент это всё, что нам нужно знать).

### AMD

CommonJS хорош, но что если нам нужно загружать модули асинхронно? Ответ на этот вопрос «Асинхронное определение модулей (Asynchronous Module Definition)» или просто AMD.

Загрузка модулей с помощью AMD выглядит примерно так:

```javascript
define(['myModule', 'myOtherModule'], function(myModule, myOtherModule) {
  console.log(myModule.hello());
});
```

Функция определения модуля принимает первым аргументом массив зависимостей. Эти зависимости загружаются в фоновом (не блокирующим) режиме и вызывают функцию обратного вызова, которая была передана вторым аргументом.

Далее, функция обратного вызова в качестве аргументов принимает уже загруженные зависимости, и позволяет использовать их. И наконец сами зависимости тоже должны быть определены с помощью ключевого слова define.

Например, myModule может выглядеть следующим образом:

```javascript
define([], function() {

  return {
    hello: function() {
      console.log('hello');
    },
    goodbye: function() {
      console.log('goodbye');
    }
  };
});
```

Итак, давайте пройдёмся ещё раз. В отличии от CommonJS, AMD реализует browser-first подход вместе с асинхронным поведением (Обратите внимание, что достаточно много людей утверждают, что динамическая загрузка файлов не благоприятна при выполнении вашего кода. Об этом мы поговорим больше в следующей части нашей статьи, посвящённой сборке модулей).

Кроме асинхронности, у AMD есть ещё одно преимущество. AMD модули могут быть функциями, конструкторами, строками, JSON’ом и другими типами, в то время как CommonJS в качестве модулей поддерживает только объекты.

Из минусов, AMD не совместим с io, файловой системой и другими серверно-ориентированными особенностями, которые доступны через CommonJS. И синтаксис функции объявления модулей многословен в сравнении с просты require.

## UMD

Для проектов, которые требуют поддержки функций обеих систем AMD и CommonJS, есть ещё один формат. Универсальное Объявление Модулей (Universal Module Definition), ну или по простому UMD.

По существу, UMD предоставляет возможность использование любого из двух вышеперечисленных способов, плюс поддерживает определение модулей через глобальную переменную. В результате, модули UMD могут работать как на клиенте, так и на сервере.

Быстрый пример того, как работает UMD:

```javascript
(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
      // AMD
    define(['myModule', 'myOtherModule'], factory);
  } else if (typeof exports === 'object') {
      // CommonJS
    module.exports = factory(require('myModule'), require('myOtherModule'));
  } else {
    // Browser globals (Note: root is window)
    root.returnExports = factory(root.myModule, root.myOtherModule);
  }
}(this, function (myModule, myOtherModule) {
  // Methods
  function notHelloOrGoodbye(){}; // A private method
  function hello(){}; // A public method because it's returned (see below)
  function goodbye(){}; // A public method because it's returned (see below)

  // Exposed public methods
  return {
      hello: hello,
      goodbye: goodbye
  }
}));
```

Дополнительные примеры UMD, можно посмотреть в [этом GitHub репозитории](https://github.com/umdjs/umd).

## Нативный JS

Фууух. Вы ещё рядом? Я не потерял вас в этом лесу? Хорошо! Потому что у нас есть ещё один тип определения модулей.

Как вы могли заметить выше, ни один из модулей не был родным для JavaScript. Вместо этого мы имитировали систему модулей, используя либо паттерн «Модуль», либо CommonJS, либо AMD.

К счастью умные люди из TC39 (the standards body that defines the syntax and semantics of ECMAScript) добавили встроенные модули в ECMAScript 6 (ES6).

ES6 предлагает разнообразные возможности для импорта и экспорта модулей, про которые рассказывали не один раз. Вот парочка ресурсов:

- [jsmodules.io](http://jsmodules.io/cjs.html)
- [exploringjs.com](http://exploringjs.com/es6/ch_modules.html)

Что хорошего в ES6 модулях в сравнении с CommonJS и AMD? То, что он собрал лучшее из двух миров: компактность, декларативный синтаксис, асинхронную загрузку, плюс дополнительные преимущества, такие как циклические зависимости.

Вероятно, моя любимая особенность ES6 модулей заключается в том, что импорты это живые read-only виды экспортов (в сравнении с CommonJS, где импорт это просто копия экспорта).

Вот пример того, как это работает:

```javascript
// lib/counter.js

var counter = 1;

function increment() {
  counter++;
}

function decrement() {
  counter--;
}

module.exports = {
  counter: counter,
  increment: increment,
  decrement: decrement
};


// src/main.js

var counter = require('../../lib/counter');

counter.increment();
console.log(counter.counter); // 1
```

В этом примере мы сделали две копии базового модуля: первый раз когда экспортировали его, а второй раз когда импортировали.

Кроме того, копия которая находится в main.js теперь отключена от оригинального модуля. Поэтому, даже когда мы увеличиваем наш счётчик, он всё равно возвращает 1, так как counter — это переменная которую мы импортировали из модуля, отключённая от оригинального модуля.

Таким образом, увеличение счётчика будет увеличивать его в модуле, но не будет увеличивать в скопированной версии. Единственный способ изменить скопированную версию, это увеличить её вручную:

```javascript
counter.counter++;
console.log(counter.counter); // 2
```

А, ES6 при импорте создает живой read-only вид модуля:

```javascript
// lib/counter.js
export let counter = 1;

export function increment() {
  counter++;
}

export function decrement() {
  counter--;
}


// src/main.js
import * as counter from '../../counter';

console.log(counter.counter); // 1
counter.increment();
console.log(counter.counter); // 2
```

Интересно, не правда ли? Что я нахожу действительно убедительным в живых read-only видах, дак это то, что они позволяют разделить ваши модули на более мелкие куски без потери функциональности.

Вы можете развернуть и объединить их заново (в новом проекте), и никаких проблем. Всё будет работать.

## Немного заглядывая вперёд: Сборка модулей

Вау! Как быстро пролетело время. Это было крутое путешествие и я искренне надеюсь, что статья дала вам возможность лучше понять модули в JavaScript.

В следующей статье мы рассмотрим связывание модулей, затронем основные темы, включая:

- Почему мы собираем модули;
- Различные подходы к сборке;
- API загрузчика модулей ECMAScript;
- И ещё много всего…

**Источник**: http://blog.zacorp.ru
