# Большая поваренная книга BASH.
## №1

Самый минимум для нормально программирования на bash:

- Нужно использовать полные названия опций logger --priority вместо logger -p
- set -o errexit, set -e - выходит из скрипта при ошибке
- || true - разрешает команде выполняться с ошибкой
- set -o nounset, set -u - выходить при обращении к неопределённой переменной
- echo ${NAME:-bubujka} - значение по умолчанию, если переменная не определена
- set -o xtrace, set -x - печатать каждую команду что исполняется
- set -o pipefail - обрывать выполнение если хоть одна команда в пайпе вернула ненулевой статус. mysqldump | gzip
- Переменные нужно брать в фигурные скобки ls /srv/${ENV}_app

## №2

Несколько самых частых хоткеев, которые сильно облегчают работу в bash:

- alt-b на слово назад
- alt-f на слово вперёд
- ctrl-p предыдущая команда
- ctrl-n следующая команда
- ctrl-w удалить слово левее
- ctrl-k удалить до конца строки вправо
- ctrl-e в конец строки
- ctrl-a в начало строки

## №3

Подавляем stdout и stderr

```sh
$ ls /ololo /etc/ &> /dev/null
```

## №4

Проверяем нахождение подстроки в строке

```sh
string='My string';

if [[ "$string" == *My* ]]
then
  echo "It's there!";
fi

needle='y s'
if [[ "$string" == *"$needle"* ]]; then
  echo "haystack '$string' contains needle '$needle'"
fi
```

```sh
It's there!
haystack 'My string' contains needle 'y s'
```
## №5

```sh
$ I=foobar
$ echo ${I/oo/aa} #replacement
faabar
$ echo ${I:1:2}   #substring
oo
$ echo ${I%bar}   #trailing substitution
foo
$ echo ${I#foo}   #leading substitution
bar
```

## №6

Добавить параметры предыдущей команды

```sh
$ ls /var/cache/
fontconfig  hald  ldconfig  man  pacman
$ cd <Alt+.>
$ cd /var/cache
```

## №7

Выполнить вторую команду с конца истории

```sh
$ ls -l foo bar
$ touch foo bar
$ !-2
```

## №8

Использовать аргументы предыдущей команды

```sh
$ ls -l foo
$ touch !:2
$ cp !:1 bar
```

## №9

Использование аргументов одной из предыдущих команд

```sh
$ ls -l foo bar
$ touch !:2 !:3
$ rm !-2:2 !-2:3
$ !-3
```

## №10

Подставить все аргументы предыдущей команды

```sh
$ ls -l foo bar
$ ls !*
```

## №11

Использовать первый аргумент предыдущей команды

```sh
$ ls /tmp /var
$ ls !^
```

## №12

Использовать последний аргумент предыдущей команды

```sh
$ ls /tmp /var
$ ls !$
```

## №13

Посмотреть какая команда будет выполнена:

```sh
$ ls /var /tmp
$ ls !$ <alt+shift+6>
$ ls /tmp
```

## №14

Использование случайных чисел

```sh
$ echo $((RANDOM % 15))
```

## №15

Проверка строки по регулярному выражению

```sh
if [[ "mystring" =~ REGEX ]] ; then
  echo match
fi
```

## №16

Использование массивов

```sh
#!/bin/bash

array[0]="a string"
array[1]="a string with spaces and \"quotation\" marks in it"
array[2]="a string with spaces, \"quotation marks\" and (parenthesis) in it"

echo "There are ${#array[*]} elements in the array."
for n in "${array[@]}"; do
    echo "element = >>${n}<<"
done
```

## №17

Посмотреть как будет выполняться скрипт

```sh
$ bash -x script.sh
```

## №18

Исправление ошибок в последней команде

```sh
$ cat /proc/cupinfo
cat: /proc/cupinfo: No such file or directory
$ ^cup^cpu
```

## №19

Использование булевых операторов в выражении

```sh
if [ 2 -lt 3 ]
    then echo "Numbers are still good!"
fi

if [[ 2 < 3 ]]
    then echo "Numbers are still good!"
fi
```

## №20

Проверить синтаксис скрипта без его выполнения

```sh
$ bash -n script.sh
```

## №21

Подсчёт времени потраченного на выполнение

```sh
$ SECONDS=0; sleep 5 ; echo "that took approximately $SECONDS seconds"
```

## №22

Использование арифметики

```sh
if [[ $((2+1)) = $((1+2)) ]]
    then echo "still ok"
fi
```

## №23

```sh
[lsc@home]$ export PROMPT_COMMAND="date"
Fri Jun  5 15:19:18 BST 2009
[lsc@home]$ ls
file_a  file_b  file_c
Fri Jun  5 15:19:19 BST 2009
[lsc@home]$ ls
```

## №24

Редактировать текущую команду в редакторе

```sh
$ ls -l <ctrl+x><ctrl+e>
```

## №25

Поместить курсор в начало/конец строки

```sh
Ctrl + a / Ctrl + e
```

Поменять местами текущий и предыдущий символ/слово

```sh
Ctrl + t / Alt + t
```

Поменять в верхний/нижний регистр всё от текущей
позиции до конца слова

```sh
Alt + u / Alt + l
```

## №26

Отчистить файл

```sh
$ > file
```

## №27

Использование базовых математических операций.

```sh
$ A=10
$ let B="A * 10 + 1" # B=101
$ let B="B / 8"      # B=12
$ let B="(RANDOM % 6) + 1" # B от 1 до 6
```

## №28

Первая команда удаляет из истории баша все дубликаты Вторая увеличивает объём истории

```sh
$ export HISTCONTROL=erasedups
$ export HISTSIZE=1000
```

## №29

Вырубать баш после 15 минут простоя

```sh
$ export TMOUT=$((15*60))
```

## №30

Раскрыть подстановки в выражениях

```sh
$ rm -r source/d*.c <Alt + *>
$ rm -r source/delete_me.c source/do_not_delete_me.c
```

## №31

Развернуть переменные и алиасы

```sh
$ ls $HOME/tmp <Ctrl Alt + e>
$ ls -N --color=tty -T 0 /home/cramey
```

## №32

Вызывать команды из команд.

```sh
$ hostname && dig +short $(hostname) && dig +short -x $(dig +short $(hostname))
```

## №33

Вызывать переменные-переменные

```sh
$ foo=bar
$ baz=foo
$ echo ${!baz}
bar
```

## №34

Массивы

```sh
array[0]=тест1
array[1]=тест2

echo ${#array[0]}    # Длина первого элемента массива
echo ${#array[*]}    # Число элементов в массиве
echo ${#array[@]}    # Число элементов в массиве
echo ${array[@]:0}   # Все элементы массива
echo ${array[@]:1}  # Все эелементы массива, начиная со 2-го

area=( ноль один два три четыре )
a=( '' )   # "a" имеет один пустой элемент
hash=( [0]="первый" [1]="второй" [3]="четвертый" )
```

## №35

Элементы массива разделяются пробелами Для обработки строк, как элементов массива нужно на время изменить разделитель:

```sh
LD_IFS="$IFS"
IFS=$'\n'

declare -a a
a=( $(cat "file.txt") )
echo "Total:" ${#a[@]}
for i in "${a[@]}"
do
    echo "$i"
done

IFS="$OLD_IFS"
```

## №36

Арифметические операторы

- +    сложение
- -    вычитание
- *    умножение
- /    деление
- **   возведение в степень
- %    модуль, остаток от деления

- +=
- -=
- /=
- *=
- %=

## №37

Битовые операторы

- <<    сдвигает на 1 бит влево (умножение на 2)
- <<=   сдвиг-влево-равно
- >>    сдвиг вправо на 1 бит (деление на 2)
- >>=   сдвиг-вправо-равно (имеет смысл обратный <<=)
- &     по-битовое И (AND)
- &=    по-битовое И-равно
- |     по-битовое ИЛИ (OR)
- |=    по-битовое ИЛИ-равно
- ~     по-битовая инверсия
- !     по-битовое отрицание
- ^     по-битовое ИСКЛЮЧАЮЩЕЕ ИЛИ (XOR)
- ^=    по-битовое ИСКЛЮЧАЮЩЕЕ-ИЛИ-равно

## №38

Логические операторы

- &&    логическое И (and)
- ||    логическое ИЛИ (or)

## №39

Длина строки

```sh
${#string}
expr length $string
expr "$string" : '.*'
```

## №40

Длина подстроки в строке

```sh
expr match "$string" '$regsubstring'
expr "$string" : '$regsubstring'
```

## №41

Специальные переменные

- $#              количество аргументов командной строки
- $* и $@         содержат все аргументы командной строки
- $0 $1 $2 ${10}  позиционные параметры
- $?              код завершения последней выполненной команды, функции или сценария
- $$              id процесса
- $!              pid последнего, запущенного в фоне, процесса
- $_              последний аргумент предыдущей команды

## №42

Перенаправление вывода

- COMMAND_OUTPUT >      # Перенаправление stdout (вывода) в файл.
- : > filename          # Операция > усекает файл "filename" до нулевой длины
- #   (аналог команды touch)
- > filename            # Операция > усекает файл "filename" до нулевой длины
- COMMAND_OUTPUT >>     # Перенаправление stdout (вывода) в файл в режиме добавления
- 1>filename            # Перенаправление вывода (stdout) в файл "filename"
- 1>>filename           # Перенаправление вывода (stdout) в файл "filename", добавление
- 2>filename            # Перенаправление stderr в файл "filename"
- 2>>filename           # Перенаправление stderr в файл "filename", добавление
- &>filename            # Перенаправление stdout и stderr в файл "filename"
- 2>&1                  # Перенаправляется stderr на stdout
- i>&j                  # Перенаправляется файл с дескриптором i в j
- >&j                   # Перенаправляется  файл с дескриптором 1 (stdout) в файл с дескриптором j
- 0< FILENAME           # Ввод из файла
- < FILENAME            # Ввод из файла

## №43

Подавить весь вывод программы

```sh
find / > /dev/null 2>&1
```

## №44

Получить расширение файла

```sh
ext=${file_name##*.}
name=${file_name%.*}
```

## №45

Обрезать пробелы в начале и конце строки

```sh
trim() { echo $1; }

echo ">>$(trim 'right side    ')<<"
echo ">>$(trim '    left side')<<"
echo ">>$(trim '    both sides    ')<<"

>>right side<<
>>left side<<
>>both sides<<
```

## №46

Создать пустой файл или отчистить его содержимое

```sh
$ > file.txt
```

## №47

Выбрать все файлы кроме тех что подходят под шаблон

```sh
$ shopt extglob
extglob         off
$ ls
abar  afoo  bbar  bfoo
$ ls !(b*)
-bash: !: event not found
$ shopt -s extglob  #Enables extglob
$ ls !(b*)
abar  afoo
$ ls !(a*)
bbar  bfoo
$ ls !(*foo)
abar  bbar
```

## №48

Итерация по переданным аргументам

```sh
for var in "$@"
do
    echo "$var"
done
```

## №49

Сопоставляем переменную с шаблоном

```sh
if expr "$projectdesc" : "Unnamed repository.*$" >/dev/null
then
        projectdesc="UNNAMED PROJECT"
fi
```

## №50

Автоинкремент в bash

```sh
$ i=1
$ i=$[i+1]
$ echo $i

2
```

## №51

Заменить все вхождения слова в предыдущей команде и выполнить её

```sh
$ echo one two one three one one

one two one three one one

$ !!:gs/one/1

echo 1 two 1 three 1 1
1 two 1 three 1 1
```

## №52

Проверяем колличество переданных аргументов

```sh
EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {arg}"
  exit $E_BADARGS
fi
```

-----------
**Источники:**

- 1 - http://kvz.io
- 4 - http://stackoverflow.com
- 5-33 - http://stackoverflow.com
- 34-42 - http://user.su
- 44 - http://www.jasny.net
- 45 - http://stackoverflow.com
- 47 - http://stackoverflow.com
- 48 - http://stackoverflow.com
- 49 - https://github.com
- 52 - http://www.linuxweblog.com
