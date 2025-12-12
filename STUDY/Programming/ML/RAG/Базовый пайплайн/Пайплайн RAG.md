
> [!finally] 
> Complete Pipeline: Tokens → Embeddings → Search

```python
# 1. Raw text  
document = "Photosynthesis is the process by which plants convert sunlight into energy"  
  
# 2. Tokenization  
tokenizer = AutoTokenizer.from_pretrained("all-MiniLM-L6-v2")  
tokens = tokenizer.tokenize(document)  
print("Tokens:", tokens)  
# ['photo', '##syn', '##thesis', 'is', 'the', 'process', ...]  
  
# 3. Token IDs  
#IMP: This line loads ONLY the tokenizer component  
token_ids = tokenizer.encode(document)  
print("Token IDs:", token_ids)  
# [101, 6302, 23433, 21369, 2003, 1996, 2832, ...]  
  
# 4. Embedding generation  
# IMP : This line loads the FULL model (which includes its own tokenizer internally)  
# A complete embedding model consists of:  
# 1. Tokenizer (converts text → token IDs)  
# 2. Embedding layers (converts token IDs → contextualized embeddings)  
# 3. Pooling layer (converts token embeddings → sentence embedding)  
model = SentenceTransformer('all-MiniLM-L6-v2')  
embedding = model.encode(document)  
print(f"Embedding shape: {embedding.shape}")  
# Embedding shape: (384,)  
  
# 5. Storage in vector database  
vector_record = {  
    "id": "doc_001",  
    "text": document,  
    "embedding": embedding.tolist(),  
    "metadata": {"source": "biology_textbook", "chapter": 1}  
}
```

Using step by step approach instead of directly using embedding as above

```python
# 1. Raw text  
document = "Photosynthesis is the process by which plants convert sunlight into energy"  
  
# 2. Load the complete model (includes tokenizer)  
model = SentenceTransformer('all-MiniLM-L6-v2')  
  
# 3. Access the model's tokenizer for inspection (optional)  
tokenizer = model.tokenizer  # This is the model's own tokenizer  
tokens = tokenizer.tokenize(document)  
print("Tokens:", tokens)  
  
# 4. Token IDs (optional, for debugging)  
token_ids = tokenizer.encode(document)  
print("Token IDs:", token_ids)  
  
# 5. Embedding generation (this handles tokenization internally)  
embedding = model.encode(document)  
print(f"Embedding shape: {embedding.shape}")  
  
# 6. Storage in vector database  
vector_record = {  
    "id": "doc_001",  
    "text": document,  
    "embedding": embedding.tolist(),  
    "metadata": {"source": "biology_textbook", "chapter": 1}  
}
```

