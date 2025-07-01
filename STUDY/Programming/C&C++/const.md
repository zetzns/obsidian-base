> [!info] 
> Вы можете использовать ключевое слово `const` с переменной, чтобы сообщить компилятору о том, что значение этой переменной не должно быть изменено после ее первой инициализации. Давайте рассмотрим простой пример ниже, чтобы понять, как работает `const`:

```c
#include <stdio.h>
#include <stdio.h>

void main() {
  uint32_t const number = 10;
  uint32_t value;
  value = number * 2;
  printf( “ The variable value is : %d\n”, value );
}
```

Выполнение приведенного выше кода даст приведенный ниже вывод, давайте попробуем изменить `number` переменной в коде.

```sh
❯ gcc main.c
❯ ./a.out   
The variable value is : 20
```

```c
#include <stdio.h>

void main() {
  uint32_t const number = 10;
  number = number * 2;
  printf( “The variable number is : %d\n”, number );
}
```

> [!example] 
> Теперь этот код выдавал бы ошибку при компиляции, так как `number` была квалифицирована как `const`, но была изменена после ее первой инициализации.

```shell
❯ gcc sample.c
❯ sample.c: In function ‘main’:
sample.c:6:10: error: assignment of read-only variable ‘number’
    6 |   number = number * 2;
      |          ^
```

Важно понимать, какими способами ключевое слово `const` может использоваться с переменной/указателем.

[[const <value>]]
[[link on const <value>]]
[[const link on <value>]]
[[const link on const <value>]]


