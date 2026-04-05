> [!info]
> Path traversal is also known as directory traversal. These vulnerabilities enable an attacker to read arbitrary files on the server that is running an application. This might include:
> 
> - Application code and data.
> - Credentials for back-end systems.
> - Sensitive operating system files.

> [!example]
> Imagine a shopping application that displays images of items for sale. This might load an image using the following HTML:
>
> `<img src="/loadImage?filename=218.png">`
> 
> This application implements no defenses against path traversal attacks. As a result, an attacker can request the following URL to retrieve the `/etc/passwd` file from the server's filesystem:
> `https://insecure-website.com/loadImage?filename=../../../etc/passwd`


