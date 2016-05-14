SYSCALL32 = 0x80
WRITE = 4
STDOUT = 1
EXIT = 1

.data
.align 32
status_word: .int 128

control_word: .int 128

PE: 
	.string "Blad precyzj\n"   
UE: 
	.string "Niedomiar\n"   
OE: 
	.string "Nadmiar\n"   
ZE: 
	.string "Zero divide\n"   
DE: 
	.string "zdenormalizowany operand precyzji\n"   
IE: 
	.string "niepoprawna instrukcja\n"   

value1:
	.float 5.46
value2:
	.float 5.45
wynik: .space 8  #zmienna tymczasowa 

.text
.global main	

main:

	finit	#inicjacja kooprocesora
		

	
	fstcw ax  
break12:	or $4, %eax            #ustawiamy blokowanie wyjatku dzielenia przez 0

	#fldcw %ax

	   
	

	#dzielenie przez 0
	fld1
	fldz
	fdivrp
	

	#pierwiastek z ujemnej
	fld1
	fchs
	fsqrt
	
	#mnozenie dwoch liczb
	fld value1
break:	fmul value2

#	fst  %st(0)
	
	#odejmowanie bliskich liczb
	#fld
	fstsw status_word       #informacje o wystepujacych wyjatkach
	mov status_word, %edi   #znajduja sie na najmlodszych 6 bitach slowa kontrolnego


get_error:	#rozpoznaje bledy z rejestru eax
	 	
test_IE:	
	test $1, %edi
	jz test_DE
	pushl $IE               # pierwszy łańcuch (%s) 
	call printf	

test_DE:
	test $2, %edi
	jz test_ZE
	pushl $DE               # pierwszy łańcuch (%s) 
	call printf	

test_ZE:	
	test $4, %edi
	jz test_OE
	pushl $ZE               # pierwszy łańcuch (%s) 
	
	call printf	

test_OE:
	test $8, %edi
	jz test_UE
	pushl $OE               # pierwszy łańcuch (%s) 
	
	call printf	

test_UE:	
	test $16, %edi
	jz test_PE
	pushl $UE               # pierwszy łańcuch (%s) 
	call printf	

test_PE:	
	test $32, %edi
	jz exit
	pushl $PE               # pierwszy łańcuch (%s) 
	call printf	
	
	jmp exit


	pushl $DE               # pierwszy łańcuch (%s) 
	call printf


exit:
	movl 	$EXIT,	%eax
	int	$SYSCALL32

