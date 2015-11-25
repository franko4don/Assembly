	
	bsf 03h,5
	movlw 00h
	movwf 06h
	bcf 03h,5
start

	movlw 0ffh
	movwf 06h
	call delay
	movlw 00h
	movwf 06h
	call delay
	
	goto start

delay
	movlw D'0'
	movwf 4ah
	movlw D'2'
	movwf 4bh
	movlw D'1'
	movwf 4ch
loop
	decfsz 4ch,1
	goto loop
	decfsz 4bh,1
	goto loop
	decfsz 4ah,1
	goto loop
	return
	end