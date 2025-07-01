
> [!attention] 
> Начнём с проверки с какой версией OS и каким дистрибутивом имеем дело

```shell
vantuzi@htb[/htb]$ cat /etc/os-release
	NAME="Ubuntu"
	VERSION="20.04.4 LTS (Focal Fossa)"
	ID=ubuntu
	ID_LIKE=debian
	PRETTY_NAME="Ubuntu 20.04.4 LTS"
	VERSION_ID="20.04"
	HOME_URL="https://www.ubuntu.com/"
	SUPPORT_URL="https://help.ubuntu.com/"
	BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
	PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
	VERSION_CODENAME=focal
	UBUNTU_CODENAME=focal
```


> [!attention] 
> А также проверим `ядро`

```bash
uname -a

Linux nixlpe02 5.4.0-122-generic #138-Ubuntu SMP Wed Jun 22 15:00:31 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```
