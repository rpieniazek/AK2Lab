SYSEXIT			= 1
SYSREAD			= 3
SYSWRITE		= 4
STDIN			= 0
STDOUT			= 1
EXIT_SUCCESS	= 0
K_1MB			= 1048576 # 1MB
K_8MB			= K_1MB * 8
K_16MB			= K_1MB * 16

.align 32

.data
	.comm first_hex,	K_16MB
	.comm second_hex,	K_16MB
	.comm first_len,	4
	.comm second_len,	4
	.comm first,		K_8MB # 16MB of asci characters converted to binary packed by 2 per byte
	.comm second,		K_8MB
	.comm res,			K_16MB
	.comm tmp,			4
	.comm zeros,		1 # leading zeros flag

.text
	msg_nl:		.ascii  "\n"
	msg_star:	.ascii  " "

.global main

main:
	# read first
	mov $first_hex,	%ecx
	mov $K_16MB,		%edx
	call read
	dec %eax
	mov %eax,	first_len

	# read second
	mov $second_hex,%ecx
	mov $K_16MB,		%edx
	call read
	dec %eax
	mov %eax,	second_len

	# init var
	movb $0, zeros # just in case


	# convert from ASCII to number
	mov first_len, 	%esi # len
	mov $first_hex,	%ecx # source address
	mov $first,		%edx # target address
	call convert
	mov %edi,	%eax # calculate number of bytes
	xor %edx,	%edx
	add $3,		%eax
	mov $4,		%ebx
	div %ebx
	mov %eax, first_len

	# same thing for second number
	mov second_len,	%esi
	mov $second_hex,%ecx
	mov $second,	%edx
	call convert
	mov %edi,	%eax
	xor %edx, 	%edx
	add $3,		%eax
	mov $4,		%ebx
	div %ebx
	mov %eax, second_len


	# multiply!
	xor %esi, %esi
	L8:
		cmp first_len, %esi
		je L9

		xor %edi, %edi
		L10:
			cmp second_len, %edi
			je L11
			mov first(, %esi, 4), %eax
			mov second(, %edi, 4), %ebx

			# calculate index
			mul %ebx
			mov %esi, %ecx
			add %edi, %ecx

			# add without carry
			add %eax, res(, %ecx, 4)

			# add with carry
			inc %ecx
			adc %edx, res(, %ecx, 4)

			# add carry to proper place
			inc %ecx
			adc $0, res(, %ecx, 4)

			inc %edi
			jmp L10
		L11:

		inc %esi
		jmp L8
	L9:


	# max result length
	mov first_len, %esi
	add second_len, %esi

	# print result
	L6:
		cmp $0, %esi
		jl L7

		mov res(, %esi, 4), %eax
		push %rsi
		call print_num
		pop %rsi

		dec %esi
		jmp L6
	L7:

	call nl

	mov $SYSEXIT,       %eax
	mov $EXIT_SUCCESS,  %ebx
	int $0x80
	ret

# Print every 4 bits as hex number skipping leading zeros
print_num: # x in %eax
	push %rsi
	xor %esi, %esi
	L1:
		cmp $32, %esi
		je L2

		push %rax
		mov %eax, %ebx
		mov %esi, %ecx
		shl %cl, %ebx # 0,4,8,12, 16,20,24,28
		shr $28, %ebx
		
		# skip leading zeros
		cmp $0, %ebx
		jne L12
			mov zeros, %edx
			cmp $0, %edx
			je L13
			
		L12:
			movb $1, zeros
		
		cmp $10, %ebx
		jl L3
			add $7, %ebx # add 7 if x>10 
		L3:

		add $48,    %ebx
		mov %ebx,   tmp
		mov $tmp,   %ecx
		mov $1,     %edx
		call print

		L13:
		add $4, %esi
		pop %rax
		jmp L1
	L2:

	pop %rsi
	ret


convert:
	# hex -> bin
	dec %esi
	xor %edi, %edi
	L4:
		cmp $0, %esi
		jl L5
		xor %ebx, %ebx

		mov (%ecx, %esi, 1), %al
		dec %esi
		call hex2bin
		mov %al, %bl

		mov (%ecx, %esi, 1), %al
		dec %esi
		call hex2bin
		shl $4, %al
		add %al, %bl

		mov %bl, (%edx, %edi, 1)

		inc %edi
		jmp L4
	L5:
	ret

hex2bin: # convert ANSI char from %al into binary number
	cmp $97, %al
	jge small_letter
	cmp $65, %al
	jge big_letter

	sub $48, %al # '0' - '9'
	ret

	small_letter:
		sub $87, %al
		ret

	big_letter:
		sub $55, %al
		ret

# io utils
print: # print data stored in %ecx with length stored in %edx to STDOUT
	mov $SYSWRITE,      %eax
	mov $STDOUT,        %ebx
	int $0x80
	ret

read: # read max %edx characters from STDIN into %ecx destination, store length in %eax
	mov $SYSREAD,       %eax
	mov $STDIN,         %ebx
	int $0x80
	ret

nl: # print new line
	mov $msg_nl,        %ecx
	mov $1,             %edx
	call print
	ret
