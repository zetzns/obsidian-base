> [!info]
> Устанавливает элемент данных в PAM-сессии.

```c
int pam_set_item(pam_handle_t *pamh, int item_type, const void *item);
```

- Параметры:
    - `pamh` — дескриптор PAM-сессии.
    - `item_type` — тип элемента.
    - `item` — значение элемента.
- Возвращает: Код статуса.
