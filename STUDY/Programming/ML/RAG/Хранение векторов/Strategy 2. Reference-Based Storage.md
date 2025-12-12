```json
{  
  "id": "chunk_123",  
  "vector": [0.12, -0.34, ...],  
  "metadata": {  
    "document_id": "doc_456",  
    "page_number": 5,  
    "offset_start": 1240,  
    "offset_end": 1680  
  }  
}
```

> [!important] 
> **Pros**: Lower storage costs, single source of truth
> **Cons**: Additional lookup required at query time
