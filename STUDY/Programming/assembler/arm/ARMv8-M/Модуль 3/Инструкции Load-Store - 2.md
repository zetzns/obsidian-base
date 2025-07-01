
> [!fact] 
> Адрес, доступный с помощью `LDR`/`STR` устанавливается с помощью основного регистра и опционального `offset`.

> [!list] 
> Offset может быть 4 типов:
> - Base register only (no offset):
> 	`LDR r0, [r1]`
> - Base register + const:
> 	`LDR r0, [r1, #8]`
> - Base register + register (optionally shifted by an immediate value):
> 	`LDR r0, [r1, r2]`
> 	`LDR r0, [r1, r2, LSL #2]`
> - The offset can be either added to or substracted from the base register
> 	`LDR r0, [r1, #-8]`
> 	`LDR r0, [r1, -r2]`
> 	`LDR r0, [r1, -r2, LSL #2]`

> [!new] 
> ***Pre-index and Post-index Offsets***:
> --- 
> Pre-index:
> `LDR R0, [R1, #12]!`
> То есть оно работает так:
> R1 = R1 + 12
> LDR R0, R1
> ---
> Post-index:
> `LDR R0, [R1], #12`
> R0 = R1
> R1 = R1 + 12
> ---




