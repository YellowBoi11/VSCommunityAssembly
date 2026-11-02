title testingMultiplicationWithShift.asm 

INCLUDE Irvine32.inc 

.data 
.code 
main PROC
  mov ecx, 32 
  mov ebx, 1
  mov edx, 0

L1:
  inc edx
  ror eax, 1
  jc mult
  loop L1

mult:
  shl :
main ENDP

END main
