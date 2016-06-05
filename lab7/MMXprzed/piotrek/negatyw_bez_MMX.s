.data
.text
.global _negatyw_bez_MMX
.type _negatyw_bez_MMX @function
_negatyw_bez_MMX:
	mov	4(%esp), %esi
	mov	8(%esp), %ecx
dzialanie:
	xor	$0b11111111111111111111111111111111, 0(%esi)
	addl	$4, %esi
	loop	dzialanie
ret
