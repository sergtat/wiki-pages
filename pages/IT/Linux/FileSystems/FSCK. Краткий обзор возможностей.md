# FSCK. Краткий обзор возможностей.
![Atime, mtime ctime](/images/Linux/Filesystems/linux-filesystem.jpg 'Atime, mtime ctime')

Рано или поздно это случается, а именно крах системы или раздела, невозможность проверить файловую систему и т.д. Поэтому системный администратор должен знать что делать в таких ситуациях, так сказать знать как «Отче наш».

## fsck при загрузке ОС
Когда случается сбой питания в работу вступает fsck: **file system consistency check and interactive repair** или если на русском, то **«проверка целосности файловой системы и интерактивное восстановление»**. По умолчанию проверка дисков отключена. Что бы её включить при загрузке системы, добавим такую строчку

    fsck_y_enable="YES"

в файл `/etc/rc.conf`. В этом случае, при некорректном завершении работы сервера, будет автоматически запускаться проверка всех файловых систем.

Сама проверка состоит из 5-ти этапов:

```bash
** Phase 1 - Check Blocks and Sizes
** Phase 2 - Check Pathnames
** Phase 3 - Check Connectivity
** Phase 4 - Check Reference Counts
** Phase 5 - Check Cyl groups
```
На самом деле, **Phase 1** ещё подразделяется на **1a** и **1b**. Это можно заметить только тогда, когда случился серъёзный крах.

Всё это хорошо, но есть одно НО! Когда происходит проверка файловой системы, то пока раздел не провериться, он не смонтируется и станет доступным, соответственно, увеличивается время загрузки сервера. Разработчики и это предусмотрели и сделали возможным запуск проверки в «фоне». Хотя на самом деле это только попытка, но всё же лучше, чем ничего. по умолчанию она включена. Правда по этому поводу точаться дискуссии на тему «нужно ли включать проверку в фоне или нет». Решать вам.

Есть один неприятный момент в процессе проверки ФС при загрузке. Если раздел достаточно большой, то его проверка может занять длительное время, при этом, **fsck** как бы зависает на каждом из этапов. Иными словами визуально непонятно, то ли идёт проверка, то ли сервер завис. Ну и при всём при этом непонятно, сколько уже проверено и сколько будет проверяться. Что бы немного облегчить жизнь системным администраторам, разработчики внедрили недокументированую возмножность. нажатие комбинации **Ctrl+T** показывает текущее состояние проверки: сколько уже проверено, в процентах. Если через пару минут захотите узнать опять состояние — нужно снова нажать **Ctrl+T** и так каждый раз (либо просто зажать и держать, тогда получите динамически обновляемые данные).

Есть несколько параметров, которые прописываются в **/etc/rc.conf** и касаются **fsck**. Ниже приведены их дефолтные значения:

```bash
fsck_y_enable="NO"              # Включить проверку при запуске, если работа была завершена некорректно.
fsck_y_flags=""                 # Дополнительные флаги для fsck -y
background_fsck="YES"           # Попытка запустить проверку в фоне
background_fsck_delay="60"      # Время задержки перед запуском fsck в фоне.
```
Я рекомендую прописать в /etc/rc.conf только такое:

    fsck_y_enable="YES"

И так, вот примеры работы **fsck**:

- если сервер выключался корректно, то при загрузке мы увидим такое сообщение:

```bash
Nov 10 14:36:33 mail kernel: Starting file system checks:
Nov 10 14:36:33 mail kernel: /dev/da0s1a: FILE SYSTEM CLEAN; SKIPPING CHECKS
Nov 10 14:36:33 mail kernel: /dev/da0s1a: clean, 942456 free (2944 frags, 117439 blocks, 0.3% fragmentation)
Nov 10 14:36:33 mail kernel: /dev/da0s1d: FILE SYSTEM CLEAN; SKIPPING CHECKS
Nov 10 14:36:33 mail kernel: /dev/da0s1d: clean, 503428 free (60 frags, 62921 blocks, 0.0% fragmentation)
Nov 10 14:36:33 mail kernel: /dev/da0s1e: FILE SYSTEM CLEAN; SKIPPING CHECKS
Nov 10 14:36:33 mail kernel: /dev/da0s1e: clean, 2301104 free (50872 frags, 281279 blocks, 1.0% fragmentation)
Nov 10 14:36:33 mail kernel: /dev/da0s1f: FILE SYSTEM CLEAN; SKIPPING CHECKS
Nov 10 14:36:33 mail kernel: /dev/da0s1f: clean, 162210122 free (2260506 frags, 19993702 blocks, 0.5% fragmentation)
Nov 10 14:36:33 mail kernel: Mounting local file systems:
```
Наличие ключевой фразы **FILE SYSTEM CLEAN; SKIPPING CHECKS** свидетельствует о предыдущем корректном завершении.

- если некорректно, то такое

```bash
Starting background file system checks in 60 seconds.
Jan 26 18:39:19 mail kernel: Starting file system checks:
Jan 26 18:39:19 mail kernel: /dev/da0s1a: 56013 files, 201857 used, 3349718 free (1702 frags, 418502 blocks, 0.0% fragmentation)
Jan 26 18:39:19 mail kernel: /dev/da0s1d: DEFER FOR BACKGROUND CHECKING
Jan 26 18:39:19 mail kernel: /dev/da0s1f: DEFER FOR BACKGROUND CHECKING
Jan 26 18:39:19 mail kernel: /dev/da0s1e: DEFER FOR BACKGROUND CHECKING
```
Но такое происходит не всегда. Если попытка не увенчалась успехом, то мы увидим такое:

```bash
** /dev/ad2s1g (NO WRITE)
** Last Mounted on /var
** Phase 1 - Check Blocks and Sizes

INCORRECT BLOCK COUNT I=446041 (4 should be 0)
CORRECT? yes
INCORRECT BLOCK COUNT I=446045 (4 should be 0)
CORRECT? yes

** Phase 2 - Check Pathnames
** Phase 3 - Check Connectivity
** Phase 4 - Check Reference Counts

UNREF FILE  I=89148  OWNER=root MODE=100600
SIZE=376 MTIME=Aug 13 13:49 2006
RECONNECT? yes
CLEAR? yes
UNREF FILE  I=89152  OWNER=root MODE=100600
SIZE=755 MTIME=Aug 13 13:49 2006
RECONNECT? yes
CLEAR? yes

** Phase 5 - Check Cyl groups

FREE BLK COUNT(S) WRONG IN SUPERBLK
SALVAGE? yes
SUMMARY INFORMATION BAD
SALVAGE? yes
BLK(S) MISSING IN BIT MAPS
SALVAGE? yes
2242 files, 1607116 used, 973436 free (2196 frags, 121405 blocks, 0.1% fragmentation)
```

## Ручной запуск fsck
Сразу замечу, что проверка делается **ТОЛЬКО НА НЕ СМОНТИРОВАННОМ РАЗДЕЛЕ!** Иначе можете потерять все данные.
И так, рассмотрим только те параметры, которые часто используются. А именно

```bash
-y|-n: этот параметр будет отвечать соответственно YES|NO на все вопросы при возникновении несоответствий.
-B|-F : соответственно фоновый и нефоновый режимы
-f : проверить раздел, даже если он был отключён корректно.
```
Рекомендую запускать с такими параметрами:

    fsck -y -f /dev/ad2s1g

Если запустить без параметра -y, то при проверке и нахождении несоответствий будет выдаваться вопрос, на что можно ответить **Y** или **N**. обычно отвечают Y. Не очень удобно каждый раз отвечать Y, поэтому лучше запускать с параметром -y

```bash
** /dev/ad2s1g (NO WRITE)
** Last Mounted on /var
** Phase 1 - Check Blocks and Sizes

INCORRECT BLOCK COUNT I=446041 (4 should be 0)
CORRECT?
```
Есть хорошая новость: комбинация **CTRL+T** работает и в ручном режиме.
