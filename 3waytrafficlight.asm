;label assignments to memories
pcl	equ 02h
status	equ	03h
porta	equ	05h
portb	equ	06h
interrupt	equ 0bh
optionreg	equ 01h
tmr0	equ	01h
CMCON	equ	1fh
	cblock 0ch
counter	;counter for the timer0
	endc

	bsf	status,5	;switches to bank1
	movlw 00h	
	movwf portb		;sets input and output for portb	
	movwf porta		;sets  input and output porta
	movlw b'11010111'
	movwf optionreg	;sets  the optionreg register which includes prescaler
	bcf status,5	;switches to bank0
	movlw 00h
	movwf interrupt	;clears the interrupt register
	bsf interrupt,5	;sets the TMR0IE
	bcf status,5

start:
	bsf porta,0
	movlw b'10000100'
	movwf portb
	call delay10
	bcf porta,0
	movlw b'01000101'
	movwf portb
	call delay5
	movlw b'00100110'
	movwf portb
	call delay10
	movlw b'00101001'
	movwf portb
	call delay5
	bsf porta,0
	movlw b'00110000'
	movwf portb
	call delay10
	movlw b'01001000'
	movwf portb
	call delay5
	goto start

delay10:
	clrf tmr0
    movlw d'152'
    movwf counter
frank:
    btfss interrupt,2
    goto frank
    bcf interrupt,2
    decfsz counter,1
    goto frank
    bcf interrupt,2
    return

delay5:
    movlw d'76'
    movwf counter
charles:
    btfss interrupt,2
    goto charles
    bcf interrupt,2
    decfsz counter,1
    goto charles
    bcf interrupt,2
    return
	end