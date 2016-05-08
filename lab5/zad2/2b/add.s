.data	
.align 32
format_string_input: 
	.string "%d %d"


format_string: 
	.ascii "Przykladowy string,Czesc  %s!, Jestem %s i mam   %d lata \n\0"

text1: 
	.ascii "Rafal\0"   # pierwszy parameter %s (łańcuch znaków zakończony \0) 
text2:
	.ascii "Rafal\0"   # drugi parameter %s (łańcuch znaków zakończony \0) 


number1: 
	.long 0            # jeden parameter %d (liczba dziesiętna)
number2: 
	.long 0            # drugi parameter %d (liczba dziesiętna) 

.global main
 
.text 

 
main:

push $number1	
push $number2
pushl $format_string_input       #łańcuch formatujący 
call scanf

                          
push number1
push number2           	
call dodaj


call exit                  # funkcja zakończenia programu

