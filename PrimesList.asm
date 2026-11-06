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

PrimesList PROTO, primeArray:ptr byte, upperBound:dword


.data
  bitArr byte 625 dup(0) ; 10000 / 2 = 5000 (only odd numbers) 5000 / 8 = 625 (bytes)
.code
main PROC
  mov eax, 10000
  Invoke PrimesList, addr bitArr, eax
  exit 
main endp 

;-------------------------
PrimesList PROC, primeArray:ptr byte, upperBound:dword
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
; LOCAL Var1:dword
.data 
  primeMessage byte " is prime",0
.code 
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
    push ecx ; Pushed because ecx must be used for rotate instructions
    mov ebx, 8
    div ebx
    dec edx ; Decrement remainder

    ; Find the location in the bitmask
    movzx ebx, byte ptr [esi + eax]
    mov ecx, edx
    ror ebx, cl  ; move the bit representing the current number as the lsb
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

    ; Prep for checking proper multiples
    mov ebx, currentLocation
  PrimeInnerLoop:

    ; Next proper multiple
    add eax, currentLocation
    cmp eax, upperBound
    jge PrimeOuterLoopEnd ; Short circuit if greater than upperBound
    mov multLocation, eax

    ; Check if even
    test eax, 1
    jp incrementBypass ; Skip the bitmask if even

    shr eax, 1 ; divide by 2 

    ; Get the byte and location
    ClearEDX
    mov ebx, 8
    div ebx
    dec edx ; decreemnt remainer

    ; Set the bit to 1
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
    
  PrimeOuterLoopEnd:
    pop ecx

    ; Increment to the next number in the sequence
    mov eax, currentLocation 
    add eax, 2 
    mov currentLocation, eax 

    ; Manual ecx check because this PROC is too large for conditional jumps
    dec ecx
    cmp ecx, 0
    jz PrimeLoopEnd 
    jmp PrimeOuterLoop

  PrimeLoopEnd:
    ret
PrimesList ENDP
END main
