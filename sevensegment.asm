;asigns label to memories
portb	equ	06h
pcl		equ	02h
porta	equ	05h
status	equ	03h
pointer	equ	0dh
bsf status,5
	movlw 00h
	movwf portb
	movwf porta
	bcf 03h,5
	movlw 01h
	movwf porta
	movlw 0ffh	
	movwf portb
start ;program starts here
	movlw 00h
	movwf portb
	movwf pointer
iterate
	movf pointer,0
	call lookup
	movwf portb
	call delay
	incf pointer,1
	incf pointer,1 ;pointer to the value contained in the table is incremented
	btfss pointer,3 ;checks if the 3rd bit is set so as to reset count
	goto iterate
	goto start
delay ;the delay routine
	movlw 1 ;time delay of one second, if set to 2 becomes 2 second delay
	movwf 4dh
times
	movlw 10
	movwf 4ah
	movlw 6
	movwf 4bh
	movlw 2
	movwf 4ch
loop1
loop2
loop3
	decfsz 4ch,1
	goto loop3
	decfsz 4bh,1
	goto loop2
	decfsz 4ah,1
	goto loop1
	decfsz 4dh,1
	goto times
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

	end