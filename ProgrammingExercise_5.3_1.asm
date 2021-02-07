; Nathan Melton
; CISP 2410
; Calculate sum from 1 to n

.586
.MODEL FLAT

INCLUDE io.h

.STACK 4096

.DATA
prompt		BYTE	"Enter number n: ", 0	; prompt user for n
userInput	BYTE	40 DUP (?)				; holds user input
resultLabel	BYTE	"The sum is: ", 0		; prompt for ouput
sumASCII	BYTE	11 DUP (?), 0			; holds string representation of sum

.CODE
_MainProc PROC
	input	prompt, userInput, 40			; get n from user
	atod	userInput						; convert ascii input to decimal

	mov		ecx, eax						; set counter register to n
	mov		eax, 0							; clear eax
ls:											; for loop label
	add		eax, ecx						; add the counter to running total
	loop	ls								; loop check, decrements ecx
	
	dtoa	sumASCII, eax					; convert sum into ascii
	output	resultLabel, sumASCII			; display sum to screen

	mov		eax, 0							; return code 0
	ret
_MainProc ENDP
END