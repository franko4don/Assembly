	
	bsf 03h,5
	movlw 00h
	movwf 06h
	bcf 03h,5
start
	movlw 0ffh
	movwf 06h
	
	call onesec

	movlw 00h
	movwf 06h

	call onesec

	goto start
delay

first
	movlw 0ffh
	movwf 4eh

	movwf 4ah

	movwf 4bh
	
	movwf 4ch
	movwf 4dh

second	
	decfsz 4eh,second
	decfsz 4ah,second
	decfsz 4bh,second
	decfsz 4ch,second
	decfsz 4dh,second
	return

onesec
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	call delay
	return
	end