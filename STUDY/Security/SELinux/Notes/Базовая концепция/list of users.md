
> [!tip] 
> First, we can get a list of users using the `-u` flag:
> 
> ![[Pasted image 20240914173540.png]]

> [!tip] 
> Мы можем выполнить команду `semanage login -l`, чтобы получить отображение Linux-пользователей на пользователей SELinux.
> 
> ![[Pasted image 20240914173803.png]]

> [!example] 
> Здесь мы можем увидеть, что пользователь root находится под пользователем SELinux `unconfined_u`. `__default__` означает, что любой пользователь, который не явно определен в конфигурационном файле, будет частью `unconfined_u`. В этом примере я вручную сопоставил пользователей Linux alice и bob с пользователем SELinux `user_u`.

> [!important]
> Вы также можете просмотреть сопоставления без использования инструментов, просто прочитав файл `/etc/selinux/{SELINUXTYPE}/seusers`, но изменения в этом файле не будут напрямую применены к политике SELinux и будут перезаписаны.

> [!security]
> Аналогичным образом, текущий диапазон уровней чувствительности можно просмотреть, используя файл `/etc/selinux/{SELINUXTYPE}/setrans.conf`.

