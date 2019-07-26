TITLE: Program #1     (Program1_Yucen_Cao.asm)

; Author: Yucen Cao
; Last Modified: 07/04/2019
; OSU email address: caoyuc@oregonstate.edu
; Course number/section: CS_271_400_U2019
; Assignment Number:  Program #1               Due Date: 07/07/2019
; Description: Write a MASM program to perform the tasks: 
;             1.Display your name and program title on the output screen.
;             2.Display instructions for the user.
;             3.Prompt the user to enter two numbers.
;             4.Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;             5.Display a terminating message.




INCLUDE Irvine32.inc


.data

; strings
	myname			byte	"My name: Yucen Cao", 0
	programTitle	byte	"Program title:  Program #1", 0
	extraCredit_1	byte	"**EC_1: Program verifies second number less than first.", 0
	extraCredit_2	byte	"**EC_2: Display the square of each number. ", 0
	instructions	byte	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
	enter_1			byte	"First number: ", 0
	enter_2			byte	"Second number: ", 0
	Sign_sum		byte	" + ", 0
	Sign_difference	byte	" - ", 0
	Sign_product	byte	" * ", 0
	Sign_divide		byte	" / ", 0
	Sign_equal		byte	" = ", 0
	Sign_remainder	byte	" remainder ", 0
	Sing_square		byte	"Square of ", 0 
	Sign_again		byte	"The second number must be less than the first! Please enter again.", 0
	terminatingMessage	byte	"Impressed? Bye!", 0

; numbers
	input_1		DWORD	?
	input_2		DWORD	?
	sum			DWORD	?
	difference	DWORD	?
	product		DWORD	?
	quotient	DWORD	?
	remainder	DWORD	?
	Square_1	DWORD	?
	Square_2	DWORD	?



.code
main PROC

; Display your name and program title on the output screen.
	mov		edx, OFFSET	myname
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	programTitle
	call	Writestring
	call	CrLf

; Display the extra point
	mov		edx, OFFSET	extraCredit_1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	extraCredit_2
	call	Writestring
	call	CrLf
	

; Display instructions for the user.
	mov		edx, OFFSET	instructions
	call	Writestring
	call	CrLf

USER_INPUT:
	; let the user enter the input 1
	mov		edx, OFFSET	enter_1
	call	Writestring
	call	ReadInt
	mov		input_1,eax

	; let the user enter input 2
	mov		edx, OFFSET	enter_2
	call	Writestring
	call	ReadInt
	mov		input_2,eax


; check the second number to be less than the first
; extra point 1 is in here
	; if input_2 less than input_1
	mov		eax, input_1
	mov		ebx, input_2
	cmp		eax, ebx						; check if the input_1 > input_2
	ja		CALCULATION						; if input_1 > input_2, go to the calculation

	; if input_1 less than input_2
	mov		edx, OFFSET Sign_again			;when input_1 <= input_2, show the sign that second number needs be bigger
	call	Writestring
	call	CrLf
	jmp		USER_INPUT						; jump to user_input, let the user to enter again



CALCULATION:
	; sum
	mov		eax, input_1
	mov		ebx, input_2
	add		eax, ebx
	mov		sum, eax

	;  difference
	mov		eax, input_1
	mov		ebx, input_2
	sub		eax, ebx
	mov		difference, eax

	; product
	mov		eax, input_1
	mov		ebx, input_2
	mul		ebx
	mov		product, eax

	; quotient
	mov		edx, 0					; initializes edx
	mov		eax, input_1
	mov		ebx, input_2
	div		ebx;
	mov		quotient, eax
	mov		remainder, edx

	; extra_point :Square
	mov		eax, input_1
	mov		ebx, input_1
	mul		ebx
	mov		Square_1, eax

	mov		eax, input_2
	mov		ebx, input_2
	mul		ebx
	mov		Square_2, eax


; dispaly
	; display sum 
	mov		eax, input_1
	call	WriteDec
	mov		edx, OFFSET Sign_sum
	call	Writestring
	mov		eax, input_2
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, sum
	call	WriteDec
	call	CrLf


	; display difference 
	mov		eax, input_1
	call	WriteDec
	mov		edx, OFFSET Sign_difference
	call	Writestring
	mov		eax, input_2
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, difference
	call	WriteDec
	call	CrLf


	; display product 
	mov		eax, input_1
	call	WriteDec
	mov		edx, OFFSET Sign_product
	call	Writestring
	mov		eax, input_2
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, product
	call	WriteDec
	call	CrLf


	; display quotient and  remainder
	mov		eax, input_1
	call	WriteDec
	mov		edx, OFFSET Sign_divide
	call	Writestring
	mov		eax, input_2
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, quotient
	call	WriteDec
	mov		edx, OFFSET Sign_remainder
	call	Writestring
	mov		eax, remainder
	call	WriteDec
	call	CrLf

	; display Square_1
	mov		edx, OFFSET	Sing_square
	call	Writestring
	mov		eax, input_1
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, Square_1
	call	WriteDec
	call	CrLf

	; display Square_2
	mov		edx, OFFSET	Sing_square
	call	Writestring
	mov		eax, input_2
	call	WriteDec
	mov		edx, OFFSET Sign_equal
	call	Writestring
	mov		eax, Square_2
	call	WriteDec
	call	CrLf




; Display a terminating message.
	mov		edx,OFFSET	terminatingMessage
	call	Writestring
	call	CrLf

	exit	; exit to operating system

main ENDP

; (insert additional procedures here)

END main
