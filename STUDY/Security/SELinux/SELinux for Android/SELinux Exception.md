```bash
avc: denied { read } for pid=4303 comm="android:taskerm"
name="devices" dev="sysfs" ino=7192
scontext=u:r:untrusted_app:s0:c512,c768 tcontext=u:object_r:sysfs:s0 tclass=dir permissive=0
```

**FIX**:
```bash
allow untrusted_app sysfs:dir read;
```


