
> [!goal] 
> Иногда нам интересно не просто построить разделяющую прямую, но и равнозначно удалить её от обоих классов:
> ![[Pasted image 20251222173840.png]]

> [!key] 
> Это можно сделать, слегка поменяв функцию ошибки, а именно положив её равной: $$F(M)=\max(0,1-M)$$
> $$L(w,x,y)=\lambda|||w|||_2^2+\sum_i\max(0,1-y_i\langle w,x_i \rangle)$$
> $$\nabla_w L(w,x,y)=2\lambda w +\sum_i\begin{cases}0, & 1-y_i\langle w,x_i \rangle \leq 0,\\ -y_ix_i,  & 1-y_i\langle w,x_i \rangle > 0\end{cases}$$

![[Pasted image 20251222174326.png]]
