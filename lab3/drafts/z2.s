#===================================================================
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDIN = 0
STDOUT = 1
EXIT_SUCCES = 0
#===================================================================

.data
	.comm	tab,400
	.comm	tmp,4
	.comm	string,100
	.comm	string_len,4
	.comm	count,4
	.comm	wykladnik,4
	.comm	wynik,4
	
.text
	intro : .ascii "Podaj ciag szesnastkowych liczb :\n"
	intro_len = .-intro
	new : .ascii "\n"
	gw	:	.ascii "*\n"

.global main

main:
	
	mov		$intro,%ecx
	mov		$intro_len,%edx
	call	out
	
#wczytanie ciagu liczb szesnastkowych 
	mov		$string,%ecx
	mov		$100,%edx
	call	in

#zapisanie dlugosci ciagu	
	dec		%eax
	mov		%eax,string_len
	
	xor 	%edx,%edx
	#zerowanie parametrow
	mov		string_len,%esi
	dec		%esi
	mov		%edx,count
	mov		%edx,wykladnik
#funkcja wczytujaca ciagi szesnastkowe i konwertujaca na 10
loop:
	xor		%eax,%eax
	mov		string(,%esi,1),%al
	mov		wykladnik,%ebx
#rozwazenie przypadku duzych i malych liter
	cmp		$32,%eax
	je		last
	cmp		$97,%eax
	jge		con1
	cmp		$65,%eax
	jge		con2
	
	sub		$48,%eax
	call	licz
	inc		%ebx
	jmp		check
	#male litery
	con1:
		sub		$87,%eax
		call	licz
		inc		%ebx
		jmp		check
	#duze litery
	con2:
		sub		$55,%eax
		call	licz
		inc		%ebx
		jmp		check
	#spacja
	last:
		xor		%ebx,%ebx
		push	%edx
		mov		count,%edx
		inc		%edx
		mov		%edx,count
		pop		%edx
	check:
		dec		%esi
		mov		%ebx,wykladnik
		cmp		$0,%esi
		jge		loop
	#sumowanie wprowadzonych liczb i konwersja na inne systemy	
	
	xor		%esi,%esi
	xor		%ecx,%ecx
	mov		%ecx,wynik
	mov		count,%edx
	cmp		$0,%edx
	je		end_loop2
	loop2:
		mov		tab(,%esi,4),%eax
		add		%eax,%ecx
		inc		%esi
		cmp		%edx,%esi
		jle		loop2
		mov		%ecx,wynik
	end_loop2:
		#wypisanie wynikow
		mov		wynik,%eax
		mov		$2,%ebx
		call	base
		
		mov		wynik,%eax
		mov		$8,%ebx
		call	base
		
		mov		wynik,%eax
		mov		$10,%ebx
		call	base
		
		mov		wynik,%eax
		mov		$16,%ebx
		call	base
		
		
				
	
#koniec programu
    mov     $SYSEXIT,%eax
    mov     $EXIT_SUCCES,%ebx
    int     $0x80
#===================================================================

#===================================================================
#funkcja wczytujaca
in:
    mov     $STDIN,%ebx
    mov     $SYSREAD,%eax
    int     $0x80
    ret

#funkcja wypisujaca
out:
    push	%eax
	push	%ebx
    mov     $STDOUT,%ebx
    mov     $SYSWRITE,%eax
    int     $0x80
    pop		%ebx
	pop		%eax
    ret
 
#przejscie do nowego wiersza
new_line: 
	mov		$new,%ecx
	mov		$1,%edx
	call	out
	ret
gwaizdka:
	mov		$gw,%ecx
	mov		$2,%edx
	call	out
	ret


#funkcja obliczjaca potege 16
potega:
	push	%esi
	xor		%esi,%esi
	push	%eax
	mov		$1,%eax
for:
	cmp		%ebx,%esi
	je		koniec
	
	push	%ebx
	mov		$16,%ebx
	mull	%ebx
	pop		%ebx
	inc		%esi
	cmp		%esi,%ebx
	jle		for
	
	koniec:
	mov		%eax,%edx
	pop		%eax
	pop		%esi
	ret
	
licz:
	call	potega
	push	%ecx
	mov		%eax,%ecx
	mov		%edx,%eax
	mul		%ecx
	push	%esi
	mov		count,%esi
	mov		tab(,%esi,4),%ecx
	add		%eax,%ecx
	mov		%ecx,tab(,%esi,4)
	pop		%esi
	pop		%ecx
	ret
	
base :	
	xor		%esi,%esi
	for_base:
		xor		%edx,%edx
		div		%ebx
		push	%edx	
		inc		%esi
		cmp		$0,%eax
		jne		for_base
	
	for_print:
		cmp		$0,%esi
		je		end_print
		pop		%edx
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
		call	new_line
	ret
		
	
	
#===================================================================
