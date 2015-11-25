portb	equ	06h
porta	equ	05h
optionreg	equ	01h
pcl	equ	02h
tmr0	equ	01h
status	equ 03h
interrupt	equ	0bh
counter	equ	0ch
service	equ	0dh
	bsf status,5
	movlw b'00000001'
	movwf portb
	movlw b'11010111'
	movwf optionreg
	movlw 00h
	movwf porta
	bcf status,5
	movwf interrupt
	bsf interrupt,5
	bsf interrupt,4
start:
	movlw 0ffh
	movwf porta
	call delay
	btfsc interrupt,1
	call ISR
	clrf porta
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

ISR:
	movlw d'5'
	movwf service
	bcf	interrupt,1
loop:
	call delay
	decfsz service,1
	goto loop
	return
	end