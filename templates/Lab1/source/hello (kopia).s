SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.align 32

.text

msg_hello: 	.ascii "Hello, world!\n"
msg_hello_len = . - msg_hello

.global _start				; wskazanie punktu wejscia do programu

_start:
	mov $SYSWRITE, %eax		; funkcja wywołania - SYSWRITEE
	mov $STDOUT, %ebx		; 1 arg. - syst. deskryptor stdout
	mov $msg_hello, %ecx		; 2 arg. - adres początkowy napisu
	mov $msg_hello_len, %edx	; 3 arg. - dłguość łańcucha
	
	int $0x80			; wywołanie przerwania programowego -
					; 	wykonywania funkcji systemowej.

;	mov $SYSEXIT, %eax
