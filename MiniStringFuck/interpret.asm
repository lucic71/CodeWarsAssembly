global interpret

section .text
interpret:
    mov r12, rsi

    xchg rsi, rdi
    ; rax handles the operator
    xor rax, rax
    ; rdx is the memory cell
    xor rdx, rdx

interpret_loop:
    lodsb
    test al, al
    jz interpret_loop_done

operator_plus:
    cmp al, 0x2b
    jnz operator_dot
    inc dl
    jmp interpret_loop

operator_dot:
    cmp al, 0x2e
    jnz interpret_loop
    xchg al, dl
    stosb
    xchg al, dl
    jmp interpret_loop

interpret_loop_done:
    xor al, al
    stosb

    ret
