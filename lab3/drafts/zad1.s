#===================================================================
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCES = 0
warunek = 83886080
#===================================================================

#===================================================================
.data
	.comm first,83886080
	.comm f2,167772160
	.comm f2_len,4
	.comm first_len,4
	.comm second,83886080
	.comm s2,167772160
	.comm s2_len,4
	.comm second_len,4
	.comm temp,4
	.comm score,335544320
	.comm score_len,4
	.comm tmp,32
#===================================================================

#===================================================================
.align 32

.text
    msg_first : .ascii "Podaj pierwsza liczbe : "
    msg_first_len = .- msg_first
	
    msg_second : .ascii "Podaj druga liczbe : "
    msg_second_len = .- msg_second
    
    war : .ascii "Przekroczono zakres \n"
    war_len = .-war
    newline : .ascii "\n"
    g : .ascii "*"
      
#===================================================================

#===================================================================
.global main

main :
	
	
	#wczytanie pierwszej liczby
	mov	$msg_first,%ecx
	mov	$msg_first_len,%edx
	call	out
	
	mov	$first,%ecx
	mov	$83886080,%edx
	call	in
	
	cmp	$warunek,%eax
	jg	end_warunkowy
	dec	%eax
	mov	%eax,first_len

	#wczytanie drugiej liczby
	mov	$msg_second,%ecx
	mov	$msg_second_len,%edx
	call	out

	mov	$second,%ecx
	mov	$83886080,%edx
	call	in
	cmp	$warunek,%eax
	jg	end_warunkowy
	dec	%eax
	mov	%eax,second_len

	#16 -> 2
	mov	first_len,%esi
	xor	%edi,%edi
	
	cmp	$0,%esi
	jle	end_for_1
	dec	%esi
	for1:
		mov	first(,%esi,1),%al
		dec	%esi
		call	hextobin
		mov	%al,%bl
		mov	first(,%esi,1),%al
		call	hextobin
		dec	%esi
		shl	$4,%al
		add	%al,%bl
		mov	%bl,f2(,%edi,1)
		inc	%edi
		cmp	$0,%esi
		jge	for1
	end_for_1:
	mov		%edi,%eax
	xor		%edx,%edx
	add		$3,%eax
	mov		$4,%ebx
	div		%ebx
	mov		%eax,f2_len
	
	
	
	mov	second_len,%esi
	xor	%edi,%edi
	cmp	$0,%esi
	jle	end_for_2
	dec	%esi
	for2:
		mov	second(,%esi,1),%al
		call	hextobin
		
		mov	%al,%bl
		dec	%esi
		mov	second(,%esi,1),%al
		here:
		call	hextobin
		dec	%esi
		shl	$4,%al
		add	%al,%bl
		mov	%bl,s2(,%edi,1)
		inc	%edi
		cmp	$0,%esi
		jge	for2
	end_for_2:
	mov		%edi,%eax
	xor		%edx,%edx
	add		$3,%eax
	mov		$4,%ebx
	div		%ebx
	mov		%eax,s2_len
	
	
	
	
	
	#mnozenie
	
	
		xor		%esi,%esi
		xor		%edi,%edi
		xor		%ecx,%ecx
		
		loop1:
			xor		%esi,%esi
			mov		%edi,%ecx
			
			loop2:
				mov		f2(,%esi,4),%eax
				mov		s2(,%edi,4),%ebx
				mul		%ebx
				
				add		%eax,score(,%ecx,4)
				inc		%ecx
				adc		%edx,score(,%ecx,4)
				inc		%ecx
				adc		$0,score(,%ecx,4)
				dec		%ecx
				inc		%esi
				cmp		f2_len,%esi
				jl		loop2
			inc		%edi
			
			cmp		s2_len,%edi
			jl		loop1
	
	
	mov 	f2_len,%eax
	mov		s2_len,%ebx
	
	add 	%eax,%ebx
	mov		%ebx,%esi
	
	#wypisanie
    	
	x22:
		dec		%esi
		mov		score(,%esi,4),%eax
		mov		$16,%ebx
		call	base
		cmp		$0,%esi
		jne		x22
		call 	new_line




	

#koniec programu
    mov $SYSEXIT,%eax
    mov $EXIT_SUCCES,%ebx
    int $0x80
    
 end_warunkowy:
	mov	$war,%ecx
	mov	$war_len,%edx
	call out
	mov $SYSEXIT,%eax
    mov $EXIT_SUCCES,%ebx
    int $0x80
#===================================================================

#===================================================================
#funkcja wczytujaca
in:
	mov $STDIN,%ebx
	mov $SYSREAD,%eax
	int $0x80
	ret

#funkcja wypisujaca
out:
	push %rax
	push %rbx
	mov $STDOUT,%rbx
	mov $SYSWRITE,%rax
        int $0x80
        pop %rbx
	pop %rax
	ret
 
#przejscie do nowego wiersza
new_line:
	mov $newline,%ecx
	mov $1,%edx
	call out
	ret
gw:
	mov	$g,%ecx
	mov	$1,%edx
	call	out
	ret


#konwersja z 16 -> 2
hextobin:
	cmp $97,%al
	jge con1
	cmp $65,%al
	jge con2

	sub $48,%al
	ret
	
	#male litery
	con1:
		sub $87,%al
		ret
	#duze litery
	con2:
		sub $55,%al
		ret
base :	
	push	%rsi
	push	%rdi

	xor		%esi,%esi
	mov		%eax,tmp
	
	for_base:

		xor		%edx,%edx
		div		%ebx
		push	%rdx	
		inc		%esi
		
		cmp		$0,%eax
		jne		for_base
	
	for_print:
		cmp		$0,%esi
		je		end_print
		pop		%rdx
		cmp		$10,%edx
		jge		hex
		add		$48,%edx
		jmp		print
		hex:
		   add		$55,%edx	
		print:
		mov		%edx,tmp
		mov		$tmp,%ecx
		mov		$1,%edx
		call	out
		dec		%esi
		end_print:
		cmp		$0,%esi
		jne		for_print
		pop		%rdi
		pop		%rsi
	ret
	
	
	
	

