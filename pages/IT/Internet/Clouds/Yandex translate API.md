# Yandex translate API
Пример использования Yandex translate API:

```javascript
function translate(text, sl, tl, success){
  $.ajax({
    url: 'http://translate.yandex.ru/tr.json/translate?srv=tr-text&id=812c6278-0-0&reason=auto',
    dataType: 'jsonp',
    data: {
      text: text, // text to translate
      lang: sl+'-'+tl
      },success: function(result) {
        success(result);
        },error: function(XMLHttpRequest, errorMsg, errorThrown) {
          alert(errorMsg); } }); }
// Пример
translate("test", 'en','ru', function(response){
alert(response); });
```
Работающий пример использования API переводчика
[здесь](http://sanstv.ru/tools/translate).
