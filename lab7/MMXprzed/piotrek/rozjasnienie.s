.data
ROZJASNIENIE: .quad 0x4040404040404040
.text
.global _rozjasnienie
.type _rozjasnienie @function
_rozjasnienie:
	mov	4(%esp), %esi
	mov	8(%esp), %ecx
	mov	%esi, %eax
dzialanie:
	movq	0(%esi), %mm0
	movq	ROZJASNIENIE, %mm4
	paddusb	%mm4, %mm0
	movq	%mm0, 0(%esi)
	addl	$8, %esi
	loop	dzialanie
ret
