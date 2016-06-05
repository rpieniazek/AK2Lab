ZERO = 0
.data
info: .long 0, 0, 0
.text

.globl getBitmapInfo
# .type getBitmapInfo, @function
getBitmapInfo:
	push %ebp
	mov %esp, %ebp

	#54 bajty header

	movl 8(%ebp), %esi
	movl $info, %eax

	movl 18(%esi), %ebx #szerokosc
	movl %ebx, 0(%eax)
	
	movl 22(%esi), %ebx #wysokosc
	movl %ebx, 4(%eax)
	
	movl 10(%esi), %ebx #adres gdzie rozpoczynają się dane
	movl %ebx, 8(%eax)

	movl 2(%esi), %ebx #wielkosc pliku w bajtach
	movl %ebx, 12(%eax)

	movl 28(%esi), %ebx #ilosc bitów na pixel
	movl %ebx, 16(%eax)

	movl 30(%esi), %ebx #typ kompresji - compression type (0=none, 1=RLE-8, 2=RLE-4)
	movl %ebx, 20(%eax)

	# movl $ZERO, %ebx
	# movl 0(%esi), %ebx #sygnatura
	# movl %ebx, 24(%eax)
	
	mov %ebp, %esp
	pop %ebp
	ret

.globl negateImage
# .type negateImage, @function
negateImage:
	push %ebp
	mov %esp, %ebp
	# pusha
	
	movl 8(%ebp), %ebx # adres gdzie zaczyna sie ciag bajtow pliku bmp
	movl $ZERO, %esi
	movl 12(%ebp), %edi # adres gdzie jest kolejno: szerokosc, wysokosc, poczatek danych 
	
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF
	pushl $0xFFFFFFFF

	movdqu (%esp), %xmm0 #wyslanie tego co na stosie do %xmm0
	# addl $16, %esp
	
PETLA:
	movdqu (%ebx, %esi, 1), %xmm1 #1 bajt * %esi (na poczatku 0) z ebx (poczatek danych) do %xmm
	movdqu %xmm0, %xmm2 # xmm0 (same 0xF) do xmm2
	psubb %xmm1, %xmm2
	movdqu %xmm2, (%ebx, %esi, 1) # zastąpienie tego co policzono

	addl $16, %esi #kolejna porcja bajtów, zwiekszenie licznika
	cmpl %edi, %esi #czy juz koniec? tzn czy 
	jb PETLA
	
	emms
	# popa
	mov %ebp, %esp
	pop %ebp
	ret
