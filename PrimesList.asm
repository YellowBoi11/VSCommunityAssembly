Title PrimesList.asm

Comment @
Luca Pendlton
11/2/26
PrimesList
Description: A program for printing all the prime numbers in a range
@


INCLUDE Irvine32.inc


ClearEAX textequ <mov eax, 0>
ClearEBX textequ <mov ebx, 0>
ClearECX textequ <mov ecx, 0>
ClearEDX textequ <mov edx, 0>
ClearESI textequ <mov esi, 0>
ClearEDI textequ <mov edi, 0>
maxLength = 10000d

PrimesList PROTO, Arg1:ptr byte, Arg2:dword


.data
  bitArr byte 800 dup(0)
.code
main PROC
  mov eax, 10000
  Invoke PrimesList, addr bitArr, eax
  exit 
main endp 

;-------------------------
PrimesList PROC, primeArray:dword, upperBound:dword
; Finds all the primes from 2 - a given number
; Recieves: a given number on the stack, a 625 byte array offset on the stack
; Returns: none, outputs primes to the screen 
;-------------------------

LOCAL currentLocation:ptr byte, multLocation:dword
; LOCAL Var1:dword
.data 
  primeMessage byte " is prime",0
.code 
;   mov ecx, Arg1
;   dec ecx
; 
;   mov ebx, 2 ; Start
; 
;   L1:
;     push ecx 
;     mov Var1, 2
;     mov ecx, ebx
;     sub ecx, 1
;   L2:
; 
;     .IF Var1 != ebx 
;       ClearEDX
;       mov eax, ebx 
;       div Var1
;       .IF edx == 0
;         jmp EndL1
;       .ENDIF
; 
;     .ELSEIF Var1 == ebx 
;       mov edx, offset primeMessage
;       mov eax, ebx
;       call WriteDec
;       call WriteString
;       call Crlf
;     .ENDIF
; 
;   
;   EndL2:
;     inc Var1
;     loop L2
;     
; 
;   EndL1:
;     pop ecx
;     inc ebx
;     Loop L1

  mov esi, primeArray
  mov currentLocation, 3 ; Initial start location
  mov ecx, upperBound
  sub ecx, 2
  ror ecx, 1 ; Divide by two since all bits are odd numbers

  PrimeOuterLoop::
    ; Get current number
    mov eax, currentLocation
    shr eax, 1 ; Divide by 2 

    ; Divide by 8 and find remainder and result for shift position and array position
    ClearEDX
    push ecx
    mov ebx, 8
    div ebx
    dec edx ; Decrement remainder
    movzx ebx, byte ptr [esi + eax]
    mov ecx, edx
    ror ebx, cl  ; move the bit representing the current number in
    test ebx, 1 ; Check if the bit is one
    pushfd 
    rol ebx, cl ; repair the current number
    popfd
    jnz PrimeOuterLoopEnd ; Skip if is one
    
    ; Print the prime message
    mov edx, offset primeMessage
    mov eax, currentLocation
    call WriteDec 
    call WriteString 
    call Crlf 

    mov ebx, currentLocation
  PrimeInnerLoop:
    ; Current value x current value 
    ClearEDX
    add eax, currentLocation
    mov multLocation, eax
    ror eax, 1
    pushfd
    rol eax, 1
    popfd
    jnc incrementBypass ; Skip if even

    shr eax, 1 ; divide by 2 

    ClearEDX
    mov ebx, 8
    div ebx
    dec edx ; decreemnt remainer

    ; Set the bit proper
    movzx ebx, byte ptr [esi + eax]
    mov ecx, edx
    ror ebx, cl
    or ebx, 00000001h
    rol ebx, cl
    mov byte ptr [esi + eax], bl

incrementBypass:
    mov eax, multLocation
    cmp eax, upperBound
    jl PrimeInnerLoop
    
  PrimeOuterLoopEnd:
    pop ecx
    mov eax, currentLocation 
    add eax, 2 
    mov currentLocation, eax 
    dec ecx
    cmp ecx, 0
    jz PrimeLoopEnd
    jmp PrimeOuterLoop

  PrimeLoopEnd:
    ret
PrimesList ENDP
END main
