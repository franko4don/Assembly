optionreg	equ 01h
counter	equ	20h
status	equ	03h
portb	equ	06h
porta	equ 05h
tmr0	equ	01h
interrupt equ	0bh
CMCON	equ	1fh
	movlw 0x07 ;Turn comparators off and
	movwf CMCON
	bsf	status,5	;switches to bank1
	movlw 00h	
	movwf portb		;sets input and output for portb
	movlw 0ffh		
	movwf porta		;sets  input and output porta
	movlw b'11010111'
	movwf optionreg	;sets  the optionreg register which includes prescaler
	bcf status,5	;switches to bank0
	movlw 00h
	movwf interrupt	;clears the interrupt register
	bsf interrupt,5	;sets the TMR0IE
	bcf status,5
	movlw 00h	
	movwf portb

start:
	btfsc porta,2
	call on
	goto start

on:
	movlw 0ffh
	movwf	portb
	call delay
	clrf portb
	return

delay:
	clrf tmr0
	movlw d'30'
    movwf counter	;moves value in working register to counter
frank:
    btfss 0bh,2		;checks the TMR0IF to know when its set
    goto frank
    bcf interrupt,2	;clears the TMR0IF
    decfsz counter,1	;decrements the value in the counter and puts the decremented value in the counter
    goto frank
    bcf interrupt,2		;clears the TMR0IF
    return
	end