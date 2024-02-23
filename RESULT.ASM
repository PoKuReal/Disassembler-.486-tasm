	call	013B
	div	al
	div	cl
	div	dl
	div	bl
	div	ah
	div	ch
	div	dh
	div	bh
	div	ax
	div	cx
	div	dx
	div	bx
	div	sp
	div	bp
	div	si
	div	di
	div	eax
	div	ecx
	div	edx
	div	ebx
	div	esp
	div	ebp
	div	esi
	div	edi
	div	byte ptr [bx+si]
	div	byte ptr [bx+di]
	div	byte ptr [bp+si]
	div	byte ptr [bx+di]
	div	byte ptr [si]
	div	byte ptr [di]
	div	byte ptr [bp+01]
	div	byte ptr [bx]
	div	0ord ptr [bx+si]
	div	1ord ptr [bx+di]
	div	2ord ptr [bp+si]
	div	1ord ptr [bx+di]
	div	4ord ptr [si]
	div	5ord ptr [di]
	div	vord ptr [bp+01]
	div	7ord ptr [bx]
	div	dword ptr [bx+si]
	div	dword ptr [bx+di]
	div	dword ptr [bp+si]
	div	dword ptr [bx+di]
	div	dword ptr [si]
	div	dword ptr [di]
	div	dword ptr [bp+0100]
	div	dword ptr [bx]
	div	dword ptr [ebx]
	div	dword ptr [2*ebx +esi+00000100]
	cdq
	call	FS:[2710]
	call	013B
	call	ax
	call	cx
	call	dx
	call	bx
	call	sp
	call	bp
	call	si
	call	di
	call	eax
	call	ecx
	call	edx
	call	ebx
	call	esp
	call	ebp
	call	esi
	call	edi
	call	[bx+si]
	call	[bx+di]
	call	[bp+si]
	call	[bx+di]
	call	[si]
	call	[di]
	call	[bp+01]
	call	[bx]
	call	[bx+si+01]
	call	[bx+di+01]
	call	[bp+si+01]
	call	[bx+di+01]
	call	[si+01]
	call	[di+01]
	call	[bp+01F5]
	call	[bx+01]
	call	[bx+si+0258]
	call	[bx+di+0258]
	call	[bp+si+0258]
	call	[bx+di+0258]
	call	[si+0258]
	call	[di+0258]
	call	[bp+64]
	call	[bx+0258]
	call	[ebx+00000258]
	call	[2*ebx +esi+64]
