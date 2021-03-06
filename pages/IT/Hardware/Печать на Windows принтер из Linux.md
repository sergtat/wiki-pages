# Печать на Windows принтер из Linux.
В этой статье я опишу настройку сервера печати LPD на Windows и последующую установку принтера на Linux.

На ПК с Windows, нужно открыть общий доступ к принтеру. Заходим в свойства принтера, и на вкладке Доступ, активируем опцию - Общий доступ к данному принтеру, с присвоением ему простого сетевого имени без пробелов и спецсимволов. В данном примере сетевое имя нашего принтера - AdminsPrint (выбирал не я:).

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_001.png 'Печать на Windows принтер из Linux')

Далее, нужно установить компонент Windows, отвечающий за сетевую печать с Unix-like ОС. Пуск -> Панель управления -> Установка и удаление программ -> Установка компонентов Windows -> Другие службы доступа к файлам и принтерам в сети -> Состав -> Службы печати для Unix, ставим галочку и применяем. Система потребует у вас предоставить компакт диск с Windows, либо указать месторасположение установочных файлов Windows на жёстком диске или в сети.

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_002.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_003.png 'Печать на Windows принтер из Linux')

Теперь нужно активировать сервер LPD и сделать его загрузку автоматической при старте операционной системы. Пуск -> Панель управления ->Администрирование -> Службы -> Сервер печати TCP/IP -> Пуск и там же сменить значение опции Тип запуска на Авто.

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_004.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_005.png 'Печать на Windows принтер из Linux')

Если у вас установлен файерволл, то нужно открыть в нём доступ к TCP порту 515, через который и работает LPD. На этом настройка Windows сервера для печати из Linux, завершена!

На ПК с Linux, осталось только установить этот принтер по LPD, любым удобным вам способом, в зависимости от используемой в вашем дистрибутиве утилиты для управления принтерами, либо воспользоваться универсальным для всех дистрибутивов методом установки принтера через веб-интерфейс CUPS. Я опишу как стандартный для Xubuntu метод установки принтера с помощью утилиты system-config-printer, так и метод установки принтера через веб-интерфейс CUPS.

Самый важный момент при установке принтера, это правильно указать его URI. В нашем случае, URI принтера имеет следующий вид:

    lpd://10.2.2.1/AdminsPrint

Где,

- lpd:// - используемый протокол печати;
- 10.2.2.1 - IP адрес Windows ПК, на котором установлен принтер;
- AdminsPrint - сетевое имя принтера (очереди) на данном ПК.

Итак, установка принтера с помощью утилиты system-config-printer:

В консоли, выполняем команду system-config-printer, либо Меню приложений -> Диспетчер настроек -> Оборудование -> Принтеры. В меню Сервер -> Новый -> Принтер. Введите адрес (URI), в нашем случае, это

     lpd://10.2.2.1/AdminsPrint

Далее, выбираем драйвер, указываем любое, понятное вам имя принтера, распечатываем тестовую страницу. Всё, принтер установлен и печатает.

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_006.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_007.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_008.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_009.png 'Печать на Windows принтер из Linux')

Альтернативный метод установки принтера - установка принтера через веб-интерфейс CUPS, работает в любом дистрибутиве Linux. Запускаем любой браузер (на скринах Firefox) и переходим к адресу:

    http://localhost:631/

Вкладка Administration -> Printers -> Add Printer. Авторизуемся под пользователем root. Выбираем опцию LPD/LPR Host or Printer-> Continue, в поле Connection вводим URI нашего принтера и кликаем Continue:

    lpd://10.2.2.1/AdminsPrint

В строке Name вводим имя нашего принтера и кликаем Continue.

Далее, указываем марку и модель принтера и кликаем Add Printer. На следующей странице кликаем на Set Default Options. CUPS сообщит, что принтер успешно установлен.

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_010.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_011.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_012.png 'Печать на Windows принтер из Linux')

![Печать на Windows принтер из Linux](/images/Linux/Hardware/print_linux_to_win_013.png 'Печать на Windows принтер из Linux')

Данный способ работает и с Windows 7 в качестве сервера и с другими дистрибутивами Linux в качестве клиентов. Модели и марки принтеров так же могут быть теоретически любые, я пробовал только модели от HP, проблем с ними нет. Единственное, что нужно учитывать - если ваш дистрибутив далеко не первой свежести, то возможно понадобиться дополнительно установить/обновить HPLIP (если у вас принтер от HP), а так же для некоторых моделей принтеров от HP требуется проприетарный плагин, который устанавливается отдельно.

**Источник**: http://yar4e-it.blogspot.ru
