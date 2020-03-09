global snail
extern malloc
extern printf

section .text
snail:
    ; Number of traversals.
    xor r15, r15

    ; Compute the size of the array
    mov rax, rcx
    imul rax, rdx
    mov [rdi], rax

    mov r12, rsi
    mov r13, rcx

    mov rdi, rax
    shl rdi, 2
    call malloc
    mov rdi, rax
    mov r14, rax

    xor rcx, rcx

    ; rcx is the counter
snail_loop:

check1:
    ; if (i == n-1-i) stop
    mov rax, r13
    dec rax
    sub rax, rcx
    cmp rax, rcx
    jz done

    ; rdx is the counter and rsi is the limit
    ; for j = i:n-i-1
    mov rdx, rcx
    ; rsi is n - 1 - i
    mov rsi, rax
    ; r8 is the base pointer of the line
    lea r8, [r12 + 4*rcx]
    mov r8, [r8]

left_right_traversal:
    mov eax, [r8]
    stosd

    add r8, 4
    inc rdx
    cmp rdx, rsi
    jle left_right_traversal

check2:
    ; if (i+1==n-i-1) stop
    mov rax, rsi
    inc rcx
    cmp rax, rcx
    jz done

    ; rdx is the counter and rsi is the limit
    ; for j = i+1:n-i-1
    mov rdx, rcx
    ; because it was incremented previously, decrement it
    dec rcx

up_down_traversal:
    ; this thing is v[j][n-i-1]
    mov r8, rdx
    shl r8, 3
    add r8, r12
    mov r8, [r8]

    mov r9, 4
    imul r9, rsi
    add r8, r9

    mov eax, [r8]
    stosd

    inc rdx
    cmp rdx, rsi
    jle up_down_traversal

check3:
    ; if (i == n - i - 2) stop
    mov rax, rsi
    dec rax
    cmp rax, rcx
    jz done

    ; rdx is the counter and rcx is the limit
    ; for j = n-i-2:i
    mov rdx, rax
    ; r8 is the base pointer of the line
    lea r8, [r12 + 8*rsi]
    mov r8, [r8]
    lea r8, [r8 + 4*rax]

right_left_traversal:
    mov eax, [r8]
    stosd

    sub r8, 4
    dec rdx
    cmp rdx, rcx
    jge right_left_traversal

check4:
    ; if (n-i-2 == i+1) stop
    mov rax, rsi
    dec rax
    inc rcx
    cmp rax, rcx
    jz done

    ; rdx is the counter and rcx is the limit
    ; for j = n-i-2:i+1
    mov rdx, rax

down_up_traversal:
    ; this thing will be v[j][i]
    mov r8, rdx
    shl r8, 3
    add r8, r12
    mov r8, [r8]

    mov r9, 4
    imul r9, rax
    add r8, r9

    mov eax, [r8]
    stosd

    dec rdx
    cmp rdx, rcx
    jge down_up_traversal

    dec rcx

    inc rcx
    cmp rcx, r13
    jl snail_loop

done:

    ret
