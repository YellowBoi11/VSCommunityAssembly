Title GCD.asm

Comment @
Luca Pendlton
11/2/26
GCD 
Description: A program for testing euclids GCD algorithm in masm assembly
@


INCLUDE Irvine32.inc

ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>

GCD proto, Numerator:dword, Arg2:dword

.data
.code
main PROC

  ; Push variables to stack
  mov eax, 4000
  mov edx, 3000

  INVOKE GCD, eax, edx

  call WriteDec
  call crlf

  exit
main endp


;-------------------------
GCD PROC, Numerator:dword, Denominator:dword
; Finds the greatest common denominator of two decimal numbers
; Recieves: Two unsigned integers from INVOKE
; Returns: eax, greatest common denominator 
;-------------------------
  LOCAL NextDenominator:dword, NextNumerator:dword

  ; Order doesn't matter here
  mov eax, Numerator
  mov ebx, Denominator
  
  ; Recursive solution 
  cmp ebx, 0
  jnz GCDStart
  ret  ; Base case that returns

GCDStart:
  ClearEDX
  div ebx 

  ; Moving denominator into numerator
  mov NextNumerator, ebx 

  ; Moving the remainder into the denominator
  mov NextDenominator, edx 
  call GCD
  
  ; Returns after all lower return.
  ret

GCD ENDP
END main
