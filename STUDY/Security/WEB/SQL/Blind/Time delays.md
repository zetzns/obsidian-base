
> [!problem] 
> Often we do not have an access to verbose errors or errors at all

> [!key] 
> If we anyway have an exploitable sql field, we can put `delay` to command and check, based on time of responses, if condition is true or not:
> `'; IF (1=2) WAITFOR DELAY '0:0:10'--` 

