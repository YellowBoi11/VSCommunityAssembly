TITLE Quiz4.asm

INCLUDE Irvine32.inc

.data
number dword 0
ones byte ?

.code
main PROC

start:
mov eax, 0
mov ebx, 0
mov ecx, 0
mov edx, 0
mov esi, 0
mov edi, 0

call GetInt			;// will return user-input integer in eax
mov number, eax		;// save user-input integer

;// NEED LOGIC HERE TO EXIT PROGRAM WHEN USER ENTERS '0'
cmp eax, 0
jz quit

mov ebx, offset ones
call howmany      ;// This will updates 'ones' to hold the number of 1's are in the binary representation of the number

mov ecx, number
movzx ebx, ones
call oddoreven		;// This will print if number of 1's in binary is odd or even

; NEED TO ZERO OUT ONES. I didn't see a better place to put this
mov ones, 0

jmp start

quit:
exit
main ENDP

;// ---------------------------------------------------------------------------------
;// menu
;// Description:    Prompts user to input an integer
;// Receives:		Nothing
;// Requires:		Nothing
;// Returns:		User-input integer in eax
;// ---------------------------------------------------------------------------------

GetInt proc
.data
prompt1 byte 0ah, 0dh, "Enter a number between 1 and 1,000,000 ( 0 to quit ) -->  ", 0h

.code
mov edx, offset prompt1
call writestring
call readdec
ret
GetInt endp



;// ---------------------------------------------------------------------------------
;// howmany
;// Description:    Finds the number of 1's in the binary representation of the integer
;// Receives:		Variable to store number of ones in, user input integer
;// Requires:		'ones' address in ebx, user-input integer in eax
;// Returns:		'ones' updated with number of 1's
;// ---------------------------------------------------------------------------------

howmany PROC

.data

.code
clc				;// clear carry flag
mov ecx, 32		;// max length of integer (in binary)
;// YOUR CODE HERE
; I made this way more complex than it needed to be. I need to consider jnc more often
L1:
  ror eax, 1
  jc increment 

ENDL1:
  loop L1
  jmp endHowMany ; Exit the procedure.

; Increments the value at ebx and jumps to the end of the loop
increment:
  inc byte ptr [ebx] 
  jmp ENDL1 ; Could just dec exc and jump to L1, but this feels more explicit
;// Hints:	ror eax, 1      - this will rotate eax to the right by 1, and copy the LSB into the carry flag
;//			rol				- performs a left rotate, and copies MSB into carry flag
;//			lahf			- loads current flags into ah
;//			and ah, 1		- preserves only the carry flag
;//			byte ptr [reg]	- to select only 1 byte of information at the address in reg
endHowMany:
  ret  
howmany ENDP



;// ---------------------------------------------------------------------------------
;// oddoreven
;// Description:    Prints if the number of 1's in binary is odd or even
;// Receives:		Will need the original number and the number of 1's
;// Requires:		?
;// Returns:		Correct output printed to console(see example on Canvas)
;// ---------------------------------------------------------------------------------

oddoreven PROC

.data
prompt2 byte ".  The number of ones is even.", 0h
prompt3 byte ".  The number of ones is odd.", 0h
prompt4 byte "The original number is ", 0h
prompt5 byte " There are ", 0h
prompt6 byte " one(s).", 0ah, 0dh, 0h
prompt7 byte "The original number in binary.", 0ah, 0dh, 0h

.code
clc;// clear the carry flag

mov edx, offset prompt4;// original number
call writestring

mov eax, ecx
call writedec

;// YOUR CODE HERE

ror ebx, 1 ; Checks LSB
jc odd
jmp eve


eve: ; If lsb is 0
  mov edx, offset prompt2 
  call writestring
  jmp numones 
odd: ; IF lsb is 1
  mov edx, offset prompt3
  call writestring 
  jmp numones

numones:
  rol ebx, 1 ; restore ebx

  ; Print number of ones
  mov edx, offset prompt5 
  call writestring 
  mov eax, ebx
  call writedec ; Write the number ones
  mov edx, offset prompt6
  call writestring 
  call crlf

  ; write the binary representation
  mov edx, offset prompt7 
  call writestring 
  mov eax, ecx
  call writebin


;// Final output of your code should match the example on Canvas

ret
oddoreven ENDP


END main
