> [!info]
> **Символьные устройства**: регистрируйте устройство с помощью `register_chrdev()`, создавайте файл устройства в `/dev`, обрабатывайте операции чтения/записи.

```c
major = register_chrdev(0, DEVICE_NAME, &fops);
if (major < 0) {
	return major; 
}


unregister_chrdev(major, DEVICE_NAME);
```

