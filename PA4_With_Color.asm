TITLE PA4_With_Color.asm

INCLUDE Irvine32.inc 

move textequ <mov>

.data 
  ; Storage for the randomly generated string
  workingString byte 36 DUP(0)
  ; Size of the working string
  workingStringSize = ($ - workingString) - 1

.code 

; Beginning of main
main PROC

  mov edx, offset workingString ; Store the offset of the workingString
  mov ebx, workingStringSize
  call Userinput ; Ask for user integer input
  mov ecx, eax ; move that input into ecx

  ; Setting the seed for Randomization
  call Randomize

; Loops the amount of times user declares in User input.
L1:
  call StringColor ; Randomizes the foreground and background color of the next string
  push ecx ; ecx is returned by some calls, so pushing to the stack makes sense
  call HowMany ; generates the length of the string in ecx
  call GenerateString ; consumes ecx to generate a string

  ; Writes the string to the screen and sets it to 0 so new strings don't overlap
  call WriteString 
  call Crlf

  call ClrString

  ; Pops the loop number back and loops
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
    mov eax, 26 ; Sets the randomly generated upper bound exclusive

    call RandomRange ; Generates the random number between 0 and 25

    add eax, 10 ; Adds ten for the lower bound of ten. Range is 10 - 35
    mov ecx, eax ; Moves the randomly generated value into ecx 
    ret

HowMany ENDP

; -------------------------------------------------------------------------------------
GenerateString PROC USES ebx
; Generates a string at a fixed length
; REQUIRES: ECX = Length of the string in bytes
; ESI: The offset of the string you want to generate
; RETURNS: EDX = Offset of the returned string 
; USES: EBX = indexed addressing index
; -------------------------------------------------------------------------------------
  .code 
    mov ebx, 0
  L:
    call GenerateCapital
    mov byte ptr [edx + ebx], al 
    inc ebx
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
ClrString PROC uses ebx ecx
; Iterates over a string until it reaches a null terminator strings MUST be terminated
; REQUIRES: EDX = offset of string 
; USES: ECX = The max number of iterations (Set to a conservative 265 here)
; EBX = offset for indexed addressing
; -------------------------------------------------------------------------------------

  .data ; no data required 
  .code 
    mov ecx, 256 ; Maximum string size user can input
    mov ebx, 0
  ClrLoop:
    ; check if the value is already null, end the procedure if so
    cmp byte ptr [edx + ebx], 0
    je ClrEnd

    ; Set the value at edx to null
    mov byte ptr [edx + ebx], 0
    inc ebx 
    loop ClrLoop 

  ClrEnd:
    ret

ClrString ENDP

; -------------------------------------------------------------------------------------
StringColor PROC uses eax
; Generates a random forground and background color (that isn't black)
; RECIEVES: none
; RETURNS: none 
; USES: EAX = the lower nibble of al is used to generate and set the color
; -------------------------------------------------------------------------------------
.data 
.code 
  mov al, 255 ; Upper bound of the colors
  call RandomRange 
  inc al ; Incremented so color does not include black on black 00h as the lower nibble of al

  call SetTextColor 
  ret 

StringColor ENDP
END main ; End of PA4 Extra credit
