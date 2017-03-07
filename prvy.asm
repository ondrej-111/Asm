%include "asm_io.inc"
segment .data
char_prompt    db  "Zadaj znak: ",0
out_msg1       db  "ASCII kod znaku '",0
out_msg2       db  "' v HEX je ",0

segment .text
	global _asm_main
_asm_main:
	enter 0,0
	pusha

	mov 	EAX, char_prompt
	call 	print_string
	call	read_char
	mov 	EBX, EAX
	call 	print_nl
	
	mov 	EAX, out_msg1
	call 	print_string
	mov 	EAX, EBX
	call 	print_char
	mov 	EAX, out_msg2
	call 	print_string
	mov		EAX, EBX 
	mov     AH,AL        ; save input character in AH
	shr     AL,4         ; move upper 4 bits to lower half
	mov     ECX,2        ; loop count - 2 hex digits to print

print_digit:
	cmp     AL,9         ; if greater than 9
	jg      A_to_F       ; convert to A through F digits
	add     AL,'0'       ; otherwise, convert to 0 through 9
	jmp     skip
A_to_F:
	add     AL,'A'-10    ; subtract 10 and add 'A' to convert to A through F

skip:
	call 	print_char	 ; write the first hex digit
	mov     AL,AH        ; restore input character in AL
	and     AL,0FH       ; mask off the upper half-byte
	loop    print_digit
	
	popa				 ; terminate program
	mov	EAX, 0
	leave
	ret
