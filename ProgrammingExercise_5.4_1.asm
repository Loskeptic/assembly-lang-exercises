; Nathan Melton
; CISP 2410
; Calculate sum of 1^2 to n^2

.586
.MODEL FLAT

INCLUDE io.h

.STACK 4096

.DATA
numA		DWORD	?
numB		DWORD	?
numC		DWORD	?
promptA		BYTE	"Enter number a: ", 0	; prompt user for a
promptB		BYTE	"Enter number b: ", 0	; prompt user for b
promptC		BYTE	"Enter number c: ", 0	; prompt user for c
userInput	BYTE	40 DUP (?)				; holds user input
resultLabel	BYTE	"The sum is: ", 0		; prompt for ouput
sumASCII	BYTE	11 DUP (?), 0			; holds string representation of sum

.CODE
_MainProc PROC
	input	promptA, userInput, 40			; get n from user
	atod	userInput						; convert ascii input to decimal
	mov		numA, eax

	input	promptB, userInput, 40			; get n from user
	atod	userInput						; convert ascii input to decimal
	mov		numB, eax

	input	promptC, userInput, 40			; get n from user
	atod	userInput						; convert ascii input to decimal
	mov		numC, eax
	
	
	dtoa	sumASCII, ebx					; convert sum into ascii
	output	resultLabel, sumASCII			; display sum to screen

	mov		eax, 0							; return code 0
	ret
_MainProc ENDP

discr PROC
	push	ebp
	mov		ebp, esp
	push	ebx
	mov		eax, [ebp+12]
	imul	ebx, eax
	mov		eax, 4
	imul	[ebp+8]
	imul	[ebp+16]
	sub		ebx, eax
	mov		eax, ebx
	pop		ebx
	pop		ebp
	ret
discr ENDP

END