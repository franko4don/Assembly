;asigns label to memories
portb	equ	06h
pcl		equ	02h
porta	equ	05h
status	equ	03h
pointer	equ	0dh

bsf status,5
	movlw 00h
	movwf portb ;sets input and output ports
	movwf porta
	bcf 03h,5
	movlw 00h
	movwf porta		
	movwf portb
	
	;initializes the lcd
	movlw 38h ;sets the matrix to 5 by 7
	call cmd_wrt
	movlw 80h  ;shifts the cursor to position 0
	call cmd_wrt
	movlw 14h
	call cmd_wrt	
	movlw 0eh
	call cmd_wrt
	movlw 0ch ;hides the cursor
	call cmd_wrt

start
	movlw d'95'
	call data_wrt
	movlw 'E'
	call data_wrt
	movlw 'L'
	call data_wrt
	movlw 'C'
	call data_wrt
	movlw 'O'
	call data_wrt
	movlw 'M'
	call data_wrt
	movlw 'E'
	call data_wrt
	movlw 01h
	call cmd_wrt
	goto start
;delay sub routine
delay
	movlw 1
	movwf 4dh
times
	movlw 2
	movwf 4ah
	movlw 0
	movwf 4bh
	movlw 0
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

data_wrt
	movwf portb
	movlw 05h
	movwf porta
	call delay
	movlw 04h
	movwf porta
	return

cmd_wrt
	movwf portb
	movlw 01h
	movwf porta
	call delay
	movlw 00h
	movwf porta
	return
	end