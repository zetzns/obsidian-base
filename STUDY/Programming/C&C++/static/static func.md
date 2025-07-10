> [!info] 
> Функции, объявленные как `static`, также имеют область видимости, ограниченную текущим файлом. Это означает, что такая функция не может быть вызвана из других файлов, что предотвращает нежелательный доступ к функции.

```c
// file1.c
static void helperFunction() {
    printf("This is a static function.\n");
}

void publicFunction() {
    helperFunction(); // Можно вызвать внутри файла
}

// file2.c
// void callHelper() {
//     helperFunction(); // Ошибка: функция не видима, так как объявлена как static в другом файле
// }
```


