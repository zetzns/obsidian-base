
> [!important] 
> To exploit SQL-inj and leak info from different tables, we can use `UNION` keyword, but firstly we have to check, how many arguments response provides normally not to be caught by error handler.

> [!key] 
> We can spoil `' UNION SELECT NULL--`, `' UNION SELECT NULL,NULL--` before gets **HTTP OK**

> [!hint] 
> In ORACLE SQL we must provide TABLE from which select is... selecting, so we can use table `DUAL` which every ORACLE DB has by default.


