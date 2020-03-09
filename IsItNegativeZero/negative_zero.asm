global isNegativeZero

section .text
isNegativeZero:
    movd eax, xmm0
    cmp eax, __float32__(-0.0)
    sete al
    ret
