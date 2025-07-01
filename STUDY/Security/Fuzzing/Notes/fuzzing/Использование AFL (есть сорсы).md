```c
int main(int argc, char* argv[]) {
	char data[100] = {0};
	char* a = 0;
	size_t size = read(0, data, 100);
	if (size > 0 && data[0] == 'H') 
		if (size > 1 && data[1] == 'I')
			if (size > 2 && data[2] == '!')
				*a = 1;
	return 0;
}
```

```shell
afl-clang-fast test.c -o test.elf
./test.elf

mkdir in; mkdir out
echo qwe > in/qwe
afl-fuzz -m none -i in -o out -- ./test.elf
```

