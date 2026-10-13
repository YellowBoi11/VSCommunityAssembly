TITLE String Reversial

; This program reverses a string

INCLUDE Irvine32.inc 
move textequ <mov>

.data 
string byte "Abraham Lincoln", 13, 10, 0
stringSize = ($ - string) - 1

.code 
main PROC
  ; Preparing WriteString by moving string offset into edx
  mov edx, offset string
  call WriteString

  ; Setting counter to string size and indirect offset to 0
  mov ecx, stringSize ; 
  mov esi, 0

; Loops over the string, pushes it onto the stack
L1:
  movzx eax, string[esi]
  push eax 
  inc esi 
  loop L1 

  call WriteStack

  mov ecx, stringSize 
  mov esi, 0

; Loops over the string, and inserts the poped value from the stack
L2:
  pop eax 
  mov string[esi], al 
  inc esi 
  loop L2 

  call WriteString
main ENDP
END main
