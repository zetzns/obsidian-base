
> [!problem] 
> Different dimensions are simply different and SGD is struggling with it

> [!solution] 
> Lets make a cache for each component on every step (t):
> $cache_{t+1}=cache_{t}+(\nabla f(x_t))^2$
> $x_{t+1}=x_{t}-\alpha\frac{\nabla f(x_t)}{cache_{t+1}+\epsilon}$
> So, square of gradient + old cache will now provide us a correction on direction of changes via dimensions




