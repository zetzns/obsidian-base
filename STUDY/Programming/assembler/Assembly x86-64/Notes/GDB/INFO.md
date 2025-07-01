> [!check]
> После `GDB` запуска мы можем использовать `info` команду для просмотра общей информации о программе, например, ее функций или переменных.

### Функции

> [!check]
> Для начала мы воспользуемся `info`командой для проверки того, какие из них `functions`определены в двоичном файле:

  Отладчик GNU (GDB)

```shell-session
gef➤  info functions

All defined functions:

Non-debugging symbols:
0x0000000000401000  _start
```

Как видим, мы нашли нашу основную `_start`функцию.

#### Переменные

> [!check]
> Мы также можем использовать `info variables`команду для просмотра всех доступных переменных в программе:

  Отладчик GNU (GDB)

```shell-session
gef➤  info variables

All defined variables:

Non-debugging symbols:
0x0000000000402000  message
0x0000000000402012  __bss_start
0x0000000000402012  _edata
0x0000000000402018  _end
```