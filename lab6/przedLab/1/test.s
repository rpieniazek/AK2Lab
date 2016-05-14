	.file	"test.c"
	.text
.globl sinus
	.type	sinus, @function
sinus:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	fldl	-8(%ebp)
	fmull	-8(%ebp)
	fstpl	X2
	fldl	-8(%ebp)
	fstpl	PL
	fld1
	fstpl	PM
	fld1
	fstpl	SIL
	fldl	PL
	fchs
	fldl	X2
	fmulp	%st, %st(1)
	fstpl	PL
	fldl	SIL
	fld1
	faddp	%st, %st(1)
	fldl	SIL
	fmulp	%st, %st(1)
	fldl	SIL
	fld1
	faddp	%st, %st(1)
	fld1
	faddp	%st, %st(1)
	fmulp	%st, %st(1)
	fstpl	PM
	fldl	SIL
	fld1
	faddp	%st, %st(1)
	fld1
	faddp	%st, %st(1)
	fstpl	SIL
	fldl	PL
	fldl	PM
	fdivrp	%st, %st(1)
	leave
	ret
	.size	sinus, .-sinus
	.section	.rodata
.LC3:
	.string	"%lf\n"
	.align 8
.LC2:
	.long	0
	.long	1073741824
	.text
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$36, %esp
	fldl	.LC2
	fstpl	(%esp)
	call	sinus
	fstpl	-16(%ebp)
	fldl	-16(%ebp)
	fstpl	4(%esp)
	movl	$.LC3, (%esp)
	call	printf
	movl	$0, %eax
	addl	$36, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.comm	X2,8,8
	.comm	PM,8,8
	.comm	PL,8,8
	.comm	SIL,8,8
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
