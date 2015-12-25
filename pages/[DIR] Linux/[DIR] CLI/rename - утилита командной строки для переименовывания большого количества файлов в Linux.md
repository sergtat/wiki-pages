# Rename - утилита командной строки для переименовывания большого количества файлов в Linux
> Оригинал: Rename - A Command Line Tool For Renaming Multiple Files in Linux  
>	Автор: Ravi Saive  
>	Дата публикации: 10 октября 2013 года  
>	Перевод: А. Кривошей  
>	Дата перевода: апрель 2014 г.

Для переименования единичного файла в Linux мы часто используем команду "mv". Однако переименование таким способом большого количества файлов займет много времени.

В Linux имеется очень мощная встроенная утилита rename, которая используется для перименовывания большого количества файлов, изменения регистра в их названиях с помощью выражений на perl.

Команда `rename` - это часть скрипта Perl, расположенного в "/usr/bin/" практически во всех дистрибутивах Linux. Вы можете использовать команду "which", чтобы посмотреть, где находится команда rename.

```bash
$ which rename
/usr/bin/rename
```

## Базовый синтаксис команды rename

	rename 's/old-name/new-name/' files

Команда rename, помимо обязательного выражения perl, имеет несколько опциональных аргументов, которые позволяют более тонко настроить ее работу.

	rename [ -v ] [ -n ] [ -f ] perlexpr [ files ]

* -v: выводить имена успешно переименованных файлов.
* -n: показать, какие файлы будут переименованы.
* -f: принудительно перезаписать существующие файлы.
* perlexpr: выражение Perl.

Для лучшего понимания работы этой утилиты мы рассмотрим несколько практических примеров

1. Простой пример использования rename
	Предположим, у вас есть куча файлов с расширением ".html", и вы хотите изменить их расширение на ".php". Сначала я вывожу их список с помощью команды "ls -l":
	
		# ravisaive@tecmint:~$ ls -l
		total 22532
		-rw-rw-r-- 1 ravisaive ravisaive 6888896 Oct 10 12:10 cricket.html
		-rw-rw-r-- 1 ravisaive ravisaive  588895 Oct 10 12:10 entertainment.html
		-rw-rw-r-- 1 ravisaive ravisaive 6188895 Oct 10 12:10 health.html
		-rw-rw-r-- 1 ravisaive ravisaive 6538895 Oct 10 12:10 lifestyle.html
		-rw-rw-r-- 1 ravisaive ravisaive  938895 Oct 10 12:10 news.html
		-rw-rw-r-- 1 ravisaive ravisaive  938937 Oct 10 12:11 photos.html
		-rw-rw-r-- 1 ravisaive ravisaive  978137 Oct 10 12:11 sports.html
	
	Для пакетного переименовывания я использую команду "rename" с perl-выражением, как показано ниже.
	
		ravisaive@tecmint:~$ rename 's/\.html$/\.php/' *.html
	
	Приведенная выше команда имеет два аргумента.
	- Первый аргумент, это perl-выражение, которое подставляет .php вместо .html.
	- Второй аргумент указывает, что эту подстановку необходимо произвести для всех файлов с расширением .html.
	
	Проверим результат выполнения команды:
	
		ravisaive@tecmint:~$ ls -l
		total 22532
		-rw-rw-r-- 1 ravisaive ravisaive 6888896 Oct 10 12:10 cricket.php
		-rw-rw-r-- 1 ravisaive ravisaive  588895 Oct 10 12:10 entertainment.php
		-rw-rw-r-- 1 ravisaive ravisaive 6188895 Oct 10 12:10 health.php
		-rw-rw-r-- 1 ravisaive ravisaive 6538895 Oct 10 12:10 lifestyle.php
		-rw-rw-r-- 1 ravisaive ravisaive  938895 Oct 10 12:10 news.php
		-rw-rw-r-- 1 ravisaive ravisaive  938937 Oct 10 12:11 photos.php
		-rw-rw-r-- 1 ravisaive ravisaive  978137 Oct 10 12:11 sports.php
2. Проверка изменений перед запуском команды rename
	При выполнении критичных или важных задач по переименовыванию, вы всегда можете сначала проверить, какие изменения будут внесены, запустив команду "rename" с аргументом "-n", который позволяет просмотреть изменения, не применяя их к реальным файлам. Пример команды ниже.

		ravisaive@tecmint:~$ rename -n 's/\.php$/\.html/' *.php
		cricket.php renamed as cricket.html
		entertainment.php renamed as entertainment.html
		health.php renamed as health.html
		lifestyle.php renamed as lifestyle.html
		news.php renamed as news.html
		photos.php renamed as photos.html
		sports.php renamed as sports.html
3. Показ вывода Rename
	Мы видим, что команда rename не выводит никакой информации о сделанных ею изменениях. Поэтому, если вы хотите видеть такую информацию, для вывода подробных сведений обо всех сделанных изменениях необходимо использовать опцию "-v".
	
		ravisaive@tecmint:~$ rename -v 's/\.php$/\.html/' *.php
		cricket.php renamed as cricket.html
		entertainment.php renamed as entertainment.html
		health.php renamed as health.html
		lifestyle.php renamed as lifestyle.html
		news.php renamed as news.html
		photos.php renamed as photos.html
		sports.php renamed as sports.html
4. Преобразование нижнего регистра в верхний и наоборот
	Например, у меня есть следующие файлы.
	
		ravisaive@tecmint:~$ ls -l
		total 22532
		-rw-rw-r-- 1 ravisaive ravisaive 6888896 Oct 10 12:10 cricket.html
		-rw-rw-r-- 1 ravisaive ravisaive  588895 Oct 10 12:10 entertainment.html
		-rw-rw-r-- 1 ravisaive ravisaive 6188895 Oct 10 12:10 health.html
		-rw-rw-r-- 1 ravisaive ravisaive 6538895 Oct 10 12:10 lifestyle.html
		-rw-rw-r-- 1 ravisaive ravisaive  938895 Oct 10 12:10 news.html
		-rw-rw-r-- 1 ravisaive ravisaive  938937 Oct 10 12:11 photos.html
		-rw-rw-r-- 1 ravisaive ravisaive  978137 Oct 10 12:11 sports.html
	
	Для пакетного изменения регистра в названиях файлов с нижнего на верхний используется следующая команда с выражением perl:
	
		ravisaive@tecmint:~$ rename 'y/a-z/A-Z/' *.html
	
	Проверим результат выполнения команды:
	
		ravisaive@tecmint:~$ ls -l
		total 22532
		-rw-rw-r-- 1 ravisaive ravisaive 6888896 Oct 10 12:10 CRICKET.HTML
		-rw-rw-r-- 1 ravisaive ravisaive  588895 Oct 10 12:10 ENTERTAINMENT.HTML
		-rw-rw-r-- 1 ravisaive ravisaive 6188895 Oct 10 12:10 HEALTH.HTML
		-rw-rw-r-- 1 ravisaive ravisaive 6538895 Oct 10 12:10 LIFESTYLE.HTML
		-rw-rw-r-- 1 ravisaive ravisaive  938895 Oct 10 12:10 NEWS.HTML
		-rw-rw-r-- 1 ravisaive ravisaive  938937 Oct 10 12:11 PHOTOS.HTML
		-rw-rw-r-- 1 ravisaive ravisaive  978137 Oct 10 12:11 SPORTS.HTML
	
	Похожим образом можно сделать обратное преобразование - из верхнего региста в нижний.
	
		ravisaive@tecmint:~$ rename 'y/A-Z/a-z/' *.HTML
		ravisaive@tecmint:~$ ls -l
		total 22532
		-rw-rw-r-- 1 ravisaive ravisaive 6888896 Oct 10 12:10 cricket.html
		-rw-rw-r-- 1 ravisaive ravisaive  588895 Oct 10 12:10 entertainment.html
		-rw-rw-r-- 1 ravisaive ravisaive 6188895 Oct 10 12:10 health.html
		-rw-rw-r-- 1 ravisaive ravisaive 6538895 Oct 10 12:10 lifestyle.html
		-rw-rw-r-- 1 ravisaive ravisaive  938895 Oct 10 12:10 news.html
		-rw-rw-r-- 1 ravisaive ravisaive  938937 Oct 10 12:11 photos.html
		-rw-rw-r-- 1 ravisaive ravisaive  978137 Oct 10 12:11 sports.html
5. Перезапись существующих файлов
	Если вы хотите принудительно перезаписать существующие файлы, используйте опцию "-f", как показано ниже.
	
		ravisaive@tecmint:~$ rename -f 's/a/b/' *.html

Для получения более подробной информации о команде rename можно почитать ее man-страницу, введя в терминале "man rename".

Команда rename очень полезна, если вам приходится иметь дело с пакетной обработкой файлов в командной строке. 
