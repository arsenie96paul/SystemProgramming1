; Various sub-routines that will be useful to the boot loader code	

; Output Carriage-Return/Line-Feed (CRLF) sequence to screen using BIOS

Console_Write_CRLF:
	mov 	ah, 0Eh						; Output CR
    mov 	al, 0Dh
    int 	10h
    mov 	al, 0Ah						; Output LF
    int 	10h
    ret

; Write to the console using BIOS.
; Input: SI points to a null-terminated string

Console_Write_16:
	mov 	ah, 0Eh						; BIOS call to output value in AL to screen

Console_Write_16_Repeat:
	lodsb								; Load byte at SI into AL and increment SI
    test 	al, al						; If the byte is 0, we are done
	je 		Console_Write_16_Done
	int 	10h							; Output character to screen
	jmp 	Console_Write_16_Repeat

Console_Write_16_Done:
    ret

; Adapt Console write hexadecimal to print the offsets
Console_Write_Offset:
	mov		dx, 0F000h
	mov		cl, 16
	jmp		HexLoop

;Console_Write_Hex, changed. Do not print hex numbers
Convert_Hex:
	mov		dx, 0F0h
	mov		cl, 8
	
Covert_Loop:
	sub 	cl, 4
	mov		si, dx
	and		si, bx
	shr		si, cl
	mov 	al, byte [si + HexChars]
	mov		ah, 0Eh
	shr		dx, 4
	jne		HexLoop
	ret	
	
; Using Console write hexadecimal to print the sector
Console_Write_Hex:
	mov		dx, 0F0h
	mov		cl, 8
	
HexLoop:
	sub 	cl, 4
	mov		si, dx
	and		si, bx
	shr		si, cl
	mov 	al, byte [si + HexChars]
	mov		ah, 0Eh
	int		10h
	shr		dx, 4
	jne		HexLoop
	ret

; Write ASCII Characters
Console_Write_ASCI:
	mov 	al, byte [0D000h + si]		; insert the adress
	cmp 	al, 31						; compare with 31
	jbe		Console_Write_Underscore	; jump to write underscore if is equal or less than 31
	mov 	al, byte [0D000h + si]		; if not, insert value
	mov 	ah, 0Eh
	int 	10h
	ret

; Write underscore for values less than 32 to avoid undesired commands
Console_Write_Underscore:
	mov 	al, 5Fh						; Insert underscore
	mov 	ah, 0Eh			 
	int 	10h				
	ret	

; Goes to the next line 
Console_WriteLine_Line:
	mov  	si, blank_space
	call 	Console_WriteLine_16
	ret

; Simple space 
Console_WriteLine_Space:
	mov 	si, blank_space
	call 	Console_Write_16
	ret

; Usal console writeline
Console_WriteLine_16:
	call 	Console_Write_16
	call 	Console_Write_CRLF
	ret

; Write a message for next sector
Console_Write_Next:
	call 	Console_Write_CRLF		
	mov  	si, next_sector
	call 	Console_WriteLine_16
	ret

HexChars	db '0123456789ABCDEF'	
IntBuffer	db	'     ', 0  			; piece of memory to bui
blank_space db ' ', 0					; this is just a blank space
complete1 	db ' Read successful!',0	; complete message
next_sector db ' Choose the next sector: '	; message for next sector