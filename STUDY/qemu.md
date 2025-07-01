```shell
qemu-img create -f qcow2 </путь/до/disk.qcow2> <40G>

qemu-system-i386 -m <mem> -cdrom </путь/до/.iso> -boot d -enable-kvm -hda </путь/до/disk.qcow2>

qemu-system-i386 -m <mem> -hda </путь/до/disk.qcow2> -enable-kvm -nographic -serial stdio
```

# Spice

```shell
qemu-system-i386 -m <mem> -hda </путь/до/disk.qcow2> -vga qxl \ -spice port=5930,disable-ticketing \ -device virtio-serial \ -chardev spicevmc,id=spicechannel,debug=0 \ -device virtserialport,chardev=spicechannel,name=com.redhat.spice.0


remote-viewer spice://localhost:5930
```

