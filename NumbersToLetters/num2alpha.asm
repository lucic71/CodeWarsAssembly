global num2alpha
extern atoi
extern calloc

section .text
num2alpha:
    ; Allocate memory
    mov r12, rdi
    mov r13, rsi

    mov rdi, rsi
    inc rdi
    mov rsi, 1
    call calloc
    mov r14, rax
    mov r15, rax

    mov rsi, r13
    mov rdi, r12

    ; Loop and convert
    mov rcx, rsi
    xor rax, rax

convert:
    ; Convert string to number
    mov r12, rdi
    mov r13, rcx

    mov rdi, [rdi]

    call atoi
    mov rdi, r12
    mov rcx, r13

    ; Check special cases
special_case1:
    cmp al, 0x1b
    jnz special_case2
    mov al, 0x21
    jmp cases_end

special_case2:
    cmp al, 0x1c
    jnz special_case3
    mov al, 0x3f
    jmp cases_end

special_case3:
    cmp al, 0x1d
    jnz normal_case
    mov al, 0x20
    jmp cases_end

normal_case:
    neg rax
    add rax, 26
    add rax, 0x61

cases_end:
    mov [r14], al
    inc r14

    ; Find next element
    mov rdi, r12
    add rdi, 8
    loop convert

    mov rax, r15

    ret
