|------------------|
|        Class          |
|------------------|
|      Manager      |
|------------------|

`__init__`
- output: .md
- llm: .dduf
- input: Node (root)
- memory-limit

`def callLLM(request: string, self.llm) -> string`
`def vulnAnalyze(block: Node, context='') -> string`
`def prevAnalyze(block: Node, context='') -> string`
`def report(self.output)`

|------------------|
|        Class          |
|------------------|
|         Node        |
|------------------|

`__init__`:
- value: list
- left: Node
- right: Node
- root: Node

`def getLeft(node: Node) -> node/None`
`def getRight(node: Node) -> node/None`
`def getRoot(node: Node) -> node/None`
`def getValue(node: Node) -> list/None`

|------------------|
|        Class          |
|------------------|
|        Graph        |
|------------------|

`__init__`:
- input: .json
- root: Tree

`def build(self.input)-> node(root)`




