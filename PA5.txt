TITLE PA5.asm

Comment @
Luca Pendlton
10/28/26
PA5
Description: Menu-based program that accepts user input and performs the following functions:
1. Enter a string
2. Convert the string to lower case.
3. Remove all non-alphabetic characters from the string. 
4. Is the string a palindrome?
5. Print the string.
6. Exit
@


Include Irvine32.inc

ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
maxLength = 51d


.data
menuPrompt byte 'MAIN MENU', 0Ah, 0Dh,
'--------------', 0Ah, 0Dh,
'1. Enter a String:', 0Ah, 0Dh,
'2. Convert all elements to lower case: ', 0Ah, 0Dh,
'3. Remove all non-alphabetic characters: ', 0Ah, 0Dh,
'4. Determine if the string is a palindrome: ', 0Ah, 0Dh,
'5. Print the string: ', 0Ah, 0Dh,
'6. Exit: ', 0Ah, 0Dh, 0h

errormessage byte 'Invalid menu selection. Please try again.', 0Ah, 0Dh, 0h

userSelection byte 0h
theString byte maxLength dup(0)
theStringLen byte 0


.code
main PROC

call ClearRegisters

menustart:
call clrscr
mov al, theStringLen
mov edx, offset menuPrompt
call WriteString
call GetInt
mov userSelection, al

mov edx, offset theString
mov ecx, lengthof theString

opt1:
cmp userSelection, 1
jne opt2
call clrscr
call GetString
mov theStringLen, al ; Move the value at al into theStringLen
jmp menustart

opt2:
cmp userSelection, 2
jne opt3
mov al, theStringLen
call ToLower ; Lowercase any uppercase
jmp menustart

opt3:
cmp userSelection, 3
jne opt4
mov al, theStringLen
call RemoveNonAlpha ; Remove non-alphabetic characcters
mov theStringLen, al ; changing theStringLen safely
jmp menustart

opt4:
cmp userSelection, 4
jne opt5
mov al, theStringLen
call IsPalindrome ; Check if it's a palindrome
jmp menustart

opt5:
cmp userSelection, 5
jne opt6
call PrintString
jmp menustart

opt6:
cmp userSelection, 6
jne printError
jmp quit

printError:
push edx
mov edx, offset errormessage
call writestring
call waitmsg
pop edx
jmp menustart


quit:
exit
main ENDP


;// Procedures
;// ---------------------------------------------------------------------------------
;// ClearRegisters
;// Description:
;// Requires: nothing
;// Returns: Nothing. Registers are now cleared.
;// ---------------------------------------------------------------------------------
ClearRegisters PROC

cleareax
clearebx
clearecx
clearedx
clearesi
clearedi

ret
ClearRegisters ENDP



;// ---------------------------------------------------------------------------------
;// GetInt
;// Description:	Prompts the user for an unsigned integer and stores it in EAX
;// Receives:		Nothing
;// Returns:		user input integer in EAX
;// Requires:		Nothing
;// ---------------------------------------------------------------------------------
GetInt PROC USES edx
.data
promptInt BYTE "Menu selection: ", 0ah, 0dh, 0h
promptInvalid BYTE "Invalid Input", 0ah, 0dh, 0h

.code
start :
mov edx, OFFSET promptInt
call WriteString
call ReadInt;// Sets the overflow flag and resets eax to 0 if input is invalid

jno validInput

mov edx, OFFSET promptInvalid
call WriteString
jmp start

validInput :
ret

GetInt endp



;// ---------------------------------------------------------------------------------
;// GetString
;// Description:	Prompts user to input a string
;// Receives:		Offset of storage location for string in edx, maximum storage size in ecx
;// Returns:		variable updated with string, stringlength in eax
;// Requires:		Nothing
;// ---------------------------------------------------------------------------------

GetString PROC uses edx ecx
.data
promptStr BYTE "Enter a string(50 or fewer characters): ", 0ah, 0dh, 0h


.code
start:
push edx
mov edx, OFFSET promptStr
call WriteString
pop edx

call clearstring

call ReadString
cmp eax, 0
je start

ret
GetString endp


;// ---------------------------------------------------------------------------------
;// ClearString
;// Description:    Clears the entire string so a new string does not contain existing values
;// Receives:		string offset in edx, maxlength(global var)
;// Requires:		Maxlength, string offset
;// Returns:		String is now cleared.
;// ---------------------------------------------------------------------------------
ClearString PROC uses ebx ecx esi
mov ecx, maxlength
clearesi
clearebx

L1:
mov [edx+esi], ebx
inc esi
loop L1

ret
ClearString ENDP


;// ---------------------------------------------------------------------------------
;// PrintString
;// Description:    Prints the current user-input string to console
;// Receives:		string offset in edx
;// Requires:		Valid string offset in edx
;// Returns:		String printed to console
;// ---------------------------------------------------------------------------------
PrintString proc uses edx
.data
option5prompt byte 'The current string is: ', 0h
.code
call clrscr
push edx
mov edx, offset option5prompt
call writestring
pop edx
call writestring
call crlf;// added a crlf for readability
call waitmsg
ret
PrintString endp




;// ---------------------------------------------------------------------------------
;// ToLower
;// Description:    Converts all alphabetic characters in a string to lower case.
;// Hint: You will need a loop, ASCII comparisons, a bitwise OR for the conversion, and ESI for indexing. 
;// Receives:		string offset in edx
;// Requires:		valid string offset in edx
;// Returns:		String is now converted to lowercase.
;// ---------------------------------------------------------------------------------

;// YOUR CODE HERE
ToLower proc uses edx ecx
mov ecx, eax  ; Maximum string length
L1:
  ; Short circuit at null terminator
  .IF byte ptr [edx] == 0 
    jmp endToLower

  .ELSEIF byte ptr [edx] > 40h && byte ptr [edx] < 5Bh
    or byte ptr [edx], 20h ; Bitwise and with 00100000b

  .ENDIF
  inc edx 
  loop L1

endToLower:
  ret 
  ToLower endp

;// ---------------------------------------------------------------------------------
;// RemoveNonAlpha
;// Description:    Removes all non-alphabetic characters from a string
;// Hint:	You can compare a character to 'A' or 'z'(or 'a' and 'Z'), and use jae and jbe jumps as needed.
;//			You will also need to come up with a strategy to shift/update the remaining characters in the string.
;//			Don't forget to update the string length variable as well. 
;// Receives:		string offset in edx, string length in eax
;// Requires:		a valid string offset and string length in edx and eax respectively
;// Returns:		String now contains only a-z or A-Z, and eax contains new string length
;// ---------------------------------------------------------------------------------

;// YOUR CODE HERE
RemoveNonAlpha proc uses edx ebx

mov ecx, eax ; Move string length into ecx

; Full loop
L1:
	; Short circuit for encountering a null-terminator
	.IF byte ptr [edx] == 0
		sub eax, ecx ; Set the new string length
    jmp EndRemoveNonAlpha

  ; Shift the string if the character is less than A or greater than z
	.ELSEIF byte ptr [edx] > 7Ah || byte ptr [edx] < 41h
		jmp L2prep

  ; Case for extra characters between Z and a
  .ELSEIF byte ptr [edx] > 5Ah && byte ptr [edx] < 61h
    jmp L2prep

	.ENDIF

	inc edx
EndL1:
	loop L1
  jmp EndRemoveNonAlpha

; Prepairation by pushing string offset and ecx
L2prep:
	push ecx
	push edx

; Character shifting loop
L2:
	; Short Circuit when null terminator
	.IF byte ptr [edx] == 0
		pop edx
		pop ecx
    inc ecx ; Incremented to check the current char again
		jmp EndL1

  ; Shift the characters one back
	.ELSE
    mov bl, byte ptr [edx + 1]
		mov byte ptr [edx], bl
    inc edx
	.ENDIF

	loop L2

  pop edx 
  pop ecx 
  inc ecx ; Incremented to check the current char again
  jmp EndL1


EndRemoveNonAlpha:
  ret 

RemoveNonAlpha ENDP


;// ---------------------------------------------------------------------------------
;// IsPalindrome
;// Description:    Determines if a string is a palindrome and prints the result.
;// Hint: Start with ecx set to the string length, and use it as an index([edx+ecx-1]).
;// This will allow you to iterate backwards through the string.
;// Use another register to also iterate forward during this same loop([edx+esi]).
;// With these two iterators you can compare characters of the string. 
;// You will need to use a register as cmp cannot do memory-to-memory.
;// Receives:		edx with the string offset, eax with string length
;// Requires:		a valid string offset and a valid string length.
;// Returns:		Palindrome result printed to console.
;// ---------------------------------------------------------------------------------

;// YOUR CODE HERE

; ebx for value at beginning of string 
; ecx for loop counter 
; eax for end of string
; esi for beginning of string 
; edx for messages

; I opted to not use the stack for this, since the return uses the stack, and I didn't 
; want to worry about finishing evey loop, setting a "flag", or doing the stack frame dance. This allows me to do it 
; by only going over half of the string size, rather than twice over the string.
IsPalindrome proc uses ebx ecx eax esi edx

.data
  ; Palindrom status messages
	noPalindromeMessage byte " is not a palindrome.", 0
	yesPalindromeMessage byte " is a palindrome.", 0

.code
; Eax will be for string end, esi for beginning
mov ecx, eax
shr ecx, 1 ; Dividing ecx by 2 to get half string length
ClearESI ; esi as beginning string
ClearEBX ; ebx as register location for end string


L1:
  ; Value at ebx into ebx for cmp 
	mov bl, byte ptr [edx+eax-1] 
	cmp bl, byte ptr [edx+esi]
  .IF bl != byte ptr [edx+esi] ; Short circuits early if they don't match
	  jmp noPalindrome 
  .ENDIF

  ; Increment and decrement our locations
	inc esi
  dec eax

	loop L1

yesPalindrome: ; Print yesPalindromeMessage
	call WriteString
	mov edx, offset yesPalindromeMessage
	jmp IsPalindromeEnd 

noPalindrome: ; Print noPalindromeMessage
	call WriteString
	mov edx, offset noPalindromeMessage
	jmp IsPalindromeEnd 

IsPalindromeEnd:
	call WriteString ; Avoid redundant code by waiting to write string until now
  call CRLF
  call waitmsg ; Wait message to display result before returning.
	ret

IsPalindrome ENDP

END main
