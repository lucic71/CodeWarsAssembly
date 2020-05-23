section .data
  ; This is the start point for the recognition.
  ; With the numbers from 0 to 9 we will produce the other numbers.
  ; 10, 11 and 12 are here because they don't quite look like the numbers
  ; between 0 and 9 and there were no method to make the program undrestand
  ; them.
  Str0:  db "zero", 0
  Str1:  db "one", 0
  Str2:  db "two", 0
  Str3:  db "three", 0
  Str4:  db "four", 0
  Str5:  db "five", 0
  Str6:  db "six", 0
  Str7:  db "seven", 0
  Str8:  db "eight", 0
  Str9:  db "nine", 0
  Str10: db "ten", 0
  Str11: db "eleven", 0
  Str12: db "twelve", 0
  
  ; This is a C-like array of strings that we will use in the recognition.
  Numbers: dq Str0, Str1, Str2, Str3, Str4, Str5, Str6, Str7, Str8, Str9, Str10, \
      Str11, Str12
      
  ; Used to recognize numbers between 13 and 19.
  TeenStr:     db "teen", 0
  ; Used to recognize numbers between 20 and 99.
  TyStr:       db "ty", 0
  ; Used to recognize numbers between 100 and 999.
  HundredStr:  db "hundred", 0
  ; Used to recognize numbers between 1000 and 999.999.
  ThousandStr: db "thousand", 0
  ; Used to recognize numbers greater than 1.000.000.
  MillionStr:  db "million", 0
  ; Used for indentifying additional "and"s between the numbers.
  AndStr:      db "and", 0
  
  NumberTen:     equ 10
  NumberHundred:  equ 100
  NumberThousand: equ 1000
  NumberMillion:  equ 1000000
  
  
  ; These constants will be frequently used during the code.
  NumbersLength:     equ 12
  HundredStrLength:  equ 7
  ThousandStrLength: equ 8
  MillionStrLength:  equ 7
  AndStrLength:      equ 3
  
  format: db "%s", 10, 0
section .text
  global parseint
  
  extern strcmp, strstr, strncpy
  extern calloc, free
  extern printf
  
  ; Because some variables are saved on the stack there could be garbage left
  ; from previouse uses and because there is no way to move a imm qword directly to memory
  ; I decided to write a macro that zeros out the memory location. I could have used
  ; a register but I prefer not to disturb them.
  %macro ZeroMemoryLoc 1
      mov [%1],   dword 0
      mov [%1+4], dword 0
  %endmacro

; <-- EAX parseint(ro [byte RDI] num) -->
parseint:

   push rdi
   mov rsi, rdi
   mov rdi, format
   xor rax, rax
   call printf
   pop rdi
   
   
   ; Use <rbx> as base pointer of the array of strings.
   mov rbx, Numbers
   
   ; Note: the pop and push <rdi> that can be found near each strstr are there
   ; because if the "haystack" is to big the subroutine will modify it, which is
   ; undesired.
   
   ; --------- TODO one million - one billion --------- 
   
   ; --------------------------------------------------
   
   ; ----- number is one million -----
    mov rsi, MillionStr
    
    push rdi
    call strstr
    pop rdi
    
    cmp rax, 0
    jne MillionLabel
   ; ---------------------------------
   
   ; ----- number is between 1000 and 999.999 -----
   mov rsi, ThousandStr
   
   push rdi
   call strstr
   pop rdi
   
   cmp rax, 0
   jne ThousandLabel
   ; ----------------------------------------------
   
   ; ----- number is between 100 and 999 -----
   mov rsi, HundredStr
   
   push rdi
   call strstr
   pop rdi
   
   cmp rax, 0
   jne HundredLabel
   ; -----------------------------------------
   
   ; ----- number is between 20 and 90 -----
   mov rsi, TyStr
   
   push rdi
   call strstr
   pop rdi
   
   cmp rax, 0
   jne TyLabel
   
   ; ----------------------------------------
   
   ; ----- number is between 13 and 19 -----
   mov rsi, TeenStr
   
   push rdi
   call strstr
   pop rdi
   
   cmp rax, 0
   jne TeenLabel
   ; ----------------------------------------
   
DigitLabel:
   push rbp
   mov rbp, rsp
   sub rsp, 8
   ; [rbp-8] is the position of the most similar string, from Numbers, with
   ; our input string.
   
   ZeroMemoryLoc rbp-8
   
.loop:
   mov rcx, [rbp-8]
   mov rsi, [rbx+rcx*8]
   
   ; strcmp( input string, Numbers + rcx)
   call strcmp
   
   cmp rax, 0
   je .return
   
   inc dword [rbp-8]
   cmp [rbp-8], dword NumbersLength
   jle .loop
   
.return:
   mov rax, [rbp-8]
   
   mov rsp, rbp
   pop rbp
   
   ret
   
TeenLabel:
  push rbp
  mov rbp, rsp
  sub rsp, 16
  ; [rbp-8]  keeps the return value of the StrbyteEqu subroutine that will calculate
  ; the most similar string with our input string.
  ; [rbp-16] is the position of the most similar string.
  
  ZeroMemoryLoc rbp-8
  ZeroMemoryLoc rbp-16
  
  ; Start from the third position in the Numbers array.
  mov rcx, 3
  
.loop:
  mov rsi, [rbx+rcx*8]
  
  ; StrbyteEqu(our string, a number between three and nine)
  call StrbyteEqu
  
  cmp rax, [rbp-8]
  jle .loop.back
  mov [rbp-8], rax
  mov [rbp-16], rcx
  
.loop.back:
  inc rcx
  cmp rcx, 9
  jle .loop
  
  mov rax, [rbp-16]
  add rax, NumberTen
  
  mov rsp, rbp
  pop rbp
  
  ret
  
TyLabel:
  push rbp
  mov rbp, rsp
  sub rsp, 16
  ; [rbp-8]  keeps the return value of the StrbyteEqu subroutine that will calculate
  ; the most similar string with our input string. In the second part of the subroutine,
  ; [rbp-8] contains the number right after the dash. Ex: "twenty-one" => [rbp-8] = 1
  ; [rbp-16] is the position of the most similar string.
  
  ZeroMemoryLoc rbp-8
  ZeroMemoryLoc rbp-16
  
  ; Start from the second position in the Numbers array.
  mov rcx, 2
  
.loop:
  mov rsi, [rbx+rcx*8]
  
  ; StrbyteEqu(our string, a number between three and nine)
  call StrbyteEqu
  
  cmp rax, [rbp-8]
  jle .loop.back
  mov [rbp-8], rax
  mov [rbp-16], rcx
  
.loop.back:
  inc rcx
  cmp rcx, 9
  jle .loop
  
  ; -------------- second part of subroutine --------------------
  ; Calculate what is after the dash.
  
  ZeroMemoryLoc rbp-8
  
  mov rsi, rdi
  call CheckForDash
  
  cmp rax, 0
  je .IsTenMultiple
  
.IsNotTenMultiple:
  mov rdi, rax
  call DigitLabel
  mov [rbp-8], rax
  
.IsTenMultiple:
  mov rax, [rbp-16]
  mov rcx, NumberTen
  
  xor rdx, rdx
  mul rcx
  
  add rax, [rbp-8]
  
  mov rsp, rbp
  pop rbp
  
  ret
  
HundredLabel:

  ; Treat the case where just "hundred" is passed as input.
.Special:
  ; Save rax in case this special case is not met.
  push rax
  
  call strcmp
  cmp rax, 0
  jne .Normal
  
  ; Delete the value pushed on stack.
  add rsp, 8
  
  ; Return 100.
  mov rax, NumberHundred
  ret
  
.Normal:

  ; Reload the normal value or rax for this subroutine
  pop rax

  push rbp
  mov rbp, rsp
  sub rsp, 24
  ; [rbp-8]  left string(before "hundred")
  ; [rbp-16] final result
  ; [rbp-24] rest of the past strstr. This way it's easier to get the
  ; right side (after "hundred)
  mov [rbp-24], rax
  
  ; Call strncpy to copy the left part on the stack
  sub rax, rdi
  dec rax
  mov rdx, rax
  
  mov rsi, rdi
  
  ZeroMemoryLoc rbp-8
  mov rdi, rbp
  sub rdi, 8
  
  call strncpy
  
  ; The left part will be passed to DigitLabel in order to be computed.
  mov rdi, rbp
  sub rdi, 8
  
  ; Since the left part can be a number between 1 and 9 we will call 
  ; DigitLabel
  call parseint
  
  ; Compute the left part of the number
  mov rcx, NumberHundred
  
  xor rdx, rdx
  mul rcx
  
  mov [rbp-16], rax
  
  ; Next step is to decide whether our number contains the string "and"
  ; because we need to know where the right part will point.
.checkAnd:
  mov rdi, [rbp-24]
  mov rsi, AndStr
  
  push rdi
  call strstr
  pop rdi
  
  cmp rax, 0
  jne .ContainsAnd
  
.ContainsNoAnd:
  ; We will need to get rid of the string "hundred" and the space right after it.
  add rdi, HundredStrLength
  
  ; Check if there is a right part before we start the computing.
  mov al, [rdi]
  test al, al
  jz .End
  
  ; Get rid of the space.
  add rdi, 1
  
.ContainsNoAnd.Parse:
  call parseint
  
  jmp .End
  
.ContainsAnd:
  ; Get rid of the additional "and" and the space after it.
  add rax, AndStrLength
  add rax, 1
  
  mov rdi, rax
  call parseint
  
.End:
  ; Add the two parts together.
  add rax, [rbp-16]
  
  mov rsp, rbp
  pop rbp
  
  ret
  
ThousandLabel:
  push rbp
  mov rbp, rsp
  sub rsp, 32
  ; [rbp-8]  left string (before "thousand")
  ; [rbp-16] final result
  ; [rbp-24] rest of the past strstr. This way it's easier to get the
  ; right side (after "hundred)
  ; [rbp-32] will be the base pointer of the calloc-ed memory we will
  ; use. I save it because it will need to be free'd.
  
  mov [rbp-24], rax
  
.LeftSide:
  ; Copy the left side(before "thousand") in the calloc'ed memory.
  sub rax, rdi
  dec rax
  mov rdx, rax
  
  ; Save the registers because calloc will change them.
  push rdi
  push rdx
  
  ; Allocate memory for the left side.
  mov rdi, rdx
  ; Make space for the null byte.
  inc rdi
  mov rsi, 1
  
  call calloc
  
  pop rdx
  pop rsi
  
  mov [rbp-32], rax
  
  mov [rbp-8], rax
  mov rdi, rax
  
  call strncpy 
  
  ; Compute left side.
  mov rdi, rbp
  sub rdi, 8
  mov rdi, [rdi]
  
  call parseint
  
  ; Multiply the result with 1000
  mov rcx, NumberThousand
  
  xor rdx, rdx
  mul rcx
  
  mov [rbp-16], rax
  
  ; Check if there is a right side to compute. If there is no right side jump
  ; at the end of subroutine.
  mov rdi, [rbp-24]
  add rdi, ThousandStrLength
  
  xor rax, rax
  mov al, [rdi]
  
  test al, al
  jz .End
  
.RightSide:
  ; Check if we find an "and" right after "thousand".
  ; Load in <rdx> the string "and" and check byte by byte
  ; <rdx> and <rsi>. <rsi> contains the right side.
  mov rsi, rdi
  inc rsi
  
  mov rdx, AndStr
  
  mov rcx, AndStrLength
  xor rax, rax
  
.RightSide.CheckAnd:
  lodsb
  cmp al, byte [rdx]
  jne .RightSide.ContainsNoAnd
  
  inc rdx
  loop .RightSide.CheckAnd
  
  jmp .RightSide.ContainsAnd
  
.RightSide.ContainsNoAnd:
  add rdi, 1
  jmp .RightSide.Parse
  
.RightSide.ContainsAnd:
  add rdi, AndStrLength
  
  ; Delete the additional two spaces, one right before
  ; "and" and one right after "and".
  add rdi, 2
  
.RightSide.Parse:
  call parseint
  
.End:
  ; Add the two parts together.
  add [rbp-16], rax
  
  ; Free the memory we used.
  mov rdi, [rbp-32]
  call free
  
  mov rax, [rbp-16]
  
  mov rsp, rbp
  pop rbp
  
  ret
  
MillionLabel:

  mov rax, 1
  mov rcx, NumberMillion
  
  xor rdx, rdx
  mul rcx
  
  ret
  
  ; ---------------------------------------------------------
  ;            Additional subroutines
  ; ---------------------------------------------------------
  
  
StrbyteEqu:
  push rbp
  mov rbp, rsp
  sub rsp, 24
  ; [rbp-24]  is the return value of this subroutine
  ; [rbp-16]  is used for comparasion between the bytes
  ; [rbp-8]   is the length of the number between 3 and 9
  
  ; Calculate the length of the number between 3 and 9.
  call Strinlen
  
  mov [rbp-8], rax
  mov [rbp-16], byte 0
  ZeroMemoryLoc rbp-24
  
  xor rax, rax
  
  ; Preserve the strings passed as arguments.
  push rdi
  push rsi
  
.loop:
  ; Upload a byte from <rsi> to <al>. Upload the byte from al to [rbp-16].
  ; Upload a byte from <rdi> to <al>. Substract <al> - [rbp-16].
  lodsb
  mov [rbp-16], al
  
  mov al, [rdi]
  sub al, [rbp-16]
  
  test al, al
  jnz .loop.back
  
  inc dword [rbp-24]
  
.loop.back:
  inc rdi
  
  dec dword [rbp-8]
  cmp [rbp-8], dword 0
  jne .loop
  
  ; Recover the strings.
  pop rsi
  pop rdi
  
  mov rax, [rbp-24]
  
  mov rsp, rbp
  pop rbp
  
  ret
  
Strinlen:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  ; [rbp-8] is the length of the string
  
  push rsi
  
  xor rax, rax
  ZeroMemoryLoc rbp-8
  
.loop:
  lodsb
  test al, al
  jz .exit
  inc dword [rbp-8]
  jmp .loop
  
.exit:
  pop rsi
  
  mov rax, [rbp-8]
  
  mov rsp, rbp
  pop rbp
  
  ret
  
  ; If dash is found return a pointer to the next byte
  ; else return 0.
CheckForDash:
  xor rax, rax
  
.loop:
  lodsb
  cmp al, 0x2d
  je .found
  
  cmp al, 0x0
  jne .loop
  
  xor rax, rax
  ret
  
.found:
  mov rax, rsi
  ret
  
; -----> endof parseint <-----
