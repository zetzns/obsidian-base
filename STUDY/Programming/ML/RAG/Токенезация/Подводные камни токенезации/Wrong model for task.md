```python
# DON'T DO THIS - using word-level model for document search  
from gensim.models import Word2Vec  
word_model = Word2Vec.load("word2vec.model")  
# Can't embed full sentences properly  
  
# DO THIS - use sentence-level model  
sentence_model = SentenceTransformer('all-MiniLM-L6-v2')
```
