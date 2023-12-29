# Этот файл можно скомпилировать в https://colab.google/

# About

Это текст финального ДЗ по курсу "Язык SQL"

В этой папке находятся:

|filename|description|comment|
|----|----|----|
|`readme.pdf`|you're reading me||
|`hw_1.pdf`|решение ДЗ-1||
|`dump.sql`|резервная копия БД||
|`phys_schema.xlsx`|физическая схема БД||
|`conc_schema.png`|концептуальная и логическая схема БД||
|`init_table.sql`|скрипт создания таблиц|только названия переменных, \n primary keys, datatypes, ограничения|
|`functions.sql`|внутрение функции||
|`triggers.sql`|триггеры||
|`fill_table.sql`|скрипт заполнения таблиц данными||
|`tests_triggers.sql`|проверки на срабатывание триггеров из `triggers.sql`||
|`examples_functions.sql`|примеры запросов с функциями из `functions.sql`||
|`transactions.sql`|примеры пользования БД||

Далее предлагается ознакомиться с файлом `hw_1.pdf` для погружения в контекст предметной области и для обзора физической схемы (также отдельно представлена в файле `phys_schema.xlsx`).
 
# Концептуальная и логическая схема БД

Логическая схема есть расширешние концептуальной (если в концептуальной есть только отношения и связи, то в логической есть атрибуты и конкретные связи между атрибутами конкретных отношений). 
Логическую схему см. в файле `schema.png`. 
(NB! атрибут `sku.warehouse_id_list` должен иметь тип `integer[]` (массив), а не `integer`)

# Нормальные формы

Recap требований:
* 1НФ: каждая ячейка содержит не более одного значения, нет дублей атрибутов;
* 2НФ: += каждый столбец НЕ-ключ зависит только отпервичного ключа;
* 3НФ: += не должно быть транзитивной функциональной зависимости;
* 4НФ: += устраняет многозначные зависимости (нельзя поделить ещё на таблицы).

Предвосхищая этот вопрос и стараясь действовать сколь возможно канонически, по построению все таблицы являются 4НФ. 

# Разворачивание БД (macOS 13.2.1 (22D68)): 

## psql installation
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
brew install postgresql
```
```
brew services start postgresql
```

## psql opening
```
    psql postgres
```

## DB init
```
create database ecom;
```

Можно воспользоваться полной установкой «под ключ»:
(Запускаем в отдельном терминале.)

```
psql -d ecom -f \i /Users/ddpp/Documents/hse/sql/hw/final/dump.sql;
```
Либо прогнать создание с нуля: 
(В изначальном терминале, с postgres. Далее описание этого сценария.)

Расчищаем себе поле:
```
\q
```
```
psql postgres
```
```
drop database ecom;
```
```
create database ecom;
```
```
\c ecom;
``` 

## DB config

```
\i /Users/ddpp/Documents/hse/sql/hw/final/init_table.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/functions.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/triggers.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/fill_table.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/tests_triggers.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/examples_functions.sql;
\i /Users/ddpp/Documents/hse/sql/hw/final/transactions.sql;
```

(Признаюсь честно, я хотел сначала взять данные с работы, но потом передумал и решил заполнить вручную: поэтому id принимают такие ''atrificial'' значения.)

## Вместо послесловия

Я увлёкся и настолько хорошо закомментировал свой код, что теперь писать что-то в отчёте явно redundant. 
При чтении скриптов в соответствии с таблицей выше, разворачивание БД идёт естественно и с большим объёмом описаний.