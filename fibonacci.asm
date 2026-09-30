TITLE fibonacci.asm
;// Author: Luca Pendleton
;// Created: Sept 23th 2026
INCLUDE Irvine32.inc
.data
  ;// base cases
  baseFib byte 00h, 01h

  ;// fibonacci array
  fullFibDword label dword ;// Labal for making moving into ebx easier
  fullFib byte 8 dup(?)

.code 
main PROC 
  ;// fibonacci array offset and loop counter
  mov esi, offset fullFib
  mov cl, lengthof fullFib

L1:
  ;// esi - 2 and - 1 will be in baseFib, where our base cases are when the loop is beginning
  mov al, [esi - 2]
  add al, [esi - 1]
  mov BYTE PTR [esi], al

  ;// inciment esi and loop
  inc esi
  loop L1

  ;// Moving the 4->7 bytes of the fibonacci array (fullFib) using the label into ebx
  mov ebx, [fullFibDword + 3]
  call DumpRegs
  exit
main ENDP ;// end of main procedure END
END main ;// end of source codePA3
