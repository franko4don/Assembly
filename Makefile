# MPLAB IDE generated this makefile for use with GNU make.
# Project: ADC.mcp
# Date: Wed Nov 04 04:25:00 2015

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

ADC.cof : ADC.o
	$(CC) /p16F84A "ADC.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"ADC.cof" /M"ADC.map" /W /x

ADC.o : ADC.asm
	$(AS) /q /p16F84A "ADC.asm" /l"ADC.lst" /e"ADC.err" /d__DEBUG=1

clean : 
	$(CC) "ADC.o" "ADC.hex" "ADC.err" "ADC.lst" "ADC.cof"

