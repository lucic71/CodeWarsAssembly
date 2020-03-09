global _start

section .text
_start:
    mov edi, 695
    mov esi, 2

    xor rcx, rcx
    mov rax, rdi
count_digits:
    test rax, rax
    jz count_digits_done

    ; load 1/10 * 2^32
    ; rdx:rax = divident / 10 * 2^32
    ; rax = divident / 10
    mov edx, 0x1999999A
    imul edx
    mov eax, edx

    inc rcx
    jmp count_digits

count_digits_done:

    mov rbx, 10
sum_of_powers:
    mov rax, rdi
    xor rdx, rdx
    div rbx
    mov rax, rdx

    push rcx
    ;add rcx, rsi
    lea rcx, [rcx + rsi - 1]

p_power:
    imul eax, edx
    loop p_power

    add rbp, rax

    pop rcx
    imul rbx, 10
    loop sum_of_powers
