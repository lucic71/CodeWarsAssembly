section .text
global decompose
; long decompose(long n, long *output);
; Write the output to `output` in increasing order, and return the length.
; If `n` has no solutions, return -1.
decompose:
  ; The subroutine will check if numbers less than our given number `n` can 
  ; fit in it. This will be accomplished by repeated substractions between the
  ; square of `n` and the square of each number from `n-1` and `1`. We will use
  ; a stack to keep track of numbers that fit. If we can't find the desired numbers
  ; in the first iteration we will get the top on the stack and repeat the same procedure
  ; until the stack is empty.
  
  ; Move array to r10. We will use this at the end of the subroutine, when we will
  ; move the numbers from stack to array.
  mov r10, rsi
  
  ; <rcx> will keep track of the difference between the square of `n` and the numbers
  ; from `n-1` to `1`.
  xor rcx, rcx
  
  ; The stack created by the process itself will be the stack we will use for our numbers
  ; too. Firstly, push the stack length and after that we can push our stack. <r8> will
  ; contain the address of the stack's length.
  push dword 1
  mov r8, rsp
  
  ; Push `n` to stack.
  push rdi
  
  ; Loop through the stack until it's empty. If we exit from this loop, it means that
  ; no sequence of numbers could fit in our number.
.loop.stack:
  ; Get top of the stack.
  pop rsi
  
  ; Decrement length of stack.
  mov rax, [r8]
  dec rax
  mov [r8], rax
  
  ; Add the square of the top of the stack to <rcx> in order to make the repeated substractions.
  ; If we go through this loop more than one time, this also means that the previous number was not
  ; useful and we add it back to <rcx> in order to preserve the condition.
  mov rax, rsi
  
  xor rdx, rdx
  mul rax
  
  add rcx, rax
  
  ; The second loop iterates through the numbers from `top of stack` to `1`. <rbx> will
  ; be the iterator.
  mov rbx, rsi
  dec rbx
  
  ; If iterator is 0 just skip over the loop since it won't help us at all.
  cmp rbx, 0
  je .loop.stack.back
  
.loop.numbers:
  ; Check if the number fits by substracting `top of stack^2` - `iterator^2`.
  mov rax, rbx
  xor rdx, rdx
  mul rax
  
  ; The substraction will take place in <rdx>.
  mov rdx, rcx
  sub rdx, rax
  
  ; If the difference is greater than 0 it means that the `iterator` fits in our
  ; `top of stack`.
  cmp rdx, 0
  jl .loop.numbers.back
  
  ; Substract the number we found from <rcx> because we need to find the next number
  ; lesser than `top of stack` and the new number we found.
  sub rcx, rax
  
  ; Append the new number to stack in order to keep track of it.
  push rbx
  
  ; Increment length of stack.
  mov rax, [r8]
  inc rax
  mov [r8], rax
  
  ; If, in the end, the repeated substractions are equal to 0 it means that we found
  ; the sequence that satisfies our condition.
  cmp rcx, 0
  je success
  
.loop.numbers.back:
  dec rbx
  cmp rbx, 1
  jge .loop.numbers
  
.loop.stack.back:
  mov rax, [r8]
  cmp rax, 0
  jne .loop.stack
  
  ; Delete the space allocated for the length of stack.
  add rsp, 8
  
  ; If failed return -1
  mov rax, -1
  ret
  
success:
  ; Move the length of the stack to rcx in order to loop through the stack and the
  ; array at the same time and copy the values one at a time.
  mov rcx, [r8]
.append.array:
  pop rax
  mov [r10], rax
  add r10, 8
  loop .append.array
  
  ; Get the length of the stack as return value.
  pop rax
  ret
  
