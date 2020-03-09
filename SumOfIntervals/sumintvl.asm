global sumintvls

struc intvl
    .first  resd 1
    .second resd 1
endstruc

intvl_sz equ 0x8

section .text

sumintvls:
    push rbp
    mov rbp, rsp

    cmp rsi, 1
    jne normal_execution

    xor rax, rax
    mov eax, [rdi + 4]
    sub eax, [rdi]
    jmp sumintvls_done

normal_execution:
    ; how many intervals
    mov rcx, rsi
    dec rcx

.outterloop:
    push rcx
    push rsi
    push rdi

    mov rsi, rdi

.innerloop:
    mov eax, [rsi]
    mov edx, [rsi + 4]
    add rsi, intvl_sz

    cmp eax, [rsi]
    jle short .order_ok
    xchg eax, [rsi]
    xchg edx, [rsi + 4]

.order_ok:
    mov [rdi], eax
    mov [rdi + 4], edx
    add rdi, intvl_sz

    loop .innerloop
    pop rdi
    pop rsi
    pop rcx
    loop .outterloop

    ; push first interval on stack
    push qword [rdi]
    mov rdx, 0x01

    ; intervals loop
    mov rcx, rsi
    dec rcx
    add rdi, intvl_sz
.intvls_loop:
    mov eax, [rdi]
    cmp eax, [rsp + 4]
    jg .push_intvl

    cmp eax, [rsp]
    cmovg eax, [rsp]
    mov [rsp], eax

    mov eax, [rdi + 4]
    cmp eax, [rsp + 4]
    cmovl eax, [rsp + 4]
    mov [rsp + 4], eax

    jmp .intvls_loop_reload
.push_intvl:
    push qword [rdi]
    inc rdx

.intvls_loop_reload:
    add rdi, intvl_sz
    loop .intvls_loop

    mov rcx, rdx
    xor rax, rax
.intvls_sum:
    add eax, [rsp + 4]
    sub eax, [rsp]

    add rsp, 8
    loop .intvls_sum

sumintvls_done:
    mov rsp, rbp
    pop rbp

    ret
