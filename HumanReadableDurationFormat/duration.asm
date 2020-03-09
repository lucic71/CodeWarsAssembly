global duration
extern asprintf

section .rodata
    secondsYear   dq 31536000
    secondsDay    dq 86400
    secondsHour   dq 3600
    secondsMinute dq 60

section .data
    now db "now", 0x00
    formatString db "%s", 0x00

section .text
duration:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    and rsp, -16

    test rdi, rdi
    jnz normal_input

    lea rdi, [rbp - 8]
    mov rsi, formatString
    mov rdx, now
    xor rax, rax
    call asprintf

    jmp duration_end

normal_input:
    mov rax, rdi
    xor rdx, rdx
    mov rcx, [secondsYear]
    div rcx
    mov r8, rax
    mov rax, rdx

    xor rdx, rdx
    mov rcx, [secondsDay]
    div rcx
    mov r9, rax
    mov rax, rdx

    xor rdx, rdx
    mov rcx, [secondsHour]
    div rcx
    mov r10, rax
    mov rax, rdx

    xor rdx, rdx
    mov rcx, [secondsMinute]
    div rcx
    mov r11, rax
    mov r12, rdx

years:
    test r8, r8
    jz days

days:


duration_end:
    mov rsp, rbp
    pop rbp

    ret
