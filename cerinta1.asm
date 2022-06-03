.data
    x: .space 200
    l: .asciz "let"
    a: .asciz "add"
    s: .asciz "sub"
    m: .asciz "mul"
    d: .asciz "div"
    test: .asciz "Am ajuns\n"
    scanFormat: .asciz "%s"
    printFormatNum: .asciz "%d "
    printFormatVar: .asciz "%c "
    printFormatCuv: .asciz "%s "
    minus: .asciz "-"
    printNewline: .asciz "\n"
.text

.global main

main:

read:
    pushl $x
    pushl $scanFormat
    call scanf
    popl %ebx
    popl %ebx
    xorl %eax,%eax
    xorl %ecx, %ecx
    xorl %edx, %edx



    movl $x,%edi

loop_start:
    
    xorl %eax,%eax
    xorl %ebx,%ebx
    xorl %edx,%edx

    movb (%edi, %ecx, 1),%al
    addl $1,%ecx
    cmpb $0, %al
    je exit_0      # Verificam daca s-a incheiat sirul

    cmpb $'A', %al
    jl hex_09
    subb $'A', %al
    addb $10, %al
    jmp after_h
hex_09:
    subb $'0', %al
after_h:
    movb %al,%dh

    movb (%edi, %ecx, 1),%al
    addl $1,%ecx
    cmpb $'A', %al
    jl hex_092
    subb $'A', %al
    addb $10, %al
    jmp after_h2
hex_092:
    subb $'0', %al
after_h2:
    movb %al,%bl

    movb (%edi, %ecx, 1),%al
    addl $1,%ecx
    cmpb $'A', %al
    jl hex_093
    subb $'A', %al
    addb $10, %al
    jmp after_h3
hex_093:
    subb $'0', %al
after_h3:
    shlb $4,%bl
    addb %al,%bl

    movb $1,%al
    pushl %ecx
    #acuma avem in %dh instructiunea si semnul, in %bl valoarea

    movb $1,%dl
    andb %dh,%dl

    shrb $1,%dh

    cmpb $0b101, %dh
    je variable
    jg instruction

    cmpb $0,%dl
    je pozitiv
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl $minus
    call printf
    popl %ebx
    popl %edx
    popl %ecx
    popl %ebx
    popl %eax
pozitiv:
    pushl %ebx
    pushl $printFormatNum
    jmp last_for
variable:
    pushl %ebx
    pushl $printFormatVar
    jmp last_for
instruction:
    cmpb $1,%bl
    jl ilet
    je iadd
    cmpb $3,%bl
    jl isub
    je imul
    pushl $d
    jmp inst_last
ilet:
    pushl $l
    jmp inst_last
iadd:
    pushl $a
    jmp inst_last
isub:
    pushl $s
    jmp inst_last
imul:
    pushl $m
    jmp inst_last
inst_last:
    pushl $printFormatCuv
last_for:
    call printf
    popl %ebx
    popl %ebx
    popl %ecx
    jmp loop_start

exit_0:
    pushl $printNewline
    call printf
    popl %ebx
    pushl stdout
    call fflush
    popl %ebx
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
