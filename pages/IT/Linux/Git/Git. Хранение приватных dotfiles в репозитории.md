# Хранение приватных dotfiles в git репозитории

1. Создаём приватный репозиторий на bitbucket.
2. Создаём bare git репозиторий локально:
```bash
cd repositories
git init --bare dotfiles
cd dotfiles
git remote add origin ssh://git@bitbucket.org/YOUR_LOGIN/dotfiles.git
```  
3.Всё ещё находясь в каталоге dotfiles, добавляем в список исключений * для исключения по-умолчанию всех файлов (иначе команды типа git status будут смотреть состояние всех файлов в домашнем каталоге):
```bash
echo '*' >> info/exclude
```  
4. Задаём текущий каталог как каталог репозитория, а домашний каталог – как рабочую копию:
```bash
export GIT_DIR=$PWD GIT_WORK_TREE=$HOME
```  
5. Переходим в домашний каталог и начинаем добавлять файлы (вызывая git add -f для добавления – так необходимо делать из-за игнорирования всех файлов по-умолчанию):
```bash
cd
git add -f .bashrc .config/git/ignore
```  
6. Коммитим:
```bash
git commit -m 'initial commit'
```  
7. Отправляем коммит в репозиторий на bitbucket:
```bash
git push --set-upstream origin master
```  
В дальнейшем можно будет использовать просто git push.

Для задания окружения, в котором можно выполнять операции с dotfiles, можно использовать простейший враппер, типа такого:
```bash
#!/bin/sh -eu
export GIT_DIR=$HOME/repositories/dotfiles
export GIT_WORK_TREE=$HOME
echo "Work with your dotfiles, then exit"
exec $(which bash)
```
> bitbucket выбран из-за того, что позволяет размещать приватные репозитории на бесплатных аккаунтах, github поддерживает такое лишь на платных аккаунтах.


