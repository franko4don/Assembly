#include<P16F628A.INC>
interrupt	equ	0bh
tmr0		equ	01h
	cblock 02h
counter
	endc
	bsf STATUS,5
	clrf PORTB
	bcf STATUS,5
	bsf interrupt,5
	movlw b'11010111'
	movwf OPTION_REG
start:
	movlw 0ffh
	movwf PORTB
	call delay
	movlw 00h
	movwf PORTB
	call delay
	goto start
delay:
	clrf tmr0
	movlw d'15'
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

