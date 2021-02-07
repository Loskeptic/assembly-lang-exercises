; Nathan Melton
; CISP 2410
; Create procedure that takes parameters and returns discriminant via eax

.586
.MODEL FLAT

INCLUDE io.h

.STACK 4096

.DATA
numA		DWORD	?								; parameter A memory
numB		DWORD	?								; parameter B memory
numC		DWORD	?								; parameter C memory
promptA		BYTE	"Enter number a: ", 0			; prompt user for a
promptB		BYTE	"Enter number b: ", 0			; prompt user for b
promptC		BYTE	"Enter number c: ", 0			; prompt user for c
userInput	BYTE	40 DUP (?)						; holds user input
resultLabel	BYTE	"The discriminant is: ", 0		; prompt for ouput
sumASCII	BYTE	11 DUP (?), 0					; holds string representation of sum

.CODE
_MainProc PROC
	input	promptA, userInput, 40			; get A from user
	atod	userInput						; convert ascii input to decimal
	mov		numA, eax						; save A to memory

	input	promptB, userInput, 40			; get B from user
	atod	userInput						; convert ascii input to decimal
	mov		numB, eax						; save B to memory

	input	promptC, userInput, 40			; get C from user
	atod	userInput						; convert ascii input to decimal
	mov		numC, eax						; save C to memory

	push	numC							; push function parameters to stack
	push	numB
	push	numA
	
	call	discr							; call function
	add		esp, 12							; increment esp past parameters so they no longer exist
	
	dtoa	sumASCII, eax					; convert discriminant to ascii
	output	resultLabel, sumASCII			; display discriminant to screen

	mov		eax, 0							; return code 0
	ret
_MainProc ENDP

; Parameters: int a, int b, int c
; Returns : b*b-4*a*c (discriminant)
discr PROC
	push	ebp								; save old ebp value
	mov		ebp, esp						; mov current stack pointer into ebp, establish stack frame
	push	ebx								; save old ebx value since this procedure will overwrite it
	mov		eax, [ebp+12]					; copy parameter b into eax
	imul	eax								; b * b (eax * eax)
	mov		ebx, eax						; copy value calculated in previous line to ebx
	mov		eax, 4							; mov 4 into eax for upcoming multiplication
	imul	DWORD PTR [ebp+8]				; eax * parameter a, specifying size of parameter
	imul	DWORD PTR [ebp+16]				; eax * parameter c, specifying size of parameter
	sub		ebx, eax						; subtract eax from ebx
	mov		eax, ebx						; mov ebx into eax, this is how discriminant is returned
	pop		ebx								; restore ebx to old value
	pop		ebp								; restore ebp to old value
	ret
discr ENDP

END