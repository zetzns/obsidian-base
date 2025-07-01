
> [!hint] 
> `remote(host, port)`
> Используется для установки соединения с удаленным сервисом по протоколу TCP или UDP. Это позволяет Pwntools взаимодействовать с сетевыми приложениями, как с локальными, так и удаленными, что полезно для тестирования сервисов на уязвимости.

```python
from pwn import *
conn = remote('example.com', 1234)  # Устанавливает соединение с сервером по TCP
conn.sendline('Hello')             # Отправляет строку
response = conn.recvline()         # Читает ответ сервера
print(response.decode())
conn.close()
```
