global crossprod
extern malloc

section .data
error db "Arguments are not 3D vectors!", 0x00

section .text
crossprod:
    ; Test the arrays.
    test rdi, rdi
    jz return_null
    test rsi, rsi
    jz return_null

    ; Test the lengths
    cmp rcx, 3
    jnz return_null
    cmp rdx, 3
    jnz return_null

    ; Allocate space for a 3D vector.
    push rdi
    push rsi

    mov rdi, 24
    call malloc

    pop rsi
    pop rdi

    ; a2*b3 - a3*b2
    movsd xmm0, [rdi + 8]
    movsd xmm1, [rsi + 16]
    mulsd xmm0, xmm1
    movsd xmm2, xmm0

    movsd xmm0, [rdi + 16]
    movsd xmm1, [rsi + 8]
    mulsd xmm0, xmm1

    subsd xmm2, xmm0
    movsd [rax], xmm2

    ; a3*b1 - a1*b3
    movsd xmm0, [rdi + 16]
    movsd xmm1, [rsi]
    mulsd xmm0, xmm1
    movsd xmm2, xmm0

    movsd xmm0, [rdi]
    movsd xmm1, [rsi + 16]
    mulsd xmm0, xmm1

    subsd xmm2, xmm0
    movsd [rax + 8], xmm2

    ; a1*b2 - a2*b1
    movsd xmm0, [rdi]
    movsd xmm1, [rsi + 8]
    mulsd xmm0, xmm1
    movsd xmm2, xmm0

    movsd xmm0, [rdi + 8]
    movsd xmm1, [rsi]
    mulsd xmm0, xmm1

    subsd xmm2, xmm0
    movsd [rax + 16], xmm2

    ret

return_null:
    xor rax, rax
    ret
