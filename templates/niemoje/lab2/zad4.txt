.data
	buf: .asciz "0"
.text
	filename: .asciz "zmienne.txt"
	space: .ascii " "
.global _start
_start:
	mov (%rsp), %r9
	mov %r9b, (buf)
	addb $48, (buf)

	mov $2, %rax
	mov $filename, %rdi
	mov $2, %rsi
	mov $0777, %rdx
	syscall
	mov %rax, %r12
break1:
	mov $1, %rax
	mov %r12, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall

	mov $1, %rax
	mov %r12, %rdi
	mov $space, %rsi
	mov $1, %rdx
	syscall

	mov $0, %r10
arg_loop:
	mov 8(%rsp,%r10,8), %rbp
	mov $0, %rcx
string:
	mov (%rbp, %rcx, 1), %r8b
	inc %rcx
	cmp $0, %r8b
	je write_space
	movb %r8b, (buf)
	push %rcx

	mov $1, %rax
	mov %r12, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall

	pop %rcx
	jmp string
write_space:
	mov $1, %rax
	mov %r12, %rdi
	mov $space, %rsi
	mov $1, %rdx
	syscall

	inc %r10
	cmp %r9, %r10
	jne arg_loop

exit:
	mov $3, %rax
	mov %r12, %rdi
	syscall

	mov $60, %rax
	mov $0, %rdi
	syscall
