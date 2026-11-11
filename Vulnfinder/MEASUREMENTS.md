# Исправления и измерения: 22–25 октября 2026

Статус: выполнены регрессии и внешние пилоты; **полная публикационная матрица ещё
не завершена**. Нельзя выдавать приведённые выборки за результаты на всём Juliet,
BinPool или CompRealVul. Исторические и неудачные запуски сохранены, не перезаписаны.

## Исправления

1. Верхняя граница маски/сравнение счётчика больше не доказывает достижимый OOB.
   `unsafe_operations.py` выдаёт `suspicious/llm-only`; `evidence_policy.py` запрещает
   promotion также старых range/loop payloads. Версия политики — v3.
   Это консервативное исправление ложного доказательства, не новый path solver.
2. Живой NO_AUTO-прогон выявил `UnboundLocalError` в `InvestigationWorklist._discover`:
   условный локальный импорт перекрывал импорт модуля. Импорт удалён; worklist v5
   инвалидирует прежний resume identity. Регрессия проверяет findings при выключенном
   promotion как с включёнными, так и с выключенными unsafe operations.
3. Внешний экспорт обнаружил подмену скрипта порядком поиска Ghidra: несмотря на
   `-scriptPath tools/exportfg`, реально выполнялся `/home/zn/ghidra_scripts/ExportFG.java`
   v3. Это видно в `INFO SCRIPT:` исходных export logs и версии в graph metadata.
   Vendored v5 синхронизирован с проверенным внешним v6; runner создаёт уникальный
   hash-named Java class и проверяет **реально загруженный путь и emitted version**.
   Пользовательский скрипт в домашней директории не изменён.

## Что уже измерено по компонентам

| Компонент | Наблюдаемый эффект | Граница вывода |
|---|---|---|
| Range/loop promotion | Safe counterexamples: 7→0 ложных продвижений; два true cases перестают auto-promote | Исправлена ложная доказательность, новый path solver не реализован |
| IR layout/capacities/frame | +2 TP в 2×2 deterministic сравнении | Девять development-дефектов |
| Межпроцедурный strong-taint | +1 TP в том же сравнении | Intra-function text-taint сохранён |
| Экспортёр v3→v6 | Пригодный IR у всех 40 внешних целей; ML/deterministic predictions не изменились | Два изменённых ML-признака не используются deployed bundle |
| ML fusion | Juliet mean AP 0.8431 против XGB 0.8219; CompReal 0.4510 против 0.4544 | External CI включает ноль; ML-shadow не улучшает A3 decisions сам по себе |
| Candidate→confirmed policy | В v6-пилоте 4 TP/3 FP candidates → 0 confirmed, 0% decision coverage | Function-level endpoint; unknown не negative |
| Упаковка context | 6000→24000: целый IR-блок 3/8→8/8; живой verifier не дал дополнительных confirmed, prompt tokens +43% | Фиксированные кандидаты, 8 целей × 3 повтора; не whole-program |
| Encoder input limit | Обрезаются 2/32 CompReal и 8/8 BinPool inputs | Влияние другого encoder limit на качество ещё не измерено |
| ML routing | Recall ceiling по 1/5/10/20/50/100% бюджета | Offline replay, не live экономия LLM |
| Requests/requeue, library policy, whole-program context | Внешней оценки эффекта пока нет | В пилоте нет исполнимых requests; target-only scope не заменяет whole-program |

## Влияние range fix и компонентов на regression-набор

Источник: [regression-components.json](measurements/20261022/regression-components.json).
8 specs, 9 ожидаемых дефектов. GT не изменялась. Это разработческий набор,
использованный при создании правил, а не независимый holdout.

| Вариант                                       |  TP |  FP |  FN |
| --------------------------------------------- | --: | --: | --: |
| Старое range-правило, изолированный replay    |   9 |   0 |   0 |
| Исправленный deterministic                    |   7 |   0 |   2 |
| Без IR layout/capacities/frame                |   5 |   0 |   4 |
| Без межпроцедурного strong-taint              |   6 |   0 |   3 |
| Только текст: без обоих дополнительных входов |   4 |   0 |   5 |

`D_NO_LAYOUT` не удаляет размеры, выведенные из самого C-текста;
`D_NO_INTERPROC_TAINT` оставляет intra-function text-taint. Это точные определения
вмешательств, а не заявления «весь layout/taint удалён».

Эти четыре варианта образуют 2×2 factorial. [Поэлементный contrast](measurements/20261025/regression-factorial.json)
даёт +2 TP от layout (liteserver `get_mime_type`, rest `fill`) и +1 TP от
межпроцедурного taint (liteserver `parse_headers`), как при включённом, так и при
выключенном втором компоненте. Взаимодействие по TP: 7−5−6+4=0. На этом
разработческом наборе эффекты складываются; это не доказательство общей независимости
компонентов. Три Juliet format-string регрессии сохраняют intra-function text-taint.

В отдельном наборе из 7 безопасных range-контрпримеров старое правило ошибочно
продвигает 7/7, исправленное — 0/7. Для двух истинных range-примеров promotion
меняется 2/2 → 0/2: они остаются кандидатами, требующими value/path evidence.
Replay восстанавливает только удалённое правило, не исполняет исторический checkout;
реальный исходный regression baseline также сохранён в первоначальном readiness snapshot.

## Juliet: 897 совпадающих с ML функций

[Manifest](measurements/20261022/juliet-manifest.jsonl),
[predictions и paired CI](measurements/20261022/juliet-deterministic-v2/metrics.json).
264 positive, 633 negative, 691 сохранённая upstream group. Отбор — весь существующий
development test, без выбора по score. Все цели сопоставлены, ошибок 0.

| Endpoint                                                 |  TP |  FP |  FN |
| -------------------------------------------------------- | --: | --: | --: |
| Deterministic promotion                                  |   8 |   0 | 256 |
| Все unsafe/suspicious/needs-layout/needs-taint кандидаты | 110 | 211 | 154 |
| Фиксированный список sink API                            |  88 | 111 | 176 |

Все 897 исходных графов **без sidecar**. Поэтому равенство D_FULL, D_NO_LAYOUT,
D_NO_INTERPROC_TAINT и D_TEXT здесь не свидетельствует о бесполезности IR:
дополнительных входов попросту нет. Первый adapter не распознал 349 сокращённых C++
имён; каталог `juliet-deterministic` сохранён как неудачный. В v2 применяется exact
match либо единственный namespace-qualified suffix, неоднозначность остаётся ошибкой.

Контроль по одному имени (`good`/`bad`) классифицирует 897/897 правильно.
Это доказательство label leakage в **сырых именах**, не доказательство того, что ML
ими пользовался. Нельзя публиковать LLM-качество на таком Juliet без общего sanitizer.

## ML: отдельный сигнал, не улучшение LLM через shadow

Сохранённые прогнозы шести ветвей на 897 функциях пересчитаны для seed 0/1/2,
с paired group-bootstrap 2000 draws. Источник и hashes —
[readiness snapshot](readiness_snapshot.json), раздел `fusion_rescore`.
Средняя AP gated = 0.8431, XGBoost = 0.8219; seed 0 CI разницы включает ноль.
Этот test использовался при развитии модели и остаётся development evidence.

[Routing replay](measurements/20261022/juliet-routing.json) измеряет бюджеты
1/5/10/20/50/100% функций для embedding, XGBoost, gated и random по трём seed.
Пример seed 2, top 10% = 90 функций: gated и XGBoost выбирают 90 positive,
embedding — 55, random — 25. Максимально возможный downstream recall для первых
двух — 90/264 = 34.1%, даже если следующий детектор идеален.
Это replay фиксированного числа функций, **не** измерение live экономии времени/токенов.

`ml-shadow` сохраняет LLM findings; это проверяется существующими regression tests.
Frozen inference и replay не дают оснований писать «ML улучшил итоговый recall A3».

## CompRealVul: инвентаризация и свежий frozen inference

Ревизия Hugging Face: `92bc2a3f280d9e4d80c19f747777c20c0772dcbb`.
[Inventory](measurements/20261022/compreal/inventory.json) содержит SHA256 всех
18 538 ELF и исходную разметку: 8 141 positive / 10 397 negative.
Файлы `.exe` здесь являются ELF. Бинарники не исполнялись, только декомпилировались.

[Label audit](measurements/20261022/compreal/label-audit.json): 112 групп, 226 строк
имеют одинаковые **binary SHA256 + target function**, но противоположные labels.
Это конфликт идентичного бинарного входа, не просто совпадение имён. В пилоте
одна такая цель: `compreal-00149161540cbad4`. Её исходная метка сохранена отдельно,
а primary label становится null; цель не удаляется и не заменяется другой.

Пилот: первые 16 объектов каждого класса по SHA256 имени файла **до прогнозов**.
32 цели экспортированы; после аудита 15 positive / 16 negative / 1 unknown.
Это сбалансированный feasibility pilot; precision нельзя переносить на реальную
распространённость уязвимостей. Groups заданы по функциям, полной project/clone lineage нет.

Свежий inference: packaged validation-selected seed 2, неизменные thresholds,
Qwen3-Embedding-0.6B pinned revision, CPU, без обучения. Основной повтор с v6:
[метрики](measurements/20261023/compreal-ml/metrics.json),
[сырые predictions](measurements/20261023/compreal-ml/predictions.jsonl).

| Модель | TP | FP | FN | AP |
|---|---:|---:|---:|---:|
| Embedding only | 13 | 13 | 2 | 0.6090 |
| XGBoost only | 9 | 9 | 6 | 0.4544 |
| Simple average | 8 | 9 | 7 | 0.5139 |
| Logistic stacking | 9 | 9 | 6 | 0.4515 |
| Ungated MLP | 9 | 11 | 6 | 0.4593 |
| Gated MLP | 9 | 12 | 6 | 0.4510 |

Gated−XGBoost: recovered TP=1, lost TP=1, added FP=4, removed FP=1.
ΔAP = −0.00339, conditional group CI95 [−0.06687, +0.05982]; ΔF1 = −0.04545,
CI95 [−0.18839, +0.09138]. Малый пилот не подтверждает перенос преимущества fusion
с Juliet; столь широкие интервалы не доказывают общее ухудшение.

Дополнительно выполнено отключение embedding при inference; это missing-channel
sensitivity, **не retraining ablation**. Thresholds не перенастраивались на пилоте.
Из 32 функций две превышают лимит encoder 1024 tokens.

Deterministic v6 на тех же 32 целях: 0 TP / 0 FP, 15 FN на известных labels;
все кандидаты дают 3 TP / 1 FP. Нулевая FP сама по себе не означает полезность
детектора с нулевым recall. [Результаты](measurements/20261023/compreal-deterministic/metrics.json).

## Внешний LLM-пилот и пригодность IR

Первый законченный пилот: 8 заранее выбранных функций × FULL/NO_AUTO/NO_UNSAFE,
48 logical requests, Gemma E4B Q4, context 8192, response budget 2048, reasoning off,
один повтор. FULL здесь означает **target-only A3**, max_depth=0, а не full-program.
Использованы исходные symbols CompReal, не общий sanitizer.

Экспорт этого первого пилота фактически был v3, и IR coverage = partial на всех
целях. Его нельзя называть результатом FULL с пригодным IR. Архив:
[первый runtime](measurements/20261022/compreal-runtime-v2/metrics.json),
[после label audit](measurements/20261022/verification-20261023/runtime-metrics-audited.json),
[стоимость и hypothesis attrition](measurements/20261022/verification-20261023/runtime-cost-and-attrition.json).

На 7 известных labels все три candidate endpoint: 4 TP / 3 FP; после verifier
0 confirmed и 0% decision coverage. Unknown не превращены в negative.
Обнаружены и общие описания функции, ошибочно выданные моделью как hypotheses;
это отдельно от доказательства наличия конкретного размеченного дефекта.
FULL/NO_AUTO/NO_UNSAFE заняли соответственно 530.1/553.8/568.8 секунды,
16 запросов каждый. Малые различия стоимости не имеют причинной интерпретации:
один последовательный повтор, кэш, неодинаковые ответы и совместная CPU-нагрузка.

**Повтор с проверенным v6 завершён**:
[метрики](measurements/20261023/compreal-runtime-v6/metrics.json),
[версионное сравнение](measurements/20261023/export-effect-final.json).
Во всех трёх вариантах: candidate 4 TP / 3 FP на известных labels, confirmed 0,
все 8 целей abstain на confirmed endpoint. Ошибок HTTP/процессов 0; это отсутствие
подтверждённого решения, не сбой выполнения и не безопасные функции.
FULL: 17 unknown + 3 needs_evidence hypotheses; NO_AUTO: 13 + 7;
NO_UNSAFE: 19 unknown. Типы/ссылки конкретных hypotheses сохранены в state/agent events.
Таким образом старый экспортёр был реальным дефектом, но исправление IR не закрыло
разрыв candidate → confirmed на этом пилоте. Нельзя считать все эти кандидаты
правильной локализацией размеченной уязвимости: metric здесь function-level.

| v6 runtime | Секунды | Запросы | Prompt tokens | Completion tokens |
|---|---:|---:|---:|---:|
| FULL | 261.2 | 16 | 58 743 | 12 046 |
| NO_AUTO | 245.8 | 16 | 58 840 | 11 825 |
| NO_UNSAFE | 252.9 | 16 | 58 261 | 11 803 |

Thinking действительно отсутствовал в transport (`reasoning_chars=0`).
Междатное ускорение относительно v3 не приписывается IR: разные cache/нагрузка,
выводы модели и последовательность исполнения. Суммировать candidate и confirmed
cost нельзя — это два представления одних запросов.
У всех 32 CompReal-целей новый IR coverage = complete.
Текст целевых функций v3/v6 совпадает побайтно 32/32: вмешательство касается evidence,
не другого исходного кода. Датированные artifacts позволяют сравнить оба состояния.

## Почему v6-пилот остаётся без окончательного решения

[Audit всех 24 запусков](measurements/20261025/attrition-and-context.json) восстановил
контексты production packer и сверил **48/48 input hashes и списков omissions**.
При несовпадении runner прекращает анализ: текущее восстановление нельзя молча
выдавать за исторический вход. Новых LLM-вызовов в этом audit нет.

Всего 59 гипотез: 40 local, 19 context; 49 unknown, 10 needs_evidence,
все с итоговым grade llm-only. В четырёх случаях сохранённая причина — policy
`Verifier did not cite available evidence`. Исходный verdict до policy в старых
артефактах отсутствует; нельзя утверждать, что все четыре были confirmations.
Остальные причины не совпадают с сообщениями policy downgrade.

У 7 из 10 needs_evidence отсутствует список запрошенных данных; у остальных нет
допустимого requestable ID. Среди всех 59 гипотез **ни одного исполнимого запроса**.
В каждой функции был ровно один detect и один verify, несмотря на лимит двух
раундов. Поэтому данный пилот не измеряет пользу adaptive requests/requeue.

Пригодность sidecar и доступность evidence в prompt — разные величины. Даже после
complete IR export ограничение контекста обрезает данные до передачи verifier:

| Бюджет evidence, символов | Полный код текущей цели | Полный IR-блок | Запуски с omissions |
|---|---:|---:|---:|
| 6000, фактический пилот | 18/24 | 9/24 | 18/24 |
| 12000, offline packing | 24/24 | 15/24 | 9/24 |
| 24000, offline packing | 24/24 | 24/24 | 0/24 |

Для FULL отдельно при 6000 это 6/8 code и 3/8 IR; при 24000 — 8/8 обоих.
Три варианта используют те же восемь целей, поэтому знаменатель 24 не означает
24 независимых программы. «Полный блок» означает отсутствие truncation в packer,
а не полноту семантики программы. Offline sweep **не измеряет изменение recall**.

## Живой парный эксперимент бюджета verifier

Чтобы проверить влияние этого ограничения, выполнены **48 новых LLM-вызовов**:
8 тех же целей FULL × 6000/24000 символов × 3 повтора. Discovery не повторялся:
20 гипотез зафиксированы по snapshot **после detect, до первого verify**. Увеличение
контекста — единственное меняемое условие между парами; обе стороны используют
тот же сервер с context window 16384 tokens, response budget 2048, temperature 0,
reasoning off, cache_prompt=false. Порядок первого бюджета сбалансирован 4/4 внутри
каждого повтора; последовательность заранее сохранена.

[Registration до запросов](measurements/20261025/verifier-context/registration.json)
фиксирует source/model/input hashes и schedule.
[Метрики](measurements/20261025/verifier-context/metrics.json),
[сводка](measurements/20261025/verifier-context-summary.json) и actual messages,
raw responses, decisions до/после policy сохранены. Source hashes не изменились
во время выполнения. Бюджеты нужно сравнивать внутри этой серии, не с прежним
сервером context 8192 и повторной генерацией кандидатов.

| Evidence budget | Вызовы | Prompt tokens | Completion tokens | Время, с | Function endpoint |
|---|---:|---:|---:|---:|---|
| 6000 | 24 | 82 041 | 19 134 | 407.3 | 24 abstain |
| 24000 | 24 | 117 357 | 19 460 | 433.4 | 24 abstain |

Ошибок 0, reasoning_chars=0, все ответы прошли локальную structured validation.
На function-level нет положительных или отрицательных окончательных решений,
как до, так и после policy. Увеличение бюджета добавило **43.0% prompt tokens**,
но не добавило confirmed и не улучшило decision coverage в этом опыте.
Время приведено описательно; эти последовательные повторы не являются общим
аппаратным latency benchmark. Raw/policy — два представления одних вызовов,
их стоимость не суммируется.

На уровне гипотез для 6000: до policy 49 unknown / 9 needs_evidence / 2 refuted,
после — 51 unknown / 9 needs_evidence. Для 24000: до policy 51 unknown /
6 needs_evidence / 3 confirmed, после — 54 unknown / 6 needs_evidence.
Все пять изменений вызваны `Verifier did not cite available evidence`.
Это 60 наблюдений на бюджет над **20 одними и теми же** гипотезами, а не 60 дефектов.

Три raw confirmations при 24000 — одна context-гипотеза
`ssl23_get_client_method`, повторённая трижды. Для неё при 6000 получены два
refuted и один unknown; везде policy оставила unknown. Модель рассуждает о
возврате NULL из stub callees, но оформляет counter_evidence как описания с
добавленными `L7`, а не exact supplied IDs. Это пример изменения решения с
контекстом и ошибки citation contract, не подтверждённая новая уязвимость.

При идентичных request hashes в каждом из двух бюджетов у 1/8 целей менялся
вектор raw dispositions между повторами. После policy нестабильность остаётся
у 1/8 целей только при 24000 (unknown ↔ needs_evidence); function-level abstain
стабилен везде. Temperature 0 не даёт оснований отказываться от повторов.
Эти повторы не считаются независимыми training seeds или новыми программами.

## BinPool: реальные пары и оптимизация

Полный Zenodo archive — 40 306 943 879 bytes. Получено 335 372 288 bytes;
загрузка остановлена после проверки скорости. Из целых первых members извлечён
один CVE `CVE-2019-3856` (libssh2), vulnerable/fixed × O0/O1/O2/O3.
Это convenience archive-prefix pilot, не случайная выборка. Checksum полного
архива не проверен. Из вложенных tar → Debian ar → data.tar извлечены ELF,
пакеты не устанавливались и бинарники не запускались.

[Inventory](measurements/20261022/binpool-v2/inventory.json) и
[mapping](measurements/20261022/binpool-v2/target-mapping.json) фиксируют переход
от private `userauth_keyboard_interactive` в O0 к inlined public API в O1–O3.
Проверено присутствие patch error marker только в исправленных версиях.
Это проверка mapping, не доказательство полной безопасности patched программы.
Поэтому **general function labels = null**; не выдаём build label за универсальный negative.

На первоначальном frozen inference gated правильно упорядочивает vulnerable > fixed
в 2/4 пар, XGBoost — 0/4 (три ties и одно обратное упорядочение).
Все 8 функций обрезаются encoder: 4251–5287 input tokens при лимите 1024.
Один CVE — одна независимая группа; нельзя считать восемь сборок восемью independent
observations или приводить CI по ним. [Pair/truncation audit](measurements/20261022/encoder-and-pair-audit.json).

После устранения Ghidra script shadowing все восемь бинарников повторно экспортированы
в `measurements/20261023/binpool-v6`. Текст целей совпадает со старым 8/8.
Повторные [ML](measurements/20261023/binpool-ml/metrics.json) и
[deterministic](measurements/20261023/binpool-deterministic/metrics.json) завершены.
У всех 8 target IR coverage = complete; binary/text совпадают с первой серией.
Все ML scores и deterministic решения совпали с первой серией: новых
автопродвижений нет; candidates/sink heuristic срабатывают на всех 8 входах.
Сохранение неизвестных generic labels не позволяет приписать им FP/TP.

На CompReal замена v3 → v6 меняет только два извлечённых ML-признака:
`pcode.alive_operation_count`, `pcode.dead_operation_count`. Они присутствуют в
общем feature contract, но **не входят** в `xgboost_feature_names` или
`semantic_feature_names` deployed bundle. Поэтому fresh ML scores здесь совпали;
это не означает, что корректность P-code не важна для основного анализатора.

## Проверка и воспроизводимость

После изменений 2026-10-23: **224 unittest OK**, **20 focused ML tests passed**;
2026-10-25 после новых audit runners — **229 unittest OK**.
CLI `python -m graphllm --help`, deterministic regression TP=7/FP=0/FN=2,
`git diff --check`; логи лежат в `measurements/20261023/` и `measurements/20261025/`.
Проверки выполнялись только через `../venv/bin/python` (ML — тот же venv по абсолютному пути).
Никакое новое обучение не выполнялось. Код mlVulnDetect не менялся.
Первоначальные `/tmp` логи исчезли после рестарта среды; workspace artifacts,
per-run configs/requests/state и результаты сохранились. Новые логи v6 сохраняются
в workspace; поднятый для измерений llama-server остановлен после окончания прогонов.
`measurements/` исключён из source knowledge graph через `.graphifyignore`.
Проверка 2026-10-25: все 85 ранее зафиксированных GraphLLM и 152 ML source hashes
совпали; [целостность шести prediction tables](measurements/20261025/prediction-integrity.json)
подтверждена без дублей или пропущенных function/variant keys.
[Новый readiness snapshot](measurements/20261025/readiness-final.json) фиксирует
состояние после продолжения; graphify обновлён (4742 nodes, 7317 edges).

## Что ещё необходимо до публикационных выводов

- Заморозить source/model/exporter hashes **до** нового holdout; текущие snapshots
  — post-run audit. Registration 2026-10-25 сделана до запросов, но покрывает только
  описанный verifier-only опыт, не всю публикационную матрицу.
- Полные внешние manifests, независимые project/CVE/template/clone groups,
  target-CVE/function scope, label-conflict quarantine; не смешивать три корпуса.
- Общая санитизация всех LLM-visible полей Juliet, включая summaries и references;
  raw-name контроль показал тривиальную утечку на всей текущей выборке.
- Whole-program FULL и отдельные context/IR/layout/requests/requeue/verifier
  вмешательства, interaction factorial; target-only пилот их не заменяет.
- Несколько LLM repeats и training seeds, одинаковый бюджет, обучение structural
  ablations только с validation selection. Inference masking не заменяет retraining.
- Статический/классический baseline, localization и predicted-chain matching,
  ручная blinded adjudication и provenance источников. Нынешний chain scorer использует GT.
- Live routing vs shadow и oracle-budget ceiling; проверить потерю recall до LLM.
- Compiler/ISA/stripping и объём контекста, особенно большие BinPool-функции;
  отдельно измерить extraction и preprocessing attrition/time/RAM.

Сильные заявления о soundness, exploitation, выигрыше каждого компонента или
обобщении на полные реальные корпуса этими пилотами не обоснованы.
