; Second stage of the boot loader

BITS 16

ORG 9000h
	jmp 	Second_Stage

%include "functions_16.asm"
%include "bpb.asm"						; The BIOS Parameter Block (i.e. information about the disk format)
%include "floppy16.asm"					; Routines to access the floppy disk drive
%include "disk.asm"
%include "read.asm"

;	Start of the second stage of the boot loader

; main program
Second_Stage:
    mov		[boot_device], dl			; Boot device number is passed in from first stage in DL. Save it to pass to kernel later.
	mov 	si, second_stage_msg		; Output our greeting message
    call 	Console_WriteLine_16
	mov 	si, Start_MSG				; Choose sector message
    call 	Console_WriteLine_16
	call    Start_Sector_Read			; Start reading ( read.asm ) 
	hlt

second_stage_msg  db 'Second stage of boot loader running', 0
start_message	  db 'Press any key to  continue...', 0			; Message for second half
boot_device		  db  0
Start_MSG		  db 'Enter the sector number to read:'
