global wheat_from_chaff
extern malloc

section .text
wheat_from_chaff:
    ; Save the arguments
    mov r12, rdi
    mov r13, rsi

    ; Allocate memory
    mov rdi, rsi
    shl rdi, 3

    ; Get a pointer to the end of the string
    mov r14, r12
    add r14, rdi
    sub r14, 8

    call malloc

    mov rsi, r12
    mov rcx, r13
    ; ret addr of malloc
    mov r13, rax
    mov rdi, rax

array_loop:
    lodsq
    bt rax, 63
    jc negative_number

positive_number:
    ; backwards pointer
    mov r8, r14
    ; current pointer
    lea r9, [rsi - 8 ]

backwards_loop:
    mov rdx, [r8]
    bt rdx, 63
    jnc .positive

.negative:
    mov rax, [r8]
    stosq

    mov r9, r13
    add r9, r8
    sub r9, r12
    mov r8, [rsi - 8]
    mov [r9], r8

    jmp array_loop_reload

.positive:
    test r8, r9
    jnz backwards_loop_reload
    jmp end

backwards_loop_reload:
    sub r8, 8
    jmp backwards_loop

negative_number:
    stosq

array_loop_reload:
    loop array_loop

end:
    ret
