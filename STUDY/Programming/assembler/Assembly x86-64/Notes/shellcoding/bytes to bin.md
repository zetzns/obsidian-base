
> [!tool] 
> Для того, чтобы из `шеллкода` получить код достаточно лишь:
> `echo <bytes> > <shell.txt>`
> `xxd -r -p <shell.txt> <shell.bin>`
> `ndisasm -b 64 <shell.bin>`
