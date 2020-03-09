section .data
	string db "aaaa", 0x0

section .text
	global _start
_start:
	xor eax, eax
	xor ecx, ecx
	mov esi, string
StringLoop:
	lodsb
	test al, al
	inc ecx
	jmp StringLoop

	nop
	nop
