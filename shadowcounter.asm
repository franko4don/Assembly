;asigns label to memories
portb	equ	06h
pcl		equ	02h
porta	equ	05h
status	equ	03h
	cblock 0ch
pointer1;	equ	0dh
pointer2;	equ	0eh
temp;	equ	3bh
count2;	equ	1dh
count3;	equ	1eh
count1;	equ	1fh
firstseg;	equ	4ch
secondseg;	equ	4dh
check
	endc

	bsf status,05h
	movlw 00h
	movwf portb ;sets input and output ports
	movlw 04h
	movwf porta
	bcf 03h,5
	movlw 00h
	movwf temp
	movwf pointer1
	movwf pointer2
	movwf check
	movlw 0c0h
	movwf firstseg
	movwf secondseg
	movlw 0ffh
	movwf porta

start:		;program starts here
	btfss porta,2
	call zero
	btfsc porta,2
	call one
	call three
	movf secondseg,0
	sublw 88h
	btfsc status,2
	call resetsecond
	movf firstseg,0
	sublw 88h
	btfsc status,2
	call resetfirst
	goto start

resetfirst:
	movlw 0c0h
	movwf firstseg
	clrf pointer2
	incf pointer2,1
	bcf	status,2
	return

resetsecond:
	clrf pointer1
	incf pointer1,1
	movlw 0c0h
	movwf secondseg
	btfss check,0
	call partial
	bcf status,2
	return

partial:
	incf pointer2,1
	call lookup2
	movwf firstseg
	return

zero:
	clrf temp
	return

one:
	btfss temp,0
	call address
	return

address:
	call lookup1
	movwf secondseg
	movlw 0ffh
	movwf temp
	incf pointer1,1
	return

lookup1:          ;the lookup table for the first segment
	clrf check
	movf pointer1,0
	addwf pcl,1
	retlw 0c0h
	retlw 0f9h
	retlw 0a4h
	retlw 0b0h
	retlw 99h
	retlw 92h
	retlw 82h
	retlw 0f8h
	retlw 80h
	retlw 90h
	retlw 88h
lookup2:          ;the lookup table for the first segment
	bsf check,0
	movf pointer2,0
	addwf pcl,1
	retlw 0c0h
	retlw 0f9h
	retlw 0a4h
	retlw 0b0h
	retlw 99h
	retlw 92h
	retlw 82h
	retlw 0f8h
	retlw 80h
	retlw 90h
	retlw 88h
delay:			;the time delay subroutine
	movlw d'1'
	movwf count1
	movlw d'20'
	movwf count2
times:
	decfsz count1,1
	goto times
	decfsz count2,1
	goto times
	return


three:
	movlw d'4'
	movwf count3
implement:			;the switching of the segments goes on here
	movf secondseg,0
	movwf portb
	movlw 02h
	movwf porta
	call delay
	movlw 00h
	movwf porta
	movf firstseg,0
	movwf portb
	movlw 01h
	movwf porta
	call delay
	movlw 00h
	movwf porta
	decfsz count3,1
	goto implement
	return
	end