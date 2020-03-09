global _start

section .data
    array dd 5, 2, 3, 1

section .text
_start:
    mov edi, array
    mov ecx, 3

.outterloop:
    pusha
    mov esi, edi

.innerloop:
    lodsd
    cmp eax, [esi]
    jge short .order_ok
    xchg eax, [esi]

.order_ok:
    stosd
    loop .innerloop
    popa
    loop .outterloop

    mov eax, 1
    int 0x80
