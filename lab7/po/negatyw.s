.data
ones:
	#.long 0xffffffffffffffff
	.long 0b11111111111111111111111111111111
.text
.global negatyw
.type negatyw @function
negatyw:
	push %ebp

	mov %esp, %ebp

	mov	8(%esp), %esi #pobranie pierwszego argumentu
	mov $0, %ecx
	mov	12(%esp), %ecx #drugi argument
	

	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	movq (%esp), %mm1  #w mm1 ciag samych 1 

dzialanie:
	movq	(%esi), %mm0 # pobranie 3 piksele
	movq 	%mm1, %mm2	#skopiowanie maski jedynek do mm2
	psubd	%mm0, %mm2  #odjecie od jedynek bitow pixela
	movq	%mm2, (%esi)
	addl	$8, %esi
	loop	dzialanie

	mov %ebp, %esp	#	przywroc wskaznik stosu	
	pop %ebp 		# 	
ret





.global negatywBEZ
.type negatywBEZ @function
negatywBEZ:

	push %ebp
	mov %esp, %ebp

	movl	8(%esp), %esi #pobranie pierwszego argumentu
	movl	12(%esp), %ecx #drugi argument
	xor 	%edx, %edx
		
	#xor %eax,%eax
dzialanieBEZ:
	movb	(%esi,%edx,1), %bl		
	#movb	$0xFF, %bl			#
	#subb	%bl, %al    		#odjecie od jedynek bitow pixela
	negb %bl
	movb	%bl, (%esi, %edx,1)
	add  	$1, %edx
	cmp  	%ecx, %edx
	jb dzialanieBEZ
break:
	mov %ebp, %esp	#	przywroc wskaznik stosu	
	pop %ebp 		# 	
ret



#.globl negateImage
#.type negateImage, @function
#negateImage:#
	#push %ebp
	#mov %esp, %ebp
	
#	movl 8(%ebp), %ebx
#	movl $0, %esi
	#movl 12(%ebp), %edi
	#pushl $-1
	#pushl $-1 

	#movl (%esp), %edx
#PETLA2:
	#pobierz wartosci kanalow
#	movl (%ebx, %esi, 1), %eax #pixel
#	movl (%esp), %edx # zera
#	subl %eax, %edx #wynik w edx
#	movl %edx, (%ebx, %esi, 1) 
#	addl $4, %esi
#	cmpl %edi, %esi 
#	jb PETLA2
	
#	mov %ebp, %esp
#	pop %ebp
#	ret


