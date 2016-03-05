SYSCALL32 = 0x80
WRITE = 4
STDOUT = 1

.data
BUFFER: .ascii "          \n"
BUFFER_LENGTH = . - BUFFER
.equ BASE, 10
.equ LENGTH, 10

.type dziesietnie @function
dziesietnie:
	#push %dl

	pushl %ebp
	movl %esp, %ebp
	movl $BASE, %ebx
	movl $LENGTH-1, %ecx
calculate:
	movl $0, %edx
bp1:
	div %ebx
bp2:
	or '0', %edx
bp3:
	mov %edx, BUFFER(%ecx)
bp4:
	dec %ecx
bp5:
	andl %eax, %eax
bp6:
	jnz calculate

	movl $WRITE, %eax
	movl $STDOUT, %ebx
	movl $BUFFER, %ecx
	movl $BUFFER_LENGTH, %edx
	int $SYSCALL32
	
	movl %ebp, %esp
	popl %ebp

	#pop %dl
	
	ret

.globl _display_int# @function
_display_int:
	push %eax
	push %ebx
	push %ecx
	push %edx

	pushl %ebp
	movl %esp, %ebp

	movl %ebp, %ebx
	call dziesietnie
	
	movl %ebp, %esp
	popl %ebp

	pop %edx
	pop %ecx
	pop %ebx
	pop %eax

	ret
