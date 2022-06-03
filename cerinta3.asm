.data
	str: .space 200
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	res: .space 4
    var: .space 256
.text

.global main

main:
    pushl $str
    call gets
    popl %ebx

	pushl $chDelim
	pushl $str
	call strtok 
	popl %ebx
	popl %ebx
	
	
	
et_for:
    movl %eax,res
    pushl res
    call atoi
    popl %ebx
    
    cmpl $0,%eax
    je not_num
    pushl %eax
    pushl $0 # Tipul ptr un numar
    jmp final_verif
not_num:
    movl res,%edi
    movl $0,%ecx
    cmpb $'0',(%edi,%ecx,1)
    jne cvar
    pushl %eax
    pushl $0
    jmp final_verif
cvar:
    pushl res
    call strlen
    popl %ebx
    cmpl $1,%eax
    jne instruct
    xorl %eax,%eax
    xorl %ecx,%ecx
    movb (%edi,%ecx,1),%al
    pushl %eax
    pushl $1  # Tipul ptr o variabila
    jmp final_verif
instruct:
    xorl %ebx,%ebx
    xorl %ecx,%ecx
    cmpb $'l', (%edi,%ecx,1)
    jne not_let
    movl $var,%edi
    popl %edx
    cmpl $1,%edx
    jne let1

    popl %ecx
    movb (%edi,%ecx,1),%bl
    jmp let2
let1:
    popl %ebx
let2:
    popl %edx
    popl %ecx
    movb %bl,(%edi,%ecx,1)
    
    jmp final_verif
not_let:
    xorl %ecx,%ecx
    movb (%edi,%ecx,1),%cl
    movl $var, %edi
    popl %edx
    cmpl $1,%edx
    jne nlet1b
    popl %edx
    movb (%edi,%edx,1),%bl
    jmp nlet2b
nlet1b:
    popl %ebx
nlet2b:
    popl %edx
    cmpl $1,%edx
    jne nlet1a
    popl %edx
    movb (%edi,%edx,1),%al
    jmp nlet2a
nlet1a:
    popl %eax
nlet2a:
    cmpb $'a',%cl
    je add_instr
    cmpb $'s',%cl
    je sub_instr
    cmpb $'m',%cl
    je mul_instr
    cmpb $'d',%cl
    je div_instr
    

add_instr:
    addl %ebx,%eax
    jmp ifin
sub_instr:
    subl %ebx,%eax
    jmp ifin
mul_instr:
    xorl %edx,%edx
    mull %ebx
    jmp ifin
div_instr:
    xorl %edx,%edx
    divl %ebx
ifin:
    pushl %eax
    pushl $0
final_verif:
	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
	
	cmp $0, %eax
	je exit_0
	
	
	jmp et_for	



    
exit_0:
    popl %eax
    pushl $formatPrintf
    call printf
    popl %ebx
    popl %ebx
    pushl stdout
    call fflush
    popl %ebx
    movl $1,%eax
    movl $0,%ebx
    int $0x80	
