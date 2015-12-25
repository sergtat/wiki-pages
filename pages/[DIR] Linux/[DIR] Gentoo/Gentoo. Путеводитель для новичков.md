#  Gentoo. Путеводитель для новичков
## **Вода**

В очередной раз наткнувшись на банальный вопрос гентушника-новичка, решил
написать в меру сжатый FAQ по Gentoo/Linux для таких пользователей.
Последующее повествование рассчитано на тех, кто имеет представление о USE
флагах, существовании /etc/portage и make.conf, их функциях и структуре.
Поехали! (C) Гагарин

## **Пакеты**

### Бинарные

Кроме ебилдов, портаж умеет работать и с бинарными пакетами. Это довольно
удобно при обновлении однотипных машин без необходимости собирать одно и то же
на каждой машине. Если хотите более подробно разобраться, то гуглите binhost.

Для бекапа они тоже хороши - можно перед обновлением подстраховаться и собрать
имеющеюся версию в бинарный пакет с помощью quickpkg. Либо же можно настроить
портаж на сборку бинарных пакетов при любых установках/обновлениях. В этом
случае вам при откате не придётся собирать снова старую версию.

Так же бинарные пакеты могут выручить при восстановлении сломанной системы
простой распаковкой в корень ( я вас этому не учил! :3 ), в случае сломанных
glibc/питона/портажа/скулов(если портаж их использует) или чего-либо ещё, без
чего невозможна нормальная работа системы.

**Это стоит применять только в крайних случаях!**

В таких случаях, если у вас нет локальных бинарных пакетов, может сильно
выручить [tinderbox](http://tinderbox.dev.gentoo.org/).

### Интерактивные

Эти пакеты требуют каких либо действий со стороны пользователя в процессе
установки. Примером такого пакета является games-fps/unreal-tournament.

Если при обновлении/пересборке мира вы хотите избежать остановки процесса из-
за такого пакета (например на ночь обновление оставили), то можно передать
портажу ключ

    --accept-properties=-interactive

### Live

Эти пакеты предоставляют текущее состояние проекта, а не некоторую
неизменяемую версию. Т.е. используют срез репозитория исходников на
git/svn/hg/и_т.д. сервере проекта. Отсюда и название "живые".

Нет версии (точнее обычно это 9999*) ---> портаж сам не может (может пока?)
обновить такие пакеты до актуального состояния. Обновление этих пакетов
рассмотрим далее в "[Обновление](#update)".

### Несамостоятельные

Это пакеты, для которых надо ручками сливать тарболы: например dev-java
/oracle-jre-bin. Таким поведением они обязаны лицензионной политике
разработчика. Тот же Oracle требует принятия лицензии у себя на сайте перед
тем как позволит загрузить свой продукт. Такие пакеты при попытке
установки/обновления скажут "иди сюда, забери то и положи в дисто-помойку".
Последнее ( по-умолчанию ) это "/usr/portage/distfiles/"

## Настройка

### portage

Настройка осуществляется через файл make.conf (лежит либо в /etc либо (в новых
установках) в /etc/portage. последний имеет бОльший приоритет) и через файлы в
директории /etc/portage. Здесь не будем это рассматривать подробно -
информации по этому поводу и так хватает.

Коротко:

/etc/portage/bashrc

Часто используется для "странных" вещей. Это скрипт, который обрабатывается
несколько раз для каждого пакета. Сюда можно запилить свои функции и
переменные, которые по тем или иным причинам в другом месте нельзя/не_хочется
указывать.

/etc/portage/package*

Используются для указания кейвордов/юзов/маскировок для отдельных пакетов, в
том числе могут использоваться и для "странных" вещей из bashrc.

/etc/portage/env/

Как и следует из названия, эта директория содержит настройки окружения для
отдельных пакетов: персональные bashrc/make.conf. Для более подробного
описания почитайте [Portage: хочется
странного](http://megabaks.blogspot.ru/2012/10/portage.html)

### Советы

#### Приоритет

Чтобы комп не тормозил во время компеляний, можно задать портажу низкий
приоритет.

    PORTAGE_NICENESS="10"

Это надо записать в make.conf. Этот же приоритет скажется и на приоритете
доступа к вводу/выводу, потому при таком раскладе использование
PORTAGE_IONICE_COMMAND избыточно.

#### Потоки

Портаж умеет собирать несколько пакетов одновременно. Для этого есть ключик
-jX, где X кол-во пакетов. Задаётся через переменную в make.conf, например

    EMERGE_DEFAULT_OPTS="-j3"

Такой же ключик имеет и утилита make, но в этом случае он задаёт максимальное
кол-во одновременно запущенных копий компилятора, каждый из которых собирает
свою часть проекта.

Наилучшие результат в плане скорости показывает схема кол-во_ядер+1. Задаётся
это тоже в make.conf, например

    MAKEOPTS="-j5"

Для bzip2 архивов так же можно задать кол-во используемых потоков. Для этого
надо установить многопоточную реализацию bzip2 - я использую lbzip2. Так же
надо задать пару переменных в том же make.conf, например так

    PORTAGE_BUNZIP2_COMMAND="lbunzip2 -n4"
    PORTAGE_BZIP2_COMMAND="lbzip2 -n4"

Это для моего 4-х ядерного процессора. разница между bzip2 и lbzip2 в 4 потока
на распаковке в оперативке

    real 0m24.287s
    user 0m23.664s
    sys 0m0.525s

супротив

    real 0m8.019s
    user 0m28.015s
    sys 0m2.135s

Хотя этот профит от lbzip2 и не даст вам реального профита :3.

Дело вот в чём: среди дистов архивов в формате bzip2 далеко не подавляющее
большинство и цифры приведены для одного из самых больших архивов
(chromium-25*). На фоне времени, затраченного на компиляцию, время на
распаковку вообще не играет роли.

Реальный профит могут получить те, кто использует бинарные пакеты и
устанавливает их в большом кол-ве (привет, binhost), где время распаковки
тарболов занимает примерно половину времени установки. Ну и те, для кого
важно, так сказать, моральное удовлетворение - процессор меньше времени
затратит на распаковку и быстрей займётся действительно важным делом.

#### tmpfs

Так же можно использовать tmpfs для директории сборки - в скорости профит
минимален, но зато не дёргает винт лишний раз. Можно монтировать
/var/tmp/portage через fstab в раму, а можно и использовать
[скрипт](http://optimization.hardlinux.ru/?page_id=163)

Но тут надо решить что вам важней - не дёргать лишний раз винт или же
сохранить кэш. Если последнее, то сборка в раме не для вас.

#### C{XX}FLAGS

Советую ключик -pipe, чтобы временные файлы при компиляции шли по конвейеру в
раме, а не дёргали винт, хотя если вы сторонник /tmp в tmpfs, то выйдет шило
на мыло. Для задания архитектуры лучше использовать

    -march=native

(-mtune, если не указан, примет аналогичное значение), но только если вы не
собираетесь использовать distcc.

#### Ccache

Это ещё один способ ускорить сборку. При каждой последующей сборке будут
пересобираться только те файлы, которые изменились и которые связаны с этими
файлами. Установка проста: ставим ccache, включаем в make.conf (или для
отдельного пакета через [Portage: хочется
странного](http://megabaks.blogspot.ru/2012/10/portage.html)), например

    FEATURES="ccache"

и там же задаём лимит на используемое место.

    CCACHE_SIZE="10G"

#### Профили

Тут 2 подхода: дефолтный профиль и потом в make.conf и /etc/portage задавать
желаемые юзы, либо же подобрать наиболее подходящий профиль и дополнить.

Тут, как говорится, "на вкус и цвет все фломастеры разные".

Для того чтобы представляли что за юзы задают различные профили, приведу их
для своей ~x86

    [ root@desktop ] megabaks # portconf -apu

    default/Linux/x86/10.0: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd
    zlib mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 acl cups gdbm
    gpm nptl unicode

    default/Linux/x86/10.0/selinux: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl
    tcpd zlib mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 cups gdbm
    gpm nptl unicode -acl selinux open_perms

    default/Linux/x86/10.0/desktop: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl
    tcpd zlib mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 acl cups gdbm
    nptl a52 aac acpi alsa bluetooth branding cairo cdda cdr consolekit dbus dts dvd dvdr emboss
    encode exif fam firefox flac gif gpm gtk jpeg lcms ldap libnotify mad mng mp3 mp4 mpeg ogg
    opengl pango pdf png policykit ppds qt3support qt4 sdl spell startup-notification svg tiff truetype
    vorbis udev udisks unicode upower usb wxwidgets X xcb x264 xml xv xvid

    default/Linux/x86/10.0/desktop/gnome: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline
    ssl tcpd zlib mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 acl cups
    gdbm nptl colord eds evo gnome gnome-keyring gnome-online-accounts gstreamer nautilus
    pulseaudio socialweb a52 aac acpi alsa bluetooth branding cairo cdda cdr consolekit dbus dts
    dvd dvdr emboss encode exif fam firefox flac gif gpm gtk jpeg lcms ldap libnotify mad mng
    mp3 mp4 mpeg ogg opengl pango pdf png policykit ppds qt3support qt4 sdl spell startup-notification
    svg tiff truetype vorbis udev udisks unicode upower usb wxwidgets X xcb x264 xml xv xvid

    default/Linux/x86/10.0/desktop/kde: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd
    zlib mudflap fortran openmp cli pcre session pppd iconv modules bzip2 acl cups gdbm nptl declarative
    dri kde kipi phonon plasma semantic-desktop xcomposite xinerama xscreensaver a52 aac acpi alsa
    bluetooth branding cairo cdda cdr consolekit dbus dts dvd dvdr emboss encode exif fam firefox flac
    gif gpm gtk jpeg lcms ldap libnotify mad mng mp3 mp4 mpeg ogg opengl pango pdf png policykit
    ppds qt3support qt4 sdl spell startup-notification svg tiff truetype vorbis udev udisks unicode upower
    usb wxwidgets X xcb x264 xml xv xvid

    default/Linux/x86/10.0/developer: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd zlib
    mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 acl cups gdbm nptl -perl -python
    snmp a52 aac acpi alsa bluetooth branding cairo cdda cdr consolekit dbus dts dvd dvdr emboss encode
    exif fam firefox flac gif gpm gtk jpeg lcms ldap libnotify mad mng mp3 mp4 mpeg ogg opengl pango
    pdf png policykit ppds qt3support qt4 sdl spell startup-notification svg tiff truetype vorbis udev udisks
    unicode upower usb wxwidgets X xcb x264 xml xv xvid

    default/Linux/x86/10.0/server: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd zlib
    mudflap fortran openmp cli pcre session dri pppd iconv modules bzip2 acl cups gdbm gpm nptl unicode
    -perl -python snmp truetype xml

    hardened/Linux/x86: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd zlib mudflap
    openmp cli pcre session dri pppd iconv modules -fortran hardened -jit pax_kernel pic urandom -orc
    bzip2 acl cups gdbm gpm nptl unicode

    hardened/Linux/x86/selinux: cracklib cxx berkdb crypt ipv6 ncurses nls pam readline ssl tcpd zlib
    mudflap openmp cli pcre session dri pppd iconv modules -fortran hardened -jit pax_kernel pic urandom
    -orc bzip2 cups gdbm gpm nptl unicode -acl selinux open_perms

    hardened/Linux/uclibc/x86: hardened nptl pax_kernel pic unicode xattr cracklib cxx berkdb crypt ipv6
    ncurses nls pam readline ssl tcpd zlib mudflap fortran openmp cli pcre session dri pppd iconv modules
    [ root@desktop ] megabaks #

Для amd64 они отличаются, но буквально парой/тройкой.

### Оверлеи

Для использования оверлеев (сторонних репозиториев) обычно используется
layman. Про его настройку достаточно информации и в рукокниге (handbook). Мы
его ещё вспомним, но при рассмотрении обновления.

<a name='keywords'></a>
### Keywords

Через кейворды можно выбрать основную ветку и/или версию пакета: стабильная,
тестовая, забить на них (нужно для пакетов без keywords, обычно это лайф).
Стабильные это x86/amd64, тестовые имеют префикс "~": ~x86/~amd64 (с другими
архитектурами аналогично).

У лайф пакетов кейворды не заданы. Чтобы поставить такой пакет надо "забить"
на кейворды - для этого служит "**", например вот такая конструкция в
/etc/portage/package.keywords

    media-sound/deadbeef **

позволит мне поставить любую версию, независимо от ветки, в которой она
находится, в том числе и лайф версию.

Для всей системы кейворды задают ветку и объявляются в make.conf, например
тестовая x86

    ACCEPT_KEYWORDS="~x86"

Кейворды в конфигах для пакетов работают как use-флаги: "-" означает
отключение. Т.е. если вы используете тестовую ветку, но хотите поставить пакет
из стабильной, то отключаем тестовую ветку для пакета в package.keywords.
Например

    www-client/chromium -~x86

Теперь при обновлении www-client/chromium будет ставиться только из стабильной
ветки.

### Блокировки

Блокировки возникают когда 2 (редко больше) пакета не могут быть установлены
одновременно. Пример вывода портажа

    [blocks B      ] <x11-base/xorg-server-1.11.4 ("<x11-base/xorg-server-1.11.4" is blocking x11-libs/gtk+-3.6.3-r2)

Это значит, что:

  * либо у меня уже установлен x11-base/xorg-server ниже версии 1.11.4
  * либо он хочет обновиться до версии, опять же, ниже 1.11.4

А вот x11-libs/gtk+-3.6.3-r2 требует иксы 1.11.4 или выше.

Выходов из ситуации несколько:

  * маскируем "зажравшийся" пакет - в нашем случае это x11-libs/gtk+-3.6.3-r2
  * удовлетворяем требования - в нашем случае обновляем x11-base/xorg-server до требуемой x11-libs/gtk+-3.6.3-r2 версии: ставим x11-base/xorg-server-1.11.4 или выше.
  * устанавливаем на свой страх и риск без учёта зависимостей с помощью ключика "-O" (я вас этому не учил! :3)

Так же бывают "недоблокировки", например при обновлении qt:

    [blocks b      ] >x11-libs/qt-core-4.8.2-r9999:4 (">x11-libs/qt-core-4.8.2-r9999:4" is blocking x11-libs/qt-declarative-4.8.2,
    x11-libs/qt-qt3support-4.8.2, x11-libs/qt-webkit-4.8.2, x11-libs/qt-svg-4.8.2, x11-libs/qt-test-4.8.2,
    x11-libs/qt-xmlpatterns-4.8.2, x11-libs/qt-sql-4.8.2, x11-libs/qt-script-4.8.2, x11-libs/qt-gui-4.8.2,
    x11-libs/qt-opengl-4.8.2, x11-libs/qt-dbus-4.8.2)

И так с каждым qt пакетом.

Тут всё просто - забейте! Эти блокировки не для вас, портаж сам разрулит.

B == блокировка

b == недоблокировка и не достойна вашего внимания.

### Маскировки

Маскируют либо "бажные/не_проверенные" пакеты ментайнеры в
/usr/portage/profiles/package.mask либо сами пользователи, например для
разрешения блокировки, как выше с иксами и гтк. Маскировки бывают 2-х видов:

  * жёсткие маскировки (hard masked). Их я описал выше
  * keyword-маскировки.

Это когда пакет имеет keywords не разрешённый в вашей системе. Например все
~arch пакеты в стабильной ветке будут keyword-masked. Обычно на такие
маскировки натыкаются при попытке поставить ~arch/лайф пакет, в том числе и
из-за того, что этот пакет тянет такие же ~arch/лайф пакеты, для которых не
заданы требуемые кейворды, т.к. разрешена тестовая ветка была только для
целевого пакета.

В первом случае пара вариантов:

  * размаскировать hard_masked пакет в /etc/portage/package.unmask, например

    media-libs/libjpeg-turbo
    media-libs/libpng:1.2
    =net-libs/libsrtp-1.4.4_p20121108
    >=sys-devel/gcc-4.5.1
    ~sys-devel/gcc-4.7.1

  * замаскировать через /etc/portage/package.mask пакеты/версии пакетов, которые тянут замаскированные пакеты.

Во втором случае см. [Keywords](#keywords).

Справки для: /etc/portage/package.{un}mask имеют бОльший приоритет, чем
/usr/portage/profiles/package.mask

-------------------------

А вообще надо просто читать что портаж пишет :) Правда понимание его выхлопа
приходит не сразу.

### wildcard-ы

wildcard - это когда вместо категории и/или имени пакета используется символ
"*". Т.е. вы по тем или иным причинам хотите задать юзы/кейворды/маски для
целой группы пакетов.

Примеры

    media-sound/*
    */*
    media-plugins/gst-plugins-*

### repo

Так же можно задать какие-либо параметры для пакетов из какого-либо репа -
будь то оверлей или основное дерево.

Например вы используете тестовую ветку (~arch), но хотите из некоего оверлея
ставить распоследние версии пакетов, в том числе лайф. Тогда в
/etc/portage/package.keywords нужно записать такую строку

    */*::оверлей **

(tnx Kindly_Cat ака Фрактал за напоминание) Конструкция "пакет::реп" работает
не только с wildcard-ами.

Основное дерево == gentoo

## Окружение

### eselect

Это утилита для настройки окружения в генте. С помощью eselect настраивается
практически всё окружение - от профилей портажа до автодополнения bash.

### gcc-config

С его помощью можно посмотреть/выбрать активную ветку gcc, которой будут
собираться все пакеты. Ветку gcc можно задать и любому пакету свою, но об этом
позднее.

### -config

Некоторые языки программирования так же имеют аналоги gcc-config для
переключения между разными версиями.

### rc-update

Он служит для просмотра состояния запускаемых сервисов на всех уровнях
запуска, а так же для добавления/удаления первых в/из вторых.

### etc-update/dispatch-conf

При обновлении пакета его конфиги так же обновляются и далеко не всегда
остаются такими же как в предыдущей версии. etc-update служат для их
обновления: показывает разницу между имеющимся и новым, а так же даёт выбор:
оставить старый и удалить новый или наоборот. dispatch-conf выполняет те же
функции.

<a name="update"></a>
## Обновление

### Sync

Перед самим обновлением необходимо синхронизировать все наши репы - и основное
дерево и оверлеи. Для этого можно использовать как

    emerge --sync

так и

    eix-sync

Если используете eix (в полезняшках рассмотрим), то второй вариант
предпочтительней. Это команды для синхронизации основного дерева. Для
синхронизации оверлеев можно использовать и

    layman -S

и

    eix-sync

если последний настроен соответствующим образом, конечно.

### world

Обновление мира каждый делает как пожелает, но всё обычно начинается с

    emerge -avuDN world

Тут особенно нечего рассматривать, потому рассмотрим что у нас может произойти
после/в_процессе обновления мира.

#### revdep-rebuild

После обновления некоторых библиотек, программы, которые используют эти
библиотеки, могут стать неработоспособными, т.к. они рассчитывают на старую
версию, которой уже нет, потому что она заменена новой. Для решения этой
проблемы и служит revdep-rebuild. Он проверяет все библиотеки и бинарники в
системе на предмет корректной линковки, если находит поломку, то выясняет
какому пакету принадлежит сломанный файл и ставит его в очередь на пересборку.
После перехода всех ебилдов на EAPI 5 с сабслотами (но когда это будет!? :3)
revdep-rebuild станет не нужен, а пока без него никак. (альфа-тестеры портажа,
не рычать!)

#### preserve-libs

Это одна из фич портажа, которая позволяет свести необходимость использования
revdep-rebuild к минимуму. Для её использования в make.conf в переменную
FEATURES надо добавить preserve-libs

    FEATURES="${FEATURES} preserve-libs"

Работает очень просто - если при обновлении библиотеки остались пользователи
старой версии, то она сохраняется, а при обновлении оные будут собираться уже
с новой версией.

#### smart-live-rebuild

Эта утилита служит для обновления так называемых лайф-пакетов. Работает очень
просто: у лайф пакета смотрит ревизию,из которой он был собран на сервере
проекта смотрит текущую ревизию если они не совпадают, то пакет отправляется
на пересборку. Можно использовать и другой подход

    emerge @live-rebuild

Но этот вариант имеет один большой недостаток - будут пересобраны ВСЕ лайф
пакеты. У меня таких пакетов 14 штук - зачем же мне пересобирать их все, если
действительно обновился только 1!?

#### X

Встречал очень много матов от гентушников после обновления иксов - "АААА!!! у
меня клава отвалилась! чо делать?" Всё просто - драйвер той же клавы собран
под ABI предыдущей версии иксов, потому с новым и не работает, значит надо его
пересобрать под новые иксы. Но т.к. все такие пакеты не упомнишь, можно просто
скомандовать

    emerge @x11-module-rebuild

если же ваш портаж допотопный, то можно и так

    emerge `qlist -IC x11-drivers`

если у вас установлен portage-utils, конечно.(см. полезняшки)

#### python-updater

После обновления питона сторонние модули могут сломаться. python-updater
служит для поиска таких пакетов и их пересборки.

    python-updater -- -avD1

#### perl-cleaner

Аналогична ситуация и с перлом. perl-cleaner в помощь.

    perl-cleaner --all

#### haskell-updater

Всё то же самое, только для программ на haskell.

#### ИТОГО:

Из всего вышесказанного^Wнаписанного следует, что для корректного обновления
системы необходимо использовать целую пачку программ. Потому совет: создавайте
алиас или скрипт, в котором и будут указаны все необходимые вам команды в
нужной последовательности, дабы максимальное кол-во проблем решались без
телодвижений с вашей стороны. Но раз проблемы уже есть, то рассмотрим наиболее
частые из них.

## Ошибки сборки

### библиотеки

Пример

    error while loading shared libraries: libicuuc.so.48: cannot open shared object file: No such file or directory

revdep-rebuild в помощь.

Некоторые "решают" такие проблемы созданием симлинков на библиотеки из
имеющейся версии. **Не делайте так!**

### python

Пример

    ImportError: No module named setuptools

python-updater поможет.

### perl

Пример

    Can't locate Locale/gettext.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl5/5.16.0/i686-linux /usr/local/lib/perl5/5.16.0 /usr/lib/perl5/vendor_perl/5.16.0/i686-linux

perl-cleaner вас спасёт.

### GLIBCXX

Пример

    version `GLIBCXX_3.4.15' not found

Это значит что программа/либа требует приплюснутую либу (libstdc++.so.6) из
состава gcc более новой ветки нежели используется сейчас. Может возникнуть
либо из-за притащенных откуда-то бинарников, либо из-за скакания с одной ветки
gcc на другую. Чтобы было понятно какую же ветку требует:

    3.4.15 == 4.6
    3.4.14 == 4.5

и т.д. Есть пакеты, которые требуют сборки с gcc отличной от текущей активной.
И чтобы система не страдала, я запилил переключатель веток gcc для каждого
отдельного пакета:

  * либо подключайте оверлей stuff и ставьте gcc-switcher, потом

    echo 'source /etc/portage/gcc-switcher' >> /etc/portage/bashrc

и уже указываете какой пакет какой веткой собирать, например

    echo "sys-boot/grub 4.4" >> /etc/portage/package.compilers

теперь grub будет всегда собираться с 4.4 независимо от соседних пакетов и
активной ветки gcc.

  * либо в свой /etc/portage/bashrc запилите вот [такой](https://raw.github.com/megabaks/gcc-switcher/master/gcc-switcher) код вместо установки из оверлея.

### Cuda

Пример

    Compiling CUDA kernel ... nvcc warning : Option '--opencc-options (-Xopencc)' is obsolete and ignored,
    when targeting compute_20, sm_20, or higher
    In file included from /usr/local/cuda/bin/../include/cuda_runtime.h:59:0, from :0:
    /usr/local/cuda/bin/../include/host_config.h:82:2: ошибка: #error -- unsupported GNU version!
    gcc 4.6 and up are not supported!

Собственно пример пакета, который привередлив к версии gcc ---> см. про
##GLIBCXX

## Полезняшки

### app-portage/eix

Выше он уже упоминался. Это утилита для быстрого поиска пакетов в том числе по
оверлеям.

Так же умеет синхронизировать (eix-sync) основное дерево и оверлеи.

Умеет выводить результаты в удобовариваемом виде - например только юзы пакета.

### app-portage/gentoolkit

В состав этого пакета входят такие утилиты как:

  * equery (**must have**)- показывает зависимости пакета, пакеты зависящие от пакета, значение юзов и т.д.
  * eclean-dist - удаляет ненужные дисты, например от неустановленных пакетов или от старых версий установленных.
  * eclean-pkg - удаляет ненужные бинарные пакеты.

### app-portage/pfl

2 скрипта для работы с portagefilelist.

  * e-file - служит для поиска содержащих файл пакетов, даже если пакеты не установлены.
  * pfl - собирает информацию о установленных пакетах и их содержимом, затем отправляет на вышеописанный сервер.

Хорошим тоном будет запилить вызов pfl в алиас/скрипт обновления мира ;)

### app-portage/portage-utils

Содержит qlist, который показывает установленные пакеты с различной
информацией о них, в том числе файлы пакета. Есть ещё несколько в составе, но
как по мне - они менее используемы.

### app-portage/genlop

Показывает информацию по пакетам: время/дату сборки, примерное время до
окончания сборки, пакеты установленные/удалённые за некий период и многое
другое. По сути это парсер портажных логов.

-------------------------------------------------------

Вроде всё, что вспомнил...

All contents copyright of the author. (C)2007-2014.
