
> [!new] 
> `adb shell pm list packages <FILTER-STR>`
> 
> `adb shell pm list packages -f <FILTER-STR>` - see their associated files
> `adb shell pm list packages -d <FILTER-STR>` - disabled packages
> `adb shell pm list packages -e <FILTER-STR>` - enabled packages
> `adb shell pm list packages -s <FILTER-STR>` - system packages
> `adb shell pm list packages -3 <FILTER-STR>` - third party packages
> `adb shell pm list packages -i <FILTER-STR>` - see the installer for the packages
> `adb shell pm list packages -u <FILTER-STR>` - include uninstalled packages
> `adb shell pm list packages --user <USER-ID> <FILTER-STR>` - the user space to query
> 


> [!new] 
> To find path to APK
> `adb shell pm path com.android.phone`

> [!new] 
> To remove all data associated with package
> `adb shell pm clear com.test.abc`




