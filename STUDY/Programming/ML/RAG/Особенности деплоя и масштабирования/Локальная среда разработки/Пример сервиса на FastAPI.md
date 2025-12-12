```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn

app = FastAPI()

class SearchRequest(BaseModel):
    query: str
    top_k: int = 5

@app.post("/search")
async def search_documents(request: SearchRequest):
    try:
        # Встраиваем (embed) запрос
        query_embedding = embedding_service.embed(request.query)
        
        # Поиск по векторной базе
        results = vector_db.search(
            query_embedding, 
            limit=request.top_k
        )
        
        # Сборка контекста
        context = assemble_context(results)
        
        # Генерация ответа
        response = llm_service.generate(request.query, context)
        
        return {
            "answer": response,
            "sources": [r.metadata for r in results],
            "query": request.query
        }
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
```