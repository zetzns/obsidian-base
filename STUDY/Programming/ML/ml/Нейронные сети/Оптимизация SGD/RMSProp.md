
> [!problem] 
> `Adagrad` is slowing cause of non-negative only values of squared gradient.

> [!solution] 
> Lets add coefficient to previous cache, so it would be decreasing value and `providing more power to new gradient itself`
> $cache_{t+1}=\beta cache_{t}+(1-\beta)(\nabla f(x_t))^2$, $\beta\in(0..1)$
> $x_{t+1}=x_{t}-\alpha\frac{\nabla f(x_t)}{cache_{t+1}+\epsilon}$
> 
