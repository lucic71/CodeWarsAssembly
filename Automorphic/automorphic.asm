global automorphic

section .data
    affirmative db "Automorphic", 0x00
    negative    db "Not!!", 0x00

section .text
automorphic:
    ; get the last digit of num
    mov rax, rdi
    xor rdx, rdx
    mov rcx, 10
    div rcx

    ; multiply the last digit with itself
    mov rax, rdx
    ; save the last digit of num for compare
    mov rdi, rax
    mul rax
    div rcx

    cmp rdx, rdi
    jnz not_automorphic

is_automorphic:
    mov rax, affirmative
    jmp automorphic_end

not_automorphic:
    mov rax, negative

automorphic_end:
    ret


