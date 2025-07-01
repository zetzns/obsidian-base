> [!info]
> Переменная, объявленная как `static` внутри функции, сохраняет своё значение между вызовами этой функции. Она инициализируется только один раз при первом вызове функции, и её значение сохраняется между последующими вызовами.

```c
#include <stdio.h>

void counter() {
    static int count = 0; // инициализируется только один раз
    count++;
    printf("Count: %d\n", count);
}

int main() {
    counter(); // Output: Count: 1
    counter(); // Output: Count: 2
    counter(); // Output: Count: 3
    return 0;
}
```

