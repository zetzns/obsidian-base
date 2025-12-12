```python
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")  
  
# Example 1: Simple sentence  
text1 = "The cat sits on the mat"  
tokens1 = tokenizer.tokenize(text1)  
print(tokens1)  
# Output: ['the', 'cat', 'sits', 'on', 'the', 'mat']  
  
# Example 2: Complex words get split into subwords  
text2 = "Mitochondria are cellular powerhouses"  
tokens2 = tokenizer.tokenize(text2)  
print(tokens2)  
# Output: ['mit', '##och', '##ond', '##ria', 'are', 'cellular', 'power', '##houses']  
  
# Example 3: Check token count  
text3 = "A very long document..."   
token_count = len(tokenizer.encode(text3))  
print(f"Token count: {token_count}")
```

> [!important]
> **Why Subword Tokenization Matters:**
> 
> - Handles unknown words by breaking them into known parts
> - Manages vocabulary size efficiently
> - Enables understanding of word variations (run, running, runner)