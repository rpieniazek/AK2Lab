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



        movl $rozmiar, %edx 	#wczytanie do rejestru edx rozmiaru tekstu
        movl $BUF, %ecx		#argumenty funkcji wczytujacej kopiowane do odpowiednich rejestrow
        movl $STDIN, %ebx	
        movl $SYSREAD, %eax	#wczytywanie z klawiatury znakow
        int $SYSCALL		#wywolanie funkcji z rejestru %eax

        movl $STDOUT, %ebx	#nowy argument do rejestru ebs, bedziemy wypisywac
        movl $SYSWRITE, %eax	
        int $SYSCALL

        movl $SYSEXIT, %eax
        int $SYSCALL



