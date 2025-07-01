> [!info]
> В языке C++ ключевое слово `explicit` используется для предотвращения неявных преобразований типов при создании объектов класса с использованием конструкторов, принимающих один аргумент. Это особенно полезно для предотвращения ошибок, связанных с неявными преобразованиями, которые могут приводить к неожиданному поведению программы.

```cpp
#include <iostream>

class MyClass {
public:
    explicit MyClass(int value) { // конструктор помечен как explicit
        std::cout << "Constructor called with value: " << value << std::endl;
    }
};

void function(MyClass obj) {
    std::cout << "Function called" << std::endl;
}

int main() {
    // function(10); // Ошибка компиляции: нет неявного преобразования int -> MyClass
    function(MyClass(10)); // Явное создание объекта MyClass
    return 0;
}
```
