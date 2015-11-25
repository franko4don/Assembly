;asigns label to memories
portb	equ	06h
pcl		equ	02h
porta	equ	05h
status	equ	03h
pointer1	equ	0dh
pointer2	equ	0eh
temp1	equ	3bh
temp2	equ 4bh
count1	equ	1ch
count2	equ	1dh
count3	equ	1eh

	bsf status,5
	movlw 00h
	movwf portb ;sets input and output ports
	movwf porta
	bcf 03h,5
	movwf portb	
	movlw 00h
	movwf pointer1
	movwf pointer2
	movlw 0c0h
	movwf temp2
start
	call iterate1
	movlw 00h
	movwf pointer1
	movwf pointer2
	goto start

iterate1
	bcf status,2
	movlw 00h
	movwf pointer1
	movf pointer2,0
	call lookup
	movwf temp1
	call iterate2
	incf pointer2,1 ;pointer to the value contained in the table is incremented
	movf temp1,0;
	sublw 90h
	btfss status,2 ;checks if count is up to 9
	goto iterate1
	return

iterate2
	bcf status,2
	movf pointer1,0
	call lookup
	movwf temp2
	sublw 90h
	call three
	incf pointer1,1 ;pointer to the value contained in the table is incremented	
	movf temp2,0;
	sublw 90h
	btfss status,2 ;checks if count is up to 9
	goto iterate2
	return

lookup          ;the lookup table
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

delay			;the time delay subroutine
	movlw d'4'
	movwf count1
	movlw d'30'
	movwf count2
times
	decfsz count1,1
	goto times
	decfsz count2,1
	goto times
	return

three
	movlw d'30'
	movwf count3
implement			;the switching of the segments goes on here
	movf temp1,0
	movwf portb
	movlw 01h
	movwf porta
	call delay
	movlw 00h
	movwf porta
	movf temp2,0
	movwf portb
	movlw 02h
	movwf porta
	call delay
	movlw 00h
	movwf porta
	decfsz count3,1
	goto implement
	return
	end