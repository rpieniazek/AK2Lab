.data
.text
.global _start

_start:
	mov $2,%rdi
	mov $3,%rsi
	call power
	
	mov %rax,%rdi	
	mov $60, %rax
	syscall 	#pojawia sie wynik
