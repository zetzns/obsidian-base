```python
# DON'T DO THIS  
# Index documents with one tokenizer  
index_tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")  
# Query with different tokenizer  
query_tokenizer = AutoTokenizer.from_pretrained("roberta-base")  
# Results will be poor!  
  
# DO THIS  
# Use same tokenizer for both  
shared_tokenizer = AutoTokenizer.from_pretrained("all-MiniLM-L6-v2")
```
