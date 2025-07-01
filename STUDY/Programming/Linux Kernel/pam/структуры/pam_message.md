
> [!info] 
> Представляет сообщения, передаваемые из PAM в приложение.

```c
// Создание массива pam_message
struct pam_message msg = {
    .msg_style = PAM_PROMPT_ECHO_OFF,  // Тип сообщения, например, скрытый ввод
    .msg = "Please enter your password:"  // Текст сообщения
};
```

- `int msg_style;` — тип сообщения (например, запрос пароля, информационное сообщение). 
- `const char *msg;` — текст сообщения.