> [!list]
> **1. Модели на уровне слов (базовые)**
> 
> - Word2Vec, GloVe, FastText
> - Каждому слову соответствует один эмбеддинг, независимо от контекста
> - Слово “bank” всегда имеет один и тот же эмбеддинг
> 
> **2. Контекстные модели (лучше)**
> 
> - BERT, RoBERTa, sentence-transformers
> - Эмбеддинг меняется в зависимости от окружения слова
> - “bank” рядом с “river” и “bank” рядом с “money” получают разные эмбеддинги
> 
> **3. Модели уровня предложений/документов (лучшие для RAG)**
> 
> - Sentence-BERT, E5, OpenAI embeddings
> - Специально обучены для встраивания целых предложений/абзацев
> - Идеально подходят для извлечения документов

```python
# Demonstrating contextual understanding  
from transformers import AutoTokenizer, AutoModel  
import torch  
  
model_name = "sentence-transformers/all-MiniLM-L6-v2"  
tokenizer = AutoTokenizer.from_pretrained(model_name)  
model = AutoModel.from_pretrained(model_name)  
  
def get_embedding(text):  
    # Tokenize  
    inputs = tokenizer(text, return_tensors="pt", padding=True, truncation=True)  
      
    # Get embeddings  
    with torch.no_grad():  
        outputs = model(**inputs)  
      
    # Mean pooling to get sentence embedding  
    embeddings = outputs.last_hidden_state.mean(dim=1)  
    return embeddings  
  
# Same word, different contexts  
text1 = "The bank of the river was muddy"  
text2 = "I deposited money at the bank"  
  
embedding1 = get_embedding(text1)  
embedding2 = get_embedding(text2)  
  
# These will be different because the model understands context!
```
