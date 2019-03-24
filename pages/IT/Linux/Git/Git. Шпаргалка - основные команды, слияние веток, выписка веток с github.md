# Git. Шпаргалка - основные команды, слияние веток, выписка веток с github.

_**Шпаргалка по git. Пошаговое руководство: как выполнить слияние веток в git, как создать новую ветку и репозиторий, как выписать ветку с github и т.п. Инструкции по git для начинающих.**_

Git — это распределенная система контроля версий. Это главное отличие git от svn. Каждый разработчик создает на своем компьютере отдельный, полноценный репозиторий.

В рамках этого репозитория можно делать все тоже самое, что и обычно в svn — создавать ветки, просматривать изменения, выполнять коммиты. Для того, чтобы можно было работать с удаленными репозиториями и обмениваться изменениями с другими разработчиками, в git есть две команды, не имеющие аналогов в svn — `git push` и `git pull`.

`git push` — вливание локальных изменений в удаленный репозиторий.

`git pull` — вливание изменений из удаленного репозитория в локальный. Обмен данными обычно происходит с использованием протокола SSH.

Git поддерживают несколько крупных репозиториев — GitHub, SourceForge, BitBucket и Google Code. Удобно использовать один из них в качестве основного хранилища для корпоративных проектов.

## Пошаговые рекомендации

### Как выписать репозиторий с github

1. Создаем новую директорию для проекта project_name, переходим в нее.
2. Выполняем команду:

```bash
git clone git@github.com:devlabuser/sharp.git ./
```

«./» означает, что создать репозиторий нужно в текущей директории.

Результат: каталог с выписанной веткой master. Теперь можно создавать новые ветки, или выписывать с github существующие.

### Как выписать ветку с github

С помощью команды «checkout» можно выписать уже существующую ветку с github:

```bash
$ git checkout -b dev origin/dev
$ git checkout -b project_branch origin/project_branch
```

Или так, что намного надежнее:
	
```bash
$ git checkout --track origin/production
```

Если команда не сработала, нужно попробовать выполнить обновление:
	
```bash
$ git remote update
```

Если вышеприведенные команды не сработали, выдали ошибку, и времени разбираться с ней нет, можно попробовать получить нужную ветку следующим способом:

```bash
git checkout -b project_branch
git pull origin project_branch
```
Т.е. сначала мы создаем новую ветку, а затем вливаем в нее изменения из ветки на github.

### Как создать новую ветку в локальном репозитории

Создаем новую ветку в локальном репозитории:
    	
```bash
$ git checkout -b dev
Switched to a new branch 'dev'
```
    Публикуем ее на github:
    	
```bash
$ git push origin dev
Total 0 (delta 0), reused 0 (delta 0)
To git@github.com:devlabuser/sharp.git
  * [new branch]      dev -> dev
```

### Как переключиться на другую ветку в git

```bash
$ git checkout project2_branch
```

Если вы случайно удалили какой-то файл, можно извлечь его из хранилища:

```bash
$ git checkout readme.txt
```

### Как посмотреть список веток

Команда «branch» позволяет посмотреть список веток в локальном репозитории. Текущая ветка будет помечена звездочкой:

```bash
$ git branch
* dev
  master
```

### Как сделать commit

Создаем новую ветку, выполняем в ней нужные изменения.

Список всех измененных и добавленных файлов можно просмотреть командой:
    	
```bash
$ git status
```

Подготавливаем коммит, добавляя в него файлы командой:
    	
```bash
$ git add <file1> <file2> ...
```

Или удаляем устаревшие файлы:

```bash
$ git rm <file1> <file2> ...
```

Выполняем коммит:

```bash
$ git commit -m 'Комментарий к коммиту'
```

Как правило, в репозитории существует две основные ветки — dev и master. Dev — общая ветка разработчиков и тестировщиков. Именно в нее добавляются все новые разработки перед очередным релизом. Master — ветка для выкладки продукта на боевые сервера.

После коммита надо влить в нашу ветку изменения из ветки dev и master:

```bash
$ git pull origin dev 
$ git pull origin master
```

Теперь наша ветка содержит изменения для проекта, и все последние изменения по другим задачам, которые успела внести команда.

Переключаемся на ветку dev:

```bash
$ git checkout dev
```

Вливаем в dev изменения из ветки проекта:

```bash
$ git merge project_branch
```

Заливаем последнюю версию ветки dev на удаленный сервер:

```bash
$ git push origin dev
  
Counting objects: 4, done.
Delta compression using up to 2 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 286 bytes, done.
Total 3 (delta 0), reused 0 (delta 0)
To git@github.com:devlab/sharp.git
    d528335..9a452d9  dev -> dev
```

push может не пройти, потому что удалённый origin/dev обогнал локальную его копию.

### Как решить конфликт бинарных файлов

Допустим, при слиянии с другой веткой git выдал ошибку. Команда git status возвращает информацию о конфликте:

```bash
$ git status
...
Unmerged paths:
  (use "git add <file>..." to mark resolution)
 
        both modified:      root/css/styles.css.gz
 
 
$ git diff root/css/styles.css.gz
diff --cc root/css/styles.css.gz
index 970c721,bc6d170..0000000
Binary files differ
```

Конфликтный файл является бинарным (это могут быть архивные файлы, изображения и т.п.), и решение конфликта стандартным способом, с помощью редактирования — не возможно.

Чтобы решить такой конфликт, надо просто выбрать — какая версия файла будет использоваться: ваша или из вливаемой ветки. Чтобы использовать свой вариант файла, вводим команду:

```bash
git checkout --ours binary.dat
git add binary.dat
```

Если мы выбираем версию из вливаемой ветки:

```bash
git checkout --theirs binary.dat
git add binary.dat
```

«ours» — от английского «наш», «theirs» — от английского «их».

### Как посмотреть историю изменений

```bash
$ git log
commit 9a452d9cdbdb57e7e4f2b09f8ce2f776cd56657a
Author: DevLab User <user@mail.ru>
Date:   Wed Jul 31 18:35:47 2013 +0400
 
    first commit
 
commit d528335724dfc15461996ed9d44d74f23ce6a075
Author: DevLab User <user@mail.ru>
Date:   Wed Jul 31 06:24:57 2013 -0700
 
    Initial commit
```

Вывод данных о каждом коммите в одну строку:
	
```bash
git log --pretty=oneline
 
9a452d9cdbdb57e7e4f2b09f8ce2f776cd56657a first commit
d528335724dfc15461996ed9d44d74f23ce6a075 Initial commit
```

Для вывода информации git log использует просмотрщик, указанный в конфиге репозитория.

Поиск по ключевому слову в комментариях к коммиту:

```bash
$ git log | grep -e "first"
    first commit
```

Команда «git show» позволяет просмотреть, какие именно изменения произошли в указанном коммите:

```bash
$ git show 99452d955bdb57e7e4f2b09f8ce2fbb6cd56377a
 
commit 99452d955bdb57e7e4f2b09f8ce2fbb6cd56377a
Author: DevLab User <user@mail.ru>
Date:   Wed Jul 31 18:35:47 2013 +0400
 
    first commit
 
diff --git a/readme.txt b/readme.txt
new file mode 100644
index 0000000..4add785
--- /dev/null
+++ b/readme.txt
@@ -0,0 +1 @@
+Text
\ No newline at end of file
```

Можно посмотреть построчную информацию о последнем коммите, имя автора и хэш коммита:

```bash
$ git blame README.md
 
^d528335 (devlabuser 2013-07-31 06:24:57 -0700 1) sharp
^d528335 (devlabuser 2013-07-31 06:24:57 -0700 2) =====
```

git annotate, выводит измененные строки и информацию о коммитах, где это произошло:

```bash
$ git annotate readme.txt
9a452d9c        (DevLab User      2013-07-31 18:35:47 +0400       1)Text
```

### Как сделать откат

git log — просмотр логов, показывает дельту (разницу/diff), привнесенную каждым коммитом.

```bash
$ git log
commit 9a452d9cdbdb57e7e4f2b09f8ce2f776cd56657a
Author: devlabuser <user@mail.ru>
Date:   Wed Jul 31 18:35:47 2013 +0400

  first commit

commit d528335724dfc15461996ed9d44d74f23ce6a075
Author: devlabuser <user@mail.ru>
Date:   Wed Jul 31 06:24:57 2013 -0700

  Initial commit
```

Копируем идентификатор коммита, до которого происходит откат.

Откатываемся до последнего успешного коммита (указываем последний коммит):

```bash
$ git reset --hard 9a452d955bdb57e7e4f2b09f8ce2fbb6cd56377a
HEAD is now at 9a45779 first commit
```

Можно откатить до последней версии ветки:

```bash
$ git reset --hard origin/dev
HEAD is now at 9a45779 first commit
```

После того, как откат сделан, и выполнен очередной локальный коммит, при попытке сделать push в удаленный репозиторий, git может начать ругаться, что версия вашей ветки младше чем на github и вам надо сделать pull. Это лечится принудительным коммитом:

```bash
git push -f origin master
```

### Как выполнить слияние с другой веткой

git merge выполняет слияние текущей и указанной ветки. Изменения добавляются в текущую ветку.

```bash
$ git merge origin/ticket_1001_branch
```

git pull забирает изменения из ветки на удаленном сервере и проводит слияние с активной веткой.

```bash
$ git pull origin ticket_1001_branch
```

git pull отличается от git merge тем, что merge только выполняет слияние веток, а pull прежде чем выполнить слияние — закачивает изменения с удаленного сервера. merge удобно использовать для слияния веток в локальном репозитории, pull — слияния веток, когда одна из них лежит на github.

 
### Создание нового локального репозитория

```bash
$ mkdir project_dir
$ cd project_dir
$ git init
```

### git cherry-pick

git cherry-pick помогает применить один-единственный коммит из одной ветки к дереву другой.

Для этого нужно выписать ветку, в которую будем вливать коммит:

```bash
git checkout master
```

Обновить ее:

```bash
git pull origin master
```

Выполнить команду, указать код коммита:

```bash
git cherry-pick eb042098a5
```

После этого обновить ветку на сервере:

```bash
git push origin master
```

### Как раскрасить команды git

После создания репозитория в текущей директории появится субдиректория .git . Она содержит файл config .

```bash
[core]
        repositoryformatversion = 0
        filemode = true
        bare = false
        logallrefupdates = true
[remote "origin"]
        fetch = +refs/heads/*:refs/remotes/origin/*
        url = git@github.com:devlab/sharp.git
[branch "master"]
        remote = origin
        merge = refs/heads/master
[branch "dev"]
        remote = origin
        merge = refs/heads/dev
```

Чтобы раскрасить вывод git, можно добавить в файл блок [color]:

```bash
[color]
        branch = auto
        diff = auto
        interactive = auto
        status = auto
        ui = auto
```

## Полезные ссылки по теме git

- [Основы работы с Git](http://www.calculate-linux.ru/main/ru/git)
- [Моя шпаргалка по работе с Git](http://eax.me/git-commands/)
- [Pro Git book, written by Scott Chacon. Русский перевод.](http://git-scm.com/book/ru)

**Источник**: https://habrahabr.ru
