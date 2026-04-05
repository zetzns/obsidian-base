
> [!problem] 
> What if we dont have this magic message?

> [!key] 
> We can put there a triggering error payload like that
> `xyz' AND (SELECT CASE WHEN (1=2) THEN 1/0 ELSE 'a' END)='a`,
> so if our condition is true, we would see error, otherwise just OK
