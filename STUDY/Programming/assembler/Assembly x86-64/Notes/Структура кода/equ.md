
> [!hint] 
> Мы можем использовать `equ` инструкцию с `$` токеном для оценки выражения, например, ***длины строки определенной переменной***. Однако метки, определенные инструкцией, `equ` являются `константами`, и их нельзя изменить позже.
> 
> Например, следующий код определяет переменную, а затем определяет константу для ее длины:

```asm
section .data
    message db "Hello World!", 0x0a
    length  equ $-message
```


> [!important] 
> Примечание: `$` токен указывает текущее расстояние от начала текущего раздела. Поскольку переменная `message` находится в начале раздела `data`, текущее местоположение, т. е. значение `$`, равно длине строки. В рамках этого модуля мы будем использовать этот токен только для вычисления длины строк, используя ту же строку кода, что показана выше.


