TITLE TestingProgramControl.asm 

INCLUDE Irvine32.inc 

.data
.code 

mov eax, 10
mov ebx, 15
main PROC

.IF eax < ebx 
  call WriteDec

.ELSE 
  mov eax, ebx 
  call WriteDec 

.ENDIF
main ENDP
END main
