> [!list]
> Как считается `risk_score` (по шагам):
> 1. База: `0.05` 
> 2. Добавки за качество декомпиляции: `missing_code +0.25`, `failed +0.30`, `truncated +0.08`, `thunk +0.03` 
> 3. Добавки за risky calls (`gets`, `strcpy`, `system`, `open`, и т.д.) с весами из `_RISKY_CALLS` 
> 4. Семантические паттерны: `printf(variable_format)` и fixed-size field copy (`memcpy/strncpy/...`) через regex 
> 5. Структурные признаки графа:  высокая degree-функция, очень длинная функция/строки 
> 6. Name hints по имени функции (`auth|token|password`, `parse|sql|input`, `file|path|open` и т.д.) 
> 7. Ограничение: `risk_score` clamp в `[0.0, 0.99]`

