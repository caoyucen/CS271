TITLE: Program #4     (Program4_Yucen_Cao.asm)

; Author: Yucen Cao
; Last Modified: 8/01/2019
; OSU email address: caoyuc@oregonstate.edu
; Course number/section: CS_271_400_U2019
; Assignment Number:  Program #4               Due Date: 08/04/2019
; Description: 1.Write a MASM program to perform the tasks shown below. Be sure to test your program and ensure that it rejects incorrect input values.
;              2.Get a user request in the range [min = 15 .. max = 200].
;              3.Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elements of an array.
;              4.Display the list of integers before sorting, 10 numbers per line.
;              5.Sort the list in descending order (i.e., largest first).
;			   6.Calculate and display the median value, rounded to the nearest integer.
;			   7.Display the sorted list, 10 numbers per line.
; Note: This progtam has data validation. If the user gives the invalid input, he has to input again.
;
; Implementation notes:
;              This program is implemented using procedures.
;              


INCLUDE Irvine32.inc

	MAX = 200
	MIN = 15
	LO = 100
	HI = 999
	LINE = 10


.data

	; strings
	myname			byte	"My name: Yucen Cao", 0
	programTitle	byte	"Program title:  Program #4: Sorting Random Integers", 0
	intro1			byte	"This program generates random numbers in the range [100 .. 999],", 0
	intro2			byte	"displays the original list, sorts the list, and calculates the", 0
	intro3			byte	"median value. Finally, it displays the list sorted in descending order.", 0
	extraCredit1	byte	"** ", 0
	extraCredit2	byte	"**EC2: (3pt) Implement the sorting functionality using a recursive Merge Sort algorithm.  ", 0
	askNumber		byte	"How many numbers should be generated? [15 .. 200]:", 0
	stringWrong		byte	"Invalid input", 0
	print_sorted	byte	"The sorted list:", 0
	print_unsorted	byte	"The unsorted random numbers:", 0
	print_median	byte	"The median is: ", 0
	goodByeWord		byte	"Thanks for using my program!", 0
	three_space		byte	"	", 0

	; data of number
	numberInput		DWORD	?       ; the numbers should be generated that enter by user from 15 to 200
	array			DWORD	MAX	DUP(?)
	numberIndex		DWORD	?       ;
	temp_array		DWORD	MAX DUP(?) 
	


.code
main PROC
	call	Randomize
	call	introduction

	; get the data from the user
	push	OFFSET numberInput
	call	getData

	;random the number
	push	numberInput
	push	OFFSET	array
	call	fillArray


	;display unsorted list
	push	OFFSET	print_unsorted
	push	numberInput
	push	OFFSET	array
	call	displayList

	


	;mergeSort the array
	mov		eax, numberInput
	dec		eax
	mov		numberIndex, eax
	push	0								;first one in array
	push	numberIndex						;last one in array
	push	OFFSET	array
	call	mergeSortList

	;display median
	push	OFFSET	print_median
	push	numberInput
	push	OFFSET	array
	call	displayMedian

	;display sorted list
	push	OFFSET	print_sorted
	push	numberInput
	push	OFFSET	array
	call	displayList


	;goodbye
	call	goodbye

	exit	; exit to operating system
main ENDP


;---------------------------------------------------------------------------------------
; introduction: the program title, introduction, programmer’s name and extra point
; receives: global variables myname, programTitle, intro1, intro2, intro3, extraCredit for intro
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
		mov		edx, OFFSET	intro1
		call	Writestring
		call	CrLf
		mov		edx, OFFSET	intro2
		call	Writestring
		call	CrLf
		mov		edx, OFFSET	intro3
		call	Writestring
		call	CrLf

	; Display the extra point
		mov		edx, OFFSET	extraCredit1
		call	WriteString
		call	CrLf
		mov		edx, OFFSET	extraCredit2
		call	WriteString
		call	CrLf

	ret
introduction ENDP



;---------------------------------------------------------------------------------------
; introduction: get the data from User
; receives: global variables askNumber for intro, parameters: numberInput (reference)
; returns: save the input in numberInput
; preconditions: none
; registers changed: edx, eax, ebx
;---------------------------------------------------------------------------------------
getData PROC
		push	ebp
		mov		ebp, esp
		mov		ebx, [ebp + 8]                      ;put the address of the input into ebx
		
	INPUT_DATA:
		;asking the number
		mov		edx, OFFSET	askNumber
		call	Writestring
		call	ReadInt
		
		; validate the data with max and min
		cmp		eax, MIN
		jl		INPUT_AGAIN
		cmp		eax, MAX
		jg		INPUT_AGAIN
		mov		[ebx], eax
		jmp		FINISHED

		; error message, input again
	INPUT_AGAIN:
		mov		edx, OFFSET	stringWrong
		call	Writestring
		call	CrLf			
		jmp		INPUT_DATA

	FINISHED:
		pop		ebp
		ret		4
getData ENDP






;---------------------------------------------------------------------------------------
; introduction: fill array with random number from 100 to 999
; receives: parameters: numberInput (value), array (reference)
; returns:  get the random number into array
; preconditions: none
; registers changed: ecx, esi, eax
;---------------------------------------------------------------------------------------
fillArray PROC
		push	ebp
		mov		ebp,esp
		mov		ecx, [ebp + 12]					;total number to get random number/ input
		mov		esi, [ebp + 8]					;the address of the first element in the array

	FILL_IT:
		;get the randomnumber
		mov		eax, HI
		sub		eax, LO
		inc		eax								;999 - 100 +1 = 900, it will get the randomnumber from 0 - 899
		call	RandomRange
		add		eax, LO
		mov		[esi], eax
		add		esi, 4
		loop	FILL_IT

	FINISHED:
		pop		ebp
		ret		8

fillArray ENDP



;---------------------------------------------------------------------------------------
; introduction:  display the  array
; receives:  numberInput (value), the array need to print(reference)
; returns: none
; preconditions: none
; registers changed: edx, esi ebx, eax, ecx
;---------------------------------------------------------------------------------------
displayList PROC
		push	ebp
		mov		ebp,esp
		mov		edx, [ebp + 16]	                ;intro
		mov		ecx, [ebp + 12]					;total number to get random number/ input
		mov		esi, [ebp + 8]					;the address of the first element in the array
		mov		ebx, 0							;the numbers in the line
		call	Writestring
		call	CrLf

	PRINT:
		cmp		ebx, LINE						;10 items in a line or not
		jne		PRINT_NUMBER
		call	CrLf
		mov		ebx, 0

	PRINT_NUMBER:
		mov		eax, [esi]
		call	WriteDec
		mov		edx, OFFSET three_space
		call	Writestring
		add		esi, 4
		add		ebx, 1
		loop	PRINT

	FINISHED:
		call	CrLf
		pop		ebp
		ret		12
		
displayList ENDP








;---------------------------------------------------------------------------------------
; introduction: merge sort the array
; receives: numberInput (value), the array need to sort(reference)
; returns: the sorted array
; preconditions: none
; registers changed:  esi, eax, ecx
;---------------------------------------------------------------------------------------
mergeSortList PROC
		push	ebp
		mov		ebp, esp
		pushad
		mov		esi, [ebp + 8]					;the address of the first element in the array
		mov		eax, [ebp + 12]					;right index of the array
		mov		ebx, [ebp +16]					;left index of the array
		
		cmp		ebx, eax
		jge		FINISHED

	getMid:
		mov		edx, 0
		sub		eax, ebx						;eax = r - l
		mov		ebx, 2
		div		ebx								;eax = (r-l)/2
		mov		ebx, [ebp +16]
		add		eax, ebx						;eax = l +  (r-l)/2
		mov		edx, eax						;mid is in the edx
		mov		eax, [ebp + 12]					;reset right index of the array

	MergeS:
		push	ebx							    ;mergeSort(arr, l, m); 
		push	edx
		push	esi
		call	mergeSortList


		
		inc		edx								;m+1
		push	edx								;mergeSort(arr, m+1, r); 
		push	eax
		push	esi
		call	mergeSortList

		
		dec		edx								;become m 
		push	eax								;right
		push	edx								;mid
		push	ebx								;left
		push	esi								;array
		call	merge

	FINISHED:
		popad
		pop		ebp
		ret		12

mergeSortList ENDP





;---------------------------------------------------------------------------------------
; introduction: merge the array
; receives: mid, left, right, the array need to sort(reference)
; returns: merged array
; preconditions: none
; registers changed: all of them
;---------------------------------------------------------------------------------------
merge PROC
		push	ebp
		mov		ebp, esp
		pushad
		mov		esi, [ebp + 8]					;the address of the first element in the array
		mov		ebx, [ebp + 12]					;left index of the array
		mov		edx, [ebp +16]					;mid index of the array
		mov		eax, [ebp + 20]					;right


		;total number
		sub		eax, ebx
		inc		eax								;r - l + 1
		push	eax								;0 push total number

		;left address
		mov		eax, [ebp + 12]
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax								;1 push left address


		;right address
		mov		eax, [ebp + 20]		
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax								;2 push right address

		;mid address
		mov		eax, [ebp +16]
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax								;3 push mid address


		
		;mid +1 address
		mov		eax, [ebp +16]
		inc		eax
		mov		ebx, 4
		mul		ebx
		add		eax, esi
		push	eax								;4 push mid+1 address


		pop		edi								;4 push mid+1 address
		pop		eax								;3 push mid address, end of the left
		pop		ebx								;2 push right address, end of the right
		pop		esi								;1 push left address
		pop		ecx								;0 push total number
		mov		edx, ebx						;save right address


	BEGIN:
		cmp		esi, eax
		jle		LS
		jmp		CRS

	;left index is small than mid index
	LS:
		cmp		edi, ebx
		jle		LARS		
		jmp		L_PUSH

	;check right index is small or not
	CRS:
		cmp		edi, ebx
		jle		R_PUSH
		jmp		RES

	;left and right all small
	LARS:
		push	eax
		push	ebx
		mov		eax, [esi]
		mov		ebx, [edi]
		cmp		eax, ebx
		jle		L_P_PUSH
		jmp		R_P_PUSH

	;for pop 
	L_P_PUSH:
		pop		ebx
		pop		eax
		jmp		L_PUSH
	
	;for pop 
	R_P_PUSH:
		pop		ebx
		pop		eax
		jmp		R_PUSH

	L_PUSH:
		push	[esi]
		add		esi, 4
		jmp		BEGIN

	R_PUSH:
		push	[edi]
		add		edi, 4
		jmp		BEGIN

	RES:
		pop		eax
		mov		[edx], eax
		mov		eax, edx
		mov		ebx, 4
		sub		eax, ebx
		mov		edx, eax
		loop	RES

	FINISHED:
		popad
		pop		ebp
		ret		16
merge ENDP




;---------------------------------------------------------------------------------------
; introduction: display the median
; receives: numberInput (value), the array need to sort(reference)
; returns: none
; preconditions: none
; registers changed: 
;---------------------------------------------------------------------------------------
displayMedian PROC
		push	ebp
		mov		ebp,esp
		mov		edx, [ebp + 16]	                ;intro
		mov		eax, [ebp + 12]					;total number to get random number/ input
		mov		esi, [ebp + 8]					;the address of the first element in the array
		call	Writestring

		mov		edx, 0
		mov		ebx, 2
		div		ebx
		cmp		edx, 0
		je		EVEN_NUMBER
		
		;odd number to get median
		mov		ebx, 4
		mul		ebx
		add		esi, eax
		mov		eax, [esi]
		jmp		PRINT

	EVEN_NUMBER:
		;even number to get median
		dec		eax
		mov		ebx, 4
		mul		ebx
		add		esi, eax
		mov		eax, [esi]
		mov		ebx, [esi+4]
		add		eax, ebx
		mov		ebx, 2
		mov		edx, 0
		div		ebx
		cmp		edx, 0
		je		PRINT
		jmp		ROUNDED

	ROUNDED:
		inc		eax								; x.5 always near to next integer, so inc 



	PRINT:
		call	WriteDec
		call	CrLf

		pop		ebp
		ret		12

		;get the location of the 



displayMedian ENDP









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




;---------------------------------------------------------------------------------------
; introduction: 
; receives: 
; returns: 
; preconditions: 
; registers changed: 
;---------------------------------------------------------------------------------------
em PROC
		

em ENDP