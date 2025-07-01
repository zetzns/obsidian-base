
> [!problem] 
> Иногда программы не дают встроить в них привычные `shellcode`, ограничивая поступающие в программу `байты`.

> [!key] 
> Для этого можно либо самому сидеть и писать `shellcode`, на ассемблере в последствии `изменяя опкоды` на другие опкоды (*может стать единственным выходом, если ограничен размер экплоита*). Либо использовать встроенные в `pwntools` `encoder`-ы. 

---
['encoders'](https://docs.pwntools.com/en/stable/encoders.html#pwnlib.encoders.encoder.encode)

---

```python
pwnlib.encoders.encoder.encode(_raw_bytes_, _avoid_, _expr_, _force_)
- raw_bytes  
- avoid – Bytes to avoid
- expr – Regular expression which matches bad characters. 
- force – Force re-encoding of the shellcode, even if it doesn’t contain any bytes in `avoid`.
```

```python
pwnlib.encoders.i386.ascii_shellcode(_raw_bytes_, _avoid=None_, _pcreg=None_)
- raw_bytes – The shellcode to be packed
- avoid – Characters to avoid. Defaults to allow printable ascii (0x21-0x7e).
- pcreg – Ignored
```