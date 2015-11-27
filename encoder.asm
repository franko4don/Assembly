;label assignments to memories

pcl	equ 02h
status	equ	03h
porta	equ	05h
portb	equ	06h
interrupt	equ 0bh
optionreg	equ 01h
tmr0	equ	01h
CMCON	equ	1fh
	cblock 20h
pin1;	input pin for portb
pin2;	input pin for portb
pin3;	input pin for portb
pin4;	input pin for portb
pin5;	input pin for portb
pin6;	input pin for portb
pin7;	input pin for portb
pin0;	input pin for portb
work;	temporal register to hold the byte of the signal to be encoded during encoding
encode;	equ	15h
bitposition	;equ	16h
pointer	;pointer to be used for lookup tables
counter	;counter for the timer0
decode	;contains the decoded signal
	endc

	movlw 0x07 ;Turn comparators off and
	movwf CMCON
	bsf	status,5	;switches to bank1
	movlw 00h	
	movwf portb		;sets input and output for portb
	movlw 0ffh		
	movwf porta		;sets  input and output porta
	movlw b'11010010'
	movwf optionreg	;sets  the optionreg register which includes prescaler
	bcf status,5	;switches to bank0
	movlw 00h
	movwf interrupt	;clears the interrupt register
	bsf interrupt,5	;sets the TMR0IE
	bcf status,5
					;initialization of variables
	movlw 00h
	movwf pointer	;sets the pointer for look up table to zero
	movwf encode	;sets the register with the encoded signal to zero
	movlw b'00000001'
	movwf portb
	movlw b'00000000'	;initializes portb with zero
	movwf pin0			;assigns bytes to pin0
	movlw b'00000001'
	movwf pin1			;assigns bytes to pin1
	movlw b'00000010'
	movwf pin2			;assigns bytes to pin2
	movlw b'00000011'
	movwf pin3			;assigns bytes to pin3
	movlw 00h
	movwf decode		;initializes the decoding register with zeros

start:
	bsf portb,0
	movlw 00h
	movwf pointer	;initializes pointer register with zeros
	movwf encode	;initializes encode register with zeros
	movwf decode	;initializes decode register with zeros
	btfsc porta,0
	call pin0encode	;calls the subroutine if the input pin goes high
	btfsc porta,1
	call pin1encode ;calls the subroutine if the input pin goes high
	btfsc porta,2
	call pin2encode ;calls the subroutine if the input pin goes high
	btfsc porta,3
	call pin3encode ;calls the subroutine if the input pin goes high
	goto start		;goes back to start

pin0encode:
	movf pin0,0	;moves content of pin0 into the working register
	movwf work	;copies content of pin0 into temp register, work
	call operate	;calls the subroutine that checks the bits
	return

pin1encode:
	movf pin1,0	;moves content of pin1 into the working register
	movwf work	;copies content of pin1 into temp register, work
	call operate	;calls the subroutine that checks the bits
	return

pin2encode:
	movf pin2,0	;moves content of pin2 into the working register
	movwf work	;copies content of pin2 into temp register, work
	call operate	;calls the subroutine that checks the bits
	return

pin3encode:
	movf pin3,0	;moves content of pin3 into the working register
	movwf work	;copies content of pin3 into temp register, work
	call operate	;calls the subroutine that checks the bits
	return

operate:
	;performs a bit check on the nibbles
	btfss work,3	;checks the 3rd bit to know if its set
	call zero		;calls subroutine that handles zero bits
	btfsc work,3	;checks the 3rd bit to know if its clear
	call one		;calls subroutine that handles one bits
	btfss work,2	;checks the 2nd bit to know if its set
	call zero		;calls subroutine that handles zero bits
	btfsc work,2	;checks the 2nd bit to know if its clear
	call one		;calls subroutine that handles one bits
	btfss work,1	;checks the ist bit to know if its set
	call zero		;calls subroutine that handles zero bits
	btfsc work,1	;checks the ist bit to know if its clear
	call one		;calls subroutine that handles one bits
	btfss work,0	;checks the zero bit to know if its set
	call zero		;calls subroutine that handles zero bits
	btfsc work,0	;checks the zero bit to know if its clear
	call one		;calls subroutine that handles one bits
	comf encode,1	;complements the encoded bytes
	call trigger
	call preamble
	call transmit	;calls subroutine that handles the transmission
	call checksum
	return

trigger:
	bcf portb,0
	return

preamble:
;	bsf portb,0
	call delay1
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	call delay1
	return

transmit:
	bsf portb,0		;sets the transmission pin
;the rest of the code in this subroutine checks the bits in the encode register and calls up the appropriate subroutine
	call delay1
	btfss encode,0
	call setb00
	btfsc encode,0
	call setb01
	btfss encode,1
	call setb00
	btfsc encode,1
	call setb01
	btfss encode,2
	call setb00
	btfsc encode,2
	call setb01
	btfss encode,3
	call setb00
	btfsc encode,3
	call setb01
	btfss encode,4
	call setb00
	btfsc encode,4
	call setb01
	btfss encode,5
	call setb00
	btfsc encode,5
	call setb01
	btfss encode,6
	call setb00
	btfsc encode,6
	call setb01
	btfss encode,7
	call setb00
	btfsc encode,7
	call setb01
	bcf portb,0
	call delay
	return

checksum:	;this subrouting sends a checkbyte to the receiver to enable it know which signal to process
	call delay1
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	bsf portb,0
	call delay
	bcf portb,0
	call delay
	call delay1
	return

setb00:
	bcf	portb,0		;clears pin0 in port b
	call delay		;calls a delay subroutine
	return

setb01:
	bsf	portb,0		;sets pin0 in port b
	call delay		;calls a delay subroutine
	return



one:					;carries out encoding for bits that are 1
	movlw b'10000000'	;moves the value into the working register
	xorwf encode,1		;xors the value of gthe working register with that of the encode register and stores the value in encode
	rlf encode,1		;rotates the bits to the left through carry
	movlw 00h			;moves the value into the working register
	xorwf encode,1	    ;xors the value of gthe working register with that of the encode register and stores the value in encode
	rlf encode,1		;rotates the bits to the left through carry
	return

zero:					;carries out encoding for bits that are 0
	movlw 00h			;moves the value into the working register
	xorwf encode,1		;xors the value of gthe working register with that of the encode register and stores the value in encode
	rlf encode,1		;rotates the bits to the left through carry
	movlw b'00000001'	;moves the value into the working register
	xorwf encode,1		;xors the value of gthe working register with that of the encode register and stores the value in encode
	rlf encode,1		;rotates the bits to the left through carry
	return

decrypt:		;this subroutine checks the odd bits in th encode register and calls up the appropriate subroutine
	movf encode,0 	;moves the content of encode into the working register
	movwf work
	btfsc work,7
	call decryptone
	btfss work,7
	call decryptzero
	btfsc work,5
	call decryptone
	btfss work,5
	call decryptzero
	btfsc work,3
	call decryptone
	btfss work,3
	call decryptzero
	btfsc work,1
	call decryptone
	btfss work,1
	call decryptzero
	rrf decode,1	;rotates the bits right once to correct the effect from the decryption
	return

decryptone:
	movlw b'00000001'	;moves value to the working register
	xorwf decode,1		;xors value in working register with decode and stores answer in decode
	rlf decode,1		;rotates left through carry
	return

decryptzero:
	movlw b'00000000'	;moves value to the working register
	xorwf decode,1		;xors value in working register with decode and stores answer in decode
	rlf decode,1		;rotates left through carry
	return
;the delay routine
delay:
	clrf tmr0
	movlw d'8'
    movwf counter	;moves value in working register to counter
frank:
    btfss interrupt,2		;checks the TMR0IF to know when its set
    goto frank
    bcf interrupt,2	;clears the TMR0IF
    decfsz counter,1	;decrements the value in the counter and puts the decremented value in the counter
    goto frank
    bcf interrupt,2		;clears the TMR0IF
    return

delay1:
	clrf tmr0
	movlw d'47'
    movwf counter	;moves value in working register to counter
frank1:
    btfss interrupt,2		;checks the TMR0IF to know when its set
    goto frank1
    bcf interrupt,2	;clears the TMR0IF
    decfsz counter,1	;decrements the value in the counter and puts the decremented value in the counter
    goto frank1
    bcf interrupt,2		;clears the TMR0IF
    return
	end