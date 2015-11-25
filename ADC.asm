porta equ 05h
portb equ 06h
portd	equ	08h
trisa	equ	05h
trisb	equ	06h
trisd	equ	08h
status	equ 03h
adcon0	equ	1fh
adcon1	equ	1fh
adresl	equ	1eh
adresh	equ	1eh
counter	equ 20h
value	equ 21h
optionreg	equ 01h
intcon	equ 0bh
adif	equ	0ch
cmcon	equ	1ch
	bsf status,5
	movlw b'11111111'
	movwf trisa
	clrf trisb
	movlw b'11010000'
	movwf optionreg	;sets  the optionreg register which includes prescaler
	movlw b'00000000'
	movwf adcon1
	clrf adresl
	bsf adif,6
	bcf status,5


	movlw b'10000001'
	movwf adcon0
;	bcf adif,6
	movlw 07h
	movwf cmcon

start:
	nop
	nop
	nop
	nop
	nop
	bsf adcon0,2
	btfss adcon0,2
	goto $-1

	movf adresl,0
	movwf portb
	bsf status,5
	movf adresl,0
	movwf value
	bcf status,5
	movf value,0
	movwf portd

	end


