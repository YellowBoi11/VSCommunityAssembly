TITLE PA4.asm

INCLUDE Irvine32.inc 

move textequ <mov>

.data 
  ; Storage for the randomly generated string
  workingString byte 36 DUP(0)
  ; Size of the working string
  workingStringSize = ($ - workingString) - 1
  ; Unknown size of the string 
  StringLen byte ?

.code 

; Beginning of main
main PROC

  mov edx, offset workingString ; Store the offset of the workingString
  mov ebx, workingStringSize
  call Userinput ; Ask for user integer input
  mov ecx, eax ; move that input into ecx

L1:
  push ecx ; ecx is returned by some calls, so pushing to the stack makes sense
  call HowMany
  call GenerateString
  call WriteString
  call Crlf
  call zeroString
  pop ecx
  loop L1


exit
main ENDP
; End of main 


; -------------------------------------------------------------------------------------
Userinput PROC USES edx
; A function that asks the user for an unsigned integer input
; REQUIRES: none
; RETURNS: EAX = The unsigned integer input
; USES: EDX = The offset of the prompt string
; -------------------------------------------------------------------------------------
  .data 
    promptString byte "Please input an unsigned int: ",0
  
  .code 
    mov edx, offset promptString ; Prepairation for WriteString
  
    call WriteString
    call ReadDec ; Reads a 32 bit integer from the keyboard
    ret 

Userinput ENDP

; -------------------------------------------------------------------------------------
HowMany PROC USES eax
; Generates a random nubmer between 10 and 35
; REQUIRES: none 
; RETURNS: ECX = The randomly generated string size
; USES: EAX = the size of the randomly generated number
; -------------------------------------------------------------------------------------
  .data ; No data required
  .code 
    ; Delay the code for 1ms so that way randomize changes the seed every time
    ; The seed is based on system time and this program can execute so fast 
    ; nothing is actually randomized
    mov eax, 1
    call Delay 

    mov eax, 26 ; Sets the randomly generated upper bound exclusive

    ; Setting the seed and calling RandomRange
    call Randomize
    call RandomRange

    add eax, 10 ; Adds ten for the lower bound of ten. Range is 10 - 35
    mov ecx, eax ; Moves the randomly generated value into ecx 
    ret

HowMany ENDP

; -------------------------------------------------------------------------------------
GenerateString PROC USES edx
; Generates a string at a fixed length
; REQUIRES: ECX = Length of the string in bytes
; ESI: The offset of the string you want to generate
; RETURNS: EDX = Offset of the returned string 
; USES: none
; -------------------------------------------------------------------------------------
  .code 
  L:
    call GenerateCapital
    mov byte ptr [edx], al 
    inc edx
    loop L
    ret

GenerateString ENDP

; -------------------------------------------------------------------------------------
GenerateCapital PROC USES ecx
; Generates a random capital letter. Uses HowMany as base and adds (the range of  
; capital letters in ASCII is 25)
; REQUIRES: none 
; RETURNS: EAX = the ASCII value of the character
; USES: ECX = The return of How Many
; -------------------------------------------------------------------------------------
  .data ; no data required
  .code 
    ; Moving 55 into eax. Uses full register to not work with upper portions
    mov eax, 55
    call HowMany ; Generate number between 10 and 35
    add eax, ecx  ; add 55 to get a number between 65 and 90
    ret 

GenerateCapital ENDP

; -------------------------------------------------------------------------------------
zeroString PROC uses edx ecx
; Iterates over a string until it reaches a null terminator strings MUST be terminated
; REQUIRES: EDX = offset of string 
; USES: ECX = The max number of iterations (Set to a conservative 265 here)
; -------------------------------------------------------------------------------------

  .data ; no data required 
  .code 
    mov ecx, 256
  L:
    mov byte ptr [edx], 0
    inc edx 
    cmp byte ptr [edx], 0
    je ZeroEnd
    loop L 

  ZeroEnd:
    ret

zeroString ENDP
END main
