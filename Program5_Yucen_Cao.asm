TITLE: Program #5A     (Program5_Yucen_Cao.asm)

; Author: Yucen Cao
; Last Modified: 8/07/2019
; OSU email address: caoyuc@oregonstate.edu
; Course number/section: CS_271_400_U2019
; Assignment Number:  Program #5A               Due Date: 08/11/2019
; Description: 1.Write a MASM program to perform the tasks shown below. Be sure to test your program and ensure that it rejects incorrect input values.
;              2.Implement macros getString and displayString. The macros may use Irvine’s ReadString to get input from the user, and WriteString to display output.
;              3.getString should display a prompt, then get the user’s keyboard input into a memory location.
;              4.displayString should print the string which is stored in a specified memory location.
;              5.ReadVal should invoke the getString macro to get the user’s string of digits. It should then convert the digit string to numeric, while validating the user’s input.
;			   6.WriteVal should convert a numeric value to a string of digits and invoke the displayString macro to produce the output.
;			   7.The program will then display the list of integers, their sum, and the average value of the list.
; Note: This program has data validation. If the user gives the invalid input, he has to input again.
;
; Implementation notes:
;              This program is implemented using procedures and macros .
;              


INCLUDE Irvine32.inc



;---------------------------------------------------------------------------------------
; introduction: use macro to get the string
; receives: prompt, inputString
; returns: 
; preconditions: none
; registers changed: ecx, edx
;---------------------------------------------------------------------------------------
getString	MACRO	prompt, inputString		
	push	ecx
	push	edx
	
	displayString prompt
	mov		edx, inputString	; move destination string to edx
	mov		ecx, 300			; size of inputString
	call	ReadString			;get the string from the user
	
	pop		edx					
	pop		ecx
ENDM


;---------------------------------------------------------------------------------------
; introduction: use macro to display the string
; receives: stringLocation
; returns: 
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
displayString	MACRO	stringLocation
	push	edx
	
	mov		edx, stringLocation
	call	WriteString
	
	pop		edx
ENDM



.data

	; strings
	myname			byte	"My name: Yucen Cao", 0
	programTitle	byte	"Program title:  Program #5a Demonstrating low-level I/O procedures", 0
	intro1			byte	"Please provide 10 decimal integers.", 0
	intro2			byte	"Each number needs to be small enough to fit inside a 32 bit register.", 0
	intro3			byte	"After you have finished inputting the raw numbers I will display a list of the integers, their sum, and their average value.", 0
	extraCredit1	byte	"**EC1: (1pt)Number each line of user input and display a running subtotal of the numbers. ", 0
	askString		byte	" Please enter an integer number: ", 0
	stringWrong		byte	"     ERROR: You did not enter an integer number or your number was too big.", 0
	print_allNumber	byte	"You entered the following numbers:", 0
	print_sum		byte	"The sum of these numbers is: ", 0
	print_average	byte	"The average is: ", 0
	goodByeWord		byte	"Thanks for using my program!", 0
	three_space		byte	"   ", 0
	hehe			byte	"come to here	", 0

	; data of number
	input			byte	300 DUP(0)       ; the input which input by user
	array			DWORD	10	DUP(?)
	sum				DWORD	?       
	average			DWORD	? 
	output			byte	10 DUP(0)		; out put the number by store it in this string
	


.code
main PROC
	;introduction
	push	OFFSET	myname
	push	OFFSET	programTitle
	push	OFFSET	intro1
	push	OFFSET	intro2
	push	OFFSET	intro3
	push	OFFSET	extraCredit1
	call	introduction

	; get the data from the user
	push	OFFSET	stringWrong
	push	OFFSET	output
	push	OFFSET askString
	push	OFFSET array
	push	OFFSET input
	call	getNumber

	
	;display  the array
	push	OFFSET	three_space
	push	OFFSET	output
	push	OFFSET print_allNumber
	push	OFFSET	array
	call	displayArray

	;display the sum of the array
	push	OFFSET	output
	push	OFFSET print_average
	push	OFFSET print_sum
	push	OFFSET	array
	call	sumArray

	

	;goodbye
	push	OFFSET	goodByeWord
	call	goodbye

	exit	; exit to operating system
main ENDP


;---------------------------------------------------------------------------------------
; introduction: the program title, introduction, programmer’s name and extra point
; receives: variables myname, programTitle, intro1, intro2, intro3, extraCredit for intro
; returns: none
; preconditions: none
; registers changed: ebp
;---------------------------------------------------------------------------------------
introduction PROC
	; Display the program title, introduction and programmer’s name.
	; [ebp + 8] extraCredit1
	; [ebp + 12] intro3
	; [ebp + 16] intro2
	; [ebp + 20] intro1
	; [ebp + 24] programTitle
	; [ebp + 28] myname

		push	ebp
		mov		ebp, esp

		displayString [ebp + 28]		;myname
		call	CrLf
		displayString [ebp + 24]		;programTitle
		call	CrLf
		displayString [ebp + 20]		;intro1
		call	CrLf
		displayString [ebp + 16]		;intro2
		call	CrLf
		displayString [ebp + 12]		;intro3
		call	CrLf
		displayString [ebp + 8]			;extraCredit1
		call	CrLf
		call	CrLf

	FINISHED:
		pop		ebp
		ret		24
introduction ENDP


;---------------------------------------------------------------------------------------
; introduction: get the number from the user
; receives: stringWrong, output, askString, array, input
; returns: the input
; preconditions: none
; registers changed: ebp, eax, ebx, ecx,edi
;---------------------------------------------------------------------------------------
getNumber PROC
		push	ebp
		mov		ebp, esp
		mov		eax, [ebp + 8]                      ;input string
		mov		edi, [ebp + 12]						;the address of the array
		mov		edx, [ebp + 16]						;askString
		mov		ecx, 1
	
	I1:
		cmp		ecx, 10
		jg		FINISHED
		push	[ebp + 24]							;the string of stringwrong 
		push	[ebp + 16]
		push	edi
		push	[ebp + 8]
		mov		eax, ecx
		
		push	eax
		push	[ebp + 20]
		call	WriteVal
		call	readVal
		inc		ecx
		add		edi, 4
		jmp		I1

	FINISHED:
		pop		ebp
		ret		20

getNumber ENDP


;---------------------------------------------------------------------------------------
; introduction: accept a numeric string input compute the corresponding integer value
; receives: stringWrong, output, askString, array, input
; returns: the string
; preconditions: none
; registers changed: edx, eax, ebx, ecx, ebp, edi
;---------------------------------------------------------------------------------------
readVal PROC
		push	ebp
		mov		ebp, esp
		mov		eax, [ebp + 8]                      ;input string
		mov		edi, [ebp + 12]						;the address of the array
		mov		edx, [ebp + 16]						;askString
		push	ecx

	INPUT_DATA:
		;extra: number each line
		getString [ebp + 16], [ebp + 8]


	VALIDATE_DATA:
		; validate the data
		mov		esi, [ebp + 8]
		mov		eax, 0				
		mov		ebx, 10					
		mov		ecx, 0					;total number
		mov		edx, 0					;number initialize
		cld
		

	L1:
		lodsb
		cmp		al, 0					;the string is in the end or not
		je		EndOfInput
		cmp		al, 48					;from 0 - 9 or not
		jl		INVALID_DATA
		cmp		al, 57
		jg		INVALID_DATA
		inc		ecx
		jmp		L1

	EndOfInput:
		cmp		ecx, 10					;only hold 32 bit number, number is large or not
		jg		INVALID_DATA

		mov		esi, [ebp + 8]
		mov		eax, 0
		
	STOI:
		lodsb
		cmp		al, 0					;the string is in the end or not
		je		FINISHED
		sub		al, 48
		push	eax
		mov		eax, edx
		mov		ebx, 10
		mul		ebx
		jc		PI						;have to pop eax, to avild crash
		mov		edx, eax
		pop		eax
		add		edx, eax
		jc		INVALID_DATA			;overflow
		jnc		STOI

		
	PI:
		pop		eax
	INVALID_DATA:
		push	edx
		displayString [ebp +20]			;stringWrong
		call	CrLf
		pop		edx
		jmp		INPUT_DATA

	FINISHED:
		

		mov		ebx, [ebp + 12]
		mov		[ebx], edx
		pop		ecx
		pop		ebp
		ret		16
readVal ENDP



;---------------------------------------------------------------------------------------
; introduction: accept a 32 bit unsigned int and display the corresponding ASCII representation on the console
; receives: number, output string
; returns: none
; preconditions: none
; registers changed: ebp, eax, ebx, ecx, edx
;---------------------------------------------------------------------------------------
WriteVal PROC
		push	ebp						
		mov		ebp, esp					
		pushad							
										
		mov		eax, [ebp+12]				;number
		mov		edi, [ebp+8]				;output string	
		mov		ecx, 0
		

	TO_STRING:
		mov		edx, 0	
		mov		ebx, 10
		div		ebx
		mov		ebx, edx
		add		ebx, 48					; transfer to ascii
		push	ebx
		inc		ecx
		cmp		eax, 0
		je		DONE
		jmp		TO_STRING
		
	DONE:
		pop		eax
		stosb							
		dec		ecx
		cmp		ecx, 0
		je		PRINT
		jmp		DONE

	PRINT:
		mov		eax, 0
		stosb							;add 0 to the end of the string
		mov edx, [ebp+8]				;now we can write the string using the macro
		displayString edx

		popad							;restore all registers
		pop ebp							;restore stack
		ret 8					
WriteVal ENDP






;---------------------------------------------------------------------------------------
; introduction:  display the  array
; receives:   the array need to print
; returns: none
; preconditions: none
; registers changed: edx, esi ebx, eax, ecx
;---------------------------------------------------------------------------------------
displayArray PROC
		push	ebp
		mov		ebp,esp
		mov		edx, [ebp + 12]	                ;print_allNumber  string
		mov		esi, [ebp + 8]					;the address of the first element in the array
		mov		ecx, 10							;the numbers in the line
		
		call	CrLf
		displayString	edx
		call	CrLf

	PRINT_NUMBER:
		mov		eax, [esi]
		push	eax
		push	[ebp + 16]
		call	WriteVal
		displayString	[ebp + 20]
		
		add		esi, 4
		loop	PRINT_NUMBER

	FINISHED:
		call	CrLf
		pop		ebp
		ret		16
		
displayArray ENDP




;---------------------------------------------------------------------------------------
; introduction: sum the array and get the average number
; receives: number array, output string
; returns: sum and average
; preconditions: none
; registers changed: ebp, eax, ebx, ecx, edx, esi
;---------------------------------------------------------------------------------------
sumArray PROC
		push	ebp
		mov		ebp,esp
		mov		edx, [ebp + 12]	                ;print_sum  string
		mov		esi, [ebp + 8]					;the address of the first element in the array
		mov		ecx, 10							;the numbers in the line
		mov		eax, 0

		displayString	edx

	SUM_IT:
		mov		ebx, [esi]
		add		eax, ebx
		add		esi, 4
		loop	SUM_IT

	DONE:
		push	eax
		push	[ebp + 20]
		call	WriteVal
		call	CrLf

	AVERAGE_N:
		mov		edx, [ebp + 16]
		displayString edx
		mov		edx, 0
		mov		ebx, 10
		div		ebx
		;cmp		edx, 5              ;sum of 10 numbers is 3577, average is 357, no need to round 
		;jl		PA
		;inc		eax
	
	PA:
		push	eax
		push	[ebp + 20]
		call	WriteVal
		call	CrLf

	FINISHED:
		pop		ebp
		ret		16
sumArray ENDP



;---------------------------------------------------------------------------------------
; introduction: Good BYE
; receives:variables goodByeWord
; returns: none
; preconditions: none
; registers changed: ebp
;---------------------------------------------------------------------------------------
goodbye PROC
		push	ebp
		mov		ebp,esp

		call	CrLf
		displayString	[ebp + 8]		;goodByeWord
		call	CrLf

	FINISHED:
		pop		ebp
		ret		4
goodbye ENDP




END main


