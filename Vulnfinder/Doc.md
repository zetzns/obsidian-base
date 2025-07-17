## Enviroment


> [!faq] 
> `OS`: Debian-based run
> `version-manager`: gitlab
> `Engine for preproccessor and parser`: clang
> 

## Preproccessor and parser


> [!info] 
> `parser.py` имеет следующий формат запуска:
> 

```bash
usage: parser.py [-h] [--lib-paths LIB_PATHS] [--no-preprocess] [--output OUTPUT] [--quiet]
                 [--max-depth MAX_DEPTH]
                 file

Firmware C file parser and preprocessor

positional arguments:
  file                  C file to analyze

options:
  -h, --help            show this help message and exit
  --lib-paths LIB_PATHS
                        Library paths (comma-separated)
  --no-preprocess       Skip preprocessing
  --output, -o OUTPUT   Output JSON file
  --quiet, -q           Quiet mode (no progress bars)
  --max-depth MAX_DEPTH
                        Maximum include depth (default: 2)
```


> [!info] 
> Данная программа парсит весь исходный код в формат json и обрабатывает все макросы и include директивы. Для обработки include-библиотек она проходится по всем библиотекам, которые пользователь подключит с помощью флага `--lib-paths`.
> 

> [!example] 
> Ожидаемый вывод:



