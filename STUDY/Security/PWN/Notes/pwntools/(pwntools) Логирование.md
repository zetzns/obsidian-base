
> [!check] 
> `log.info()`, `log.success()`, `log.error()`
> Функции для структурированного вывода информации. Упрощают отслеживание этапов эксплуатации, помогая различать информационные сообщения, успешные операции и ошибки.

```python
from pwn import *
log.info("Connecting to server")
conn = remote('example.com', 1337)
log.success("Connection established")
conn.sendline("test_payload")
response = conn.recvline()
log.info(f"Received response: {response}")
conn.close()
log.error("Connection closed unexpectedly")
```
