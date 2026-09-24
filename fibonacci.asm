TITLE fibonacci.asm
;// Author: Luca Pendleton
;// Created: Sept 23th 2026
INCLUDE Irvine32.inc
.data
  ;// base cases
  baseFib byte 00h, 01h

  fullFibDword label dword ;// Labal for making moving into eax easier
  fullFib byte 8 dup(?)

.code 
main PROC 
  ;// fibonacci array offset and loop counter
  mov esi, offset fullFib
  mov cl, lengthof fullFib

L1:
  ;// esi - 2 and - 1 will be in baseFib, where our base cases are
  mov bl, [esi - 2]
  add bl, [esi - 1]
  mov BYTE PTR [esi], bl

  ;// inciment esi and loop
  inc esi
  loop L1

  ;// Moving the top half of the fibonacci array (fullFib) using the label into eax
  mov eax, [fullFibDword + 4]
  call DumpRegs
  exit
main ENDP ;// end of main procedure END
END main ;// end of source codePA3
