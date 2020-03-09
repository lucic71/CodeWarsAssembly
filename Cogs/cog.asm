global cog_rpm

section .text
cog_rpm:

; First variant using x87 registers

;    mov rax, rsi
;    shr rax, 1
;    setc al
;    shl al, 1
;    dec al
;    movsx rax, al
;
;    fild dword [rdi]
;    add rdi, 4
;    dec rsi
;
;array_loop:
;    fild dword [rdi]
;    fdivp st1, st0
;    add rdi, 4
;
;    dec rsi
;    test rsi, rsi
;    jnz array_loop
;
;    push rax
;    fmul dword [rsp]
;    nop
;
;    ret

; Second variant using sse registers
    push rbp
    mov rbp, rsp
    and rsp, -16

    mov eax, [rdi]
    push rax
    cvtsi2sd xmm0, [rsp]
    add rsp, 8

    mov rax, rsi
    shr al, 1
    setc al
    movzx rax, al
    shl al, 1
    dec al
    movsx rax, al

    dec rsi
    cvtsi2sd xmm1, [rdi + 4 * rsi]

    divpd xmm0, xmm1

multiply:
    push rax
    cvtsi2sd xmm1, [rsp]
    add rsp, 8

    mulpd xmm0, xmm1

    mov rsp, rbp
    pop rbp

    ret
