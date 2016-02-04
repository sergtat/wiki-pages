# Великий, могучий shell scripting. Сила FIND
Пожалуй, приступим.

Имеем задачу: необходимо изменить у множества файлов и директорий, расположенных в различных каталогах нашей файловой системы, желаемые атрибуты (права доступа или владельца), причем для файлов нужны одни атрибуты, для директорий другие.

Для тех, кто хоть как-то знаком с командной строкой в Linux, на ум приходят две популярные команды, с помощью которых можно решить данную задачку, это chmod и chown, которые можно запустить с опцией рекурсии, но как-же отделить файлы от директорий?

На помощь приходит одна из самых полезных утилит – FIND.
Задачка решается красиво и быстро:

    find . -type d -exec chmod 750 {} ;
    find . -type f -exec chown user:usergr {} ;

Расшифрую: Найти (find) начиная с текущей директории и ниже (.) все директории (-type d) и выполнить (-exec) команду (chmod 750) для этих ({}) найденных объектов (; — конец опции -exec)

Аналогично для файлов:

    find . -type f -exec chmod 640 {} ;
    find . -type f -exec chown user:usergr {} ;

или для определенных файлов, допустим с расширением .log в директории /var/log:

    find /var/log -type f –name ‘*.log’ -exec chmod 640 {} ;

Find — это незаменимый инструмент в умелых руках, если Вы дружите с английским, почитайте man к find (man find) или русские переводы на данную тему, к примеру здесь, а я приведу еще примеры:

чистим архивы от файлов, которые были модифицированы в последний раз более 30 дней назад:

    find /archive -mtime +30 -exec rm {} ;

и на закуску, более комплексный пример, который ищет самый «свежий» файл, т.е. файл с самым последним (самым новым) временем доступа к нему:

    find . -type f -printf «%A@ %p
    » | sort | tail -n 1 | sed -e «s/[0-9]* //»

Люблю команды в одну строку :)

Расшифрую: Найти (find) начиная с текущей директории и ниже (.) все файлы (-type f) и вывести их (-printf) в формате: «время последнего доступа к файлу, ввиде количества секунд с 1 Января 1970 года по часовому поясу 00:00 GMT (%A@), далее пробел ( ) полное имя файла(%p) и перевод строки(
    )», затем отсортировать их ( | sort) и взять последний с конца отсортированного списка ( | tail -n 1), затем отредактировать полученную строку ( | sed) заменив в строке подстроку содержащую набор цифр и пробел ( -e «s/[0-9]* //») на пустоту.

Кто использует хитрые конструкции с использованием find или ищет решение, для своей задачки поиска, пишите в комменты, будем решать.