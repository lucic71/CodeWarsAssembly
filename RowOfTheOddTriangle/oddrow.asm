global oddrow
extern malloc

oddrow:
    ; save rownumber for later
    push rdi

    ; allocate int buffer
    shl rdi, 3
    call malloc
    mov rdi, rax

    ; saved for loop iteration
    pop rcx

    ; calculate first number in row
    mov rax, rcx
    dec rcx
    imul rax, rcx

    inc rax
    inc rcx

    ; save the beginning of the buffer
    mov rsi, rdi

    ; loop through array and store numbers
loop_store:
    stosq
    add rax, 2

    loop loop_store

    ; return the buffer
    mov rax, rsi
    ret
