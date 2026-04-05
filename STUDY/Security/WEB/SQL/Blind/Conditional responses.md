
> [!idea] 
> Sometimes we have logic kinda trigger to display some message when something is true.
> For example, we have a logic, that displays 'Welcome back!', if your cookie is in DB.
> And if in this field they didnt put a validation of input, we can exploit it just brutforcing useful information:

> [!example] 
> `TrackID=<valid cookie>' AND (SELECT SUBSTRING(password,20,1) FROM users WHERE username='administrator' AND LENGTH(password)=20)='a`
> 
> so, if we get valid response, condition is true and we can consider 20 letter of password as 'a'
