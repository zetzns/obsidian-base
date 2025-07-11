
> [!info] 
> `ThreadSanitizer` обнаруживает проблемы с многопоточностью, такие как гонки данных (`data races`), неправильное использование синхронизационных примитивов (`mutex'ы`, `семафоры`) и другие ошибки взаимодействия между потоками.

> [!bug]
> - **Гонки данных (data races):** Одновременный доступ к одной и той же переменной из разных потоков без надлежащей синхронизации.
> - **Ошибки использования блокировок:** Например, некорректная работа с мьютексами или семафорами.
> - **Ошибки синхронизации потоков, приводящие к некорректному исполнению программы.**


