Title PrimesList.asm

Comment @
Luca Pendlton
11/2/26
PrimesList
Description: A program for printing all the prime numbers in a range
@


INCLUDE Irvine32.inc

Arg2 textequ <dword ptr [ebp + 12]>
Arg1 textequ <dword ptr [ebp + 8]>

Var2 textequ <dword ptr [ebp - 8]>
Var1 textequ <dword ptr [ebp - 4]>

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
  mov eax, -1
  push eax
  call PrimesList 
  exit 
main endp 

;-------------------------
PrimesList PROC
; Finds all the primes from 2 - a given number
; Recieves: a given number on the stack
; Returns: none, outputs primes to the screen 
;-------------------------
.data 
  primeMessage byte " is prime",0
.code 
  enter -1, 0
  mov ecx, Arg1
  dec ecx

  mov ebx, 2 ; Start

  L1:
    push ecx 
    mov Var1, 2
    mov ecx, ebx
    sub ecx, 1
  L2:

    .IF Var1 != ebx 
      ClearEDX
      mov eax, ebx 
      div Var1
      .IF edx == 0
        jmp EndL1
      .ENDIF

    .ELSEIF Var1 == ebx 
      mov edx, offset primeMessage
      mov eax, ebx
      call WriteDec
      call WriteString
      call Crlf
    .ENDIF

  
  EndL2:
    inc Var1
    loop L2
    

  EndL1:
    pop ecx
    inc ebx
    Loop L1



  leave
PrimesList ENDP
END main
