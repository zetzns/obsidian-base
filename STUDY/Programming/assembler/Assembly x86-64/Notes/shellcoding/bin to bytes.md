
> [!tool] 
> Для получения `шеллкода в виде байт` можно воспользоваться `objdump` и `xxd`:
> `objdump -O binary --only-section=.text <elf> <elf.bin>`
> `xxd -p <elf.bin>`
