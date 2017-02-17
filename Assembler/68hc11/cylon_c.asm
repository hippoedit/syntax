*
*	File: cylon_c.asm
*	Program to control LEDs on PORT C, flashing
*	them back and forth.
*	Tom Dickens  8/21/1998
*
*       Assumes an 'E1 or 'A1 device.
*       Change $B600 to $F800 for 'E2

	ORG	$B600
*
*	Initialize PORT C for output
*
	ldaa	#$FF
	staa	$1007	; data direction for Port C (0=in, 1=out)
*
Top:
	ldx	#TABLE	; X points to the data in the TABLE
Loop:
	ldaa	0,X	; load the data from the TABLE
	beq	Top	; if we read the zero, start over
	staa	$1003	; store value from TABLE to Port C
	bsr	Delay	; wait a while
	inx		; x = x + 1, point to next value in TABLE
	bra	Loop	; do it again...
*
*	Subroutine to delay half a second / 14 =  035.7 mS
*	1 cycle = 500 nS.  Each X loop takes 6 cycles, or 3uS.
*	Each Y loop takes 10 + 6 X cycles, for an equation of:
*	delay_time = 14 * (24 + Y (10 + 6 X) ) 500 nS
*	Now we need to solve for X and Y to get 0.5 S.
*	X=3330 and Y=50 gives us 0.4999912 S.
*
Delay:
	pshx		; remember X (4 cycles)
	pshy		; remember Y (5 cycles)
	ldy	#4	; (4 cycles)
LoopY:
	ldx	#2973	; (3 cycles)
LoopX:
	dex		; x = x - 1 (3 cycles)
	bne	LoopX	; if x!= 0, loop (3 cycles)
*	
	dey		; y = y - 1 (4 cycles)
	bne	LoopY	; if y!= 0, loop (3 cycles)
*	
	puly		; restore Y (6 cycles)
	pulx		; restore X (5 cycles)
	rts
*
*	The following table is data we will read in for the LED values.
*	These values exist as data values in the program.  The values
*	end with a zero, which causes the reading program to loop.
*
TABLE:
 fcb	$01, $02, $04, $08, $10, $20, $40, $80
 fcb	$40, $20, $10, $08, $04, $02, $00
