.data
	formatScanf: .asciz "%300[^\n]"
	formatPrintf: .asciz "%d "
	formatPrintNewLine: .asciz "\n"
	minus1: /asciz "-1\n"
	chdelim: .asciz " "
	n: .space 4
	m: .space 4
	vector: .space 1000
	frecv: .space 1000
	inceput: .long 1
	ok: .space 4
	nul: .long 0
	sir: .space 370
	aux: .long 0
	n1: .space 4
	numar3: .long 3
	zero: .long 0
.text


.global main
valid:
	pushl %ebp
	movl %esp, %ebp
	
	movl aux, %eax
	
	subl m, %eax
	cmp %eax, inceput
	jge valoarea1
	jmp incepere
valoarea1:
	movl $1, %eax	
	
incepere:

	movl $1, %edx
	movl %edx, ok
	movl aux, %edx
	movl (%edi, %edx, 4), %ebx
	
	pushl %ecx
	
etforvalidare:
	cmp %eax, aux
	je eticheta2
	movl (%edi, %eax, 4), %ecx
	cmp %ecx, %ebx
	je ok_devine_null
	
	incl %eax
	jmp etforvalidare
	
	
eticheta2:
	movl aux, %eax
	addl m, %eax
	cmp %eax, n
	jle valoaren
	jmp incepere1
valoaren:
	movl n, %eax	

incepere1:
	movl (%edi, %edx, 4), %ebx
etforvalidaree:
	cmp %eax, aux
	je eticheta3
	movl (%edi, %eax, 4), %ecx
	cmp %ecx, %ebx
	je ok_devine_null
	
	subl $1, %eax
	jmp etforvalidaree

eticheta3:
	movl $1, %ebx
	
etforvalidare2:
	cmp %ebx, n1
	jl finalizare
	movl (%esi, %ebx, 4), %eax
	cmp %eax, numar3
	jl ok_devine_null
	incl %ebx
	jmp etforvalidare2
	
ok_devine_null:

	movl $0, %ebx
	movl %ebx, ok	
	
finalizare:
	#aici ajungem daca ok a ramas 1, deci daca e valid
	#si in cazul in care ok devine 0, aici ajungem si vom returna %eax
	popl %ecx
	popl %ebp
	ret
	
backk:
	pushl %ebp
	movl %esp, %ebp
	
	movl 8(%ebp), %edx
	movl (%edi, %edx, 4), %eax
	cmp %eax, nul
	je pct_nefix
	jmp pct_fix
	
pct_nefix:
	movl $1, %ecx
	etfor2:
		cmp %edx, zero
		je afisare_minus1
		cmp %ecx, n1
		jge verificare
		etsalut:
		popl %ebp
		ret
		verificare:
			movl %ecx, (%edi, %edx, 4)
			addl $1, (%esi, %ecx, 4)
			movl %edx, aux
			pushl %ecx
			pushl %edx
			call valid
			popl %ebx
			popl %ebx
			movl ok, %ebx
			cmp %ebx, nul
			jne validare
			subl $1, (%esi, %ecx, 4)
			movl $0, (%edi, %edx, 4)
			incl %ecx
			jmp etfor2
			validare:
				cmp %edx, n
				jne back_urm_pas
				jmp tipar
				back_urm_pas:
					incl %edx
					pushl %ecx
					pushl %edx
					call backk
					popl %ebx
					popl %ebx
					movl (%edi, %edx, 4), %ebx
					cmp %ebx, zero
					je etzero
					movl $0, (%edi, %edx, 4)
					subl $1, %ecx
					subl $1, (%esi, %ecx, 4)
					etzero:
					subl $1, %edx
					movl (%edi, %edx, 4), %ecx
					subl $1, (%esi, %ecx, 4)
					incl %ecx
					jmp etfor2
		
		
pct_fix:
	movl %edx, aux
	pushl %ecx
	pushl %edx
	call valid
	popl %ebx
	popl %ebx
	movl ok, %eax
et3:
	cmp %eax, nul
	je else1
	jmp else2

else2:
	cmp %edx, n
	jne else_back
	jmp tipar

else_back:
	incl %edx
	pushl %edx
	call backk
	popl %edx
	popl %ebp
	ret
	
else1:
	subl $1, %edx
main:

	pushl $sir
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
		
	pushl $chdelim
	pushl $sir
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, n1
	
	movl $3, %ebx
	mull %ebx
	movl %eax, n

	pushl $chdelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, m

	movl $1, %ecx
	
	lea frecv, %esi
	lea vector, %edi
etfor:
	cmp %ecx, n
	jl etout
	
	pushl %ecx
	pushl $chdelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	 
	pushl %eax
	call atoi
	popl %ebx
	popl %ecx
	
	movl %eax, (%edi, %ecx, 4)	
	
	cmp %eax, nul
	jne et_elem_fix
	incl %ecx
	jmp etfor
	
et_elem_fix:

	addl $1, (%esi, %eax, 4)
	incl %ecx
	jmp etfor
	
etout:
	pushl inceput
	call backk
	popl %edx
	
tipar:
	movl $1, %ebx
	etfor_afisare:
	cmp %ebx, n
	jl newline
	movl (%edi, %ebx, 4), %eax
	pushl %ebx
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %edx
	popl %edx
	
	
	pushl $0
	call fflush
	popl %edx
	popl %ebx
	incl %ebx
	jmp etfor_afisare
newline:
	pushl $formatPrintNewLine
	call printf
	popl %edx
	jmp etexit
	
afisare_minus1:
	pushl minus1
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
etexit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
#3 1 1 0 0 0 0 3 0 2 3
#    1 2 1 3 2 3 1 2 3
