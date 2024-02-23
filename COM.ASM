.model	tiny
.486
.code
	org	100h
start:
	call l
	div al
	div cl
	div dl
	div bl
	div	ah
	div ch
	div	dh
	div bh
	div ax
	div cx
	div dx
	div bx
	div	sp
	div bp
	div	si
	div di
	div eax
	div ecx
	div edx
	div ebx
	div	esp
	div ebp
	div	esi
	div edi
l:	div byte ptr [bx+si]
	div byte ptr [bx+di]
	div byte ptr [bp+si]
	div byte ptr [bx+di]
	div byte ptr [si]
	div byte ptr [di]
	div byte ptr [bp+1h]
	div byte ptr [bx]
	div word ptr [bx+si]
	div word ptr [bx+di]
	div word ptr [bp+si]
	div word ptr [bx+di]
	div word ptr [si]
	div word ptr [di]
	div word ptr [bp+ 1h]
	div word ptr [bx]
	div dword ptr [bx+si]
	div dword ptr [bx+di]
	div dword ptr [bp+si]
	div dword ptr [bx+di]
	div dword ptr [si]
	div dword ptr [di]
	div dword ptr [bp + 100h]
	div dword ptr [bx]
	div dword ptr [ebx]
	div dword ptr [2*ebx+esi+100h]
	cdq
	call	FS:[00010000]
	call	l
	call 	ax
	call 	cx
	call 	dx
	call 	bx
	call 	sp
	call 	bp
	call 	si
	call 	di
	call 	eax
	call 	ecx
	call 	edx
	call 	ebx
	call 	esp
	call 	ebp
	call 	esi
	call 	edi
	call 	[bx+si]
	call 	[bx+di]
	call 	[bp+si]
	call 	[bx+di]
	call 	[si]
	call 	[di]
	call 	[bp+01]
	call  	[bx]
	call 	[bx+si+1]
	call 	[bx+di+1]
	call  	[bp+si+1]
	call  	[bx+di+1]
	call 	[si+1]
	call 	[di+1]
	call 	[bp+501]
	call 	[bx+1]
	call 	[bx+si+600]
	call 	[bx+di+600]
	call 	[bp+si+600]
	call 	[bx+di+600]
	call 	[si+600]
	call 	[di+600]
	call 	[bp+0100]
	call 	[bx+600]
	call 	[ebx+600]
	call 	[2*ebx +esi+00000100]
	
end	start
