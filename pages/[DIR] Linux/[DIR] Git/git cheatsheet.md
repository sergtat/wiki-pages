#git cheatsheet

комманда | действие
---------|---------
git init | инициализация (создание) репозитория
git status | проверка состояния
git log | просмотр истории
git log --all | просмотр всей истории всех веток
git log -p | просмотр истории с `diff` файлов
git log -p -2 | то же, 2 последних коммита
git log --word-diff | показывать изменения на уровне слов
git log --stat | для каждого коммита дополнительно выводить </br>статистику по изменённым файлам
git log --shortstat | показывать только строку changed/insertions/deletions </br>от вывода с опцией --stat
git log --name-only | показывать список изменённых файлов после информации о коммите
git log --name-status | выводить список изменённых файлов </br>вместе с информацией о добавлении/изменении/удалении
git log --graph | показывать ASCII-граф истории ветвлений и </br>слияний рядом с выводом лога.
git log --pretty | отображать коммиты в альтернативном формате. </br>Возможные параметры: oneline, short, full, fuller и </br>format (где вы можете указать свой собственный формат)
git hist | см. [Алиасы Git](#gitalias)
git hist --max-count=1 | показать последний коммит
git cat-file -t <hash> | тип объекта <hash>
git cat-file -p <hash> | дамп объекта <hash>
git cat-file -p <treehash> | дамп объекта <treehash>
git cat-file -p <blob> | дамп объекта <blob>
git diff | просмотр непроиндексированных изменений
git diff --cached | просмотр проиндексированных изменений
git diff --staged | просмотр проиндексированных изменений
git add <file> | добавление (индексирование) <file> в репозиторий
git add . | добавление (индексирование) всех изменений в репозиторий
git commit -m <comment>| коммит изменений с комментарием в ком.строке
git commit --amend -m <comment> | внесение изменений в коммиты
git commit | коммит изменений с комментарием в редакторе
git commit -a --status | выполняет необходимые `git add`, `git mv`, `git mv`,</br>делает `git commit` и за тем `git status`
git tag | листинг доступных тегов
git tag <tag> | создание тега версии
git tag -d <tag> | удаление тега версии
git checkout <hash> &#124; <tag> | переход в точку <hash> или <tag>
git checkout <ver>^  | возврат к предыдущей версии
git checkout <ver>~1 | возврат к предыдущей версии
git checkout master  | возврат к последней версии в ветке master
git checkout <branch>  | переход к последней версии в ветке <branch>
git checkout <file> | отмена локальных изменений (до индексации)
git reset HEAD <file> | отмена проиндексированных изменений (перед коммитом)
git revert HEAD | отмена коммитов
git reset --hard <ver> | сброс коммитов до ветки <ver>
git mv <file> <dir/file> | перемещение и индексирование файла
git rm <file> | удаление файла
git rm --cached <file> | удаление файла из индекса
git branch | доступные ветки
git branch -a | все доступные ветки
git branch <name> | создание ветки <name>
git checkout -b <name> | создание ветки <name> и переход в нее
git merge master | слияние с веткой master
git rebase master | перебазирование в ветку master
git clone <repo> <newrepo> | клонирование репозитория <repo> в <newrepo>
git remote | Узнать об именахизвлекать изменения из удаленного </br>репозитория удаленных репозиториев
git remote show origin | получить более подробную информацию об имени по умолчанию
git fetch | извлечение изменения из удаленного репозитория
git merge origin/master | слияние извлеченных изменений с веткой </br>master
git pull | извлечение изменений и слияние с веткой master
git branch --track <name> <origin/name> | добавить локальную ветку,</br> которая отслеживает удаленную ветку
git clone --bare <repo> <newrepo.git> | создание (клонирование) </br>чистого репозитория
git remote add shared <repo> | добавляем чистый репозиторий в качестве </br>удаленного репозитория к нашему оригинальному репозиторию
git push shared master | отправляем изменения в удаленный репозиторий

##Установки Git
###Имя и электронная почта
```sh
git config --global user.name "Your Name"
git config --global user.email "your_email@whatever.com"
```
###Окончание строк
***Wwindows:***
```sh
git config --global core.autocrlf true
git config --global core.safecrlf true
```
***Unix/Mac:***
```sh
git config --global core.autocrlf input
git config --global core.safecrlf true
```
###Редактор и утилита сравнения
Редактор выбирается из следующего списка (в порядке приоритета):

- переменная среды GIT_EDITOR
- параметр конфигурации core.editor
- переменная среды VISUAL
- переменная среды EDITOR

```sh
git config --global core.editor vim
git config --global merge.tool vimdiff
```
###Варианты git log
```sh
git log --pretty=oneline
git log --pretty=oneline --max-count=2
git log --pretty=oneline --since='5 minutes ago'
git log --pretty=oneline --until='5 minutes ago'
git log --pretty=oneline --author=<your name>
git log --pretty=oneline --all
git log --all --pretty=format:"%h %cd %s (%an)" --since='7 days ago'
git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short
```
<a name='gitalias'></a>
###Алиасы Git
***Windows***
```sh
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.br branch
git config --global alias.hist 'log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short'
git config --global alias.type 'cat-file -t'
git config --global alias.dump 'cat-file -p'
```
***Unix/Mac
В файле $HOME/.gitconfig:
```sh
[alias]
  co = checkout
  ci = commit
  st = status
  br = branch
  hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
  type = cat-file -t
  dump = cat-file -p
```
###Проверка настроек
```sh
git config --list
git config user.name
```
###Алиасы команд (опционально)
```sh
alias got='git'
alias get='git'
alias gs='git status'
alias ga='git add'
alias gal='git add .'
alias gb='git branch'
alias gc='git commit'
alias gca='git commit -a --status'
alias gcam='git commit -a --status -m'
alias gd='git diff'
alias go='git checkout'
alias gom='git checkout master'
alias gh='git hist'
alias gha='git hist --all'
alias ghm='git hist master --all'
alias gk='gitk --all&'
```
##Git-crypt
```sh
git-crypt keygen /path/to/keyfile
cd repo
git-crypt init /path/to/keyfile
```
Создаем .gitattributes
```sh
secretfile1 filter=git-crypt diff=git-crypt
secretfile2 filter=git-crypt diff=git-crypt
*.secret filter=git-crypt diff=git-crypt
```
Клонируем репозиторий с зашифрованными файлами

```sh
git clone /path/to/repo
cd repo
git-crypt init /path/to/keyfile
```
