
> [!idea] 
> Lets put together ideas of `how to manage scaling learning coef for many dimensions` and `momentum advancing direction of gradient`
> 

> [!done] 
> $v_{t+1}=\gamma v_{t}+(1-\gamma)\nabla f(x_t)$ - импульс
> $cache_{t+1}=\beta cache_{t}+(1-\beta)(\nabla f(x_t))^2$ - кэш
> $x_{t+1}=x_t-\alpha\frac{v_{t+1}}{cache_{t+1}+\epsilon}$ - считаем нормированный переход




