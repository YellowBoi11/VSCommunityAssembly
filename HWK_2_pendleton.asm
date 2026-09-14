TITLE HWK_2_pendleton.asm
;// Author: Luca Pendleton
;// Created: Sept 9th 2026
INCLUDE Irvine32.inc
.data
;//{ your variables are be defined here
  move textequ <mov>
  ;// pt 1
  nineFact textequ %(9 * 8 * 7 * 6 * 5 * 4 * 3 * 2) ; Calculates 9!
  LOAD_NINE textequ <mov eax, nineFact> ;// moves nineFact into eax. 9! needs > 16 bit so eax rather than ax
  ;// pt 2
  unsignedInt dword 0FFFFFFFFh
  signedInt sdword 7FFFFFFFh ;// set to seven to switch the sign upon addition
  ;// pt 3
  calculatedSecondsInDay textequ %(60 * 60 * 24) ;// calcuate seconds in day from 60s * 60m * 24h
  SECONDS_IN_DAY textequ <mov edx, calculatedSecondsInDay> ;// moves secods in day to edx
  ;// pt 4 
  A word 123d 
  B word 01101001b
  otherC word 0AF5h ; this means we must eventually load into ax as this is 12 bits
  D word 85d

.code 
main PROC 
  ;//{executable code here} call DumpRegs 
  ;// you may use this line of code as necessary to show the contents of the
  ;// registers and flags.
  ;// Part 1
  mov eax, 0
  LOAD_NINE ;// evaluates to 58980h
  call DumpRegs ;// Check hex and cf and of here
  
  ;// Part 2 
  ;// Zeroing out registers
  mov ebx, 0
  mov ecx, 0

  ;// Causing the unsigned int to carry out. 
  ;// Adding 2 to make it more understandable when reading the register
  mov ebx, unsignedInt
  add ebx, 2 ;// evaluates to 1h and should set cf
  call DumpRegs

  ;// Causing the signed into to flip the final bit from 0 to 1
  mov ecx, signedInt 
  add ecx, 2 ;// evaluates to 80000001h and should set of
  call DumpRegs

  ;// Part 3 
  mov edx, 0
  SECONDS_IN_DAY
  call DumpRegs

  ;// Part 4
  mov eax, 0

  ;// A - B
  mov ax, A 
  sub ax, B
  mov A, ax
  ;// C - D
  mov ax, otherC 
  sub ax, D
  ;// (A - B) + (C - D)
  add ax, A
  call DumpRegs
  call WriteInt
  
  exit
main ENDP ;// end of main procedure END
END main ;// end of source code
