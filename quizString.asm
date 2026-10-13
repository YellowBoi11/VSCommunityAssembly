TITLE classString.asm

INCLUDE Irvine32.inc 

.data 
  inputString byte 26 DUP(0) ; User input string
  inputStringLen byte ? ; The length of the string calculated by LenUserString
  decimalLoc sbyte ? ; The number the user puts in for the decimal location
.code
main PROC

Beginning:
  call Crlf
  mov esi, 0 ; Moving zero into esi
  mov edx, offset inputString ; Offset of the input string for UserString
  mov ecx, sizeof inputString 
  dec ecx ; Setting the size of the input to 25 char without using more .data

  call UserString ; Get the user number
  call LenUserString ; Get the length of the user number
  mov inputStringLen, al ; move the output to al

  call UserDecimal ; Get user decimal
  mov decimalLoc, al ; mov it to demical Loc

  movzx ecx, inputStringLen ; Loop initialization

  ; Jump to negativePeriod (the output if decimalLoc is negative)
  cmp decimalLoc, 0
  jl NegativePeriod

; Beginning of loop
LoopBegin:
  ; Write each character in the string
  mov al, inputString[esi]
  call WriteChar
  inc esi

  ; compare the curernt location to the decimal location
  mov ebx, esi
  cmp decimalLoc, bl
  je PrintPeriod ; print a period if the location is equal to decimalLoc

LoopEnd:
  loop LoopBegin

  ; Jump to positive Period if decimalLoc is greater than inputStringLen
  mov bl, inputStringLen 
  cmp decimalLoc, bl
  jg PositivePeriod

  ; Jump to the end of the program
  jmp ProgramEnd

  ; end the loop if the decimalLoc equals the string end
PrintPeriod:  
  mov bl, inputStringLen
  cmp decimalLoc, bl
  je ProgramEnd

  ; Print the period
  mov al, '.'
  call WriteChar
  jmp LoopEnd

NegativePeriod:
  ; Print the number of negative periods
  mov al, decimalLoc
  call PrintNegPeriod

  ; Jump to the beginning of the loop
  jmp LoopBegin

PositivePeriod:
  ; calculate the number of zeros needed at the end
  mov al, decimalLoc 
  sub al, inputStringLen 
  call PrintPosPeriod

ProgramEnd: 
  ; Prompt the user to continue
  call endPrompt
  cmp al, 'y'
  je Restart
  exit ; Ends if not continued

Restart:
  ; Zero out the inputString
  mov cl, InputStringLen 
  mov edx, offset InputString
  call zeroString

  ; Jump to the start of main
  jmp Beginning

main ENDP

; ---------------------------
UserString PROC USES edx ecx
; Gets a 25 char max string from the user
; REQUIRES: EDX = String offset 
; ECX = String Size
; RETURNS: Nothing
; ---------------------------
.data 
  promptString byte "Input your 25 char string: ", 0
.code
  
  ; Prompt user for their string
  push edx 
  mov edx, offset promptString 
  call WriteString

  ; Read the user string
  pop edx
  call ReadString
  ret

UserString ENDP

; ---------------------------
LenUserString PROC USES edx ebx
; Gets the length of a user string 
; REQUIRES: EDX = the offset of a string 
; ECX = the max length of a string
; RETURNS: EAX = length of user string
; ---------------------------
.data 
.code 
  ; Set eax to zero
  mov eax, 0
LenLoop:
  ; Ends the loop if a null terminator is found
  cmp byte ptr [edx], 0
  jz LenLoopEnd

  ; Increments the eax and edx value if not
  inc eax 
  inc edx
  loop LenLoop

LenLoopEnd: 
  ret

LenUserString ENDP

; ---------------------------
UserDecimal PROC uses edx
; Gets the decimal location for this program
; REQUIRES: EAX = Decimal Number
; RETURNS: EAX = Decimal location
; ---------------------------

.data 
  promptDec byte "Input the decimal location: ", 0
.code 
  ; Prompt user for decimal location
  mov edx, offset promptDec 
  call WriteString 

  ; Read that location into eax
  call ReadInt
  ret

UserDecimal ENDP

; ---------------------------
PrintNegPeriod PROC USES eax ecx
; Prints out the decimal if decimalLoc is negative
; REQUIRES: EAX = decimal location
; RETURNS: None
; ---------------------------
.data 
.code 
  ; move ecx into eax and swap the sign and decremt it for the number of zeros
  mov ecx, eax
  neg ecx
  dec ecx

  ; Print "0." to the screen
  mov al, '0'
  call WriteChar
  mov al, '.'
  call WriteChar

  ; End the loop if eax is zero
  cmp ecx, 0
  je EndNegDec

  ; Set the print char to '0'
  mov al, "0"

  
NegativeLoop:
  ; Write the char ecx times
  call WriteChar 
  loop NegativeLoop

EndNegDec:
  ret

PrintNegPeriod ENDP

; ---------------------------
PrintPosPeriod PROC uses eax ecx
; Prints out the decimal if decamalLoc is greater than inputStringLength
; REQUIRES: EAX = difference of inputStringLength and decimalLoc 
; RETURNS: none
; ---------------------------

.data ; no data required 
.code 
  ; Move eax into ecx
  mov ecx, eax 
  dec ecx

  ; If ecx is zero, skip printing zeros
  cmp ecx, 0
  je EndPrintPosPeriod

PrintPosPeriodLoop:
  ; Pint zero ecx times
  mov al, '0'
  call WriteChar 
  loop PrintPosPeriodLoop


EndPrintPosPeriod:
  ; print ".0" to the screen
  mov al, '.'
  call WriteChar 
  mov al, '0'
  call WriteChar

  ret 

PrintPosPeriod ENDP 

; ----------------------------
endPrompt PROC uses edx
; Prompts the user for yes or no
; REQUIRES: none 
; Returns: AL = char 
; ----------------------------
.data 
  continueString byte "Continue [y/n]? ",0
.code
  ; Ask the user if they'd like to continue
  mov edx, offset continueString
  call Crlf
  call WriteString 

  ; Returns al for comparison
  call ReadChar
  ret

endPrompt ENDP 

; ----------------------------
zeroString PROC USES edx ecx
; Zeros out a string 
; REQUIRES: EDX = Offset of string 
; ECX = String length 
; ----------------------------

.data ; no data requried 
.code 

ZeroStringLoop:
  ; Set the character at edx to null terminator
  mov byte ptr [edx], 0
  inc edx ; inc edx
  loop ZeroStringLoop

  ret 
zeroString ENDP
END main
