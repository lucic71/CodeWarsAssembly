global paint_letterboxes
extern malloc

section .text
paint_letterboxes:

    mov r12, rdi
    mov r13, rsi

    mov rax, 10
    shl rax, 2
    call malloc

numbers_loop:
    
