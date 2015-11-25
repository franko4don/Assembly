#include<P16F628A.INC>
tmr0	equ	01h
counter		equ	20h
	bsf	STATUS,5
	movlw 00h
	movwf PORTB
	movlw b'11010111'
	movwf tmr0
	bcf STATUS,5
	bsf INTCON,5
start:
	movlw 0ffh
	movwf PORTB
	call delay
	clrf PORTB
	call delay
	goto start

delay:
	movlw d'30'
    movwf counter
frank:
    btfss INTCON,2
    goto frank
    bcf INTCON,2
    decfsz counter,1
    goto frank
    bcf INTCON,2
    return
	end