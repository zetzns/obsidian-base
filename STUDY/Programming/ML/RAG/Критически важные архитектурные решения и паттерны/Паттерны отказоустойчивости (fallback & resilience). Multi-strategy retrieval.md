```python
def robust_retrieval(query, strategies=['semantic', 'keyword', 'fuzzy']):
    results = []
    
    for strategy in strategies:
        try:
            if strategy == 'semantic':
                query_embedding = embed_text(query)
                strategy_results = vector_db.search(query_embedding, k=5)
            elif strategy == 'keyword':
                strategy_results = elasticsearch.search(query, k=5)
            elif strategy == 'fuzzy':
                strategy_results = fuzzy_search(query, k=5)
            
            if strategy_results and len(strategy_results) > 0:
                results.extend(strategy_results)
                break
                
        except Exception as e:
            logger.warning(f"Strategy {strategy} failed: {e}")
            continue
    
    return deduplicate_and_rank(results)
```
