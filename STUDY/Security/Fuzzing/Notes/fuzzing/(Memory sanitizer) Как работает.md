
> [!info] 
> `MemorySanitizer` работает путём добавления специальной [[Теневая память|теневой памяти]], которая сохраняет информацию о состоянии каждого байта обычной памяти. Каждый байт обычной памяти ассоциирован с одним битом тeнeвой памяти, который показывает, инициализирован ли данный байт или нет.

> [!important] 
> **Перехват операций с памятью:** MSan отслеживает операции выделения памяти (например, `malloc` или `new`), а также доступ к переменным, чтобы проверять их состояние.

