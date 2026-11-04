Title GCD.asm

Comment @
Luca Pendlton
11/2/26
GCD 
Description: A program for testing euclids GCD algorithm in masm assembly
@


INCLUDE Irvine32.inc

Arg2 textequ <dword ptr [ebp + 12]>
Arg1 textequ <dword ptr [ebp + 8]>

ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
maxLength = 51d


.data
.code
main PROC

  ; Push variables to stack
  mov eax, 35
  mov edx, 21
  push eax
  push edx 

  call GCD
  call WriteDec
  call crlf

  exit
main endp


;-------------------------
GCD PROC
; Finds the greatest common denominator of two decimal numbers
; Recieves: Two unsigned integers in the stack
; Returns: eax, greatest common denominator 
;-------------------------
  enter 8, 0

  ; Order doesn't matter here
  mov eax, Arg1
  mov ebx, Arg2
  
  ; Recursive solution 
  .IF ebx <= 0
    leave 
    ret 
  .ENDIF

  ClearEDX
  div ebx 

  ; Moving denominator into numerator
  mov dword ptr [ebp - 8], ebx 

  ; Moving the remainder into the denominator
  mov dword ptr [ebp - 4], edx 
  call GCD

  ; Iterative Solution
  ; .WHILE ebx > 0

  ;   ; Make sure edx is zero
  ;   ClearEDX
  ;   div ebx

  ;   ; Move the denominator into the numerator
  ;   mov eax, ebx

  ;   ; Move the remainder into the demoniator
  ;   mov ebx, edx

  ; .ENDW

  leave
  ret

GCD ENDP
END main
