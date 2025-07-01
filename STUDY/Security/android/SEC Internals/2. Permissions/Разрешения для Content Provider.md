Content Provider в Android имеет более сложную модель разрешений по сравнению с другими компонентами. В этом разделе мы подробно рассмотрим эту модель.

---
## Статические Разрешения для Content Provider

> [!fact] 
> Хотя для контроля доступа ко всему провайдеру можно указать одно разрешение, большинство провайдеров используют разные разрешения для чтения и записи, а также могут задавать разрешения для отдельных URI. Пример провайдера, который использует разные разрешения для чтения и записи, — встроенный `ContactsProvider`. 
> 

Листинг 2-24 показывает объявление его класса `ContactsProvider2`.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.android.providers.contacts"
    android:sharedUserId="android.uid.shared"
    android:sharedUserLabel="@string/sharedUserLabel">
    --snip--
    <provider android:name="ContactsProvider2"
        android:authorities="contacts;com.android.contacts"
        android:label="@string/provider_label"
        android:multiprocess="false"
        android:exported="true"
        android:readPermission="android.permission.READ_CONTACTS"
        android:writePermission="android.permission.WRITE_CONTACTS">
        --snip--
        <path-permission
            android:pathPattern="/contacts/.*/photo"
            android:readPermission="android.permission.GLOBAL_SEARCH" />
        <grant-uri-permission android:pathPattern=".*" />
    </provider>
    --snip--
</manifest>
```


> [!example] 
> Провайдер использует атрибут `readPermission` для указания одного разрешения для чтения данных (`READ_CONTACTS`), и отдельное разрешение для записи данных с помощью атрибута `writePermission` (`WRITE_CONTACTS`). Таким образом, приложения, которые имеют только разрешение `READ_CONTACTS`, могут вызывать только метод `query()` провайдера, а вызовы к методам `insert()`, `update()` или `delete()` требуют наличия разрешения `WRITE_CONTACTS`. Приложениям, которым необходимо как читать, так и писать данные в провайдер контактов, нужно иметь оба разрешения.

Когда глобальные разрешения на чтение и запись недостаточно гибки, провайдеры могут задавать разрешения на уровне URI для защиты определенного набора данных. Разрешения на уровне URI имеют более высокий приоритет, чем разрешения на уровне компонента (или отдельно указанные разрешения на чтение и запись).

> [!important]
> Таким образом, если приложение хочет получить доступ к URI провайдера контента, имеющему связанное разрешение, оно должно иметь только разрешение для целевого URI, а не разрешение на уровне компонента.

> [!example] 
> В Листинге 2-24, `ContactsProvider2` использует тег `<path-permission>`, чтобы требовать от приложений, пытающихся прочитать фотографии контактов, наличия разрешения `GLOBAL_SEARCH`. Поскольку разрешения на уровне URI имеют приоритет над глобальными разрешениями на чтение, приложениям, которым нужно только прочитать фотографии контактов, не нужно иметь разрешение `READ_CONTACTS`.

---
## Динамические Разрешения для Content Provider

> [!fact] 
> Хотя статически определенные разрешения на уровне URI могут быть достаточно мощными, приложения иногда нуждаются в предоставлении временного доступа к определенному набору данных (обозначенному URI) другим приложениям, без необходимости предоставления им конкретного разрешения.

Например, приложение для электронной почты или обмена сообщениями может понадобиться взаимодействовать с приложением для просмотра изображений для отображения вложений. Поскольку приложение не может заранее знать URI вложений, использование статических разрешений на уровне URI потребовало бы предоставления доступа ко всем вложениям приложению для просмотра изображений, что нежелательно.

> [!security] 
> Чтобы избежать этой ситуации и потенциальной угрозы безопасности, приложения могут динамически предоставлять временный доступ на уровне URI, используя методы `Context.grantUriPermission(String toPackage, Uri uri, int modeFlags)` и отозвать доступ, используя соответствующий метод `revokeUriPermission(Uri uri, int modeFlags)`. Временный доступ на уровне URI включается путем установки атрибута `grantUriPermissions` в `true` или добавлением тега `<grant-uri-permission>`, чтобы включить его для конкретного URI.

Листинг 2-25 показывает, как приложение Email использует атрибут `grantUriPermissions`, чтобы позволить временный доступ к вложениям без необходимости разрешения `READ_ATTACHMENT`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.android.email"
    android:versionCode="500060" >
    <provider
        android:name=".provider.AttachmentProvider"
        android:authorities="com.android.email.attachmentprovider"
        android:grantUriPermissions="true"
        android:exported="true"
        android:readPermission="com.android.email.permission.READ_ATTACHMENT"/>
    --snip--
</manifest>
```

> [!important] 
> На практике приложения редко используют методы `Context.grantPermission()` и `revokePermission()` напрямую для предоставления доступа на уровне URI. Вместо этого они устанавливают флаги `FLAG_GRANT_READ_URI_PERMISSION` или `FLAG_GRANT_WRITE_URI_PERMISSION` в intent, используемом для запуска взаимодействующего приложения (например, приложения для просмотра изображений). Когда эти флаги установлены, получатель intent получает разрешение на выполнение операций чтения или записи на URI в данных intent.

> [!info] 
> Начиная с Android 4.4 (API Level 19), разрешения на уровне URI могут сохраняться между перезагрузками устройства с помощью метода `ContentResolver.takePersistableUriPermission()`, если полученный intent имеет установленный флаг `FLAG_GRANT_PERSISTABLE_URI_PERMISSION`. Разрешения сохраняются в файле `/data/system/urigrants.xml` и могут быть отозваны, вызвав метод `releasePersistableUriPermission()`. Временные и постоянные разрешения на уровне URI управляются системной службой `ActivityManagerService`, к которой обращаются API, связанные с доступом на уровне URI.

> [!info] 
> Начиная с Android 4.1 (API Level 16), приложения могут использовать возможность `ClipData` intent для добавления более одного контентного URI для временного предоставления доступа.

Доступ на уровне URI предоставляется с использованием одного из флагов `FLAG_GRANT_*` intent и автоматически отзывается, когда задача вызываемого приложения завершается, поэтому нет необходимости вызывать `revokePermission()`.

Листинг 2-26 показывает, как приложение Email создает intent, который запускает приложение для просмотра вложений.

```java
public Intent getAttachmentIntent(Context context, long accountId) {
    Uri contentUri = getUriForIntent(context, accountId);
    Intent intent = new Intent(Intent.ACTION_VIEW);
    intent.setDataAndType(contentUri, mContentType);
    intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_ACTIVITY_CLEAR_WHEN_TASK_RESET);
    return intent;
}
```

---
---
Следующая глава [[Pending Intents]]
Предыдущая глава [[Разрешения для широковещательных сообщений]]
Раздел [[Permissions]]
Книга [[SEC Internals]]