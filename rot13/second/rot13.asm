section .bss
	testString        resb 10
	rotatedString     resb 4

section .data
	firstHalfL  db "abcdefghijklm", 0x0
	secondHalfL db "nopqrstuvwxyz", 0x0
	firstHalfU  db "ABCDEFGHIJKLM", 0x0
	secondHalfU db "NOPQRSTUVWXYZ", 0x0
	testStringLength EQU 10

section .text
	global main
	extern malloc
	extern strcpy
main:

ReadString:
	mov eax, 3
	mov ebx, 0
	mov ecx, testString
	mov edx, testStringLength
	int 0x80

	cmp eax, -1
	je Exit

AllocateMemory:
	push eax
	call malloc
	mov [rotatedString], eax

	push testString
	mov eax, [rotatedString]
	push eax

	call strcpy

	add esp, 4
	xor edx, edx

Prelude:
	mov esi, testString
	xor eax, eax
	xor ecx, ecx

	mov cx, 12

	mov edi, rotatedString
	mov edi, [edi]

ROT13:
	lodsb 
	
	test al, al
	jz ROT13Finished

CheckIfLetterUpper:
	cmp al, 'A'
	jl JumpBackROT13

	cmp al, 'Z'
	jl CheckFirstHalfUpper

CheckIfLetterLower:
	cmp al, 'a'
	jl JumpBackROT13

	cmp al, 'z'
	jg JumpBackROT13

CheckFirstHalfLower:

	mov ebx, firstHalfL
	mov dl, [ebx+ecx*1]

	cmp al, dl
	jg CheckSecondHalfLower

	cmp al, 'a'
	jl CheckFirstHalfUpper

	sub dl, al
	neg dl
	add dl, 12

	mov al, [secondHalfL+edx*1]	
	stosb

	jmp JumpBackROT13

CheckSecondHalfLower:

	mov ebx, secondHalfL
	mov dl, [ebx+ecx*1]

	cmp al, dl
	jg CheckFirstHalfUpper

	sub dl, al
	neg dl
	add dl, 12

	mov al, [firstHalfL+edx*1]
	stosb

	jmp JumpBackROT13

CheckFirstHalfUpper:

	mov ebx, firstHalfU
	mov dl, [ebx+ecx*1]

	cmp al, dl
	jg CheckSecondHalfUpper

	sub dl, al
	neg dl
	add dl, 12

	mov al, [secondHalfU+edx*1]	
	stosb

	jmp JumpBackROT13

CheckSecondHalfUpper:

	mov ebx, secondHalfU
	mov dl, [ebx+ecx*1]

	cmp al, dl
	jg CheckFirstHalfUpper

	sub dl, al
	neg dl
	add dl, 12

	mov al, [firstHalfU+edx*1]
	stosb

	jmp JumpBackROT13

JumpBackROT13:
	jmp ROT13	

ROT13Finished:

PrintROT13String:
	mov eax, 4
	mov ebx, 1
	mov ecx, testString
	mov edx, testStringLength
	int 0x80

;PrintNewLine:
;	xor eax, eax
;	mov al, 0x0a
;	push eax 
;	
;	mov eax, 4
;	mov ebx, 1
;	mov ecx, esp
;	mov edx, 1
;	int 0x80
;
;	add esp, 4 
;
Exit:
	mov eax, 1
	xor ebx, ebx
	int 0x80	
