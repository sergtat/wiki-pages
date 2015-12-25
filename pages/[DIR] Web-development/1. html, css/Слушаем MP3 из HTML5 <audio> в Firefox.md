#  Слушаем MP3 из HTML5 <audio> в Firefox
Вовсе нет! Вспоминаем про старые добрые незаслуженно забытые теги EMBED и OBJECT, которые позволяли играть всё, что умеют играть плагины браузера. А уж об этом может позаботиться и Totem plugin, и VLC plugin, и все-все-все.
```
audio=document.getElementsByTagName("audio")[0].getAttribute("src"); // берём ссылку на музыку
player=document.createElement("object"); // создаём object
player.setAttribute("width",300); // обязательно указываем размер!
player.setAttribute("height",50); // иначе VLC plugin роняет браузер, пытаясь рисовать картинку в никуда
player.setAttribute("type","audio/mpeg"); // чтобы браузер запустил правильный плагин, подробнее см. about:plugins
player.setAttribute("src",audio); // ну и, собственно, ссылка на музыку
// id "queue-header" заменить на подходящий существующий в коде страницы
// можно найти при помощи ПКМ -> "Исследовать элемент"
document.getElementById("queue-header").appendChild(player); // let's rock!
```
Выполняем этот код в веб-консоли, и на странице появляется плеер, который таки начинает играть музыку.