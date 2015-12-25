# Обзор и настройка расширения Unite
Unite позволяет заменить просто огромное количество плагинов для Vim. Unite сочетает в себе функционал таких расширений как: CtrlP, FuzzyFinder, ack, yankring, LustyJuggler, buffer explorer и т.д.

##Установка Unite

Прежде чем приступить к настройке расширения необходимо установить зависимости. Я использую Vundle, поэтому устанавливать будем через него. Для доступа к некоторым функциям Unite необходим плагин vimproc. Для этого добавим следующие строчки в наш файл .vimrc:

```vim
Bundle 'Shougo/Vimproc.vim'
Bundle 'Shougo/unite.vim' 
```
Перезапускаем редактор и вводим команду `:BundleInstall`. Откомпилируем vimproc:

```bash
cd ~
cd .vim/bundle/Vimproc.vim
make -f make_mac.mak # тут зависит от платформы, для Linux: make_unix.mak
```
Установка всех зависимостей завершена, переходим к настройке Unite. Давайте добавим следующие строки в vimrc:

```vim
" Автоматический insert mode
let g:unite_enable_start_insert = 1

" Отображаем Unite в нижней части экрана
let g:unite_split_rule = "botright"

" Отключаем замену статус строки
let g:unite_force_overwrite_statusline = 0

" Размер окна Unite
let g:unite_winheight = 10

" Красивые стрелочки
let g:unite_candidate_icon="▷"
```

Ознакомимся с некоторыми командами Unite:

`Unite file` - открыть список файлов и директории в текущем проекте  
`Unite buffer` - показать открытые буферы  
`Unite file buffer` - показать файлы и открытые буферы

Команда Unite так же поддерживает опции, например запустив Unite с опцией `-auto-preview` мы запустим Unite с функцией предпросмотра файлов (как в Sublime).

Если вам нужно ходить по файлам рекурсивно, то есть осуществлять поиск по текущему проекту просто вводя начальные буквы файла как в CtrlP и Command-T, для этого достаточно запустить Unite с флагом `file_rec/async`, хочу предупредить что без сборки vimproc данная опция работать не будет:

    Unite file_rec/async

Что бы поиск происходил по первым введенным буквам нужно добавить опцию `-start-insert`:

    Unite file_rec/async -start-insert

И наконец конечный результат команды, которую я привязал к комбинации leader+f

    nnoremap <leader>f :<C-u>Unite -buffer-name=files -start-insert buffer file_rec/async:!<cr>

Скриншот редактора с запущенным Unite

![](/images/Linux/Vim/Unite-1.png)

У Unite есть так же и командный режим, который запускается нажатием клавиши `Ctrl+i` в открытом буфере Unite. Командный режим позволяет создавать и сравнивать файлы, директории, создавать закладки, выполнять grep и т. д. Кстати, посмотреть список закладок можно командой `:Unite bookmark`, а добавить файл в закладки можно из командного режима.

##Создаем собственное меню в Unite
В Unite есть возможность создавать собственное меню. Пример использования:

```vim
let g:unite_source_menu_menus = {}
let g:unite_source_menu_menus.mymenu = {
            \     'description' : 'My Unite menu',
            \ }
let g:unite_source_menu_menus.mymenu.candidates = {
            \   'mru&buffer'      : 'Unite buffer file_mru',
            \   'tag'      : 'Unite tag',
            \   'file'      : 'Unite file',
            \   'file_rec'      : 'Unite file_rec',
            \   'file_rec/async'      : 'Unite file_rec/async',
            \   'find'      : 'Unite find',
            \   'grep'      : 'Unite grep',
            \   'register'      : 'Unite register',
            \   'bookmark'      : 'Unite bookmark',
            \   'output'      : 'Unite output',
            \ }
function g:unite_source_menu_menus.mymenu.map(key, value)
    return {
            \       'word' : a:key, 'kind' : 'command',
            \       'action__command' : a:value,
            \ }
endfunction
```
Запустить меню можно командой

    :Unite menu:mymenu

##Еще несколько примеров работы Unite
Поиск по файлу как в CtrlP

    :Unite file_rec/async

![](/images/Linux/Vim/Unite-2.gif)

Поиск как в ack.vim

    :Unite grep:.

![](/images/Linux/Vim/Unite-3.gif)

Поиск по истории как в yankring/yankstack

    let g:unite_source_history_yank_enable = 1
    :Unite history/yank

![](/images/Linux/Vim/Unite-4.gif)

Переключение буферов как в LustyJuggler

    :Unite -quick-match buffer

![](/images/Linux/Vim/Unite-5.gif)

[Страница проекта](https://github.com/Shougo/unite.vim)

P.S.

Для полного счастья еще стоит упомянуть возможность создания различных меню, т.к. многие операции удобнее вешать не на разные «хот-кеи», а на одну комбинацию. Например, работа с буферами, табами, сплитами и т.п. у меня висит на сочетании <leader>w

![](/images/Linux/Vim/Unite-6.png)

а поиск по файлам висит на <leader>f

![](/images/Linux/Vim/Unite-7.png)

И так сгруппированы все необходимые вещи — VCS, кодировки, размеры табуляции, выбор синтаксиса, вызовы спелчекеров, анализа кода, смена подсветки синтаксиса и т.д. и т.п.

Вызов всех меню происходит с `-start-insert`, что позволяет почти мгновенно выбрать необходимый пункт, а часто используемые операции привязаны к своим кобинациям клавиш.

Плюс к этому, если после отпуска или праздников забыл, что на что повешано, то всегда можно вызвать глобальное меню по всем созданным меню.

    :Unite menu

Короче, меню — это одна из самых клевых штук в Unite.
