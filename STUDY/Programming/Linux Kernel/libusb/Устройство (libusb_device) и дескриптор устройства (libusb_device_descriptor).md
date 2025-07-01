> [!info]
> `libusb_device` представляет USB-устройство, подключенное к системе.

> [!info]
> Дескриптор устройства содержит основную информацию об устройстве, такую как VID, PID, классы и версии устройства.

Функции:

- `libusb_get_device_list(libusb_context *ctx, libusb_device ***list)` — получает список всех подключённых устройств.
- `libusb_get_device_descriptor(libusb_device *dev, struct libusb_device_descriptor *desc)` — получает дескриптор устройства для указанного устройства.