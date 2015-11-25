;assignment of labels
porta	equ 05h
portb	equ	06h
status	equ 03h
count1	equ	0dh
count2	equ	0eh
count3	equ 0fh
	bsf	status,5
	movlw 00h	
	movwf portb
	movwf porta
	bcf status,5
	
start
	call three
	goto start
three
	movlw D'2'
	movwf count2
	movlw D'5'
	movwf count3
delay
	nop
	movlw D'165'
	movwf count1
times
	decfsz count1,1
	goto times
	decfsz count2,1
	goto delay
	decfsz count3,1
	goto delay
	return
	
	end