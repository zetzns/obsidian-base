1. CFG drawing
	- [ ] optimize render
2. LLM local analyze:
	- [x] CLI LLM
	- [x] Analyze JSON -> Entry Points
	- [x] Analyze JSON -> Branch1 {Entry; Func1, Func2,....}, Branch2 {...}, ..., BranchN (we have to save our way to every function we have visited)
	- [x] Option for moving inside single Branch (from only one entry_point)
	- [x] Option for moving between Func1 to Func2
	- [x] LLM Module for analyze a single function
	- [x] LLM analyze every func and save analyze as a file (1000 or number in option tokens for every func not for all program)
	- [ ] Condition moving inside branch (for example if func name starts with ma_ we analyze func above it if there it is again but with context as a vulnerabilities of current function)
	- [ ] Make context (as a summury of analyze) saves during current analyze inside branch (from upside to downside by every branch, but not from downside to upside)
	- [ ] Vulnerability presence as a condition: 
		- if code inside block have a vulnerability we would move the way we got here upside up to entry_point and analyze it again with the same prompt and after it jump for the vulnerability again continue going downside 
		- change prompt adding vulnerability from our function as context for going inside this branch all over downside 
	- [ ] Make Context Manager: Context is a local variable for a single branch starting from entry point, as far as we find new vulnerability inside this branch we try to learn all information inside this branch (way from vuln func to entry points) early about all we and program are dealing with this vulnerability downside (what variables is it using, how it deals with memory, how can we exploit it, can we do it (from somehow input) and what can we get from it and etc), after going up to entry point from potential vulnerability we save all information to a final review and make this review short and save this short version as a new context that would have been added after we would have been jumped to the vulnerable code (from the start of branch).  
