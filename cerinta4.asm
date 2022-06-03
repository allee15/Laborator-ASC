.data
	 
	formatScanf: .asciz "%d"
	
	formatPrintf: .asciz "Numarul citit este %d\n"
    n: .space 4 
    m: .space 4	
	aij: .space 4
	aij2: .space 4
    mxn: .space 4

	scnum: .asciz "%d"
    scstr: .asciz "%s"
	prnum: .asciz "%d "

    minus: .asciz "-"
    prnl: .asciz "\n"
    
	v: .space 1600 
    rotmat: .space 1600
    x: .space 10
.text

.global main

main:
	// scanf("%d", &x)

    pushl $x 
	pushl $scstr
	call scanf
	popl %ebx
	popl %ebx

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

    xorl %edx,%edx
    movl m,%eax
    movl n,%ebx
    mull %ebx
    movl %eax,mxn
    xorl %ecx,%ecx
    movl $v,%edi

for_read:
    pushl %ecx

    pushl $aij 
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
    movl aij,%eax
    

    popl %ecx
    movl %eax,(%edi,%ecx,4)
    incl %ecx
    cmpl mxn,%ecx
    jl for_read

readop:
    pushl $x 
	pushl $scstr
	call scanf
	popl %ebx
	popl %ebx

    pushl $x 
	pushl $scstr
	call scanf
	popl %ebx
	popl %ebx

    pushl $aij2 
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx


    cmpl $0,%eax
    je rot90


    pushl $x
	pushl $scstr
	call scanf
	popl %ebx
	popl %ebx

    pushl n
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx

    pushl m
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx

    
    pushl %edi
    movl $x,%edi
    xorl %ecx,%ecx
    cmpb $'a',(%edi,%ecx,1)
    je add_instr

    cmpb $'s',(%edi,%ecx,1)
    je sub_instr
    
    cmpb $'m',(%edi,%ecx,1)
    je mul_instr
    
    cmpb $'d',(%edi,%ecx,1)
    je div_instr
    

add_instr:
    popl %edi
for_add:
    movl (%edi,%ecx,4),%eax
    addl aij2,%eax
    movl %eax,(%edi,%ecx,4)
    incl %ecx
    cmpl mxn,%ecx
    jl for_add
    jmp print_start
sub_instr:
    popl %edi
for_sub:
    movl (%edi,%ecx,4),%eax
    subl aij2,%eax
    movl %eax,(%edi,%ecx,4)
    incl %ecx
    cmpl mxn,%ecx
    jl for_sub
    jmp print_start
mul_instr:
    popl %edi
for_mul:
    movl (%edi,%ecx,4),%eax
    movl aij2,%ebx
    xorl %edx,%edx
    imull %ebx
    movl %eax,(%edi,%ecx,4)
    incl %ecx
    cmpl mxn,%ecx
    jl for_mul
    jmp print_start
div_instr:
    popl %edi
for_div:
    movl (%edi,%ecx,4),%eax
    movl aij2,%ebx
    xorl %edx,%edx
    cmpl $0,%eax
    jge actdiv
    decl %edx
actdiv:
    idivl %ebx
    movl %eax,(%edi,%ecx,4)
    incl %ecx
    cmpl mxn,%ecx
    jl for_div
    
print_start:
    xorl %ecx,%ecx
    movl $v,%edi
for_print:
    pushl %ecx
    movl (%edi,%ecx,4),%eax
    pushl %eax
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx
    popl %ecx

    incl %ecx
    cmpl mxn,%ecx
    jl for_print
    jmp exit_0
    

rot90:
    pushl m
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx

    pushl n
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx
    xorl %eax,%eax
    xorl %ecx,%ecx

for_rot:
    cmpl n,%eax
    jge rot_print
    xorl %edx,%edx
    movl $v,%edi
    # eax=i, ecx=j
    pushl %eax
    
    mull m
    addl %ecx,%eax
    movl (%edi,%eax,4),%ebx


    movl %ecx,%eax
    popl %ecx
    # eax=j,ecx=i
    pushl %eax
    pushl %ecx

    mull n
    movl n,%edx
    subl $1,%edx
    subl %ecx,%edx
    addl %edx,%eax


    movl $rotmat,%edi
    movl %ebx,(%edi,%eax,4)
    popl %eax
    popl %ecx
    # eax=i, ecx=j
    incl %ecx
    cmpl m,%ecx
    jl not_done_j
    incl %eax
    xorl %ecx,%ecx
not_done_j:
    jmp for_rot

rot_print:
    xorl %ecx,%ecx
    movl $rotmat,%edi
for_rot_print:
    pushl %ecx
    movl (%edi,%ecx,4),%eax
    pushl %eax
    pushl $prnum
    call printf
    popl %ebx
    popl %ebx
    popl %ecx

    incl %ecx
    cmpl mxn,%ecx
    jl for_print
    jmp exit_0


exit_0:
    pushl $prnl
    call printf
    popl %ebx
    pushl stdout
    call fflush
    popl %ebx
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
