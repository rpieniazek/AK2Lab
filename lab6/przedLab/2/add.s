SYSCALL32 = 0x80
WRITE = 4
STDOUT = 1
EXIT = 1

.data
wartosc: .float -5555555.9999
control_word: .int 0b1111111111100000
status_word: .int 128



.text
.global output

output:

	finit	#inicjacja kooprocesora
	fstcw control_word # StoreControlWorld, przechowuje informacje o zaokroagleniach, 
	mov control_word, %ax
	shr $8, %eax                    #pole PC (precision control) znajduje sie 
	and $3, %eax                    #miedzy 8 a 9 bitem slowa controlnego FPU       
	ret

	fstsw %ax
	test %ax, status_word

movl 	$EXIT,	%eax
int	$SYSCALL32

