; Nathan Melton
; CISP 2410
; Ask user for name, build new string with names switched

.586
.MODEL FLAT

INCLUDE io.h															; header file for input/output

.STACK 4096

.DATA
prompt1		BYTE    "Enter your name in format LastName, FirstName", 0	; tell user how to input data
key			BYTE	", ", 0												; key that seperates first and last name
keyLen		DWORD	2													; key length
userInput	BYTE    80 DUP (?)											; where user's input is stored
stringOut	BYTE	80 DUP (?)											; final string
lastPosn	DWORD	?													; last position to cmp when comparing input with key
resultLabel	BYTE	"The resulting string is", 0						; windows gui window labels
failureLabel BYTE	"Input not formatted correctly." , 0

.CODE
_MainProc PROC
        input   prompt1, userInput, 80				; get input from user
		lea		eax, userInput						; store address of userinput in eax
		push	eax									; strlen parameter
		call	strlen								; strlen(string address)
		add		esp, 4								; remove parameter from stack
		sub		eax, keyLen							; subtract key length from input length
		inc		eax									; add one, this gives the last position to compare strings
		mov		lastPosn, eax						; store in lastPosn
		cld											; set direction flag for upcoming string operations
		mov		eax, 0

whilePosn:											; loop compares key to each postion of userinput, looking for matching chars
		cmp		eax,  lastPosn						; eax holds current check position for userinput
		jnle	endWhilePosn						; if eax is greater than the last position, jump

		lea		esi, userInput						; load userinput start address into esi
		add		esi, eax							; add offset to userinput start address
		lea		edi, key							; load key start address into edi
		mov		ecx, keyLen							; move key length to ecx, this is so repe knows how many chars to compare
		repe	cmpsb								; compare each key char to same amount of userinput chars
		jz		found								; if compared chars match, jump
		inc		eax									; if not, advance userinput check position, and restart loop
		jmp		whilePosn

endWhilePosn:										; key couldn't be found in userinput, tell the user
		output	failureLabel, failureLabel
		jmp		quit								; quit program

found:												; key was found in string, build new string based on key position
		push	esi									; strcopy param 2, esi currently points to char directly after key in userinput
		lea		edi, stringOut						; load start address of stringOut to edi
		push	edi									; strcopy param 1
		call	strcopy
		add		esp, 8								; remove parameters from stack

		sub		esi, keyLen							; mov esi back and terminate string
		mov		BYTE PTR [esi], 0

		mov		ebx, eax							; save eax to ebx
		mov		eax, 32								; move ascii code for space into eax
		stosb										; store space in stringOut after first name
		mov		eax, ebx							; restore eax

		lea		esi, userInput						; load start address of userinput into esi
		push	esi									; strcopy param 2
		push	edi									; strcopy param 1
		call	strcopy
		add		esp, 8								; remove parameters from stack
		output	resultLabel, stringOut				; output final string

quit:	
        mov     eax, 0  ; exit with return code 0
        ret
_MainProc ENDP

; Calculates length of string, returns via eax
; strlen(string address)
strlen	PROC
		push	ebp
		mov		ebp, esp
		push	ebx
		sub		eax, eax
		mov		ebx, [ebp+8]
whileChar:
		cmp		BYTE PTR [ebx], 0
		je		endWhileChar
		inc		eax
		inc		ebx
		jmp		whileChar
endWhileChar:
		pop		ebx
		pop		ebp
		ret
strlen	ENDP

; Copy string from source to dest
; strcopy(dest address, source address)
strcopy	PROC NEAR32
		push	ebp
		mov		ebp, esp
		push	esi
		pushfd

		mov		edi, [ebp+8]
		mov		esi, [ebp+12]
		cld

whileNoNull:
		cmp		BYTE PTR [esi], 0
		je		endWhileNoNull
		movsb
		jmp		whileNoNull

endWhileNoNull:
		popfd
		pop		esi
		pop		ebp
		ret
strcopy	ENDP
END
