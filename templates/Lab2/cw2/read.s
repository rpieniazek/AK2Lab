SYSCALL = 0x80 
SYSEXIT	 = 1
SYSREAD	 = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.data          
rozmiar = 255
BUF:           
.space 255

.global main

main:   
        movl $rozmiar, %edx
        movl $BUF, %ecx
        movl $STDIN, %ebx
        movl $SYSREAD, %eax
        int $SYSCALL

        movl $STDOUT, %ebx
        movl $SYSWRITE, %eax
        int $SYSCALL

        movl $SYSEXIT, %eax
        int $SYSCALL



