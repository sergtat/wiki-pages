# javascript. полезные функции.
## переключатель: показать/скрыть объект
В этой функции несколько способов, как можно показать/скрыть элементы
```js
function toggleMap(self, id){
    var map = document.getElementById(id);
    if ( map.style.visibility == "hidden" ){ // идёт привяка к состоянию одного элемента, а остальные изменяются
        descr.style["display"] = "";
        map1.innerHTML = "новый контент";
        map.style.visibility = "";
        self.innerHTML = "&uarr";
    } else {
        descr.style["display"] = "none";
        map1.innerHTML = "";
        map.style.visibility = "hidden";
        self.innerHTML = "&darr";
    }
    return false;
}
```
```html
<a href="#" style="text-decoration: none;" onclick="return toggleMap(this, 'map' );">↑</a>
<div id="map"></div>
```

## экранирование спец-символов html
```js
function htmlspecialchars(text)
{
   var chars = Array("&", "<", ">", '"', "'");
   var replacements = Array("&", "<", ">", """, "'");
   for (var i=0; i<chars.length; i++)
   {
       var re = new RegExp(chars[i], "gi");
       if(re.test(text))
       {
           text = text.replace(re, replacements[i]);
       }
   }
   return text;
}
```

## форма в полупрозрачном модальном окне
```html
<div id="a" style="position: absolute; display: none; z-index: 1; width: 100%; height: 100%;">
<div style="position: absolute; opacity: 0.5, background-color: grey; width: 100%; height: 100%;"> </div>
<form>
.....
</form>
</div>
<button onclick="$('#a').css({display: "block"})"></button>
```
	
## drag&drop сортировка
```html
<div id="main">
    <div class="menu_item">1</div>
    <div class="menu_item">2</div>
    <div class="menu_item">3</div>
    <div class="menu_item">4</div>
    <div class="menu_item">5</div>
</div>
```
```js
<script type="text/javascript">
var mainDiv = document.getElementById( "main" )
mainDiv.insertAfter = function(node, referenceNode){
    document.getElementById( "main" ).insertBefore(node, referenceNode.nextSibling);
}
var ch = mainDiv.childNodes;
var startItem = null;
var startY;
for (i=0; i< ch.length; i++){
    obj = ch.item(i)
    obj.onmousedown = function(e){
        startItem = this;
        startY = e.pageY;
    }
    obj.onmouseup = function(e){
        if (e.pageY > startY){
            mainDiv.insertAfter(startItem,this);
        } else {
            mainDiv.insertBefore(startItem,this);
        }
    }
}
</script>
```

## setBackgroundByScreenWidth
```js
function setBackgroundByScreenWidth(obj){
    var width = window.screen.width;
    var path = "img/";
    var pictures = [ "800.jpg", "1024.jpg", "1280.jpg", "1440.jpg" ];
    var widths = [800, 1024, 1280, 1440];


    var variant = 0;
    for (i=0; i<widths.length; i++){
        if (width > widths[i]){
            variant++;
        }   
    }

    obj.style.backgroundImage = "url(" + path + pictures[variant] + ")";
    obj.style.backgroundRepeat = "no-repeat";
}
```

## определить положение объекта
```js
        function getAbsPos(p) {
                var s = { x:0, y:0 };
                while (p.offsetParent) {
                        s.x += p.offsetLeft;
                        s.y += p.offsetTop;
                        p = p.offsetParent;
                }
                return s;
        }
        var pos = getAbsPos(document.getElementById('box'));
            alert( pos.y + ' ' + pos.x);
```

## определить посещённые страницы
браузер выделяет ссылки, которые были посещены и javascript умеет определять это по объекту-ссылке

## сумма прописью (с копейками)
```html
<div id="aa"></div>
```

```js
<script language="JavaScript" type="text/javascript">
var money;
var price;
var rub, kop;
var litera = sotny = desatky = edinicy = minus = "";
var k = 0, i, j;

N = ["", "один", "два", "три", "четыре", "пять", "шесть", "семь", "восемь", "девять",
"", "одиннадцать", "двенадцать", "тринадцать", "четырнадцать", "пятнадцать", "шестнадцать", "семнадцать", "восемнадцать", "девятнадцать",
"", "десять", "двадцать", "тридцать", "сорок", "пятьдесят", "шестьдесят", "семьдесят", "восемьдесят", "девяносто",
"", "сто", "двести", "триста", "четыреста", "пятьсот", "шестьсот", "семьсот", "восемьсот", "девятьсот",
"тысяч", "тысяча", "тысячи", "тысячи", "тысячи", "тысяч", "тысяч", "тысяч", "тысяч", "тысяч",
"миллионов","миллион","миллиона","миллиона", "миллиона", "миллионов", "миллионов", "миллионов", "миллионов", "миллионов",
"миллиардов", "миллиард", "миллиарда", "миллиарда", "миллиарда", "миллиардов", "миллиардов", "миллиардов", "миллиардов", "миллиардов"];

var M = new Array(10);
for (j = 0; j < 10; ++j)
  M[j] = new Array(N.length);

for (i = 0; i < N.length; i++)
  for (j = 0; j < 10; j++)
    M[j][i] = N[k++]

var R = new Array("рублей", "рубль", "рубля", "рубля", "рубля", "рублей", "рублей", "рублей", "рублей", "рублей");
var K = new Array("копеек", "копейка", "копейки", "копейки", "копейки", "копеек", "копеек", "копеек", "копеек", "копеек");

function num2str(money, target)
{
  rub = "", kop = "";
  money = money.replace(",", ".");

  if(isNaN(money)) {document.getElementById(target).innerHTML = "Не числовое значение"; return}
  if(money.substr(0, 1) == "-") {money = money.substr(1); minus = "минус "}
   else minus = "";
  money = Math.round(money * 100) / 100 + "";

  if(money.indexOf(".") != -1)
    {
     rub = money.substr(0, money.indexOf("."));
     kop = money.substr(money.indexOf(".") + 1);
     if(kop.length == 1) kop += "0";
    }
  else rub = money;

  if(rub.length > 12) {document.getElementById(target).innerHTML = "Слишком большое число"; return}

  ru = propis(price = rub, R);
  ko = propis(price = kop, K);
  ko != "" ? res = ru + " " + ko: res = ru;
  ru == "Ноль " + R[0] && ko != ""? res = ko: 0;
  kop == 0? res += " ноль " + K[0]: 0;
  document.getElementById(target).innerHTML = (minus + res).substr(0,1).toUpperCase() + (minus + res).substr(1);
}

function propis(price, D)
{
  litera = "";
  for(i = 0; i < price.length; i += 3)
    {
     sotny = desatky = edinicy = "";
     if(n(i + 2, 2) > 10 && n(i + 2, 2) < 20)
       {
        edinicy = " " + M[n(i + 1, 1)][1] + " " + M[0][i / 3 + 3];
        i == 0? edinicy += D[0]: 0;
       }
     else
       {
        edinicy = M[n(i + 1, 1)][0];
        (edinicy == "один" && (i == 3 || D == K))? edinicy = "одна": 0;
        (edinicy == "два"  && (i == 3 || D == K))? edinicy = "две" : 0;
        i == 0 && edinicy != ""? 0: edinicy += " " + M[n(i + 1, 1)][i / 3 + 3];
        edinicy == " "? edinicy = "": (edinicy == " " + M[n(i + 1, 1)][i / 3 + 3])? 0: edinicy = " " + edinicy;
        i == 0? edinicy += " " + D[n(i + 1, 1)]: 0;
        (desatky = M[n(i + 2, 1)][2]) != ""? desatky = " " + desatky: 0;
       }
     (sotny = M[n(i + 3, 1)][3]) != ""? sotny = " " + sotny: 0;
     if(price.substr(price.length - i - 3, 3) == "000" && edinicy == " " + M[0][i / 3 + 3]) edinicy = "";
     litera = sotny + desatky + edinicy + litera;
    }
   if(litera == " " + R[0]) return "ноль" + litera;
     else return litera.substr(1);
}

function n(start,len)
{
  if(start > price.length) return 0;
    else return Number(price.substr(price.length - start, len));
}
num2str("3", "aa");
</script>
```

## Отправить форму в несколько окон (родительское/дочерние)
```js
<script type="text/javascript">
function mySubmit( myform ){
         window.open( '', 'blank', 'height=400,width=600,toolbar=no');
         myform.submit(); // отправляем в дочернее окно (определяется через target у формы)
         document.getElementById( 'task' ).value = 'save';
         myform.target = '_self'; // меняем target на текущее окно
         myform.submit();
         return true;
}
</script>
```
```html
<button style="width: 193px; height: 25px" onclick="mySubmit(this.form);">Сформировать счет</button>
```

## Иерархические указатели
### parentHi
```js
function parentHi(str){ return str.substring( 0, str.lastIndexOf('.')); }
```

### buildTreeByHi
```js
function buildTreeByHi( list ){
    var res = {};
    res[list[0][0]] = {
            hi: list[0][0],
            header: list[0][1],
            items: []
    }
    var item;
    for ( i=1; i<list.length; i++ ){
            item = list[i];
            res[item[0]] = {
                    hi: item[0],
                    header: item[1],
                    items: []
            };
            res[parentHi(item[0])].items.push(res[item[0]]);
    }
    return res;
}
```
	

## Проверка пароля на сложность
```js
function testPassword( value ){
    var p = 100; // пусть у нас пароль 100% сложности
    
    var minusWords = ['admin', 'invoice']; // выкидываем из пароля при оценке сложности
    for (var i=0; i<minusWords.length; i++){
            value = value.replace( new RegExp(minusWords[i], 'gi'), minusWords[i][0] );
    }
    var nearCount = 0;
    if (value.length>1){
            // находим количество букв, находящиеся рядом на клавиатуре:
            var keyboardMap = [ // карта клавиатуры, чтобы пользователь не набирал последовательных букв
                    '1234567890',
                    'qwertyuiop',
                    'asdfghjkl',
                    'zxcvbnm',
                    // '1qaz',
                    // '2wsx',
                    // '3edc',
                    // '4rfv',
                    // '5tgb',
                    // '6yhn',
                    // '7ujm',
                    // '8ik',
                    // '9ol'
            ];
            var l = keyboardMap.length;
            for (var i=0; i<l; i++){ // добавляем перевёрнутые строки
                    keyboardMap.push(keyboardMap[i].split('').reverse().join(''));
            }
            var c;
            for (var i=1; i<value.length; i++){
                    if (value[i-1] == value[i]){
                            nearCount++;
                            continue;
                    }
                    c = value[i-1] + value[i];
                    for (var j=0; j<keyboardMap.length; j++){
                            if ( !/^\w+$/.test(c) ) continue;
                            if ( new RegExp( c, 'gi').test( keyboardMap[j] ) ){ // мы нашли два последовательных символа
                                    nearCount++;
                                    break;
                            }
                    }
            }
    }


    var charsLength = value.length - nearCount*0.9;
    // начисляем коэффициент за количество символов            
    if ( charsLength < 2){
            p = 0;
    } else if (charsLength < 8) {
            p = p * Math.pow(
                    (charsLength-1.7)/6,
                    1.4 // степень определяет вогнутость степенной функции
            );
    } else {
            p = p * Math.pow( 1.03, charsLength - 8 ); // бонус за количество символов
    }
    
    if ( /^[A-z]+$/.test(value) ){ // пароль состоит только из букв
            p = p * 0.8;
    } else if ( /^\d+$/.test(value) ){ // пароль состоит только из цифр
            p = p * 0.6;
    }
    if ( !/[a-z]/.test(value) ){ // не содержит строчных букв
            p = p * 0.9;
    }
    if ( !/[A-Z]/.test(value) ){ // не содержит заглавных букв
            p = p * 0.9;
    }
    if ( /[~@#$%^&*-+_=/|\\,.;:?!`'"<>{}\[\]]/.test(value)){
            var n;
            var specChars = "~@#$%^&*-+_=/|\,.;:?!`'\"<>{}[]".split('');
            for ( var i=0; i<value.length; i++){
                    n = specChars.indexOf(value[i]);
                    if ( n > -1 ){
                            specChars.splice(n, 1);
                            p = p * 1.05; // повышающих коэффициент за использование спец-символа
                    }
            }
    } else { // пароль не содержит спец-символов
            p = p * 0.9;
    }
    return p;
}
```
## Дата модификации документа
```js
 <script language="JavaScript">
<!--

document.write ("Дата последней модификации: " + document.lastModified);

//-->
</script>
```
Дата выводится в формате, соответствующем региональным настройкам компьютера, а это не всегда нам подходит.
```js
<script language="JavaScript">
<!--

LastDate = new Date(document.lastModified);

LastDay = LastDate.getDate(); // Считываем число
LastMonth = LastDate.getMonth(); // Считываем месяц
LastYear = LastDate.getYear(); // Считываем год

LastYear = LastYear % 100;
LastYear = ((LastYear < 50) ? (2000 + LastYear) : (1900 + LastYear));

document.write ("Дата последней модификации: ", LastDay, "/", LastMonth+1, "/", LastYear);

//-->
</script> 
```

## Как сделать страничку стартовой?
```html
<p><a href="#" onClick="this.style.behavior='url(#default#homepage)'; this.setHomePage('http://www.yoursite.com/'); return false;">Сделать стартовой страницей</a></p>
```

## Добавление странички в "Избранное".
```html
<p><a href="#" onClick="window.external.addFavorite('http://www.yoursite.com/', 'Description'); return false;">Добавить сайт в Избранное</a></p>
```

## Распечатка страницы из кода.
```js
<script language="JavaScript">
<!--

var browser_name = navigator.appName;

function printit() {

    if (browser_name == "Netscape") {
        window.print();
    } else {
        var WebBrowser = '<object id="WebBrowser1" width=0 height=0
        classid="clsid:8856F961-340A-11D0-A96B-00C04FD705A2"></object>';
        document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
        WebBrowser1.ExecWB(6, 2);
    }
}

//-->
</script>
```
```html
<a href="#" onClick="printit();">Распечатать статью</a>
```
Только не путайте этот скрипт с версиями страничек "для распечатки". Страничка для распечатки - это обычный html-файл, из которого убрали дизайнерское оформление и оставили очень простую вёрстку, чтобы при печати не было лишних элементов. Приведённый же выше код непосредственно посылает страничку на принтер.
