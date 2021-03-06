# Как отключить автозапуск Windows
Автозапуск Windows позволяет автоматически запускать содержимое носителя информации при его подключении. К примеру, запустить презентацию сразу как только вы вставите компакт-диск в привод или подключите флэшку.

Если диски достаточно безопасны, так как на них нельзя осуществлять запись, то флэшки представляют собой отличный переносчик заразы благодаря возможности легкой записи на них и тому самому пресловутому автозапуску. Вставил флэшку в комп и он уже заражен. Отлично!

Поэтому рекомендуется отключить автозапуск Windows на своей машине. Сделать это можно так:

1. Если вы используете Windows XP, то желательно предварительно установить обновление для WinXP x86 или WinXP x64.
2. Поправить ключ в реестре, что в принципе, не безопасно, если вы не будете внимательны, но способ с использованием Gpedit.msc у меня не сработал. Итак, последовательность действий следующая:

  * В меню Пуск выберите пункт Выполнить, в поле Открыть введите команду regedit и нажмите кнопку ОК.
  * Найдите и выберите в реестре следующую запись: `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer\NoDriveTypeAutorun`
  * Щелкните правой кнопкой мыши параметр `NoDriveTypeAutoRun` и выберите команду Изменить.
  * Чтобы отключить все типы дисков, в поле Значение введите `0xFF`. Или для выборочного отключения дисков введите другое значение, список которых приведен ниже.
  * Нажмите кнопку ОК и закройте редактор реестра.
  * Перезагрузите компьютер.

Ниже указаны возможные значения параметра `NoDriveTypeAutoRun`:

* `0x1` или `0x80` - отключение автозапуска для дисков неизвестного типа.
* `0x4` - отключение автозапуска для съемных носителей.
* `0x8` - отключение автозапуска для несъемных дисков.
* `0x10` - отключение автозапуска для сетевых дисков.
* `0x20` - отключение автозапуска для компакт-дисков.
* `0x40` - отключение автозапуска для электронных дисков.
* `0xFF` - отключение автозапуска для дисков всех типов.

Если необходимо отключить автозапуск для нескольких дисков, прибавьте к значению `0x10` соответствующее шестнадцатеричное значение. Например, чтобы отключить автозапуск для съемных носителей и сетевых дисков сложите два шестнадцатеричных значения `0x4` и `0x10`, чтобы получить необходимое значение. `0x4 + 0x10 = 0x14`. Таким образом, в данном примере следовало бы присвоить параметру `NoDriveTypeAutoRun` значение `0x14`.

Этого вполне достаточно чтобы отключить автозапуск в Windows и жить спокойно.

Остальные подробности на странице <http://support.microsoft.com/kb/967715/ru>
