# Вещи, которые надо помнить о GIT на Windows.
1. Создавай алиасы:

	```bash
	git config alias.ci commit
	git config alias.co checkout
	git config alias.br branch
	git config alias.sh stash
	git config alias.st status
	```

Это в разы упрощает и ускоряет работу.

2. Устанавливай git для работы с консолью. Зачастую, работа с консолью удобнее работы через графический интерфейс.
3. Добавляй свой логин к url репозитория: user@host/repo, чтобы не вводить его каждый раз при обращении к серверу (fetch, pull).
4. Создай переменные окружения HOME = %USERPROFILE%\ и GIT_SSH = {TortoiseGit install dir}\TortoisePlink.exe, чтобы работать через консоль.
5. Имя домашней директории пользователя должно быть на английском. Опять же важно для работы с консолью.
6. Проверь наличие директории .ssh в домашней директории. Если её нет — создай и положи туда публичный ключ.
В этой директории должен лежать приватный ключ с именем id_rsa или id_rsa.ppk
7. Укажи настройки в конфигах:

	```bash
	git config --global user.name "ваше имя"
	git config --global user.email "ваша почта"
	git config --global core.autocrlf false
	git config --global core.safecrlf false
	```

	Подробнее: http://jenyay.net/Git/Autocrlf

8. Почитай литературу:

	http://dbanck.de/2009/10/08/github-windows-and-tortoisegit-part-1-installing-pulling/  
	http://habrahabr.ru/blogs/Git/125799/  
	http://githowto.com/
