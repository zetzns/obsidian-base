> [!info]
> **kmalloc()** и **kfree()** для динамического выделения и освобождения памяти.

```c
#include <linux/slab.h> // для kmalloc и kfree

void *buffer;
buffer = kmalloc(1024, GFP_KERNEL);
if (!buffer) {
    printk(KERN_ALERT "Failed to allocate memory with kmalloc\n");
    return -ENOMEM;
}
```

> [!important] 
> **Флаги для выделения памяти**:
> - `GFP_KERNEL`: используется в контексте, когда процесс может быть прерван (например, обычные потоки ядра).
>- `GFP_ATOMIC`: используется, когда выделение должно быть выполнено немедленно, без возможности прерывания (например, в обработчиках прерываний).
>- `GFP_DMA`: выделение памяти в диапазоне, подходящем для устройств с прямым доступом к памяти (DMA).

```c
kfree(buffer);
```

