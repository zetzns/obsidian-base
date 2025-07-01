
> [!def] 
> `CPL` - `Current Priv Level`

> [!list] 
> Rings:
> - `0` - Kernel
> - `1` - drivers
> - `2` - services
> - `3` - apps

> [!question] 
> Как узнать какой у нас уровень привилегий? 
> 

> [!solved] 
> Регистр `cs` в двух младших битах содержит `CPL`.






