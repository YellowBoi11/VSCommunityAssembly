
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


GCD PROTO, Numerator:word, Denominator:word
FindPrimes PROTO, primeArray:ptr byte, upperBound:dword

.data
menuPrompt byte 'MAIN MENU', 0Ah, 0Dh,
'--------------', 0Ah, 0Dh,
'1. Find all prime numbers between 2 and n (max of 10000):', 0Ah, 0Dh,
'2. Find the GCD of two numbers: ', 0Ah, 0Dh,
'3. Exit: ', 0Ah, 0Dh, 0h

GCDinfo byte "Number #1", 9h, "Number #2", 9h, "GCD", 09h, "GCD Prime?", 0Ah, 0Dh,
'---------------------------------------------------', 0Ah, 0Dh, 0

; This needs to be global so other prodedures can access it (sucks)
bitArr byte 625 dup(0) ; 10000 / 2 = 5000 (only odd numbers) 5000 / 8 = 625 (bytes)

errormessage byte 'Invalid menu selection. Please try again.', 0Ah, 0Dh, 0h
userSelection word 0h
userSecondSelection word 0h
.code 

main PROC

menustart:
  call clrscr
  mov edx, offset menuPrompt
  call WriteString
  call GetInt
  mov userSelection, ax

opt1:
  cmp userSelection, 1
  jne opt2
  call GetInt

opt2:
  cmp userSelection, 2 
  jne opt3 
  call GetInt
  mov userSelection, ax
  call GetInt
  mov userSecondSelection, ax

  ; Outputting the menu for into before calling the function
  mov edx, offset GCDinfo 
  call WriteString
  movzx eax, userSelection
  call WriteDec
  mov eax, 9h
  call WriteChar
  call WriteChar
  movzx eax, userSecondSelection
  call WriteDec
  mov eax, 9h
  call WriteChar
  call WriteChar

  ; GCD call
  INVOKE GCD, userSelection, userSecondSelection
  call waitmsg
  jmp menustart

opt3:
  cmp userSelection, 3 
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
;// ---------------------------------------------------------------------------------
;// GetInt
;// Description:	Prompts the user for an unsigned integer and stores it in EAX
;// Receives:		Nothing
;// Returns:		user input integer in EAX
;// Requires:		Nothing
;// Info: Recycled code from PA5. 
;// ---------------------------------------------------------------------------------
GetInt PROC USES edx
.data
promptInt BYTE "Input an integer between 2-10000: ", 0ah, 0dh, 0h
promptInvalid BYTE "Invalid Input", 0ah, 0dh, 0h

.code
start:
mov edx, OFFSET promptInt
call WriteString
call ReadInt
call clrscr


cmp eax, 10000
jg InvalidInput ; Jump invalid if greater than 10000
cmp eax, 2 
jnl validInput ; jump over if not less than two


; fallthrough or jump
InvalidInput:
mov edx, OFFSET promptInvalid
call WriteString
jmp start

validInput:
ret

GetInt endp

GCD PROC, Numerator:word, Denominator:word
; Finds the greatest common denominator of two decimal numbers
; Recieves: Two unsigned integers from INVOKE
; Returns: eax, greatest common denominator 
;-------------------------
LOCAL NextDenominator:word, NextNumerator:word

.data 

yes byte "Yes", 0Ah, 0Dh, 0
no byte "No", 0Ah, 0Dh, 0

.code
  ClearEAX
  ClearEBX

  ; Order doesn't matter here
  mov ax, Numerator
  mov bx, Denominator
  
  ; Recursive solution 
  cmp ebx, 0
  jnz GCDStart

  ; Output succes message
  call WriteDec
  mov eax, 9h
  call WriteChar
  movzx eax, Numerator

  ; Make sure it's not even
  ror eax,1 
  pushfd
  rol eax, 1
  jnc GCDNotPrime

  cmp eax, 2 
  jng GCDPrime ; If less than 2
  inc Numerator
  INVOKE FindPrimes, addr bitArr, Numerator
  dec Numerator

  ; Find the prime of said GCD 
  ClearEDX
  mov esi, offset bitArr
  mov ax, Numerator
  mov ebx, 8
  shr eax, 1
  dec eax
  div ebx
  mov ecx, edx
  inc ecx
  movzx ebx, byte ptr [esi + eax]
  ror ebx, cl 
  pushfd
  rol ebx, cl 
  popfd
  jc GCDNotPrime

GCDPrime:
  mov edx, offset yes
  jmp GCDBaseCaseEnd
  
GCDNotPrime:
  mov edx, offset no

GCDBaseCaseEnd:
  call WriteString
  ret  ; Base case that returns

GCDStart:
  ClearEDX
  div ebx 

  ; Moving denominator into numerator
  mov NextNumerator, bx

  ; Moving the remainder into the denominator
  mov NextDenominator, dx 
  INVOKE GCD, NextNumerator, NextDenominator
  
  ; Returns after all lower return.
  ret

GCD ENDP

;-------------------------
FindPrimes PROC, primeArray:ptr byte, upperBound:dword
; Finds all the primes from 3 - a given number
; Recieves: an upperBound number on the stack, an (limit/2)/8 byte array of zeros offset on the stack
; Returns: nothing, outputs primes to the screen 
; INFO: Each number from 3 up to 10000 has it's own bit. This bit is found by dividing
; the current number by 2 (eliminating evens), dividing by 8 (eax holds the byte), 
; and rotating right by edx - 1 (remainder holds the bit location). this allows our 
; memory space to be 1/16 what it would be if each number had it's own byte, and 
; even numbers were checked. I know there are further optimizations that can be made 
; through segmentation, but this was enough for me. I can't even do LOOP because the 
; procedure is too large.
;-------------------------

LOCAL currentLocation:dword, multLocation:dword

.code 
  mov esi, primeArray
  mov currentLocation, 3 ; Initial start location
  mov ecx, upperBound
  sub ecx, 1
  shr ecx, 1 ; Divide by two since all bits are odd numbers

  PrimeOuterLoop:
    ; Get current number
    mov eax, currentLocation
    shr eax, 1 ; Divide by 2 

    ; Divide by 8 and find remainder and result for shift position and array position
    ClearEDX
    push ecx ; Pushed because ecx must be used for rotate instructions
    mov ebx, 8
    dec eax ; Decrement so 3 -> 0, 5 -> 1, 7 -> 2, etc
    div ebx

    ; Find the location in the bitmask
    movzx ebx, byte ptr [esi + eax]
    mov ecx, edx
    ror ebx, cl  ; move the bit representing the current number as the lsb
    test ebx, 1 ; Check if the bit is one
    pushfd 
    rol ebx, cl ; repair the current number
    popfd
    jnz PrimeOuterLoopEnd ; Skip if is one
    
    ; Print 
    mov eax, currentLocation
    ; call WriteDec 
    ; call Crlf
  ; Checking proper multiples
  PrimeInnerLoop:
    ; Next proper multiple
    add eax, currentLocation
    cmp eax, upperBound
    jg PrimeOuterLoopEnd ; Short circuit if greater than upperBound
    mov multLocation, eax

    ; Check if even
    test eax, 1
    jp incrementBypass ; Skip the bitmask if even

    shr eax, 1 ; divide by 2 

    ; Get the byte and location
    ClearEDX
    mov ebx, 8
    dec eax ; Decrement so 3 -> 0, 5 -> 1, 7 -> 2, etc
    div ebx

    ; Move the mask and edit it's apropriate location
    movzx ebx, byte ptr [esi + eax]
    mov ecx, edx
    ror ebx, cl
    or ebx, 00000001h
    rol ebx, cl
    mov byte ptr [esi + eax], bl ; move the mask back into the array

  incrementBypass:
    ; Move  the multLocation back into eax
    mov eax, multLocation
    jmp PrimeInnerLoop
  
  ; Move to the next number
  PrimeOuterLoopEnd:
    pop ecx

    ; Increment to the next number in the sequence
    mov eax, currentLocation 
    add eax, 2 
    mov currentLocation, eax 
    mov multLocation, 0

    ; Manual ecx check because this PROC is too large for conditional jumps
    dec ecx
    cmp ecx, 0
    jz PrimeLoopEnd 
    jmp PrimeOuterLoop

  PrimeLoopEnd:
    ret
FindPrimes ENDP

END main
