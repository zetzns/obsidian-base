
> [!important] 
> `Стэк` — это область памяти, используемая для хранения данных временного характера, таких как `локальные переменные` и `параметры функций`. Он работает по принципу LIFO (Last In, First Out), где последний добавленный элемент извлекается первым.

> [!fact]
> При вызове функции в стэке создается новый **кадр стэка** (stack frame), который содержит:
> - Адрес возврата
> - Параметры функции
> - Локальные переменные
> 
> Когда функция завершается, ее кадр удаляется, и управление возвращается к вызывающей функции.

> [!finally] 
> На самом деле `стэк` `растёт вниз`. Для расширения стэка процессор используют операции вида `sub esp, N`


