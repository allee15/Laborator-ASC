.data
    v: .space 360
    p: .space 120
    f: .space 120
    n: .long 0
    m: .long 0
    x: .long 0
    formatScanf: .asciz "%d"
    formatPrintf: .asciz "%d "
    formatFin: .asciz "\n"


.text

back:
    movl 4(%esp), %ecx 

    pushl %ebp
    pushl %edi
    pushl %ebx
    movl %esp, %ebp

    movl $3, %eax
    mull n

    

    cmpl %eax, %ecx
    jge else1

    movl $v, %edi
    movl (%edi, %ecx, 4), %edx
    cmpl $0, %edx
    jne else2

    movl $1, %eax


for_greu:
    cmpl n, %eax
    jg pauza
    movl $p, %edi
    movl (%edi, %eax, 4), %edx
    addl m, %edx
    cmpl %ecx, %edx
    jge end_if
    movl $f, %edi
    movl (%edi, %eax, 4), %edx
    cmpl $3, %edx
    jge end_if

    movl $p, %edi
    movl (%edi, %eax, 4), %edx
    pushl %edi
    movl $v, %edi
    movl %eax, (%edi, %ecx, 4)
    popl %edi
    movl %ecx, (%edi, %eax, 4)
    movl $f, %edi
    incl (%edi,%eax,4)
    incl %ecx

    pushl %edx
    pushl %eax
    pushl %ecx
    call back
    popl %ecx
    popl %eax
    popl %edx

    decl %ecx
    decl (%edi, %eax, 4)
    movl $p, %edi
    movl %edx, (%edi, %eax, 4)


end_if:
    incl %eax
    jmp for_greu


pauza:
    movl $v, %edi
    movl $0, (%edi, %ecx, 4)
    jmp return_0
else2:
    movl $p, %edi
    movl (%edi, %edx, 4), %eax # eax = pos
    pushl %ecx


    addl m,%eax # eax = pos+m
    cmpl %ecx, %eax
    jl else21
    pushl $1
    jmp ifor2
else21:
    pushl $0
ifor2:
    subl m, %eax
    movl $f, %edi
    
    movl (%edi, %edx, 4), %ebx
    cmpl $3, %ebx
    jl else22
    pushl $1
    jmp ifor3
else22:
    pushl $0
ifor3:
    popl %ebx
    popl %ecx
    orl %ecx, %ebx
    cmpl $1, %ebx
    je return_0

    popl %ecx

    movl $p, %edi
    movl %ecx, (%edi, %edx, 4)

    movl $f, %edi
    incl (%edi, %edx, 4) 
    
    incl %ecx
    pushl %ecx
    call back
    popl %ecx
    decl (%edi, %edx, 4)

    movl $p, %edi
    movl %eax, (%edi, %edx, 4)
    jmp return_0




else1:
    movl $0, %edx
    movl $v, %edi
for_afis:
    cmpl %eax, %edx
    jge exit_0
    pushl %eax
    pushl %edx

    pushl (%edi, %edx, 4)
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

    popl %edx
    popl %eax
    incl %edx
    jmp for_afis

return_0:
    movl %ebp, %esp
    popl %ebx
    popl %edi
    popl %ebp
    ret


.global main


main:
    pushl $n
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    
    pushl $m
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx

    movl $0, %ecx
    movl $3, %eax
    mull n
    movl $v, %edi


for_citire:
    cmpl %eax, %ecx
    jge pre_for_p
    pushl %ecx
    pushl %eax
    pushl $x
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    popl %eax
    popl %ecx

    movl x, %ebx
    movl %ebx, (%edi, %ecx,4)
    addl $1, %ecx
    jmp for_citire

pre_for_p:
    movl $0, %ecx
    movl $p, %edi

for_p:
    cmpl n, %ecx
    jge ceva
    movl $-30, (%edi, %ecx, 4)
    addl $1,%ecx
    jmp for_p

ceva:
    pushl $0
    call back
    popl %ebx

    pushl $-1
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx

exit_0:
    pushl $formatFin
    call printf
    popl %ebx
    movl $1, %eax
    movl $0, %ebx
    int $0x80
