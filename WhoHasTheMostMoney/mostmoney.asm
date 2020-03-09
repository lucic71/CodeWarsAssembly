global mostmoney

struc student
    .name:        resb 9
                  alignb 4
    .fives:       resd 1
    .tens:        resd 1
    .twenties:    resd 1
endstruc

student_sz equ 0x18

section .text
mostmoney:

    mov r8, -1
    mov rcx, rsi
    mov r9, -1

StudentArrayLoop:

    mov ebx, [rdi + student.fives - student]
    lea ebx, [ebx * 5]

    mov esi, [rdi + student.tens - student]
    imul esi, 10
    add ebx, esi

    mov esi, [rdi + student.twenties - student]
    imul esi, 20
    add ebx, esi

    ; move maximum number of money and the kid
    cmp rbx, r8

    cmovg r8, rbx
    cmovg rax, rdi

    ; move minimun number of money
    cmp rbx, r9

    cmovb r9, rbx

    add rdi, student_sz
    loop StudentArrayLoop

    ; compare max and min
    cmp r8, r9
    jnz mostmoney_end

    mov dword [rax], 0x6c6c61

mostmoney_end:
    ret

