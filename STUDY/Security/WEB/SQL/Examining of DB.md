
> [!important] 
> Sometimes useful to understand what version of SQL we have on server: it may contains CVEs for example. 

| Database type    | Query                     |
| ---------------- | ------------------------- |
| Microsoft, MySQL | `SELECT @@version`        |
| Oracle           | `SELECT * FROM v$version` |
| PostgreSQL       | `SELECT version()`        |

> [!important] 
> Also we should check all content we can see in DB

| Oracle     | `SELECT * FROM all_tables   SELECT * FROM all_tab_columns WHERE table_name = 'TABLE-NAME-HERE'`                              |
| ---------- | ---------------------------------------------------------------------------------------------------------------------------- |
| Microsoft  | `SELECT * FROM information_schema.tables   SELECT * FROM information_schema.columns WHERE table_name = 'TABLE-NAME-HERE'   ` |
| PostgreSQL | `SELECT * FROM information_schema.tables   SELECT * FROM information_schema.columns WHERE table_name = 'TABLE-NAME-HERE'   ` |
| MySQL      | `SELECT * FROM information_schema.tables   SELECT * FROM information_schema.columns WHERE table_name = 'TABLE-NAME-HERE'   ` |
