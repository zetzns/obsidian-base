
> [!check] 
> На стэке находим `libc_start_main`, узнаём его адрес и вбиваем в ['базу'](https://libc.rip/). Отсюда находим версию `libc` и адрес этой же функции внутри библиотеки.
> Тогда `libc_base = libc_func_adr - func_adr`


