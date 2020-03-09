global rmurlahr
extern malloc

section .text
rmurlahr:
    ; save the beginning of the string
    mov rsi, rdi

    xor rax, rax
    mov rcx, -1

    repne scasb

    mov rax, rcx
    not rax
    ; dec rax

    ; save url and the length on stack
    push rsi
    push rax

    mov rdi, rax
    ; inc rdi
    call malloc

    ; put heap addres on destination register
    mov rdi, rax

    ; restore url and length
    pop rcx
    pop rsi
    dec rcx

    xor rax, rax
copy_bytes:
    lodsb
    cmp al, '#'
    jz copy_bytes_done
    stosb
    loop copy_bytes

copy_bytes_done:
    xor al, al
    stosb
    mov rax, rdx

    ret
