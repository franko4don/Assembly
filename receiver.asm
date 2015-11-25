;assignment of variables to memory
portb	equ 06h
porta	equ	05h
optionreg	equ	01h
status	equ	03h
interrupt	equ	0bh
;temp	equ	0dh
tmr0	equ	01h
CMCON	equ	1fh
	cblock 20h
receiver
work	
decode	
counter
checker
pin0
pin1
pin2
pin3
pin4
temp
onstate
receivedbyte
startbyte
checkbyte
bitcheck
	endc

	movlw 0x07
	movwf CMCON		;sets porta to digital I/O
	bsf status,5	;I/O port setup in bank1
	movlw 00h
	movwf portb		;input and ouput pin setup on portb
	movlw b'00000001'
	movwf porta		;initialiazation of portb with zeros
	movlw b'11010010'
	movwf optionreg	;opreg setup for prescaler,TOCS and TOSE
	bcf status,5	;switches back to bank0
	movlw 00h
	movwf interrupt
	bsf interrupt,5	;TMR0IE
	movlw 00h
	movwf portb	;portb initialization
	movlw b'00000000'
	movwf pin0
	movlw b'00000001'
	movwf pin1
	movlw b'00000010'
	movwf pin2
	movlw b'00000011'
	movwf pin3
	movlw b'10101010'
	movwf checkbyte

start:
	movlw 00h	
	movwf receiver	;initializes receiver register with zeros
	movwf decode	;initializes decode register with zeros
	movwf receivedbyte
	movwf checker
	btfsc porta,0
	call preamble
	goto start		;goes back to start

preamble:
	call delay1
	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay

	btfss porta,0
	call zeroth1
	btfsc porta,0
	call oneth1
	call delay
	rlf startbyte,1
	rlf startbyte,1
	call delay1

	bcf status,2
	movlw b'10101010'
	xorwf startbyte
	btfsc status,2
	call reception
	return
reception:	;triggers the receiver
	call operation	;calls the subroutine that accepts the bits
	bcf status,2
	movf receivedbyte,0
	xorwf checkbyte,0
	btfsc status,2
	call decrypt	;decoded the received signal
	bcf status,2
	movf receivedbyte,0
	xorwf checkbyte,0
	btfsc status,2 
	call switch
	return

switch:		;this subroutine checks it the decoded signal matches the supposed values in memory
	bcf status,2
	movf decode,0	;moves the value of decoded signal to the working register
	xorwf pin3,0	;xors the value of the working register with pin3 and stores answer in working register
	btfsc status,2	;checks if the signal matches the content of pin3 by checking the state of the zero flag
	call onandoff3
	bcf status,2
	movf decode,0	;moves the value of decoded signal to the working register
	xorwf pin2,0	;xors the value of the working register with pin2 and stores answer in working register
	btfsc status,2	;checks if the signal matches the content of pin2 by checking the state of the zero flag
	call onandoff2
	bcf status,2
	movf decode,0	;moves the value of decoded signal to the working register
	xorwf pin1,0	;xors the value of the working register with pin1 and stores answer in working register
	btfsc status,2	;checks if the signal matches the content of pin1 by checking the state of the zero flag
	call onandoff1
	bcf status,2
	movf decode,0	;moves the value of decoded signal to the working register
	xorwf pin0,0	;xors the value of the working register with pin0 and stores answer in working register
	btfsc status,2	;checks if the signal matches the content of pin0 by checking the state of the zero flag
	call onandoff0
	bcf status,2
	return

onandoff0:
	bsf portb,0
	movlw b'00000001'
	xorwf onstate,1
	movf onstate,0
	movwf portb
	return

onandoff1:
	bsf portb,1
	movlw b'00000010'
	xorwf onstate,1
	movf onstate,0
	movwf portb
	return

onandoff2:
	bsf portb,2
	movlw b'00000100'
	xorwf onstate,1
	movf onstate,0
	movwf portb
	return

onandoff3:
	bsf portb,3
	movlw b'00001000'
	xorwf onstate,1
	movf onstate,0
	movwf portb
	return


operation:			;actual reception goes on here. This subroutine checks the status of pino every 160ms to ascertain 
;the status of the pin then calls up the appropriate subroutine
	bsf porta,0
	call delay1

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay

	btfss porta,0
	call zero
	btfsc porta,0
	call one
	call delay
	bcf porta,0
	call delay
	rlf receiver,1	;rotates the receiver register left through carry once
	call bytecheck
	return

bytecheck:
	call delay1
	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay

	btfss porta,0
	call zeroth
	btfsc porta,0
	call oneth
	call delay
	rlf receivedbyte,1
	rlf receivedbyte,1
	call delay1
	return

zeroth:
	bcf porta,1
	movlw b'00000000'	
	xorwf receivedbyte,1	;xors the value in the working register with that in the receiver
	rrf receivedbyte,1		;rotates the content of receiver right through carry
	return

oneth:
	bsf porta,1
	movlw b'10000000'
	xorwf receivedbyte,1	;xors the value in the working register with that in the receiver
	rrf receivedbyte,1		;rotates the content of receiver right through carry
	return

zeroth1:
	bcf porta,1
	movlw b'00000000'	
	xorwf startbyte,1	;xors the value in the working register with that in the receiver
	rrf startbyte,1		;rotates the content of receiver right through carry
	return

oneth1:
	bsf porta,1
	movlw b'10000000'
	xorwf startbyte,1	;xors the value in the working register with that in the receiver
	rrf startbyte,1		;rotates the content of receiver right through carry
	return

zero:
	bcf porta,1
	movlw b'00000000'	
	xorwf receiver,1	;xors the value in the working register with that in the receiver
	rrf receiver,1		;rotates the content of receiver right through carry
	return

one:
	bsf porta,1
	movlw b'10000000'
	xorwf receiver,1	;xors the value in the working register with that in the receiver
	rrf receiver,1		;rotates the content of receiver right through carry
	return


delay:		;time delay using interrupt and time zero
	clrf tmr0
	movlw d'8'
    movwf counter
frank:
    btfss interrupt,2
    goto frank
    bcf interrupt,2
    decfsz counter,1
    goto frank
    bcf interrupt,2
    return

delay1:		;time delay usinf interrupt and time zero
	clrf tmr0
	movlw d'47'
    movwf counter
frank1:
    btfss interrupt,2
    goto frank1
    bcf interrupt,2
    decfsz counter,1
    goto frank1
    bcf interrupt,2
    return

delay3:		;time delay usinf interrupt and time zero
	clrf tmr0
	movlw d'227'
    movwf counter
frank2:
    btfss interrupt,2
    goto frank2
    bcf interrupt,2
    decfsz counter,1
    goto frank2
    bcf interrupt,2
    return

decrypt:			;decoding of the received signal goes on here
	movf receiver,0
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
	movlw b'00000001'
	xorwf decode,1
	rlf decode,1
	return

decryptzero:
	movlw b'00000000'
	xorwf decode,1
	rlf decode,1
	return

	end