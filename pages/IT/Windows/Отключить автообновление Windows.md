# Отключить автообновление Windows.

```
[HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\GWX]
"DisableGwx"=dword:00000001
```

Never10 скачай и поставь. http://remontka.pro/never-10/

Винду можно откатить на старую - "Параметры" - "Восстановление" - "Восстановить старую версию операционной системы"

---
Инструкция для пользователей Про и Корпоративных версий...
"Пуск" - Выполнить - gpedit.msc - Конфигурация компьютера - Административные шаблоны - Компоненты Windows - Центр обновления Windows - параметр "Turn off upgrade to latest version of windows" перевести в состояние "Включено".

P.S. А этим cmd скриптом можно навсегда отрубить gwx, запускать от имени администратора.

```
@ECHO OFF
:: declare base dir
SET "WORK_DIR1=%SystemRoot%\SYSTEM32\GWX"
:: check applicability
IF NOT EXIST "%WORK_DIR1%\" IF EXIST "%WORK_DIR1%" (ECHO GWX already processed &PAUSE&EXIT 0)
:: declare additional dir for AMD64 architecture
ECHO "%PROCESSOR_ARCHITECTURE%""%PROCESSOR_ARCHITEW6432%"|1>NUL 2>NUL FIND /I "64"&&SET "WORK_DIR2=%SystemRoot%\SysWOW64\GWX"
SET "WORK_NAME=gwx"
:: Killing task
tasklist.exe|find /i "%WORK_NAME%"&&taskkill.exe /f /im %WORK_NAME%*
tasklist.exe|find /i "%WORK_NAME%"&&(ECHO kill processes %WORK_EXE%* failed! &PAUSE&EXIT 1)
:: rеnаmе DIR1
IF EXIST "%WORK_DIR1%\" attrib -s -h -r "%WORK_DIR1%"
IF EXIST "%WORK_DIR1%\" REN "%WORK_DIR1%\" "_%WORK_NAME%"
IF EXIST "%WORK_DIR1%\" (ECHO Could not rеnаmе "%WORK_DIR1%\" PAUSE&EXIT 2)
:: create FILE1
ECHO. >>"%WORK_DIR1%"
IF NOT EXIST "%WORK_DIR1%" (ECHO Could not create file "%WORK_DIR1%" &PAUSE&EXIT 3)
:: deny access FILE1 for SYSTEM
icacls.exe "%WORK_DIR1%" /inheritance:r /Q 1>NUL 2>&1
icacls.exe "%WORK_DIR1%" /deny SYSTEM:F /Q 1>NUL 2>&1

IF NOT "%WORK_DIR2%"=="" (
:: rеnаmе DIR2
IF EXIST "%WORK_DIR2%\" attrib -s -h -r "%WORK_DIR2%"
IF EXIST "%WORK_DIR2%\" REN "%WORK_DIR2%\" "_%WORK_NAME%"
IF EXIST "%WORK_DIR2%\" (ECHO Could not rеnаmе "%WORK_DIR2%\" PAUSE&EXIT 4)
:: create FILE2
ECHO. >>"%WORK_DIR2%"
IF NOT EXIST "%WORK_DIR2%" (ECHO Could not create file "%WORK_DIR2%" &PAUSE&EXIT 5)
:: deny access FILE2 for SYSTEM
icacls.exe "%WORK_DIR2%" /inheritance:R /Q 1>NUL 2>&1
icacls.exe "%WORK_DIR2%" /deny SYSTEM:F /Q 1>NUL 2>&1
)
EXIT 0
```

---
Таки не обязательно отключать обновления полностью, достаточно лишь "скрыть" те паки, которые обновляют до 10 винды

Действуй так: Открываем через «Панель управления» инструмент для установки и удаления программ и переключаемся в режим отображения обновлений системы (пункт «Просмотр установленных обновлений»).

Если у вас Windows 7, то необходимо искать в списке обновления с номерами:

- KB2952664
- KB3021917
- KB3022345
- KB3035583
- KB3050265
- KB3050267
- KB3065987
- KB3080149
- KB3083324
- KB3083710
- KB3139929
- KB3146449
- KB3150513
- KB971033

Если у вас Windows 8 или 8.1, то необходимо искать в списке обновления с номерами:

- KB2902907
- KB2976978
- KB3022345
- KB3035583
- KB3044374
- KB3046480
- KB3050267
- KB3065988
- KB3068708
- KB3075249
- KB3075853
- KB3080149
- KB3083325
- KB3139929
- KB3150513
- KB3146449

Удалите обновления, выбрав соответствующий пункт в контекстном меню, которое вызывается правой кнопкой мышки.

Выберите «Перезагрузить позже» по окончании процесса удаления и переходите к удалению следующего (если имеется больше одного обновления).

Когда все обновления удалены, перезагрузите компьютер.

Теперь необходимо сделать так, чтобы данные предложение больше не появлялось на вашем компьютер, потому что в противном случае данные обновления снова будут установлены автоматически. Нет нужды отключать автоматическое обновление в целом, потому что это нецелесообразно и даже вредно. Нужно просто скрыть указанные выше обновления из списка предлагаемых, тогда они не будут установлены вновь.
