> [!attention]
> While attempting to brute-force a login page, you should pay particular attention to any differences in:
> 
> - **Status codes**: During a brute-force attack, the returned HTTP status code is likely to be the same for the vast majority of guesses because most of them will be wrong. If a guess returns a different status code, this is a strong indication that the username was correct
> - **Error messages**: Sometimes the returned error message is different depending on whether both the username AND password are incorrect or only the password was incorrect
> - **Response times**: If most of the requests were handled with a similar response time, any that deviate from this suggest that something different was happening behind the scenes

