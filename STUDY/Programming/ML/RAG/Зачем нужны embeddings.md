
> [!problem] 
> Компьютеры оперируют числами, но смысл слов сам по себе не исчислим, создавая для нас большую проблему.
> ```python
> # How does a computer understand these are similar?  
sentence1 = "The dog is running"  
sentence2 = "A canine is jogging"  
sentence3 = "The car is broken"
>```  

> [!solved] 
> `Embeddings` превращают текст в векторы большой размерности, захватывая тем самым семантическое значение.

```python
# Conceptual representation  
"dog" → [0.2, -0.1, 0.8, 0.3, ...]        # 384 numbers  
"canine" → [0.18, -0.12, 0.83, 0.28, ...]  # Similar numbers!  
"car" → [-0.1, 0.9, -0.2, 0.7, ...]       # Different numbers

# Distance between vectors indicates similarity  
distance(dog, canine) = 0.05  # Very similar  
distance(dog, car) = 0.89     # Very different
```


