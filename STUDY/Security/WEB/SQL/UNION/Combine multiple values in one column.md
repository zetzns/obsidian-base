
> [!problem] 
> Sometimes we wanna exfiltrate multiple values, but response provides only one column 

> [!solved] 
> We can use '~' symbol plus **two** concantenations (specified by type of DB)
> 

| Oracle     | 'foo'\|\|'bar'                                                                  |
| ---------- | ------------------------------------------------------------------------------- |
| Microsoft  | 'foo'+'bar'                                                                     |
| PostgreSQL | 'foo'\|'bar'                                                                    |
| MySQL      | 'foo' 'bar' [Note the space between the two strings]  <br>`CONCAT('foo','bar')` |

