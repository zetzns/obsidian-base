```python
import ABC

class Feature(ABC):
	@abstractmethod
	def __init__(self, *args, **kwargs):
		None
	@abstractmethod 
	def calc(self) -> float:
		None
```

## Example

```python
class Delta(Feature):
'''
Delta-feature
open: float - open price of candle
close: float - close price of candle

--return--
delta: float = (close - open)
'''
	@abstractmethod
	def __init__(self, price_open: float, price_close: float):
		self.open = price_open
		self.close = price_close

	@abstractmethod
	def calc(self) -> float:
		delta: float = price_close - price_open
		return delta
```
