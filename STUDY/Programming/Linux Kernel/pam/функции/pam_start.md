
> [!info] 
> Инициализирует новую PAM-сессию.

```c
int pam_start(const char *service_name, const char *user, const struct pam_conv *pam_conversation, pam_handle_t **pamh);
```

- Параметры:
    - `service_name` — имя PAM-сервиса (например, "login").
    - `user` — имя пользователя (может быть NULL).
    - `pam_conversation` — указатель на структуру `pam_conv`.
    - `pamh` — указатель на дескриптор PAM-сессии.
- Возвращает: Код статуса (PAM_SUCCESS при успешном завершении).


