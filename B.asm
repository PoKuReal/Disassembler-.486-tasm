.model	small
.486
.data
buf	db	1024 dup(?)
sourse	db	"com.com", 0
destin	db	"result.asm", 0
sib		db	''
save	db	''
savve	db	''
word_ptr	db	'word ptr $'
byte_ptr	db	'byte ptr $'
dword_ptr	db	'dword ptr $'
mdrmbyte	db 0
ib	db	0
iw	db	0
id	db	0

immediate	db 8 dup ('$')
cdq_msg	db 9, 'cdq$'
div_msg	db 9, 'div', 9, '$'
call_msg	db	9, 'call', 9, '$'
rg	dw	2	dup('$')
plus	db	'+$'
bebs	db	''
savet	dw	''
savets	dd	''
right_par	db	']$'
left_par	db	'[$'
mem	db	12	dup ('$')
segm	dd	4	dup('$')
otst	db	13, 10, '$'
e	db	'e$'
reg_e	db 0
mem_e	db 0
v	db 0
d	db 0
coma	db ', $'
.stack 100h
.code
start:
		mov	ax, @data
		mov	ds, ax
		mov	es, ax
		mov	ax, 3d00h ;open source com file
		lea	dx, sourse
		int	21h

		mov	bx, ax
		lea	dx, buf
		mov	cx, 1024
		mov	ah,	3fh ; read from it
		int	21h
		mov ax, 3e00h ; close it
		int 21h

		mov ax, 3c00h ;create destination file
		lea dx, destin
		int 21h
		mov ax, 3d01h ;open it for writting
		int 21h
		lea	si, buf
		lea	di, mem
		jmp prefix_byte

exit:	
		mov	ah, 3eh
		int	21h
		mov	ah, 4ch
		int	21h

prefix_byte:	
		lodsb
		cmp	al, 66h
		jnz	cmp_one
		mov	reg_e, 1
		jmp	prefix_byte
cmp_one: cmp	al, 26h
		jnz	cmp_two
		mov	segm, ' :SE'
		jmp	prefix_byte
cmp_two: cmp	al, 2eh
		jnz	cmp_three
		mov	segm, ' :SC'
		jmp	prefix_byte
cmp_three: cmp	al, 36h
		jnz	cmp_four
		mov	segm, ' :SS'
		jmp	prefix_byte
cmp_four: cmp	al, 64h
		jnz	cmp_five
		mov	segm, ' :SF'
		jmp	prefix_byte
cmp_five: cmp	al, 65h
		jnz	cmp_six
		mov	segm, ' :SG'
		jmp	prefix_byte
cmp_six: cmp	al, 3eh
		jnz	cmp_seven
		mov	segm, ' :SD'
		jmp prefix_byte
cmp_seven: cmp	al, 67h
		jnz	opcode
		mov	mem_e, 1
		lodsb
opcode:
		
		cmp	al, 99h
		jnz	callone
		call print_cdq
		jmp print_otst
callone:
		cmp al,  0e8h
		jnz grp5
		call print_call
		lodsw
		add ax, si
		add ax, 100h
		call print_chisl
		jmp print_otst

grp5:
		cmp al, 0ffh
		jnz	grp3_byte
		lodsb
		mov	save, al
		and al, 38h
		shr al, 3
		cmp al, 010b
		jnz exit
		call print_call
		mov	al, save
		and	al, 0c0h
		cmp	al,	0
		jz	_mod_zero
		cmp	al, 40h
		jz	_mod_one
		cmp	al, 80h	
		jz	_mod_two
		cmp	reg_e, 1
		jnz _suda
		call print_e
		mov	reg_e, 0
		mov	al, save
		and	al, 07
		call print_word_reg
		jmp print_otst
_suda:	mov	al, save
		and al, 07
		call print_word_reg
		jmp	print_otst
_mod_zero:
		mov mdrmbyte, 1
		call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz _mod_zero_emem
		call print_word_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp print_otst
_mod_zero_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp	print_otst
_mod_one:
		call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz _mod_one_emem
		call print_word_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
_mod_one_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
_mod_two:
		call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz _mod_two_emem
		call print_word_mem
		call print_plus
		call imm16
		call print_right_par
		jmp	print_otst
_mod_two_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm32
		call print_right_par
		jmp	print_otst


grp3_byte:	
		cmp	al, 0f6h
		jnz	grp3_word
		lodsb
		mov	save, al
		and al, 38h
		shr	al, 3
		cmp al, 110b
		jnz	exit
		call print_div
		mov	al, save
		and	al, 0c0h
		cmp	al,	0
		jz	@mod_zero
		cmp	al, 40h
		jz	@mod_one
		cmp	al, 80h	
		jz	@mod_two
		mov	al, save
		and al, 07
		call print_byte_reg
		jmp	print_otst
@mod_zero:
		call print_byte_ptr
		call	print_segment
		mov mdrmbyte, 1
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @mod_zero_emem
		call print_word_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp print_otst
@mod_zero_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp	print_otst
@mod_one:
		call print_byte_ptr
		call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @mod_one_emem
		call print_word_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
@mod_one_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
@mod_two:
		call print_byte_ptr
		call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @mod_two_emem
		call print_word_mem
		call print_plus
		call imm16
		call print_right_par
		jmp	print_otst
@mod_two_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm32
		call print_right_par
		jmp	print_otst
grp3_word:
		cmp	al, 0f7h
		jnz	exit
		lodsb
		mov	save, al
		and al, 38h
		shr	al, 3
		cmp al, 110b
		jnz	exit
		call print_div
		mov	al, save
		and	al, 0c0h
		cmp	al,	0
		jz	@@mod_zero
		cmp	al, 40h
		jz	@@mod_one
		cmp	al, 80h	
		jz	@@mod_two
		cmp	reg_e, 1
		jnz @suda
		call print_e
		mov	reg_e, 0
		mov	al, save
		and	al, 07
		call print_word_reg
		jmp print_otst
@suda:	mov	al, save
		and al, 07
		call print_word_reg
		jmp	print_otst
@@mod_zero:
		mov mdrmbyte, 1
		cmp	reg_e, 1
		jnz wrd
		call print_dword_ptr

		jmp itog
wrd:	call print_word_ptr
		
itog:	call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @@mod_zero_emem
		call print_word_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp print_otst
@@mod_zero_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_right_par
		mov mdrmbyte, 0
		jmp	print_otst
@@mod_one:
		cmp	reg_e, 1
		jnz @wrd
		call print_dword_ptr
		jmp @itog
@wrd:	call print_word_ptr

@itog:	call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @@mod_one_emem
		call print_word_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
@@mod_one_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm8
		call print_right_par
		jmp	print_otst
@@mod_two:
		cmp	reg_e, 1
		jnz @@wrd
		call print_dword_ptr
		jmp @@itog
@@wrd:	call print_word_ptr

@@itog:	call print_segment
		mov	al, save
		and al, 07
		cmp mem_e, 1
		jz @@mod_two_emem
		call print_word_mem
		call print_plus
		call imm16
		call print_right_par
		jmp	print_otst
@@mod_two_emem:
		mov	mem_e, 0
		call print_dword_mem
		call print_plus
		call imm32
		call print_right_par
		jmp	print_otst





byte_modrm:
		lodsb
		mov	savve, al
		and	al, 0c0h
		cmp	al, 0h
		jz mod_zero
		cmp	al, 40h
		jz mod_one
		cmp	al, 80h
		jz mod_two
		cmp	v, 1
		jz	word_reg
		mov	al, savve
		and	al, 38h
		shr	al, 3
		call	print_byte_reg
		call	print_coma
		mov	al, savve
		and	al, 7
		call	print_byte_reg
		jmp	print_otst
word_reg:
		cmp	reg_e, 1
		jnz @no_e
		call	print_e
@no_e:	mov	al, savve
		and	al, 38h
		shr	al, 3
		call	print_word_reg
		call	print_coma
		cmp	reg_e, 1
		jnz @@no_e
		call	print_e
		mov	reg_e, 0
@@no_e:	mov	al, savve
		and	al, 7
		call	print_word_reg
		jmp	print_otst
mod_zero: 
		mov mdrmbyte, 1
		cmp	al, 0
		jnz mod_one
		call Adress
		mov mdrmbyte, 0
		jmp	print_otst
mod_one:
		cmp	al, 40h
		jnz	mod_two
		mov	ib, 1
		call Adress
		mov	ib, 0
		jmp	print_otst
mod_two:
		cmp mem_e, 1
		jz	newmem
		mov	iw, 1
		call Adress
		mov	iw, 0
		jmp print_otst
newmem:	
		mov	id, 1
		call Adress
		mov	id, 0
		mov	mem_e, 0
		jmp print_otst

print_div:
		lea	dx, div_msg
		mov	cx, 5
		call VIVOD
		ret

print_call:
		lea	dx, call_msg
		mov	cx, 6
		call	VIVOD
		ret	

print_segment:
		lea	dx, segm
		cmp	segm, '$'
		jz	nosegment
		mov	cx, 3
		call	VIVOD
		mov	segm, '$'
nosegment:
		
		ret

print_cdq:
		mov	reg_e, 0
		lea	dx, cdq_msg
		mov	cx, 4
		call	VIVOD
print_otst:
		lea dx, otst
		mov	cx, 2
		call	VIVOD
		jmp prefix_byte

define_byte_reg:
	cmp	al, 000b
		jnz trycl
		mov	dx, 'la'
		ret
trycl:	cmp	al, 001b
		jnz trydl
		mov	dx, 'lc'
		ret
trydl:	cmp	al, 010b
		jnz trybl
		mov	dx, 'ld'
		ret
trybl:	cmp	al, 011b
		jnz tryah
		mov	dx, 'lb'
		ret
tryah:	cmp	al, 100b
		jnz trych
		mov	dx, 'ha'
		ret
trych:	cmp	al, 101b
		jnz trydh
		mov	dx, 'hc'
		ret
trydh:	cmp	al, 110b
		jnz trybh
		mov	dx, 'hd'
		ret
trybh:	mov	dx, 'hb'
		ret


define_word_reg:
		cmp	al, 000b
		jnz trycx
		mov	dx, 'xa'
		ret
trycx:	cmp	al, 001b
		jnz trydx
		mov	dx, 'xc'
		ret
trydx:	cmp	al, 010b
		jnz trybx
		mov	dx, 'xd'
		ret
trybx:	cmp	al, 011b
		jnz trysp
		mov	dx, 'xb'
		ret
trysp:	cmp	al, 100b
		jnz trybp
		mov	dx, 'ps'
		ret
trybp:	cmp	al, 101b
		jnz trysi
		mov	dx, 'pb'
		ret
trysi:	cmp	al, 110b
		jnz trydi
		mov	dx, 'is'
		ret
trydi:	mov	dx, 'id'
		ret

define_word_mem:
		cmp	al, 000b
		jnz @trybxdi
		mov	eax, '+xb['
		stosd
		mov	eax, '$is'
		stosd
		lea	di, mem
		mov	cx, 6
		ret
@trybxdi:
		cmp	al, 001b
		jnz @trybpsi
		mov	eax, '+xb['
		stosd
		mov	eax, '$id'
		stosd
		lea	di, mem
		mov	cx, 6
		ret
@trybpsi:	
		cmp	al, 010b
		jnz @trybpdi
		mov	eax, '+pb['
		stosd
		mov	eax, '$is'
		stosd
		lea	di, mem
		mov	cx, 6
		ret
@trybpdi:	cmp	al, 011b
		jnz @trysi
		mov	eax, '+pb['
		stosd
		mov	eax, '$id'
		stosd
		lea	di, mem
		mov	cx, 6
		ret
@trysi:	cmp	al, 100b
		jnz @trydi
		mov	eax, '$is['
		stosd
		lea	di, mem
		mov	cx, 3
		ret
@trydi:	cmp	al, 101b
		jnz @trydisp
		mov	eax, '$id['
		stosd
		lea	di, mem
		mov	cx, 3
		ret
@trydisp:	cmp	al, 110b
		jnz @trybx
		cmp	mdrmbyte, 1
		jnz bp_plus
		mov	al, '$'
		stosb
		lea	di, mem
		call	print_left_par
		call imm16
		mov	cx, 0
		ret
bp_plus:
		mov	eax, '$pb['
		stosd
		lea	di, mem
		mov	cx, 3
		ret
		
@trybx:	mov	eax, '$xb['
		stosd
		lea	di, mem
		mov	cx, 3
		ret

define_dword_mem:
		cmp	al, 000b
		jnz tryecx
		mov	eax, 'xae['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryecx:	cmp	al, 001b
		jnz tryedx
		mov	eax, 'xce['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryedx:	cmp	al, 010b
		jnz tryebx
		mov	eax, 'xde['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryebx:	cmp	al, 011b
		jnz tryesp
		mov	eax, 'xbe['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryesp:	cmp	al, 100b
		jnz trydisp
		mov	al, '['
		stosb
		lodsb
		mov	sib, al
		and al, 0c0h
		cmp al, 0
		jnz x
		mov	ax, '  '
		stosw
		jmp prod
x:		cmp	al, 40h
		jnz xx
		mov	ax, '*2'
		stosw
		jmp prod
xx:		cmp	al, 80h
		jnz xxx
		mov	ax, '*4'
		stosw
		jmp prod
xxx:	cmp	al, 0c0h
		mov	ax, '*8'
		stosw
prod:	mov	al, 'e'
		stosb
		mov	al, sib
		and	al, 38h
		shr	al, 3
		call define_word_reg
		mov	ax, dx
		stosw
		mov	ax, '+ '
		stosw
		mov	al, 'e'
		stosb
		mov	al, sib
		and	al, 7
		call	define_word_reg
		mov	ax, dx
		stosw
		lea	di, mem
		mov	cx, 11

		ret
trydisp:cmp	al, 101b
		jnz tryesi
		cmp	mdrmbyte, 1
		jnz ebp_plus
		mov	mdrmbyte, 0
		mov	mem, '$'
		call	print_left_par
		call VIVOD
		call imm32
		mov	cx, 0
		ret
ebp_plus:
		mov	eax, 'pbe['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryesi:	cmp	al, 110b
		jnz tryedi
		mov	eax, 'ise['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret
tryedi:	mov	eax, 'ide['
		stosd
		mov	al, '$'
		stosb
		lea	di, mem
		mov	cx, 4
		ret

print_right_par:
	lea	dx, right_par
	mov	cx, 1
	call VIVOD
	ret
print_left_par:
	lea	dx, left_par
	mov	cx, 1
	call VIVOD
	ret
print_plus:
	lea	dx, plus
	mov	cx, 1
	call VIVOD
	ret
print_byte_reg:
	call	define_byte_reg
	mov	rg, dx
	lea	dx, rg
	mov	cx, 2
	call VIVOD
	ret
print_word_reg:
	call	define_word_reg
	mov	rg, dx
	lea	dx, rg
	mov	cx, 2
	call VIVOD
	ret
print_word_mem:
	call	define_word_mem
	lea	dx, mem
	call VIVOD
	mov	mem, 0
	ret
print_dword_mem:
	call	define_dword_mem
	lea	dx, mem
	call VIVOD
	mov	dword ptr mem, 0
	ret

print_coma:
	lea	dx, coma
	mov	cx, 2
	call VIVOD
	ret
print_e:
	lea	dx, e
	mov	cx, 1
	call VIVOD
	ret
print_byte_ptr:
	lea	dx, byte_ptr
	mov	cx, 9
	call VIVOD
	ret
print_word_ptr:
	lea	dx, word_ptr
	mov	cx, 9
	call VIVOD
	ret
print_dword_ptr:
	lea	dx, dword_ptr
	mov	cx, 10
	call VIVOD
	ret
VIVOD:
	mov	ah, 09h
	int	21h
	mov	ah, 40h
	int	21h
	ret
Adress:
		cmp	d, 1
		jnz	normal
		cmp	v, 1
		jz	nenormal_v
		mov	al, savve
		and	al, 38h
		shr al, 3
		call	print_byte_reg
		jmp	nenorm_second
nenormal_v: 
		cmp	reg_e, 1
		jnz @noe
		call	print_e
		mov	reg_e, 0
@noe:	mov	al, savve
		and	al, 38h
		shr	al, 3
		call	print_word_reg
nenorm_second:
		call print_coma
		call print_segment
		mov	al, savve
		and	al, 7
		cmp	mem_e, 1
		jz printdw
		call print_word_mem
		jmp plius
printdw:
		call	print_dword_mem
		mov	mem_e, 0
plius:	cmp	ib, 1
		jz	byte_plus
		cmp	iw, 1
		jz	word_plus
		cmp	id, 1
		jz	dword_plus
resumes:
		call	print_right_par
		ret
byte_plus:
		call	print_plus
		call	imm8
		jmp	resumes
word_plus:
		call	print_plus
		call	imm16
		jmp	resumes
dword_plus:
		call	print_plus
		call	imm32
		jmp	resumes
normal:	
		call print_segment

		mov	al, savve
		and	al, 7

cmp	mem_e, 1
		jz @printdw
		call print_word_mem
		jmp @plius
@printdw:
		call	print_dword_mem
		mov	mem_e, 0
@plius:	cmp	ib, 1
		jz	plus_byte
		cmp	iw, 1
		jz	plus_word
		cmp	id, 1
		jz	plus_dword

resume:	call	print_right_par
		call	print_coma
		cmp	v, 1
		jz	normal_second_v
		mov	al, savve
		and	al, 38h
		shr	al, 3
		call	print_byte_reg
		ret
plus_byte:
		call	print_plus
		call	imm8
		jmp	resume
plus_word:
		call	print_plus
		call	imm16
		jmp	resume
plus_dword:
		call	print_plus
		call	imm32
		jmp	resume

normal_second_v: 
		cmp	reg_e, 1
		jnz @@noe
		call	print_e
		mov	reg_e, 0
@@noe:	mov	al, savve
		and	al, 38h
		shr	al, 3
		call	print_word_reg
		ret

imm8:
	lodsb
	mov	bebs, al
	shr al, 4
	call	immout
	mov	al, bebs
	and	al, 0fh
	call	immout
	ret
immout:
	cmp	al, 10
	jae	abcdef
	add	al, 30h
	mov	immediate, al
	lea	dx, immediate
	mov	cx, 1
	call VIVOD
	ret
abcdef:
	sub	al, 10
	add	al, 'A'
	mov	immediate, al
	lea	dx, immediate
	mov	cx, 1
	call VIVOD
	ret
imm16:
	lodsw
print_chisl:
	mov	savet, ax
	shr ax, 12
	and	ax, 000fh
	call	immout
	mov	ax, savet
	shr	ax, 8
	and	ax, 000fh
	call	immout
	mov	ax, savet
	shr	ax, 4
	and	ax, 000fh
	call	immout
	mov	ax, savet
	and	ax, 000fh
	call	immout
	ret
imm32:
	lodsd
	mov	savets, eax
	shr eax, 28
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr eax, 24
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr eax, 20
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr eax, 16
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr eax, 12
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr	eax, 8
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	shr	eax, 4
	and	eax, 0000000fh
	call	immout
	mov	eax, savets
	and	eax, 0000000fh
	call	immout
	ret
end start