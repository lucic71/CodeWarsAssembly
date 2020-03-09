section .data
	testStr db "Nest", 0x0

section .text
	global _start
_start:
	mov esi, testStr 
	xor eax, eax
Rot13Loop:
	lodsb 

	test al, al
	je Rot13LoopFinished
	
CheckCapitalised:
	cmp al, 65	
	jl NotALetter

	cmp al, 90
	jg CheckNotCapitalised

		
	cmp al, 'M'
	jg AsciiSecondHalf
	
AsciiFirstHalf:
	add ax, 13

	mov edi, esi
	dec edi
	mov byte [edi], al	

	jmp JumpBack
	
AsciiSecondHalf:
	mov dl, 'Z'
	sub dl, al

	neg dl
	add dl, 13
	dec dl

	mov al, 'A'
	add al, dl

	mov edi, esi
	dec edi
	mov byte [edi], al
	
	jmp JumpBack
	

CheckNotCapitalised:
	cmp al, 97
	jl NotALetter

	cmp al, 122
	jg NotALetter

	cmp al, 'm'
	jg AsciiSecondHalfL
	
AsciiFirstHalfL:
	add ax, 13

	mov edi, esi
	dec edi
	mov byte [edi], al	

	jmp JumpBack
	
AsciiSecondHalfL:
	mov dl, 'z'
	sub dl, al

	neg dl
	add dl, 13
	dec dl

	mov al, 'a'
	add al, dl

	mov edi, esi
	dec edi
	mov byte [edi], al
	
	jmp JumpBack
	
NotALetter:

JumpBack:
	jmp Rot13Loop

Rot13LoopFinished:
	mov eax, 1
	xor ebx, ebx
	int 0x80	
