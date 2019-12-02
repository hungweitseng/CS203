	.section	__TEXT,__text,regular,pure_instructions
	.macosx_version_min 10, 12
	.globl	_modifyloop
	.p2align	4, 0x90
_modifyloop:                            ## @modifyloop
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi0:
	.cfi_def_cfa_offset 16
Lcfi1:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi2:
	.cfi_def_cfa_register %rbp
	movl	$1, %edi
	callq	_sleep
	leaq	L_str(%rip), %rdi
	callq	_puts
	leaq	L_.str.1(%rip), %rdi
	movq	_loop@GOTPCREL(%rip), %rsi
	xorl	%eax, %eax
	callq	_scanf
	xorl	%eax, %eax
	popq	%rbp
	retq
	.cfi_endproc

	.globl	_main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## BB#0:
	pushq	%rbp
Lcfi3:
	.cfi_def_cfa_offset 16
Lcfi4:
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
Lcfi5:
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
Lcfi6:
	.cfi_offset %rbx, -24
	movq	_loop@GOTPCREL(%rip), %rbx
	movl	$1, (%rbx)
	leaq	_modifyloop(%rip), %rdx
	leaq	-16(%rbp), %rdi
	xorl	%esi, %esi
	xorl	%ecx, %ecx
	callq	_pthread_create
	cmpl	$1, (%rbx)
	sete	%al
	.p2align	4, 0x90
LBB1_1:                                 ## =>This Inner Loop Header: Depth=1
	testb	$1, %al
	movb	$1, %al
	jne	LBB1_1
## BB#2:
	movq	-16(%rbp), %rdi
	xorl	%esi, %esi
	callq	_pthread_join
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rax), %rdi
	movl	(%rbx), %edx
	leaq	L_.str.2(%rip), %rsi
	xorl	%eax, %eax
	callq	_fprintf
	xorl	%eax, %eax
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	retq
	.cfi_endproc

	.section	__TEXT,__cstring,cstring_literals
L_.str.1:                               ## @.str.1
	.asciz	"%d"

	.comm	_loop,4,2               ## @loop
L_.str.2:                               ## @.str.2
	.asciz	"User input: %d\n"

	.p2align	4               ## @str
L_str:
	.asciz	"Please input a number:"


.subsections_via_symbols
