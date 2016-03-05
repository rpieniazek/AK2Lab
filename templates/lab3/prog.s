 
.data
	chose: .ascii "0"
	number:.ascii "AAAAAAAA"
        
.text 
error_message :
	.ascii "Niepoprawna ilosc argumentow: "
error_message_length = . -error_message
.global _start
	
_start:
	#najpierw sprawdzimy czy liczba arg. sie zgadza	
	mov (%rsp),%rdi			 # przeniesienie liczby argumentow do rdi
break:
	cmp $3,%rdi	
	jne error
		
       
	#wczytanie parametru programu
	mov $1,%r11
	mov 8(%rsp,%r11,8), %r13 	#wyciagniecie adresu poczatku pierwszego stringa
	inc %r11 			#inkrementacja licznika adresu
	mov 8(%rsp,%r11,8), %r14 	#wyciagniecie adresu drugiego stringa i pocz nast
	inc %r11
	mov 8(%rsp,%r11,8), %r15 
	sub %r14,%r15			#w r15 znajduje sie dlugosc liczby
		
	mov (%r13),%rdi
	mov %rdi, (chose)

	mov (%r14),%rdi
	mov %rdi, (number)
	
	#wyswietlenie (wywolanie funkcji systemowej)
		
	mov %r13,%rsi
	mov $1,%rdx	#dlugosc
	mov $1,%rax
	mov $1,%rdi
	syscall 	#pojawia sie opcja

	#sprawdzimy jaki algorytm uruchmic
	
	movb (chose), %r10b

	cmp $98,%r10 # 98 to szestanstkowy kod ascii litery 'b'
	je decimal_to_bin
	
	
	cmp $111,%r10 # 111 to szestanstkowy kod ascii litery 'o'
	je decimal_to_oct
	
	
	cmp $104,%r10 # 104 to szestanstkowy kod ascii litery 'h'
	je decimal_to_hex
	
	jmp end
	#sysexit?

decimal_to_bin:
	mov $number,%rsi	
	mov $3,%rdx 	#dlugosc
	mov $1,%rax
	mov $1,%rdi
	syscall 	#pojawia sie numer:
	jmp end	
	
decimal_to_oct:
	

decimal_to_hex:

error:
	mov $error_message,%rsi	
	mov $error_message_length,%rdx 	#dlugosc
	mov $1,%rax
	mov $1,%rdi
	syscall 	#pojawia sie komunikat o bledach:
	jmp end	


end:
	mov $60,%rax		# exit syscall (x86_64)
	mov $0,%rdi			# status = 0 (exit normally)
	
	syscall

