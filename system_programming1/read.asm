;This file contain the sequences of method, in order to read the first half of the sector

; Message for next sector and wait for a key to be pressed
Next_Sector:
	call Console_Write_Next

; Initialize everything for reading the sector
Start_Sector_Read:
	call 	Simple_key_Read					; take an input
	movsx 	bx,al							; move its ASCII code in bx
	call	Convert_Hex						; convert to hex
	mov 	ax, si							; move the hex value in ax (Sector to start)
	mov 	cx, 1							; number of sectors to read
	mov 	bx, 0D000h						; buffer to read to
	call 	ReadSectors
	mov 	di, 512							; set di to 512 (for each character)
	mov		bx,0							; set dx 0 for the offset
	push	bx								; save dx	 
	
;Start the loop 
Line_loop:
	mov 	bp, 16							; set bp to 16 (16 characters per line as I decide to use bp as a counter)
	call 	Console_WriteLine_Line			; goes to the next line	
	
	pop 	bx								; bring back the bx for offset
	call 	Console_Write_Offset			; writte the offset
	add 	bx, 16							; increment bx by 16 (next hex character)
	push 	bx								; save bx
	call 	Sector_loop						; call the next loop
	 	
	cmp 	bp, 0							; if end line
	call 	ASCII_START						; write ascii

	cmp 	di, 256							; if di = 256 (middle of sector)
	je 		Second_Half						; Press key for second half	(disk.asm)	
	test 	di, di							; test if di is 0
	jnz 	Line_loop						; do it again untill di = 0	
	pop     bx								; bring back bx to mantain the stack
	
	cmp 	di, 0							; check if is the end of the sector
	je      Next_Sector						; jump to the next sector
	ret						

;Second loop
Sector_loop:
	mov 	si, 512							; si should be every time 512 (512 -512 = 0), from the begining of the sector to the end
	sub 	si, di							; difference will result and increasing of si from 0 to 512 
	mov 	bx, [0D000h +si]				; writte in the adress		
	call 	Console_WriteLine_Space			; write a space
	call 	Console_Write_Hex				; write the hex value
	sub 	di, 1							; decrement di
	dec 	bp								; decrement bp
	jnz 	Sector_loop						; do it again untill bp = 0
	ret

; Initialize a counter for ASCII and insert a space 
ASCII_START:
	add 	di, 16							; as we substract 16 from di in Sector_loop, I would like to take the same 16 values for ASCII
	mov 	bp, 16							; counter 16 for ascii
	call 	Console_WriteLine_Space			; put a space between hex and ASCII
	
;ASCII loop
Sector_ASCII:
	mov 	si, 512							; si should be every time 512  
	sub 	si, di							;(512 -512/511/510.. = 0/1/2..) from the begining of the sector to the end
	call 	Console_Write_ASCI				; write the ASCII value
	sub 	di, 1							; decrement di
	dec 	bp								; decrement bp
	jnz 	Sector_ASCII					; do it again untill bp = 0
	ret	