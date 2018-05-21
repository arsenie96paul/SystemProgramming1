;This file contain the read key methods

; Messages befor to start the second half of the sector
Second_Half:
	call 	Console_WriteLine_Line		; goes to the next line	
	mov 	si, start_message			; insert the text in si
	call 	Console_WriteLine_16		; Display the message ("press any key")	

; Start writting second half by pressing any key
Keyboard_Reading:	
	mov 	ah, 00h
	int 	16h							; if press, continue
	jmp 	Line_loop					; Continue looping
	
; Simple continue if u press a key (no jumps)
Simple_key_Read:	
	mov 	ah, 00h
	int 	16h							; if press, continue
	ret					