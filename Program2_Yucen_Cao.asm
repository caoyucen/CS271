TITLE: Program #2     (Program2_Yucen_Cao.asm)

; Author: Yucen Cao
; Last Modified: 07/12/2019
; OSU email address: caoyuc@oregonstate.edu
; Course number/section: CS_271_400_U2019
; Assignment Number:  Program #2               Due Date: 07/14/2019
; Description: Write a program to calculate Fibonacci numbers.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

; data of string
	myname			byte	"My name: Yucen Cao", 0
	programTitle	byte	"Program title:  Program #2 Write a program to calculate Fibonacci numbers.", 0
	extraCredit		byte	"**EC: (1 pt) Display the numbers in aligned columns.", 0
	askUserName		byte	"What is your name?", 0
	userName		byte	60 DUP(0)
	greet			byte	"Hello, ", 0
	instructions1	byte	"Enter the number of Fibonacci terms to be displayed. ", 0
	instructions2	byte	"Provide the number as an integer in the range [1 .. 46].", 0
	askNumber		byte	"How many Fibonacci terms do you want?", 0
	stringWrong		byte	"Out of range. Enter a number in [1 .. 46]", 0
	end_yucen		byte	"Results certified by Yucen Cao.", 0
	goodBye			byte	"Goodbye, ", 0
	two_tab			byte	"		", 0
	one_tab			byte	"	", 0


; data of number
	numberFibonacci	DWORD	?
	result			DWORD	?
	minFibonacci	DWORD	1
	maxFibonacci	DWORD	46
	Fibonacci_0		DWORD	0
	Fibonacci_1		DWORD	1
	temp			DWORD	?
	itemInLine		DWORD	0
	markNumber		DWORD	0



.code
main PROC

; Display the program title and programmer’s name.
	mov		edx, OFFSET	myname
	call	WriteString
	call	CrLf
	mov		edx, OFFSET	programTitle
	call	Writestring
	call	CrLf

; Display the extra point
	mov		edx, OFFSET	extraCredit
	call	WriteString
	call	CrLf

; Prompt the user for their name and greet them (by name).
	mov		edx, OFFSET	askUserName
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF	userName
	call	ReadString
	mov		edx, OFFSET	greet
	call	WriteString
	mov		edx, OFFSET	userName
	call	WriteString
	call	CrLf


; Display the instructions1
	mov		edx, OFFSET	instructions1
	call	Writestring
	call	CrLf
	mov		edx, OFFSET	instructions2
	call	Writestring
	call	CrLf


;ask user for the input for Fibonacci
FIBONACCI_INPUT:
	; string for asking the number
	mov		edx, OFFSET	askNumber
	call	Writestring
	call	ReadInt
	mov		numberFibonacci,eax
	mov		edx, numberFibonacci
	cmp		edx, minFibonacci
	jl		INPUT_AGAIN
	cmp		edx, maxFibonacci
	jg		INPUT_AGAIN
	jmp		Begin_CALCULATION

; error message, input again
INPUT_AGAIN:
	mov		edx, OFFSET	stringWrong
	call	Writestring
	call	CrLf
	jmp		FIBONACCI_INPUT




; calculate and print the Fibonacci
Begin_CALCULATION:
	mov		ecx, numberFibonacci

; calculate the  Fibonacci number
CALCULATION:
	mov		eax, Fibonacci_0
	mov		ebx, Fibonacci_1
	add		eax, ebx
	mov		Fibonacci_0, ebx
	mov		Fibonacci_1, eax
	inc		itemInLine
	inc		markNumber
	jmp		CHECK_NEWLINE

;check print new line or not 
CHECK_NEWLINE:
	mov		edx, itemInLine
	cmp		edx, 4
	jg		PRINT_NEWLINE
	jmp		PRINT_FIBONACCI

; print the new line
PRINT_NEWLINE:
	call	Crlf
	mov		itemInLine, 1
	jmp		PRINT_FIBONACCI


; print the Fibonacci 
PRINT_FIBONACCI:
	mov		eax, Fibonacci_0
	call	WriteDec
	cmp		marknumber, 35          ; if the marknumber bigger than 35, print one tab, less print two tab
	jg		PRINT_TAB
	mov		edx, OFFSET	one_tab
	call	Writestring

PRINT_TAB:
	mov		edx, OFFSET	two_tab
	call	Writestring
	loop	CALCULATION



; Good BYE
	call	CrLf
	mov		edx, OFFSET	end_yucen
	call	Writestring
	call	CrLf
	mov		edx, OFFSET	goodBye
	call	Writestring
	mov		edx, OFFSET	userName
	call	Writestring
	call	CrLf


	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
