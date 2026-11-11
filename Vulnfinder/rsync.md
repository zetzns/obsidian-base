```
rsync -avR --partial -e "ssh -p $P" \
graphs/ \
"$REMOTE:/home/alex/GraphLLMAnalyzer/graphs/"
```