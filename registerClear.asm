TITLE registerClear.asm 

; Clears your registers

INCLUDE Irvine32.inc 

; Macros for clearing registers
ClearEax TEXTEQU <mov eax, 0>
ClearEbx TEXTEQU <mov ebx, 0>
ClearEcx TEXTEQU <mov ecx, 0>
ClearEcx TEXTEQU <mov edx, 0>

; Start of main 
.data 
.code
main PROC
  
  call ClearRegisters
  call DumpRegs

exit
main ENDP

; -------------------------
ClearRegisters PROC
; Clears your eax, ebx, ecx, and edx registers
; Recieves: an eax, ebx, ecx, and edx you don't mind losing the values in
; Returns: An empty eax, ebx, ecx, and edx 
; -------------------------
.data 
.code 
  call DumpRegs
  ClearEax
  ClearEbx  
  ClearEcx
  ClearEcx

ClearRegisters ENDP
END main
