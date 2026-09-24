
TITLE reorder.asm
;// Author: Luca Pendleton
;// Created: Sept 23th 2026
INCLUDE Irvine32.inc
.data
  MyArray word 5676h, 2132h, 4798h ;// result should be 2132h, 4798h, 5676h
  MyArrayLen = ($ - MyArray)/2

.code 
main PROC 
  ;// Setup for DumpMem
  mov esi, offset MyArray
  mov ecx, MyArrayLen 
  mov ebx, type MyArray

  ;// Exchange MyArray and MyArray + 2
  mov ax, [MyArray + 2]
  xchg ax, MyArray
  mov [MyArray + 2], ax

  ;// Exchange MyArray + 2 and MyArray + 4
  xchg [MyArray + 4], ax
  mov [MyArray + 2], ax

  call DumpMem
  exit
main ENDP ;// end of main procedure END
END main ;// end of source code PA3
