TITLE: Program #3     (Program3_Yucen_Cao.asm)

; Author: Yucen Cao
; Last Modified: 7/27/2019
; OSU email address: caoyuc@oregonstate.edu
; Course number/section: CS_271_400_U2019
; Assignment Number:  Program #3               Due Date: 07/28/2019
; Description: 1.Write a program to calculate composite numbers. 
;              2.First, the user is instructed to enter the number n of composites to be displayed from 1 to 300
;              3.If n is out of range, the user is re-prompted until they enter a value in the specified range. 
;              4.The program then calculates and displays all of the composite numbers up to and including the nth composite.
;              5.The results should be displayed 10 composites per line with at least 3 spaces between the numbers.
;
; Note: This progtam has data validation. If the user gives the invalid input, he has to input again.
;
; Implementation notes:
;              This program is implemented using procedures.
;              All variables are global ... no parameter passing
;

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

	; strings
	myname			byte	"My name: Yucen Cao", 0
	programTitle	byte	"Program title:  Program #3: calculate composite numbers", 0
	intro			byte	"This program is capable of generating a list of composite numbers.", 0
	extraCredit		byte	"**EC: (2pt) Give the user the option to display only composite numbers that are also odd numbers. ", 0
	instructions1	byte	"Simply let me know how many you would like to see. ", 0
	instructions2	byte	"I will accept orders for up to 300 composites.", 0
	askNumber		byte	"How many composites do you want to view? [1 .. 300]:", 0
	askOdd_1		byte	"Do you want display only composite numbers that are also odd numbers?", 0
	askOdd_2		byte	"Enter 1 for YES, Enter 0 for NO.", 0
	oddWrong		byte	"Out of range. Please Enter 0 or 1", 0
	stringWrong		byte	"Out of range. Please try again.", 0
	goodByeWord		byte	"Thanks for using my program!", 0
	three_space		byte	"	", 0

	; data of number
	numberComposite	DWORD	?       ; the toatl number to print enter by user from 1 to 300
	itemInLine		DWORD	0       ; from 1 to 10 in pre line
	markNumber		DWORD	0       ; the mark of total printed numberComposite, from 1 to 300
	minComposite	DWORD	1
	maxComposite	DWORD	300
	Composite_now	DWORD	4       ; the number to validate or print now
	find_Composite	DWORD	0       ; 1 for it is the composite number, 0 for not
	odd_only		DWORD	0       ;if the user choose print odd number or not


.code
main PROC
	call	introduction
	call	getUserData
	call	numberOdd
	call	showComposites
	call	goodbye

	exit	; exit to operating system
main ENDP


;---------------------------------------------------------------------------------------
; introduction: the program title, introduction, programmer’s name and extra point
; receives: global variables myname, programTitle, intro, extraCredit, instructions1, instructions2
; returns: none
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
introduction PROC
	; Display the program title, introduction and programmer’s name.
		mov		edx, OFFSET	myname
		call	WriteString
		call	CrLf
		mov		edx, OFFSET	programTitle
		call	Writestring
		call	CrLf
		mov		edx, OFFSET	intro
		call	Writestring
		call	CrLf

	; Display the extra point
		mov		edx, OFFSET	extraCredit
		call	WriteString
		call	CrLf

	; Display the instructions for the number
		mov		edx, OFFSET	instructions1
		call	Writestring
		call	CrLf
		mov		edx, OFFSET	instructions2
		call	Writestring
		call	CrLf

	ret
introduction ENDP



;---------------------------------------------------------------------------------------
; introduction: get the data from User
; receives: global variables askNumber
; returns: save the input in numberComposite
; preconditions: none
; registers changed: edx, eax
;---------------------------------------------------------------------------------------
getUserData PROC
	;asking the number
		mov		edx, OFFSET	askNumber
		call	Writestring
		call	ReadInt
		mov		numberComposite,eax
		call	validate
	ret
getUserData ENDP



;---------------------------------------------------------------------------------------
; introduction: validate the data of number from 1 to 300
; receives: global variables minComposite, maxComposite, numberComposite, stringWrong
; returns: save the input in numberComposite
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
validate PROC
	; validate the data with max and min
		mov		edx, numberComposite
		cmp		edx, minComposite
		jl		INPUT_AGAIN
		cmp		edx, maxComposite
		jg		INPUT_AGAIN
		jmp		FINISHED

	; error message, input again
		INPUT_AGAIN:
			mov		edx, OFFSET	stringWrong
			call	Writestring
			call	CrLf
			call	getUserData
	; the data is validate, finished
		FINISHED:
			ret
validate ENDP



;---------------------------------------------------------------------------------------
; introduction: ask the user print only odd number or not
; receives: global variables askOdd_1, askOdd_2, odd_only
; returns: put the input in odd_only
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
numberOdd PROC
	;asking the number
		mov		edx, OFFSET	askOdd_1
		call	Writestring
		mov		edx, OFFSET	askOdd_2
		call	Writestring
		call	ReadInt
		mov		odd_only,eax
		call	validateExtra
	ret
numberOdd ENDP


;---------------------------------------------------------------------------------------
; introduction:validate the data for print only odd number
; receives: global variables odd_only, oddWrong
; returns: put the input in odd_only
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
validateExtra PROC
	; validate the data with 1 and 0
		mov		edx, odd_only
		cmp		edx, 1
		je		FINISHED          ;the input is 1
		cmp		edx, 0
		je		FINISHED          ;the input is 0    

	; the input is not 1 or 0, error message, input again
		INPUT_AGAIN:
			mov		edx, OFFSET	oddWrong
			call	Writestring
			call	CrLf
			call	numberOdd
	; the data is validate, finished
		FINISHED:
			ret
validateExtra ENDP




;---------------------------------------------------------------------------------------
; introduction: Print the COMPOSITE number
; receives: global variables odd_only, Composite_now, find_Composite, markNumber, itemInLine, three_space, numberComposite
; returns: none
; preconditions: markNumber <= numberComposite
; registers changed: edx, eax
;---------------------------------------------------------------------------------------
showComposites PROC
			
		CHECK_ODD:
			cmp		odd_only, 0
			je		CHECK_COMPOSITE        ;the user choose print all number
			; the user choose print odd only, to check the number is odd or not
			mov		edx, 0                 
			mov		eax, Composite_now
			mov		ebx, 2
			div		ebx
			cmp		edx, 0
			jne		CHECK_COMPOSITE       ;the number is odd, next to validate it is composite or not
			inc		Composite_now         ;the number is even, add 1 to the number

		CHECK_COMPOSITE:
			mov		find_Composite, 0     ;initialize the find_Composite to 0
			call	isComposite
			cmp		find_Composite, 1
			je		PRINT
			inc		Composite_now
			jmp		CHECK_ODD

			

		PRINT:
			inc		markNumber
			inc		itemInLine
			jmp		CHECK_NEWLINE
			

		;check print new line or not 
		CHECK_NEWLINE:
			mov		edx, itemInLine
			cmp		edx, 10
			jg		PRINT_NEWLINE
			jmp		PRINT_NUMBER

		; print the new line
		PRINT_NEWLINE:
			call	Crlf
			mov		itemInLine, 1
			jmp		PRINT_NUMBER


		; print the number 
		PRINT_NUMBER:
			mov		eax, Composite_now
			call	WriteDec
			mov		edx, OFFSET	three_space
			call	Writestring

		; to print the next or not
		NEXT:
			mov		eax, markNumber
			cmp		eax, numberComposite
			je		FINISHED
			inc		Composite_now
			jmp		CHECK_ODD

		FINISHED:
			ret

showComposites ENDP



;---------------------------------------------------------------------------------------
; introduction:check the number is Composite number or not
; receives: global variables Composite_now, find_Composite
; returns: if it is a composite, let find_Composite = 1
; preconditions: none
; registers changed: ecx, edx, eax
;---------------------------------------------------------------------------------------
isComposite PROC
	mov		ecx, Composite_now
	dec		ecx                             ; div all the number less than itself, so dec 

	CHECK_COMPOSITE:
			cmp		ecx, 1
			je		FINISHED                 ;check all the number less than the number
			mov		edx, 0
			mov		eax, Composite_now
			div		ecx
			cmp		edx, 0
			je		FIND_IT
			loop	CHECK_COMPOSITE

	FIND_IT:
			mov		find_Composite, 1

	FINISHED:
			ret
isComposite ENDP



;---------------------------------------------------------------------------------------
; introduction: Good BYE
; receives: global variables goodByeWord
; returns: none
; preconditions: none
; registers changed: edx
;---------------------------------------------------------------------------------------
goodbye PROC
	;goodbye
		call	CrLf
		mov		edx, OFFSET	goodByeWord
		call	Writestring
		call	CrLf

	ret
goodbye ENDP




END main
