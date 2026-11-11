
> [!def] 
> `tf-idf(t,d,D)` - мера важности слова `t` для документа `d` в наборе документов `D`.
> $$tf-idf(t,d,D)=tf(t,d)\times idf(t,D)$$
> $tf(t,d)=\frac{n_t}{\sum_kn_k}$ 
> $idf(t,D)=\log\frac{|D|}{|\{d_{i}\in D\ |\ t\in d_{i}\}|}$
