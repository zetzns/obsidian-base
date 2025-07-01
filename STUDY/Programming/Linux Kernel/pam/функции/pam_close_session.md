
> [!info] 
> Закрывает сессию пользователя.

```c
int pam_close_session(pam_handle_t *pamh, int flags);
```

- Параметры:
    - `pamh` — дескриптор PAM-сессии.
    - `flags` — дополнительные флаги.
- Возвращает: Код статуса.
