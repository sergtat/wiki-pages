# Управление несколькими учетными записями Github.

_**Давайте рассмотрим, как управлять несколькими учетными записями Github с одного компьютера. По сути, это просто вопрос балансировки обеих конфигураций git и ssh, что на самом деле не так плохо, как может показаться.**_

## Создание SSH-ключей.

Предположим, что ваши две учетные записи Github называются githubPersonal и githubWork, соответственно.

Создадим две пары ssh-ключей сохранив их в различные файлы:

```bash
$ cd ~/.ssh
$ ssh-keygen -t rsa -C "your_email@associated_with_githubPersonal.com"
# save it as id_rsa_personal when prompted
$ ssh-keygen -t rsa -C "your_email@associated_with_githubWork.com"
# save it as id_rsa_work when prompted
```

Эти команды создадут следующие файлы:

- id_rsa_personal
- id_rsa_personal.pub
- id_rsa_work
- id_rsa_work.pub

## Добавление ключей в Github-аккаунты.

Скопируем ключ в буфер обмена:

```bash
$ xcopy -i < ~/.ssh/id_rsa_personal.pub
```

Добавим ключ в свой аккаунт:

1. Зайти в аккаунт.
2. Выбрать "SSH Keys", затем "Add SSH key".
3. Скопировать ключ в поле "Key" и добавить соответствующий заголовок.
4. Выбрать "Add key", затем ввести пароль аккаунта для подтверждения.

Повторить все для аккаунта githubWork.

## Создание файла конфигурации для управления ключами.

Создадим файл конфигурации `~/.ssh/config`.

```bash
touch ~/.ssh/config
```

Редактируем в редакторе. Я использую vim: `vim ~/.ssh/config`:

```bash
# githubPersonal
Host personal
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa_personal

# githubWork
Host work
   HostName github.com
   User git
   IdentityFile ~/.ssh/id_rsa_work
```

## Обновление ssh-идентификаторов.

Очистим сохраненные идентификаторы;

```bash
$ ssh-add -D
```

Добавим наши новые ключи:

```bash
$ ssh-add id_rsa_personal
$ ssh-add id_rsa_work
```

Проверим, что ключи сохранены:

```bash
$ ssh-add -l
```

Проверим, что Github распознает ключи правильно:

```bash
$ ssh -T personal
Hi githubPersonal! You've successfully authenticated, but GitHub does not provide shell access.

$ ssh -T work
Hi githubWork! You've successfully authenticated, but GitHub does not provide shell access.
```

## Test PUSH

Создадим новый репозиторий `test-personsl`на GitHub в нашем домашнем аккаунте - `githubPersonal`.

Вернемся на локальную машинути создадим тестовую директорию:

```bash
$ cd ~/documents
$ mkdir test-personal
$ cd test-personal
```

Добавим пустой `readme.md` файл и сделаем PUSH на Github:

```bash
$ touch readme.md
$ git init
$ git add .
$ git commit -am "first commit"
$ git remote add origin git@personal:githubPersonal/test-personal.git
$ git push origin master

    Notice how we’re using the custom account, git@personal, instead of git@github.com.
```

Повторим для рабочего `githubWork` аккаунта.

## Test PULL

Добавим какой-нибудь текст в `readme.md` файл в `githubPersonal` аккаунте на Github.

Теперь вернемся на локальную машину и сделаем PULL и объединим изменения, выполнив следующую команду в тестовой директории:

```bash
$ git pull origin master
```

Повторим для `githubWork` аккаунта.

**Источник**: Перевод с https://mherman.org/
