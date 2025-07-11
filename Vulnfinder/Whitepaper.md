# Vulnerability scanner LLM based


> [!problem] 
> Анализ кода ***большого размера*** (порядка нескольких миллионов строк) может занимать недели, месяцы, так как порой для получения **стабильного эксплоита** требуется понимание всего контекста исполнения.
> 

> [!finally]
> Данный проект может стать решением данной проблемы. Автоматизация поиска уязвимости с помощью большой языковой модели позволит находить уязвимые участки кода, которые имеют потенциал к эксплуатации.

## 1. Цели и задачи

- **Автоматизация поиска уязвимостей** в больших проектах.
- **Сохранение и передача контекстной информации** между частями кода.
- **Повышение точности** за счет обучения на специализированных данных по CWE.
- **Оптимизация ресурсов**: минимизация объема данных, загружаемых в модель.
## 2. Наиболее упрощённый вид проекта

![[Pasted image 20250710123005.png]]
## 3.  Проблемы и их решение

### 3. 1 Проблемы

> [!problem] Problem 1 
> Ни одна из существующих `LLM` ***не обладает контекстным окном, способным принять даже 1 млн строчек***. При этом разбивать код на части (впрямую, без разбора) не даст желаемого результата, ведь **модель не сможет хранить контекст предыдущего ответа** (в полном размере), а значит будет терять в понимании контекста выполнения кода, что неминуемо приведёт к галлюцинациям языковой модели и потерям в качестве результата (некоторые уязвимости найдены не будут, а некоторые найденные не будут пригодны к эксплуатации).
> 

> [!problem] Problem 2
> Имеющиеся языковые модели `недостаточно обучены` на предмет нахождения уязвимостей - для этого необходимо дообучать модель.

> [!problem] Problem 3
> Для работы с крупной и мощной языковой моделью необходимо сильное `железо`.

### 3.1 Решение проблем

> [!solved] Problem 1
> Решением данной проблемы является `преобразование кода в граф` по принципу вызовов. Более того, мы не будем терять в контексте, сохраняя важную информацию о передаваемых в функции далее аргументах, а также о всех уязвимостях, найденных на данном этапе. Также необходимо предусмотреть обратную передачу всего найденного контекста (и его преобразование в минимальный вид, для минимизации дополнительного контекста) в исходную вызываемую функцию, в случае образования цикла в графе (например, в функции *main* была вызвана *a = foo()*, после выполнения *foo* RIP вернётся обратно на *main*, а значит, нам, возможно, понадобится информации об уязвимых участках внутри *foo* и всех его возможных *child-вызовах* и так далее). Проход по графу по одной функции будет решать эту проблему, ведь нам будет необходимо ***загружать в модель лишь функции в порядке их вызова по ветвям исполнения***. Покрыв весь код, нам будет известно, как добраться до уязвимых кусков кода и что можно с этим сделать.
> 
> Таким образом, наш инструмент будет из исходного кода создавать граф кода и отправлять в порядке вызовов код внутрь языковой модели.
> 

> [!solved] Problem 2
> Обучение модели строится по принципу образования условного `JSON`-файла в формате 
> {input: <'code'>; output:<предполагаемый вывод модели>}
> Где нам предстоит образовать `code`-базу из уязвимых и безопасных вызовов различных функций в роде **printf, gets...**, а `output` из желаемого ответа модели на каждый соответствующий кусок кода (сам уязвимый кусок код + универсальные советы по эксплуатации (можно написать на каждую CWE)).
> 
> Очень удобно, что в интернете уже можно найти целые базы данных с примерами уязвимых вызовов, а значит, всё, что останется - создание множества (порядка 5000 на каждую CWE) примеров безопасного использования этих функций, выбор (порядка 5000 на каждую CWE) уязвимых вариантов среди имеющихся данных, а также генерация желаемого `пояснения модели`.

> [!solved] Problem 3
> 32 Гб Видеопамяти
> 128 Гб ОЗУ

## 4. Архитектура системы

Система выполнена по модульному принципу и состоит из следующих уровней:

> [!list] Архитектура
> - **Уровень предобработки** (Parser & Preprocessor)
> - **Уровень построения графа кода** (Code Graph Builder)
> - **Уровень анализа и оптимизации графа** (Graph Optimizer)
> - **Интеграционный уровень** (LLM Gateway)
> - **Уровень обучения** (Training Module)
> - **Слой данных** (Knowledge Base)
> - **Интерфейсный слой** (Report Generator & API)

## 5. Основные компоненты и модули

### 5.1. Модуль предобработки и парсинга

- **Функции:**
    - Разрешение include и макросов
    - Условная компиляция
    - Лексический и синтаксический анализ (AST): построение абстрактного синтаксического дерева — иерархического представления исходного кода, где каждый узел отражает конструкцию (выражение, оператор, декларацию). AST позволяет проводить семантический анализ и трансформацию кода.
        
- **Вход:** исходные файлы (C/C++, другие языки)
- **Выход:** AST и семантические таблицы символов
    

### 5.2. Модуль построения графа кода

- **Функции:**
    - Генерация CFG (Control Flow Graph) и SSA (Static Single Assignment) на основе AST
    - Маркировка узлов контекстной информацией: аргументы функций, возвратные значения
        
- **Выход:** оптимизированный SSA-CFG для каждой функции
    

### 5.3. Модуль оптимизации графа

- **Функции:**
    - Dead Code Elimination (DCE)
    - Упрощение и слияние SSA
    - Сглаживание и агрегация связанных графов
        
- **Цель:** снижение объёма графа без потери аналитической информации
    

### 5.4. Модуль интеграции с локальной LLM

- **Функции:**
    - Развёртывание и управление локальной моделью (QWEN-3, Gemma, LLaMA или кастомный трансформер)
    - Разбиение графов на батчи и пошаговая подача в LLM
    - Управление контекстным окном и агрегация ответов
        
- **Особенности:**
    - Отсутствие зависимости от облачных API
    - Конфигурируемые параметры обучения и инференса
        

### 5.5. Модуль дообучения (Training Module)

- **Функции:**
    - Подготовка датасета: аннотация кейсов CWE, генерация формата `{input: SSA-CFG, output: метки уязвимостей}`
    - Запуск дообучения локальной модели на специализированных примерах
    - Мониторинг метрик качества и сохранение контрольных точек
        
- **Инструменты:** PyTorch/TensorFlow, библиотеки оптимизации тренировки
    

### 5.6. Knowledge Base

- **Функции:**
    - Хранение классификации уязвимостей (CWE)
    - Индексация и поиск по историческим анализам
    - Интерфейс для автоматического обновления после новых запусков модели
        

### 5.7. Report Generator и CLI-интерфейс

- **Функции Report Generator:**
    - Формирование отчётов о найденных уязвимостях с детализацией путей исполнения
    - Экспорт в JSON, HTML, PDF
        
- **CLI-интерфейс:**
    - Удобная команда запуска анализа: `llm-tool analyze --project /path/to/src`
    - Параметры конфигурации (уровень детализации, выбор модели, пути экспорта)
        

---

## 6. Взаимодействие компонентов (Data Flow)

1. **Запуск через CLI** (`llm-tool analyze --project /path/to/src`) → сбор параметров и конфигурации.
2. **Предобработка и парсинг** → построение AST и семантических таблиц.
3. **Построение графов** → генерация SSA-CFG для каждой функции.
4. **Оптимизация графов** → применение DCE и упрощение SSA.
5. **Инференс локальной LLM** → разбиение графов на батчи, пошаговая подача в модель, управление контекстным окном.
6. **Агрегация ответов** → объединение результатов инференса, выработка меток уязвимостей.
7. **Обновление Knowledge Base** → сохранение новых кейсов, индексация для последующих запусков.
8. **Генерация отчёта и вывод** → формирование JSON/HTML/PDF и вывод через CLI или отправка по REST API.

---

## 7. Технологический стек

> [!list] Стек
> - **Языки разработки:** Python, C++
> - **Анализ исходного кода:** LLVM/Clang, ANTLR
> - **LLM-движок:** локальные модели (QWEN-3, Gemma, LLaMA или кастомный трансформер)
> - **Фреймворки дообучения и инференса:** PyTorch, TensorRT
> - **Хранение данных:** PSQL, MySQL
> - **CI/CD:** GitLab CI
> - **Инструменты тестирования:** pytest, Catch2 (C++)
> - **CLI:** Python (Click)

## 8. Перспективы развития и дорожная карта (завершение до апреля 2026)

> [!finally]
> - **Этап 1 (июль – август 2025)**
>     - Определение точных требований и оформление ТЗ  
>     - Настройка окружения: GitLab CI, выбор инструментов (LLVM/Clang, ANTLR)  
>     - Реализация базового предобработчика и парсера исходного кода с поддержкой include/макросов  
>     - Первичное покрытие AST для C/C++ и простые юнит-тесты  
> 
> - **Этап 2 (сентябрь – октябрь 2025)**
>     - Построение CFG и SSA для функций на базе полученного AST  
>     - Разработка модуля оптимизации графов (DCE, упрощение SSA)  
>     - Интеграция простейшей Knowledge Base: хранение и поиск кейсов CWE  
>     - Расширение набора юнит-тестов для CFG и оптимизатора  
> 
> - **Этап 3 (ноябрь – декабрь 2025)**
>     - Развёртывание локальной LLM-системы и дообучение одной из моделей (QWEN-3, Gemma, LLaMA или кастомный transformer)  
>     - Реализация механизма поэтапной отправки графов/ветвей исполнения в модель и управления контекстным окном  
>     - Агрегация ответов модели и выработка единого результата анализа  
>     - Подготовка и аннотация первых наборов примеров CWE для дообучения  
> 
> - **Этап 4 (январь – февраль 2026)**
>     - Масштабирование процесса дообучения: расширение и аннотация базы примеров для повышения качества  
>     - Тестирование точности поиска уязвимостей на нескольких реальных репозиториях  
>     - Оптимизация производительности: профилирование и сокращение потребления памяти  
>     - Автоматическое обновление Knowledge Base по итогам анализа  
> 
> - **Этап 5 (март – начало апреля 2026)**
>     - Разработка Report Generator: экспорт в JSON/HTML/PDF и первая версия RESTful API  
>     - Создание CLI-инструмента для запуска анализа «из коробки»  
>     - Подготовка документации и инструкций по установке/использованию  
>     - Финальная проверка, тестирование и исправление критических багов  
> 