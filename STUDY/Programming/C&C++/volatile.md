
> [!new] 
> Ключевое слово `volatile` сообщает компилятору то, что значение переменной может быть ***неожиданно изменено*** без ведома самого компилятора.

> [!important] 
> Ключевое слово `volatile` также предотвращает **попадание** **переменных в CPU** **REGISTERS**, но опять же, это зависит от стандартов оптимизации конкретного процессора. В зависимости от этого, изменяемая переменная может быть или не может быть **КЭШИРОВАНА** в **CPU REGISTERS**.

```c
#include <stdio.h>
#include <stdint.h>

// Using “volatile” keyword with status_register.
volatile uint32_t *status_register = (uint32_t *) 0x40010000;

void main() {
    while(1)
    {
           if( *status_register == 0 )
           {
                // some functionality here!
           }
    }

}
```

> [!example] 
> Поскольку мы используем ключевое слово `volatile` для `status_register`, это гарантирует, что компилятор извлекает значение регистра состояния из памяти при каждом чтении, поэтому он точно получает текущее состояние оборудования. Ассемблер (псевдокод) приведенного выше кода приведен ниже:

```asm
Loop:
	LOAD *status_register, R0 ; Load the value of status_register from memory to register R0
	COMPARE R0, 0x0	          ; Compare R0 with 0x0
	JUMP_IF_NOT_EQUAL Loop 	  ; If not equal, jump back to Loop
	; Application does some functionality here
```

---

> [!warning] 
> Теперь напишем тот же код без использования `volatile` с `status_register`. Код будет выглядеть примерно так:

```c
#include <stdio.h>

// Not using “volatile” keyword with status_register.
uint32_t *status_register = (uint32_t *) 0x40010000;

int main()
{
    while(1)
    {
           if( *status_register == 0 )
           {
                // some functionality here!
           }
    }

    return 0;

}
```

> [!example] 
> Поскольку мы не используем ключевое слово `volatile`, компилятор может оптимизировать операцию чтения, кэшируя значение регистра состояния в регистре и не извлекая его из памяти на каждой итерации. Это может привести к некорректному поведению, так как цикл может не обнаружить изменения в регистре состояния оборудования.

```asm
LoadStatus:
	LOAD *status_register, R0  ; Load the value of status_register from memory to register R0
Loop:
	COMPARE R0, 0x80000000 	; Compare R0 with 0x80000000
	JUMP_IF_NOT_EQUAL Loop 	; If not equal, jump back to Loop
	; Application does some functionality here!
```

