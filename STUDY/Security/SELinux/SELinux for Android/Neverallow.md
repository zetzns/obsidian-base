
> [!important] 
> `Neverallow` - политика для политик, написанная на уровне системы

```bash
// Запретить загрузку политик уровня ядра всем доменам кроме init
neverallow { domain -init } kernel:security load_policy;

// Запретить исполнение любых файлов кроме системных и исполняемых всем доменам кроме указанных

neverallow {
	domain
	-appdomain
	-autoplay_app
	-dumpstate
	-shell
	-audioserver
	-system_server
	-zygote
} { file_type -system_file -exec_type -postinstall_file }:file execute;
```

