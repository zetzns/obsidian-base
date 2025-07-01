
> [!example] 
> https://github.com/zardus/preeny - клонируем и собираем `make`
> https://pastebin.com/1bFsjQED
> Запустить 
> `LD_PRELOAD=desock.so afl-fuzz -m none -i in/ -o out ./client.elf 127.0.0.1 123`

