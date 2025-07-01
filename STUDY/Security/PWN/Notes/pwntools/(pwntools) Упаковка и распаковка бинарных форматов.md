
> [!important] 
> `pack()` и `unpack()`
> Функции для упаковки (pack) и распаковки (unpack) чисел в бинарный формат с учетом порядка байтов (endian). Это важно при взаимодействии с бинарными данными и адресами, где критичен правильный порядок байтов.

```python
packed_data = pack(0xdeadbeef, endian='little')  # Упаковка числа с учетом порядка байтов
print(packed_data)                       # Выводит b'\xef\xbe\xad\xde'
unpacked_data = unpack(packed_data, endian='little')
print(hex(unpacked_data))           # Распаковывает обратно в 0xdeadbeef
```
