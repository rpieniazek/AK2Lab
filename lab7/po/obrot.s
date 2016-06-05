.data
.text
.global obrot
.type obrot @function
obrot:
	mov	4(%esp), %esi
	mov	8(%esp), %ecx
	mov	%esi, %eax
dzialanie:
	movq	0(%esi), %mm0
	pcmpeqw	%mm4, %mm4
	pxor	%mm4, %mm0
	movq	%mm0, 0(%esi)
	addl	$8, %esi
	loop	dzialanie
ret
