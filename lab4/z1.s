SYSCALL32 = 0x80

EXIT = 1
WRITE = 4
READ = 3
STDOUT = 1
BUFOR_SIZE = 10
BASE = 10
.data
bufor: .space BUFOR_SIZE
bufor_len = . - bufor 

outputBufor: .ascii "wynik:         \n"
outputBuforLen=.-outputBufor


.text
.global _start


_start:

	call processInputNumber	#wczytaj i przetworz pierwsza liczbe
	jmp out

    	pushl $edx       #factorial of this value will be calculated
	call Fact
	
 	movl %eax, %ebx #eax contains the result, Result is the return val of the program
    	movl $1, %eax
    	int $0x80
    	ret

Fact:
    popl %ebx     #Return address
    popl %edx
    movl $1, %ecx #Will be used as a counter
    movl $1, %eax #Result(Partial & complete) will be stored here
    LOOP:
        mul %ecx
        inc %ecx
        cmp %ecx, %edx
        jle LOOP
    pushl %ebx    #Restore the return address
    ret


###########################
processInputNumber:	#wczyta i przetworzy napis podany na wejsciu na liczbe dziesietna, wyniki w %edx

	#wczytanie
	movl $bufor_len, %edx
	movl $bufor, %ecx
	movl $STDOUT, %ebx
	movl $READ, %eax
	
	int $SYSCALL32

	
	mov $0,%edx		#wynik
	mov $0,%edi		
	mov $0,%ecx

L1:
	movb bufor(,%edi,1), %cl
		
	cmpb $'\n',%cl
	jne L2
break1:		ret
	L2:
	mov $BASE,%eax
	mul %edx
	mov %eax,%edx
	subb $'0',%cl
	add %ecx,%edx

	inc %edi
	jmp L1

processOutputNumber:	#przetworzy dane z eax na ciag łańcuchów ascii i wynik przechowa w buforze

	mov $BASE,%ebx
br:	mov $outputBuforLen-2, %ecx
	L3:
	mov $0, %edx
	div %ebx
	addb $'0', %dl
	movb %dl,outputBufor(,%ecx,1)
	dec %ecx
	cmp $0,%eax
	jne L3
	ret			

out:
#wyswietlenie
	movl $outputBuforLen, %edx
	movl $outputBufor, %ecx
	movl $STDOUT, %ebx
	movl $WRITE, %eax
	
	int $SYSCALL32
	
	movl $EXIT, %eax
	int $SYSCALL32
	
	
	

