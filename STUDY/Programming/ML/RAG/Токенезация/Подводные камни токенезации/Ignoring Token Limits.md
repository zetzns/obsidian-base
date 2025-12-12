```python
# DON'T DO THIS  
long_document = "A very long document with thousands of words..."  
embedding = model.encode(long_document)  # Gets truncated silently!  
  
# DO THIS  
def chunk_document(text, max_tokens=400):  
    tokens = tokenizer.encode(text)  
    chunks = []  
    for i in range(0, len(tokens), max_tokens):  
        chunk_tokens = tokens[i:i + max_tokens]  
        chunk_text = tokenizer.decode(chunk_tokens)  
        chunks.append(chunk_text)  
    return chunks  
  
chunks = chunk_document(long_document)  
embeddings = [model.encode(chunk) for chunk in chunks]
```
