```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rag-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rag-service
  template:
    metadata:
      labels:
        app: rag-service
    spec:
      containers:
      - name: rag-service
        image: your-registry/rag-service:latest
        ports:
        - containerPort: 8000
        env:
        - name: VECTOR_DB_URL
          value: "http://qdrant-service:6333"
        - name: EMBEDDING_MODEL
          value: "sentence-transformers/all-MiniLM-L6-v2"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1"
```