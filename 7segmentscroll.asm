;asigns label to memories
portb	equ	06h
pcl		equ	02h
porta	equ	05h
status	equ	03h
pointer1	equ	0dh
pointer2	equ	0eh
temp1	equ	1ah
temp2	equ 1bh
	bsf status,5
	movlw 00h
	movwf portb ;sets input and output ports
	movwf porta
	bcf 03h,5
	movlw 00h
	movwf porta	
	movwf portb	
start
	call iterate1
	goto start
iterate1
	movf pointer1,0
	call lookup
	movwf temp1	
	incf pointer1,1 ;pointer to the value contained in the table is incremented
	movlw 00h
	movwf pointer2
	call iterate2
	btfss pointer1,3 ;checks if the 3rd bit is set so as to reset count
	goto iterate1
	return
iterate2
	movf pointer2,0
	call lookup
	movwf temp2
	call times
	incf pointer2,1 ;pointer to the value contained in the table is incremented
	btfss pointer2,3 ;checks if the 3rd bit is set so as to reset count
	goto iterate2
	movlw 00h
	movwf pcl
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

three
	movlw D'1'
	movwf count2
	movlw D'5'
	movwf count3

delay
	nop
	movlw D'165'
	movwf count1
times
	decfsz count1,1
	goto times
	decfsz count2,1
	goto delay
	decfsz count3,1
	goto delay
	return
	end