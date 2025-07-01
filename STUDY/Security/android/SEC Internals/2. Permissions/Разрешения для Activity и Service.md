
> [!security] 
> Activity и Service в Android могут быть защищены одним разрешением, установленным с помощью атрибута `permission` целевого компонента. Разрешение для активности проверяется, когда другие приложения вызывают методы `Context.startActivity()` или `Context.startActivityForResult()` с intent, который разрешается к этой активности. Для сервисов разрешение проверяется, когда другие приложения вызывают один из методов `Context.startService()`, `stopService()` или `bindService()` с intent, который разрешается к этому сервису.

В следующем примере показаны два пользовательских разрешения, `START_MY_ACTIVITY` и `USE_MY_SERVICE`, которые применяются к активности и сервису соответственно. Приложения, которые хотят использовать эти компоненты, должны запросить соответствующие разрешения, используя тег `<uses-permission>` в своем манифесте.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.myapp"
    ... >
    
    <permission android:name="com.example.permission.START_MY_ACTIVITY"
        android:protectionLevel="signature"
        android:label="@string/start_my_activity_perm_label"
        android:description="@string/start_my_activity_perm_desc" />
    
    <permission android:name="com.example.permission.USE_MY_SERVICE"
        android:protectionLevel="signature"
        android:label="@string/use_my_service_perm_label"
        android:description="@string/use_my_service_perm_desc"/>
    
    <!-- Компоненты приложения -->
    <activity android:name=".MyActivity"
        android:label="@string/my_activity"
        android:permission="com.example.permission.START_MY_ACTIVITY">
        <intent-filter>
            <!-- Фильтры намерений -->
        </intent-filter>
    </activity>
    
    <service android:name=".MyService"
        android:permission="com.example.permission.USE_MY_SERVICE">
        <intent-filter>
            <!-- Фильтры намерений -->
        </intent-filter>
    </service>
    
</manifest>
```

---
---
Следующая глава [[Разрешения для широковещательных сообщений]]
Предыдущая глава [[Публичные и Приватные Компоненты]]
Раздел [[Permissions]]
Книга [[SEC Internals]]
