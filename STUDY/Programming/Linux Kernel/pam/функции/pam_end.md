
> [!info] 
> Завершает PAM-сессию

```c
int pam_end(pam_handle_t *pamh, int pam_status);
```

- Параметры:
    - `pamh` — дескриптор PAM-сессии.
    - `pam_status` — конечный статус сеанса (например, PAM_SUCCESS).
- Возвращает: Код статуса.


