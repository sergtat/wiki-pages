# Разные советы по Vim
## Нумерация списка
1. Создать первый элемент списка, убедившись, что он начинается с числа.
2. qa        - начать запись в буфер 'a'.
3. Y         - скопировать элемент списка.
4. p         - вклеить копию элемента под первым.
5. CTRL-A    - увеличить число
6. q         - остановить запись
7. <число>@a - повторить копирование, вклейку и увеличение числа заданное <число> раз

## vim + openssl = удобное и безопасное хранилище приватной информации
1 - добавляем в свой .vimrc следующее
```
augroup aes256autocmd!autocmd BufReadPre,FileReadPre      *.aes set binautocmd BufReadPost,FileReadPost    *.aes '[,']!openssl enc -d -aes-256-cbcautocmd BufReadPost,FileReadPost    *.aes set nobinautocmd BufReadPost,FileReadPost    *.aes execute ":doautocmd BufReadPost " . expand("%:r")autocmd BufWritePost,FileWritePost  *.aes !mv <afile> <afile>:rautocmd BufWritePost,FileWritePost  *.aes !openssl enc -e -aes-256-cbc -in <afile>:r -out <afile>
```
```
autocmd FileAppendPre               *.aes !openssl enc -d -aes-256-cbc -in <afile> -out <afile>:rautocmd FileAppendPre               *.aes !mv <afile>:r <afile>autocmd FileAppendPost              *.aes !mv <afile> <afile>:rautocmd FileAppendPost              *.aes !openssl enc -e -aes-256-cbc -in <afile>:r -out <afile>augroup END
```
2 - открываем например
```
vim test.aes
```
добавляем туда строчку и сохраняем. у вас попросят пароль на кодирование.

3 - если после этого еще раз открыть этот test.aes то попросят ввести пароль на раскодирование

Предупреждение - исходный текстовый файл без расширения .aes автоматически не будет удален!

# Compose в VIM
В vim для таких целей есть удобная фича digraph (:help digraph).

Посмотреть таблицу символом с их кодами и мнемоническими сокращениями можно командой :digraph.

Символ копирайта можно вставить либо по коду CTRL+V 169 либо по мнемоническму сокращению CTRL+K Co.

