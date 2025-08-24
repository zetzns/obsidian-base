# Features

|-----------------|
abstract class Features
|-----------------|
`def __init__`
`def __calc__`

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

Example

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

### Шаг-за-шагом: архитектура и общие правила

1. **Базовый контракт** (уже задан): каждый индикатор — класс, наследник `Feature`, реализует:
    - `__init__(...)` — принимает ряды/параметры, валидирует.
    - `calc(self) -> float` — возвращает **последнее** значение индикатора на конце поданного ряда.
        
2. **Формат входов**:
    - Ряды: `Sequence[float]` (list/tuple/np.ndarray), одномерные, конечные значения.
    - Параметры: целые (`int`) для длин окон; коэффициенты/множители — `float`.
    - Для HLCV-индикаторов обязательны соответствующие ряды (`high`, `low`, `close`, `volume`).
        
3. **Валидация и ошибки**:
    - Проверка типов и длин: при недостатке данных — `ValueError` с понятным текстом: _"Недостаточно данных для `<NAME>`: нужно >= X, получено Y"_.
    - Деления на ноль, NaN/inf — запрещены; выбрасывать `ValueError` с пояснением.
    - EMA/RSI/ATR/ADX — использовать классические определения (EMA — рекуррентное сглаживание; Wilder — для ATR/RSI/ADX).
        
4. **Мультилинейные индикаторы**:
    - Каждая линия — **отдельный класс** (`-> float`): MACDLine / MACDSignal / MACDHist; BBUpper/BBMiddle/BBLower; Keltner (Upper/Middle/Lower); Ichimoku (Tenkan/Kijun/SenkouA/SenkouB/Chikou); Stochastic (StochK/StochD).
    - SuperTrend — одна линия.
        
5. **Докстринги** (обязательны):
    - Краткое описание; входы; формула/смысл; возвращаемое значение; минимально необходимая длина данных.
        
6. **Ограничения**:
    - Без внешних зависимостей, кроме `numpy`.
    - Детерминизм: повторные вызовы `calc()` на тех же входах дают одинаковый результат.
    - Память: не модифицировать входные массивы.
        
7. **Режим `test=True` (из вашего конфига)**:
    - Для него должны существовать классы RSI, MACD* (3 линии), EMA(*), VWAP. Остальные игнорируются фабрикой (это интеграционное требование; здесь фиксируем наличие соответствующих классов).
        

---

### ТЗ по каждому индикатору (сигнатуры, формулы, данные, граничные случаи)

> Ниже указываются **класс(ы)**, **сигнатуры** (интерфейсы), **минимальная длина данных**, и **требования к расчёту**. Реализация должна соответствовать формулам; возврат — **одно** число (последнее значение).

#### SMA — `sma_periods: list[int]`
- **Класс**: `SMA`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: среднее последних `period` значений `close`.
- **Мин. длина**: `period`.
- **Ошибки**: `period > 0`, данные конечны.
    

#### EMA — `ema_periods: list[int]`

- **Класс**: `EMA`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: классическая EMA с `alpha = 2/(period+1)`, начальное значение — SMA первых `period`.
- **Мин. длина**: `period`.
- **Ошибки**: `period > 0`.
    
#### WMA — `wma_length: int`
- **Класс**: `WMA`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], length: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: линейные веса `1..length` на последние `length` значений.
- **Мин. длина**: `length`.
    
#### MACD — `macd_params: (fast, slow, signal)`
- **Классы**:
    - `MACDLine` — EMA(fast) − EMA(slow)
    - `MACDSignal` — EMA(MACDLine, signal)
    - `MACDHist` — MACDLine − MACDSignal
- **Сигнатуры**:
    - `MACDLine.__init__(close: Sequence[float], fast: int, slow: int) -> None`
    - `MACDSignal.__init__(close: Sequence[float], fast: int, slow: int, signal: int) -> None`
    - `MACDHist.__init__(close: Sequence[float], fast: int, slow: int, signal: int) -> None`
    - `calc(self) -> float` — у каждого.
        
- **Условия**: `fast < slow`, все > 0.
- **Мин. длина**: для корректного сигнала — не меньше `slow + signal` наблюдений.
    
#### ADX — `adx_length: int`
- **Класс**: `ADX`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int) -> None`
    - `calc(self) -> float`
        
- **Формулы**: True Range; +DM/−DM; сглаживание Уайлдера; +DI/−DI; DX; ADX (Wilder).
- **Мин. длина**: `length + 1` (для первой разности).
- **Ошибки**: `length > 0`, согласованные длины H/L/C.
    
#### Parabolic SAR — `sar_params: (acceleration, maximum)`
- **Класс**: `ParabolicSAR`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], acceleration: float, maximum: float) -> None`
    - `calc(self) -> float`
    
- **Формула**: классика Уайлдера; обновление SAR, EP, AF; ограничения SAR на предыдущие экстремумы; переключение тренда.
- **Условия**: `0 < acceleration <= maximum`.
- **Мин. длина**: ≥ 2 бара.
    
#### RSI — `rsi_length: int`
- **Класс**: `RSI`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], length: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: Wilder smoothing по gains/losses; `RSI = 100 - 100/(1+RS)`.
- **Мин. длина**: `length + 1`.
- **Края**: если средняя потеря = 0 и есть прибыль → 100; если средняя прибыль = 0 и есть потери → 0.
    
#### Stochastic — `stoch_params: (k, d, smooth)`
- **Классы**:
    - `StochK` — %K со сглаживанием SMA по `smooth`.
    - `StochD` — %D = SMA(%K, `d`).
- **Сигнатуры**:
    - `StochK.__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], k: int, smooth: int) -> None`
    - `StochD.__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], k: int, d: int, smooth: int) -> None`
    - `calc(self) -> float` — у каждого.
        
- **Формулы**: `%K = 100*(close - LL(k))/(HH(k)-LL(k))`, затем SMA по `smooth`; `%D = SMA(%K, d)`.
- **Мин. длина**: для %K — `k + smooth - 1` (для сглаживания); для %D — дополнительно `d - 1` значений %K (см. примечание ниже).
- **Примечание**: для точного `%D` требуется исторический буфер %K; предусмотреть получение/хранение истории на уровне потока данных.
    

#### CCI — `cci_length: int`
- **Класс**: `CCI`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: `TP=(H+L+C)/3; CCI=(TP_last - SMA(TP,length)) / (0.015 * MD)`, где `MD` — среднее |TP−SMA|.
- **Мин. длина**: `length`.
- **Края**: `MD=0` → ошибка с пояснением.
    

#### Bollinger Bands — `bb_params: (length, std)`
- **Классы**:
    - `BBMiddle` — SMA(close, length)
    - `BBUpper` — `SMA + std_mult * σ`
    - `BBLower` — `SMA - std_mult * σ`
- **Сигнатуры**:
    - `BBMiddle.__init__(close: Sequence[float], length: int) -> None`
    - `BBUpper.__init__(close: Sequence[float], length: int, std_mult: float) -> None`
    - `BBLower.__init__(close: Sequence[float], length: int, std_mult: float) -> None`
    - `calc(self) -> float`
- **Мин. длина**: `length`.

#### Keltner Channel — `kc_params: (length, multiplier)`
- **Классы**:
    - `KCMiddle` — EMA(close, length)
    - `KCUpper` — `KCMiddle + multiplier * ATR(length)`
    - `KCLower` — `KCMiddle - multiplier * ATR(length)`
- **Сигнатуры**:
    - `KCMiddle.__init__(close: Sequence[float], length: int) -> None`
    - `KCUpper.__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int, multiplier: float) -> None`
    - `KCLower.__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int, multiplier: float) -> None`
    - `calc(self) -> float`
        
- **Мин. длина**: для верх/низ — `length + 1` (для TR/ATR).
    

### Волатильность (годовая) — `volatility_periods: list[int]`
- **Класс**: `VolatilitySTD`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: `σ_ann = std( ln(C_t/C_{t-1}) на окне period ) * sqrt(252)`.
- **Мин. длина**: `period + 1`.
    

#### ATR — `atr_length: int`
- **Класс**: `ATR`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: True Range; сглаживание Уайлдера.
- **Мин. длина**: `length + 1`.
    

#### Momentum — `momentum_period: int`
- **Класс**: `Momentum`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: `close_t - close_{t-period}`.
- **Мин. длина**: `period + 1`.
    

#### ROC — `roc_period: int`
- **Класс**: `ROC`
- **Сигнатуры**:
    - `__init__(close: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: `100 * (close_t / close_{t-period} - 1)`.
- **Мин. длина**: `period + 1`.
- **Края**: базовое значение = 0 → ошибка.
    

#### Ichimoku — `ichimoku_params: (tenkan, kijun, senkou, chikou)`
- **Классы**:
    - `IchimokuTenkan` — `(max(H,tenkan)+min(L,tenkan))/2`
    - `IchimokuKijun` — `(max(H,kijun)+min(L,kijun))/2`
    - `IchimokuSenkouA` — `(Tenkan + Kijun)/2`
    - `IchimokuSenkouB` — `(max(H,senkou)+min(L,senkou))/2`
    - `IchimokuChikou` — текущее `close` (смещение — отображение, не в `calc()`).
        
- **Сигнатуры**:
    - Соответствующие `__init__(...)` как по формулам выше.
    - `calc(self) -> float`
        
- **Мин. длина**: равна соответствующим периодам (для Chikou — `chikou + 1`).
    

#### SuperTrend — `supertrend_params: (length, multiplier)`
- **Класс**: `SuperTrend`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], length: int, multiplier: float) -> None`
    - `calc(self) -> float`
        
- **Формула**: `HL2=(H+L)/2`; `ATR(length)` (Wilder); базовые верх/низ; финальные уровни (перекат правил); линия в зависимости от направления; вернуть текущий уровень.
- **Мин. длина**: `length + 2`.
    

#### Объёмные SMA — `volume_sma_periods: list[int]`
- **Класс**: `VolumeSMA`
- **Сигнатуры**:
    - `__init__(volume: Sequence[float], period: int) -> None`
    - `calc(self) -> float`
        
- **Формула**: SMA по `volume`.
- **Мин. длина**: `period`.
    

#### VWAP (для режима `test=True` и раздела «объём»)
- **Класс**: `VWAP`
- **Сигнатуры**:
    - `__init__(high: Sequence[float], low: Sequence[float], close: Sequence[float], volume: Sequence[float]) -> None`
    - `calc(self) -> float`
        
- **Формула**: `TP=(H+L+C)/3; VWAP = sum(TP*V)/sum(V)` по поданному отрезку.
- **Мин. длина**: ≥ 1 бар с `volume_sum > 0`.

---
# Labels

|-----------------|
abstract class Labels
|-----------------|
`def __init__`
`def __calc__`

```python
class Label(ABC):
    """
    Абстрактный класс для всех целевых меток (Labels).
    Требования:
      - __init__(...): принимает ряды/параметры, выполняет валидацию входов
      - calc() -> int: возвращает последнее значение метки в стандартизированном кодировании
    Запрещено: модифицировать входные массивы, возвращать NaN/None.
    """

    @abstractmethod
    def __init__(self, *args, **kwargs) -> None:
        raise NotImplementedError("init must be implemented by subclass")

    @abstractmethod
    def calc(self) -> float:
        """
        Возвращает целочисленный код метки согласно ТЗ конкретного класса.
        """
        raise NotImplementedError("calc must be implemented by subclass")
```

### Example

```python
from typing import Sequence
import numpy as np

class NextBarDirectionLabel(Label):
    """
    Классификация направления следующего бара по закрытию.
    Кодирование: -1 (вниз), 0 (флэт в пределах eps), 1 (вверх).

    Входы:
      - close: Sequence[float] — ряд цен закрытия (одномерный, конечные значения)
      - eps: float — порог нечувствительности (относительный, доля от цены), по умолчанию 0.0

    Минимальная длина: 2 значения close (текущая и следующая точка).
    Правила:
      r = close[-1] / close[-2] - 1
      если r > eps -> 1
      если r < -eps -> -1
      иначе -> 0

    Ошибки:
      - len(close) < 2 -> ValueError
      - eps < 0 -> ValueError
      - NaN/inf во входах -> ValueError

    Детерминизм: да, не использует внешнее состояние.
    """

    def __init__(self, close: Sequence[float], eps: float = 0.0) -> None:
        if not isinstance(close, (list, tuple, np.ndarray)):
            raise TypeError("close должен быть list/tuple/np.ndarray")
        self.close = np.asarray(close, dtype=float)
        if self.close.ndim != 1:
            raise ValueError("close должен быть одномерным рядом")
        if not np.all(np.isfinite(self.close)):
            raise ValueError("close содержит NaN/inf")
        if self.close.size < 2:
            raise ValueError("Недостаточно данных для NextBarDirectionLabel: нужно >= 2")
        if eps < 0:
            raise ValueError("eps должен быть >= 0")
        self.eps = float(eps)

    def calc(self) -> int:
        prev_c = self.close[-2]
        curr_c = self.close[-1]
        if prev_c == 0:
            raise ValueError("деление на ноль (предыдущее close равно 0)")
        r = curr_c / prev_c - 1.0
        if r > self.eps:
            return 1
        if r < -self.eps:
            return -1
        return 0
```

### Базовые Labels (перечень)

1. `NextBarDirectionLabel` — направление следующего бара (пример выше).
2. `HorizonReturnLabel` — знак доходности за горизонт `h` с мёртвой зоной `eps`.
3. `MultiClassReturnLabel` — дискретизация доходности по порогам (мультикласс).
4. `TPSLFirstTouchLabel` — какое событие сработало раньше в окне: TP, SL или ничего.
5. `DrawdownBreachLabel` — превышён ли локальный просадочный порог (MAE) за горизонт.
6. `BreakoutLabel` — пробой `HH/LL` за lookback-окно.
7. `MACrossoverLabel` — кроссовер быстрый/медленный MA на текущем баре.
8. `TrendRegimeLabel` — режим тренда (вверх/вниз/нейтр.) по цене vs SMA и ADX.
9. `VolatilityRegimeLabel` — режим волатильности (низкая/средняя/высокая) по ATR/σ.
10. `VolumeSpikeLabel` — всплеск объёма относительно SMA(volume).
11. `GapDirectionLabel` — гэп на открытии относительно предыдущего закрытия.
12. `InsideOutsideBarLabel` — внутренний/внешний бар.
13. `BollingerBreakLabel` — выход закрытия за границы Боллинджера.
14. `KeltnerSqueezeLabel` — “сквиз”: полоса Боллинджера внутри Келтнера (режим).

> Примечание: все метки возвращают **целое число** согласно кодировке ниже. При необходимости бинарные метки используют {0,1}, направленные — {-1,0,1}, режимы — {0,1,2} и т.д., что явно оговорено в ТЗ каждой метки.

---

### ТЗ по каждой метке

#### 1) NextBarDirectionLabel
- **Назначение**: направление изменения закрытия текущего бара относительно предыдущего с мёртвой зоной.
- **Входы**: `close: Sequence[float]`; **Параметры**: `eps: float >= 0` (по умолчанию `0.0`).
- **Кодирование (int)**: `-1` (вниз), `0` (|r| ≤ eps), `1` (вверх); где `r = close[-1]/close[-2]-1`.
- **Сигнатуры**:  
    `__init__(close: Sequence[float], eps: float = 0.0) -> None`  
    `calc(self) -> int`
- **Мин. длина данных**: `2`.
- **Ошибки**: недостаток данных; `eps < 0`; `prev_close == 0`; NaN/inf.
- **Детерминизм**: обязателен.
    
#### 2) HorizonReturnLabel
- **Назначение**: знак доходности за горизонт `h` баров (классификация {-1/0/1}).
- **Входы**: `close`; **Параметры**: `h: int > 0`, `eps: float >= 0`.
- **Кодирование**: `r_h = close[-1]/close[-1-h] - 1`; > eps → `1`; < -eps → `-1`; иначе `0`.
- **Сигнатуры**:  
    `__init__(close: Sequence[float], h: int, eps: float = 0.0) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `h + 1`.
- **Ошибки**: `h<=0`; `eps<0`; база равна 0; NaN/inf.
    
#### 3) MultiClassReturnLabel
- **Назначение**: мультиклассовая дискретизация доходности по симметричным порогам.
- **Входы**: `close`; **Параметры**: `h: int>0`, `thresholds: Sequence[float]` упорядочены `0 < t1 < t2 < ...`.
- **Кодирование** (пример):  
    Пусть `r_h` как выше. Классы:  
    `0: r_h < -t_k`, `1: -t_k ≤ r_h < -t_{k-1}`, …, `k: -t_1 ≤ r_h ≤ t_1`, …, `2k: r_h > t_k`.  
    (Чёткая схема должна быть зафиксирована в докстринге реализации; коды — `0..2k`.)
- **Сигнатуры**:  
    `__init__(close: Sequence[float], h: int, thresholds: Sequence[float]) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `h + 1`.
- **Ошибки**: пустые/нестрого возрастающие пороги; отрицательные пороги; база=0.
    
#### 4) TPSLFirstTouchLabel
- **Назначение**: что сработает первым в ближайшие `h` баров от **текущей цены входа**: TP, SL или ничто.
- **Входы**: `high, low, close`; **Параметры**: `h: int>0`, `tp: float>0`, `sl: float>0`, `side: int in {1,-1}` (лонг/шорт).
- **Определения**: точка входа `px = close[-1]`.
    - Для **лонга**: TP-хит при `high[t] >= px*(1+tp)`, SL-хит при `low[t] <= px*(1-sl)`.
    - Для **шорта**: TP-хит при `low[t] <= px*(1-tp)`, SL-хит при `high[t] >= px*(1+sl)`.  
        Смотрим **первое** событие по времени в окне `1..h`.
- **Кодирование**: `1`=TP, `-1`=SL, `0`=ничего за `h`.
- **Сигнатуры**:  
    `__init__(high, low, close, h: int, tp: float, sl: float, side: int) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `h + 1`.
- **Ошибки**: `tp<=0`/`sl<=0`; `side` не в `{1,-1}`; несогласованные длины H/L/C.
    
#### 5) DrawdownBreachLabel
- **Назначение**: был ли **макс. неблагоприятный ход (MAE)** хуже порога в ближайшие `h` баров.
- **Входы**: `high, low, close`; **Параметры**: `h: int>0`, `mae_thr: float>0`, `side: {1,-1}`.
- **Определения**:
    - Лонг: `MAE = max(0, (px - min_low)/px)` за окно, где `px=close[-1]`.
    - Шорт: `MAE = max(0, (max_high - px)/px)`.  
        Бинарная проверка `MAE >= mae_thr`.
- **Кодирование**: `1`=порог нарушен, `0`=нет.
- **Сигнатуры**:  
    `__init__(high, low, close, h: int, mae_thr: float, side: int) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `h + 1`.
- **Ошибки**: `mae_thr<=0`; `side` неверен; H/L/C длины.
    
#### 6) BreakoutLabel
- **Назначение**: был ли пробой исторического экстремума за lookback `L` на текущем баре.
- **Входы**: `high, low, close`; **Параметры**: `L: int>0`, `mode: {"high","low","both"}`.
- **Кодирование**:
    - `1`=пробит максимум `max(high[-L-1:-1])` закрытием `close[-1] > HH`;
    - `-1`=пробит минимум `close[-1] < LL`;
    - `0`=нет пробоя; при `mode="high"/"low"` допускается только соответствующее направление.
- **Сигнатуры**:  
    `__init__(high, low, close, L: int, mode: str = "both") -> None`  
    `calc(self) -> int`
- **Мин. длина**: `L + 1`.
- **Ошибки**: `L<=0`; `mode` не из набора.
    
#### 7) MACrossoverLabel
- **Назначение**: фиксирует **событие кроссовера** быстрый/медленный MA **на текущем баре**.
- **Входы**: `close`; **Параметры**: `fast:int>0`, `slow:int>0`, `ma_type: {"SMA","EMA","WMA"}`.
- **Кодирование**: `1`=golden cross (fast пересёк slow снизу вверх), `-1`=death cross (сверху вниз), `0`=нет события на этом баре. Требуется сравнение пар `({t-1},{t})`.
- **Сигнатуры**:  
    `__init__(close, fast: int, slow: int, ma_type: str = "SMA") -> None`  
    `calc(self) -> int`
- **Мин. длина**: `max(fast, slow) + 1`.
- **Ошибки**: `fast>=slow` запрещено; неверный `ma_type`.
    
#### 8) TrendRegimeLabel
- **Назначение**: режим тренда (вверх/нейтр./вниз) на основе положения цены vs SMA и силы тренда по ADX.
- **Входы**: `high, low, close`; **Параметры**: `len_sma:int>0`, `adx_len:int>0`, `adx_thr: float>=0`.
- **Логика**:
    - `trend_dir = sign(close[-1] - SMA(close,len_sma))` → `dir ∈ {-1,0,1}` (0 при |разности| ≤ eps_price опционально).
    - `trend_strength = ADX(adx_len) >= adx_thr`.
    - Кодирование: `1`=сильный ап-тренд (`dir=1` и `strength`), `-1`=сильный даун-тренд (`dir=-1` и `strength`), `0`=иное.
- **Сигнатуры**:  
    `__init__(high, low, close, len_sma: int, adx_len: int, adx_thr: float = 20.0) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `max(len_sma, adx_len) + 1`.
- **Ошибки**: некорректные параметры; несогласованные H/L/C.
    
#### 9) VolatilityRegimeLabel
- **Назначение**: классификация волатильности (низкая/средняя/высокая) по ATR или σ-доходностей.
- **Входы**: `high, low, close`; **Параметры**: `mode: {"ATR","STD"}`, `length:int>0`, `thr_low:float>=0`, `thr_high:float>thr_low`.
- **Нормировка**:
    - ATR-режим: `vol = ATR(length) / close[-1]`.
    - STD-режим: `vol = std( ln(C_t/C_{t-1}) на окне length ) * sqrt(252)`.
- **Кодирование**: `0` (vol ≤ thr_low), `1` (thr_low < vol ≤ thr_high), `2` (vol > thr_high).
- **Сигнатуры**:  
    `__init__(high, low, close, mode: str, length: int, thr_low: float, thr_high: float) -> None`  
    `calc(self) -> int`
- **Мин. длина**: для ATR — `length + 1`; для STD — `length + 1`.
- **Ошибки**: `thr_high<=thr_low`; неверный `mode`.
    
#### 10) VolumeSpikeLabel
- **Назначение**: всплеск объёма относительно скользящей средней объёма.
- **Входы**: `volume`; **Параметры**: `len_sma:int>0`, `mult:float>0`, `drought_mult:float>0` (опц.).
- **Кодирование**:
    - `1` если `volume[-1] >= mult * SMA(volume, len_sma)`;
    - `-1` если `volume[-1] <= SMA/ d_r` (если `drought_mult` задан);
    - `0` иначе.
- **Сигнатуры**:  
    `__init__(volume, len_sma: int, mult: float, drought_mult: float | None = None) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `len_sma`.
- **Ошибки**: некорректные множители; `SMA==0` и т.д.
    
#### 11) GapDirectionLabel
- **Назначение**: определение гэпа открытия относительно предыдущего закрытия.
- **Входы**: `open, close` (или `open` и предыдущий `close`); **Параметры**: `eps: float>=0`.
- **Кодирование**:  
    `gap = open[-1]/close[-2] - 1`; `1` если `gap > eps`; `-1` если `gap < -eps`; `0` иначе.
- **Сигнатуры**:  
    `__init__(open: Sequence[float], close: Sequence[float], eps: float = 0.0) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `2`.
- **Ошибки**: `close[-2]==0`; `eps<0`.
    
#### 12) InsideOutsideBarLabel
- **Назначение**: классификация текущего бара: **inside** (сжатие) / **outside** (расширение) относительно предыдущего.
- **Входы**: `high, low`; **Параметры**: нет (или `eps_abs` для равенств).
- **Определения**:
    - Inside: `high[-1] <= high[-2]` и `low[-1] >= low[-2]`.
    - Outside: `high[-1] >= high[-2]` и `low[-1] <= low[-2]`.
    - Иначе: none.
- **Кодирование**: `1`=outside, `-1`=inside, `0`=none.
- **Сигнатуры**:  
    `__init__(high, low) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `2`.
- **Ошибки**: недостаток данных.
    
#### 13) BollingerBreakLabel
- **Назначение**: выход закрытия за границы полос Боллинджера на текущем баре.
- **Входы**: `close`; **Параметры**: `length:int>0`, `std_mult:float>0`.
- **Определения**: `SMA=mean(close[-length:])`, `σ=std(..., ddof=0)`.  
    Верхняя/нижняя полоса: `bb_u = SMA + std_mult*σ`, `bb_l = SMA - std_mult*σ`.
- **Кодирование**: `1` если `close[-1] > bb_u`; `-1` если `< bb_l`; `0` иначе.
- **Сигнатуры**:  
    `__init__(close, length: int, std_mult: float) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `length`.
- **Ошибки**: `length<=0`, `std_mult<=0`.
    
#### 14) KeltnerSqueezeLabel
- **Назначение**: режим “сквиза” — полосы Боллинджера находятся **внутри** канала Келтнера (сжатие).
- **Входы**: `high, low, close`; **Параметры**: `length:int>0`, `kc_mult:float>0`, `bb_mult:float>0`.
- **Определения**:
    - `mid = EMA(close, length)`; `ATR = ATR(length)`; `KC_u = mid + kc_mult*ATR`, `KC_l = mid - kc_mult*ATR`.
    - `BB_u/l` как в пунктах выше.
    - Сжатие, если `BB_u <= KC_u` и `BB_l >= KC_l`.
- **Кодирование**: `1`=сквиз (сжатие), `0`=нет.
- **Сигнатуры**:  
    `__init__(high, low, close, length: int, kc_mult: float, bb_mult: float) -> None`  
    `calc(self) -> int`
- **Мин. длина**: `length + 1` (для ATR).
- **Ошибки**: параметры ≤ 0; несогласованные H/L/C.
    
---

### Общие требования по качеству (для всех Labels)

1. **Единая архитектура**: каждый класс наследует `Label`, реализует `__init__` и `calc()->int`.
2. **Валидация входов**: типы (list/tuple/np.ndarray), одномерность, конечность значений; согласованность длин H/L/C/V.
3. **Ошибки**: информативные `ValueError`/`TypeError`; отсутствие делений на ноль и NaN/inf в расчётах и на выходе.
4. **Детерминизм**: повторные вызовы `calc()` на тех же данных обязаны давать идентичный результат.
5. **Сложность**: O(n) по длине используемого окна; без модификации входных массивов.
6. **Докстринги**: для каждого класса — назначение, входы, параметры, кодировка, формула/правила, минимальная длина, граничные случаи.
7. **Стандартизация кодов**:
    - направленные: `{-1,0,1}`;
    - бинарные: `{0,1}`;
    - режимы 3-класса: `{0,1,2}`;
    - мультикласс по порогам: `0..K` (зафиксировать в докстринге и тестах).
8. **Зависимости**: только `numpy` (при необходимости).
9. **Временные окна**: расчёт **только** по поданному отрезку данных; нет скрытого состояния.

---

# Normalize

|-----------------|
abstart class Normalize
|-----------------|
`def __init__`
`def __calc__`

```python
class Normalize(ABC):
    """
    Абстрактный класс для всех нормализаторов признаков/рядов.

    Контракт:
      - fit(x): оценка параметров нормализации на 1D-выборке; вернуть self
      - transform(x) -> np.ndarray: применение нормализации
      - fit_transform(x) -> np.ndarray: fit(x) + transform(x)
      - inverse_transform(x_norm) -> np.ndarray: обратное преобразование
      - get_params() -> dict: вернуть обученные параметры (mean/std, min/max, scale и т.п.)
      - set_params(**params) -> Normalize: загрузить параметры; установить состояние "обучен"

    Стандарты:
      - Входы: Sequence[float] или np.ndarray (только 1D, конечные значения)
      - Выходы: np.ndarray(dtype=float, ndim=1)
      - Запрещено: модифицировать входные массивы; возвращать NaN/inf/None
      - Ошибки: TypeError/ValueError с понятными сообщениями
    """

    def __init__(self) -> None:
        # Базовое состояние; наследники обязаны установить True в fit()/set_params()
        self._fitted: bool = False

    # ---------- Обязательные методы для переопределения наследниками ----------

    @abstractmethod
    def fit(self, x: Sequence[float]) -> "Normalize":
        """
        Оценить параметры нормализации на массиве x и вернуть self.
        Требования к x:
          - одномерный ряд
          - len(x) > 0
          - только конечные значения
        Обязанности реализации:
          - сохранить рассчитанные параметры
          - установить self._fitted = True
        """
        raise NotImplementedError("fit must be implemented by subclass")

    @abstractmethod
    def transform(self, x: Sequence[float]) -> np.ndarray:
        """
        Применить нормализацию к x с использованием ранее оценённых параметров.
        Если нормализатор не обучен (self._fitted=False), выбросить RuntimeError.
        Возврат: новый np.ndarray (не изменяющий входной x).
        """
        raise NotImplementedError("transform must be implemented by subclass")

    @abstractmethod
    def inverse_transform(self, x_norm: Sequence[float]) -> np.ndarray:
        """
        Преобразовать нормализованные значения обратно в исходное пространство.
        Должна использовать те же параметры, что и transform().
        """
        raise NotImplementedError("inverse_transform must be implemented by subclass")

    @abstractmethod
    def get_params(self) -> Dict[str, Any]:
        """
        Вернуть словарь с обученными параметрами нормализации.
        Примеры ключей: 'mean', 'std', 'min', 'max', 'scale', 'offset' и т.д.
        """
        raise NotImplementedError("get_params must be implemented by subclass")

    @abstractmethod
    def set_params(self, **params: Any) -> "Normalize":
        """
        Установить параметры нормализации из внешнего источника; вернуть self.
        Обязана валидировать значения и установить self._fitted = True.
        """
        raise NotImplementedError("set_params must be implemented by subclass")

    # ---------- Готовые базовые утилиты (можно использовать в наследниках) ----------

    def fit_transform(self, x: Sequence[float]) -> np.ndarray:
        """
        Удобный конвейер: fit(x) затем transform(x).
        """
        self.fit(x)
        return self.transform(x)

    @property
    def fitted(self) -> bool:
        """True, если нормализатор обучен или параметры установлены."""
        return self._fitted

    def _require_fitted(self) -> None:
        """
        Вспомогательная проверка для наследников перед transform()/inverse_transform().
        """
        if not self._fitted:
            raise RuntimeError("Нормализатор не обучен: вызовите fit(...) или set_params(...).")

    @staticmethod
    def _as_np_1d(x: Sequence[float], name: str = "x") -> np.ndarray:
        """
        Приведение входа к np.ndarray(dtype=float, ndim=1) с проверками.
        Возвращает КОПИЮ массива, чтобы исключить модификацию входных данных.
        """
        if not isinstance(x, (list, tuple, np.ndarray)):
            raise TypeError(f"{name} должен быть list/tuple/np.ndarray")
        arr = np.asarray(x, dtype=float)
        if arr.ndim != 1:
            raise ValueError(f"{name} должен быть одномерным рядом")
        if arr.size == 0:
            raise ValueError(f"{name} пуст")
        if not np.all(np.isfinite(arr)):
            raise ValueError(f"{name} содержит NaN/inf")
        return arr.copy()
```


### Example

```python
class ZScoreNormalize(Normalize):
    """
    Нормализация в z-оценки (стандартизация).

    Формула:
        y_i = (x_i - mean_) / max(std_, eps)      # если with_center=True и with_scale=True
        y_i = (x_i - mean_)                       # если with_center=True и with_scale=False
        y_i =  x_i / max(std_, eps)               # если with_center=False и with_scale=True
        y_i =  x_i                                # если оба False (тривиальная идентичность)

    Обратное преобразование:
        x_i = y_i * s + m, где
        s = (with_scale ? max(std_, eps) : 1.0)
        m = (with_center ? mean_ : 0.0)

    Параметры:
      - with_center: bool = True  — вычитать среднее
      - with_scale:  bool = True  — делить на стандартное отклонение
      - ddof:        int  = 0     — параметр для np.std (0 — популяционное, 1 — выборочное)
      - eps:         float= 1e-12 — защита от деления на 0 (используется через max(std_, eps))

    Атрибуты после fit():
      - mean_: float
      - std_:  float (несмещённое значение np.std(x, ddof))
    """

    def __init__(
        self,
        *,
        with_center: bool = True,
        with_scale: bool = True,
        ddof: int = 0,
        eps: float = 1e-12,
    ) -> None:
        super().__init__()
        if ddof < 0:
            raise ValueError("ddof должен быть >= 0")
        if eps <= 0 or not np.isfinite(eps):
            raise ValueError("eps должен быть положительным конечным числом")
        self.with_center = bool(with_center)
        self.with_scale = bool(with_scale)
        self.ddof = int(ddof)
        self.eps = float(eps)
        # Будут заданы в fit()/set_params()
        self.mean_: float = np.nan
        self.std_: float = np.nan

    def fit(self, x: Sequence[float]) -> "ZScoreNormalize":
        arr = self._as_np_1d(x, "x")
        self.mean_ = float(np.mean(arr)) if self.with_center else 0.0
        # std вычисляем всегда для согласованности inverse_transform,
        # но применяем только если with_scale=True
        std_val = float(np.std(arr, ddof=self.ddof))
        if std_val < 0 or not np.isfinite(std_val):
            raise ValueError("std получился некорректным (NaN/inf/отрицательный)")
        self.std_ = std_val
        self._fitted = True
        return self

    def transform(self, x: Sequence[float]) -> np.ndarray:
        self._require_fitted()
        arr = self._as_np_1d(x, "x")
        out = arr
        if self.with_center:
            out = out - self.mean_
        if self.with_scale:
            s = max(self.std_, self.eps)
            out = out / s
        # Гарантируем float и 1D
        out = np.asarray(out, dtype=float).reshape(-1)
        if not np.all(np.isfinite(out)):
            raise ValueError("Результат transform содержит NaN/inf")
        return out

    def inverse_transform(self, x_norm: Sequence[float]) -> np.ndarray:
        self._require_fitted()
        arr = self._as_np_1d(x_norm, "x_norm")
        out = arr
        # Обратное масштабирование и центрирование выполняем в обратном порядке
        if self.with_scale:
            s = max(self.std_, self.eps)
            out = out * s
        if self.with_center:
            out = out + self.mean_
        out = np.asarray(out, dtype=float).reshape(-1)
        if not np.all(np.isfinite(out)):
            raise ValueError("Результат inverse_transform содержит NaN/inf")
        return out

    def get_params(self) -> Dict[str, Any]:
        self._require_fitted()
        return {
            "with_center": self.with_center,
            "with_scale": self.with_scale,
            "ddof": self.ddof,
            "eps": self.eps,
            "mean_": float(self.mean_),
            "std_": float(self.std_),
        }

    def set_params(self, **params: Any) -> "ZScoreNormalize":
        # Восстановление параметров без fit()
        required = {"with_center", "with_scale", "ddof", "eps", "mean_", "std_"}
        missing = required - set(params.keys())
        if missing:
            raise ValueError(f"Отсутствуют параметры для set_params: {sorted(missing)}")

        with_center = bool(params["with_center"])
        with_scale = bool(params["with_scale"])
        ddof = int(params["ddof"])
        eps = float(params["eps"])
        mean_ = float(params["mean_"])
        std_ = float(params["std_"])

        if ddof < 0:
            raise ValueError("ddof должен быть >= 0")
        if eps <= 0 or not np.isfinite(eps):
            raise ValueError("eps должен быть положительным конечным числом")
        if std_ < 0 or not np.isfinite(std_):
            raise ValueError("std_ должен быть конечным неотрицательным числом")
        if not np.isfinite(mean_):
            raise ValueError("mean_ должен быть конечным числом")

        self.with_center = with_center
        self.with_scale = with_scale
        self.ddof = ddof
        self.eps = eps
        self.mean_ = mean_
        self.std_ = std_
        self._fitted = True
        return self

```

#### 1) MinMaxNormalize
**Назначение:** линейное масштабирование значений в заданный интервал [a,b][a, b] с корректной обратной трансформацией.

**Входы:**
- `x: Sequence[float]` — одномерный ряд конечных чисел.
**Параметры:**
- `feature_min: float = 0.0` (a) — нижняя граница диапазона.
- `feature_max: float = 1.0` (b) — верхняя граница диапазона, требуется `feature_max > feature_min`.
- `eps: float = 1e-12` — защита при нулевом размахе.
- `clip: bool = False` — опция отсечки результата в [a,b][a, b] при редких численных артефактах (_включение ухудшает точную обратимость на насыщенных точках_).
**Сигнатуры (интерфейс):**
- `__init__(feature_min: float = 0.0, feature_max: float = 1.0, eps: float = 1e-12, clip: bool = False) -> None`
- `fit(self, x: Sequence[float]) -> MinMaxNormalize`
- `transform(self, x: Sequence[float]) -> np.ndarray`
- `inverse_transform(self, x_norm: Sequence[float]) -> np.ndarray`
- `get_params(self) -> Dict[str, Any]` → возвращает `{"feature_min","feature_max","eps","clip","data_min_","data_max_"}`
- `set_params(self, **params: Any) -> MinMaxNormalize`
    
**Формулы:**  
Пусть после `fit`: `data_min_ = min(x)`, `data_max_ = max(x)`, `range_ = max(data_max_ - data_min_, eps)`, `F = feature_max - feature_min`
- Прямое: `y = feature_min + (x - data_min_) * F / range_`
- Обратное: `x = data_min_ + (y - feature_min) * range_ / F`
**Мин. длина данных:** `len(x) >= 1`.

**Ошибки:**
- Некорректные типы/NaN/inf/размерность → `TypeError/ValueError`.
- `feature_max <= feature_min` → `ValueError`.
- В `inverse_transform`: если `F == 0` (не должно случиться при валидации) → `ValueError`.
    
**Детерминизм и обратимость:**
- Детерминированно; при `clip=False` — строго обратимо (кроме численных округлений).
- При `clip=True` насыщенные значения обратятся к границе (потеря точности — ожидаемое поведение).

#### 2) RobustNormalize
**Назначение:** устойчивое к выбросам центрирование и масштабирование по медиане и IQR.

**Входы:**
- `x: Sequence[float]` — одномерный ряд конечных чисел.
**Параметры:**
- `with_center: bool = True` — вычитать медиану.
- `with_scale: bool = True` — делить на IQR.
- `q_low: float = 25.0`, `q_high: float = 75.0` — процентили для IQR, `0 < q_low < q_high < 100`.
- `eps: float = 1e-12` — защита при нулевом IQR.
**Сигнатуры (интерфейс):**
- `__init__(with_center: bool = True, with_scale: bool = True, q_low: float = 25.0, q_high: float = 75.0, eps: float = 1e-12) -> None`
- `fit(self, x: Sequence[float]) -> RobustNormalize`
- `transform(self, x: Sequence[float]) -> np.ndarray`
- `inverse_transform(self, x_norm: Sequence[float]) -> np.ndarray`
- `get_params(self) -> Dict[str, Any]` → `{"with_center","with_scale","q_low","q_high","eps","median_","iqr_"}`
- `set_params(self, **params: Any) -> RobustNormalize`
    
**Формулы:**  
Пусть после `fit`: `median_ = median(x)`, `q1 = quantile(x, q_low)`, `q3 = quantile(x, q_high)`, `iqr_ = max(q3 - q1, eps)`.
- Прямое:
    - если `with_center` и `with_scale`: `y = (x - median_) / iqr_`
    - если только центрирование: `y = x - median_`
    - если только масштабирование: `y = x / iqr_`
    - если оба False: `y = x`
- Обратное: `x = y * s + m`, где `s = (with_scale ? iqr_ : 1.0)`, `m = (with_center ? median_ : 0.0)`.
**Мин. длина данных:** `len(x) >= 1`.

**Ошибки:**
- Неверные процентили/тип/NaN/inf → `ValueError/TypeError`.
- Если `q_high - q_low` слишком мал → устойчивость проверяется через `eps`.
- В `inverse_transform` — проверка, что нормализатор обучен.

**Детерминизм и обратимость:**
- Детерминированно; обратимость точная (с учётом `eps` и округлений).
    
#### 3) LogScaleNormalize
**Назначение:** стабилизировать дисперсию и правый хвост распределения через лог-преобразование со сдвигом, затем z-стандартизация в лог-пространстве; обратимое.

**Входы:**
- `x: Sequence[float]` — одномерный ряд конечных чисел; допускает неположительные значения при авто-сдвиге.
**Параметры:**
- `shift: float | None = None` — добавляемый сдвиг перед логом. Если `None`, на `fit` выбирается автоматически: `shift_ = max(0, -(min(x)) + delta)` так, чтобы `x + shift_ > 0`.
- `delta: float = 1e-9` — минимальная прибавка в авто-режиме.
- `with_center: bool = True` — центрирование в лог-пространстве.
- `with_scale: bool = True` — масштабирование (std) в лог-пространстве.
- `ddof: int = 0` — параметр дисперсии.
- `eps: float = 1e-12` — защита от нулевой std

**Сигнатуры (интерфейс):**
- `__init__(shift: float | None = None, delta: float = 1e-9, with_center: bool = True, with_scale: bool = True, ddof: int = 0, eps: float = 1e-12) -> None`
- `fit(self, x: Sequence[float]) -> LogScaleNormalize`
- `transform(self, x: Sequence[float]) -> np.ndarray`
- `inverse_transform(self, x_norm: Sequence[float]) -> np.ndarray`
- `get_params(self) -> Dict[str, Any]` → `{"shift_","with_center","with_scale","ddof","eps","mu_","sigma_","delta"}`
- `set_params(self, **params: Any) -> LogScaleNormalize`
    
**Формулы:**  
На этапе `fit`
1. Выбор сдвига:
    - если `shift is None`: `shift_ = max(0.0, -min(x) + delta)`; иначе `shift_ = shift` (валидируется, чтобы `x_i + shift_ > 0` для всех i).
2. Переход в лог-пространство: `z = ln(x + shift_)`.
3. `mu_ = mean(z) if with_center else 0.0`; `sigma_ = std(z, ddof)`.
На `transform`
- Вычислить `z = ln(x + shift_)`.
- Если `with_center`: `z = z - mu_`.
- Если `with_scale`: `z = z / max(sigma_, eps)`.
- Вернуть `y = z`.
На `inverse_transform`
- `z = y`; если `with_scale`: `z = z * max(sigma_, eps)`; если `with_center`: `z = z + mu_`.
- Вернуть `x = exp(z) - shift_`.
**Мин. длина данных:** `len(x) >= 1` (но практически полезно ≥ 2 для std).

**Ошибки:**
- Если `shift is not None` и существует `x_i + shift <= 0` → `ValueError`.
- `delta <= 0` → `ValueError`.
- NaN/inf/тип/размерность → `TypeError/ValueError`.
- Нулевая дисперсия в лог-пространстве обрабатывается через `eps`.

**Детерминизм и обратимость:**
- Детерминированно.
- Полностью обратимо (за исключением численных округлений), если не было внешнего клиппинга.
### Общие критерии приёмки для всех трёх нормализаторов

1. Строгая совместимость с базовым интерфейсом `Normalize`: реализованы `fit/transform/inverse_transform/get_params/set_params`, `fit_transform` унаследован.
2. Полные докстринги: назначение, входы, параметры, формулы, обратимость, минимальные длины, граничные случаи.
3. Жёсткая валидация входов: 1D, конечные числа, информативные ошибки.
4. Не модифицировать входные массивы; возвращать новый `np.ndarray(float, 1D)`.
5. Детерминизм: повторный `transform` на тех же параметрах даёт идентичный результат; `inverse_transform(transform(x)) ≈ x` (с точностью до `1e-9`–`1e-12` в зависимости от масштаба).
6. `get_params()/set_params(...)` обеспечивают воспроизводимость инференса без повторного `fit`.

---

# Decrease Dimensions

|-----------------|
abstract class decDimensions
|-----------------|
`def __init__`
`def __calc__`


---

# Data Analyze 

|-----------------|
class DataAnalyze
|-----------------|
`def __init__`
`def getDataViaApi`
`def getFeatures`
`def getLabels`
`def normalize`
`def decDimensions`
`def out`