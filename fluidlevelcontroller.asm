;variable declaration
status	equ 03h
porta	equ	05h
portb	equ	06h

	cblock 0ch
full
threequater
medium
exchange
vlow
zero
	endc

	bsf status,5	;moves to bank1
	clrf portb		;sets portb as output port
	movlw 0ffh		;moves 0ffh into working register
	movwf porta		;sets porta as input port
	bcf status,5	;returns to bank0

;initialization of variables
	movlw b'00001111'
	movwf full
	movlw b'00001110'
	movwf threequater
	movlw b'00001100'
	movwf medium
	movlw b'00001000'
	movwf vlow
	clrf portb
	clrf zero
;program starts
start:
	bcf status,2	;clears zero flag
	movf porta,0	;moves d state of porta into working register
	xorwf full,0	;xors the value of working reg with full
	btfsc status,2	;performs a bitcheck on the zero flag
	call on1		;calls the on1 subroutine

	bcf status,2	;clears zero flag
	movf porta,0	;moves d state of porta into working register
	xorwf threequater,0	;xors the value of working reg with threequater
	btfsc status,2	;performs a bitcheck on the zero flag
	call on2		;calls the on2 subroutine

	bcf status,2	;clears zero flag
	movf porta,0	;moves d state of porta into working register
	xorwf medium,0	;xors the value of working reg with medium
	btfsc status,2	;performs a bitcheck on the zero flag
	call on3		;calls the on3 subroutine

	bcf status,2	;clears zero flag
	movf porta,0	;moves d state of porta into working register
	xorwf vlow,0	;xors the value of working reg with vlow
	btfsc status,2	;performs a bitcheck on the zero flag
	call on4		;calls the on4 subroutine

	bcf status,2	;clears zero flag
	movf porta,0	;moves d state of porta into working register
	xorwf zero,0	;xors the value of working reg with zero
	btfsc status,2	;performs a bitcheck on the zero flag
	call on5		;calls the on5 subroutine

	goto start		;jumps back to start label

on1:
	;switches the necessary pins
	bcf portb,4
	bcf portb,3
	bcf portb,2
	bcf portb,1
	bsf portb,0
	return

on2:
    ;switches the necessary pins
	bcf portb,3
	bcf portb,2
	bsf portb,1
	bcf portb,0
	return

on3:
	;switches the necessary pins
	bcf portb,3
	bsf portb,2
	bcf portb,1
	bcf portb,0
	return

on4:
	;switches the necessary pins
	bsf portb,4
	bsf portb,3
	bcf portb,2
	bcf portb,1
	bcf portb,0
	return

on5:
	;switches the necessary pins
	bsf portb,4
	bsf portb,3
	bcf portb,2
	bcf portb,1
	bcf portb,0
	return
	end