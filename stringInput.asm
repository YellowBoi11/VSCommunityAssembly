TITLE Read a string

INCLUDE Irvine32.inc 

.data 
string byte "Placeholder string", 80 dup(0)
.code 
main PROC
  mov edx, offset string
  mov ecx, sizeof string - 1
  call GetUserString
  call WriteString
  call Crlf

exit
main ENDP

; ---------------------
GetUserString PROC
; Requires: EDX = the offset of the string you want to write to 
; ECX = Size in bytes of the string 
; Returns: EDX = The offset of the newly written string from user 
; ---------------------
.data 
fileName byte "Input your string: ",0

.code 
  push edx 
  mov edx, offset fileName 

  call WriteString

  pop edx
  call ReadString 
  ret

GetuserString ENDP
END main
