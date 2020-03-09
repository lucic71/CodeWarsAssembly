global _start

section .text
_start:

    mov rax, 0xfe21e21
    mov rdi, 5
    mov rsi, 5

    test rdi, rdi
    setne al
    test rsi, rsi
    setne dl

    test al, dl
    mov rax, 0
    jz return

    mov rax, rdi
    imul rax, rsi
    dec rax

return:
    nop

