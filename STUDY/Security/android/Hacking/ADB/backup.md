
> [!important] 
> `adb backup [-apk] [-shared] [-system] [-all] -f file.backup`
> apk - include apk from third parties apps
> shared - include removable storage
> system - include sys apps
> all - include all apps
> 
> `adb backup -f myapp_backup.ab -apk com.myapp`
> `adb restore myapp_backup.ab`


