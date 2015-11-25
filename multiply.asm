status	equ	03h
multiplier	equ	20h
multiplied	equ	21h
counter	equ	24h
temp	equ	23h
loop	equ	22h
porta	equ	05h
portb	equ	06h
optionreg	equ	01h
	bsf status,5
	clrf portb
	clrf porta
	movlw b'00000111'
	movwf optionreg
	bcf	status,5

start:
	movlw d'5'
	movwf multiplied
	movlw d'11'
	movwf multiplier
	call multiply
	movf multiplied,0
	movwf portb
	call delay
	goto start


multiply:
	movf multiplied,0	;moves content of multiplied register to working register
	movwf temp			;moves content of working register to temp register
	decf multiplier,1	;decrements the multiplier
iterate:
	movf temp,0			;moves content of temp register to working register
	addwf multiplied,1	;adds content of working register to multiplied register and stores in multiplied register
	decfsz multiplier,1	;decrements the multiplier and skips next instruction if zero
	goto iterate
	return

delay:
    movlw d'30'
    movwf counter
frank:
    btfss 0bh,2
    goto frank
    bcf 0bh,2
    decfsz counter,1
    goto frank
    bcf 0bh,2
    return
	end