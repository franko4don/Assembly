portb	equ	06h
porta	equ	05h
optionreg	equ	81h
pcl	equ	02h
tmr0	equ	01h
status	equ 03h
interrupt	equ	0bh
counter	equ	0ch
	bsf status,5
	movlw 00h
	movwf portb
	movlw b'11010111'
	movwf optionreg
	bcf status,5
	movlw 00h
	movwf interrupt
	bsf interrupt,5
start:
	movlw 0ffh
	movwf portb
	call delay
	movlw 00h
	movwf portb	
	call delay
	goto start
delay:
	movlw d'15'
	movwf counter
iterate:
	btfss interrupt,2
	goto iterate
	bcf interrupt,2
	decfsz counter,1
	goto iterate
	bcf interrupt,2
	return
	end