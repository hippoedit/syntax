* 
* 	Program to use an LCD.
*	The LCD is connected to port C with the following bit assignments:
*	  V+  :LCD2
*	  Gnd :LCD1
*	  Vref:LCD3
*	  C0  :LCD11	data I/O to LCD data bit 4
*	  C1  :LCD12	data I/O to LCD data bit 5
*	  C2  :LCD13	data I/O to LCD data bit 6
*	  C3  :LCD14	data I/O to LCD data bit 7
*	  C4  :LCD4	RS (register select) L=control, H=data
*	  C5  :LCD5	R/W H=read, L=write
*	  C6  :LCD6	E (enable) H is enabled, transaction on H->L edge.
*	  C7 -unused-
*
*	Port C is located at $1003
*	Data direction for Port C is address $1007.  L=input, H=output
* 
 
NOTE_ON		EQU	$90
NOTE_OFF	EQU	$80

	ORG $B600		; Start of EEPROM
Init
	ldx	#$1000		; setup X for address reference
	bset	$07,x #$FF	; set port C, all bits for output
	ldab	#$08
	clr	$04,x		; clear port B
LOOPB
	inc	$04,x		; count on port B
	ldaa	#$03
	jsr	Write_C_nibble
	ldy	#$5000		; delay 40 mS
LOOPY1
	dey
	bne	LOOPY1
	decb
	bne	LOOPB
	

	jsr	Delay
	jsr	Delay
	clr	$04,x		; clear port B

	ldy	#LCD_Init_Table
More_Init
	inc	$04,x		; count on port B
	ldaa	$00,y
	beq	Init_Done
	jsr	Write_C_LCD
	iny
	bra	More_Init
Init_Done

	jsr	Delay
	jsr	Delay
	clr	$04,x		; clear port B

	ldy	#LCD_Test_Table
More_Test
	inc	$04,x		; count on port B
	ldaa	$00,y
	beq	Test_Done
	jsr	Write_D_LCD
	jsr	Delay
	iny
	bra	More_Test

Test_Done
	jsr	Delay
	jsr	Delay
	clr	$04,x		; clear port B

Test_Done_2
	dec	$04,x		; count on port B
	jsr	Delay
	bra	Test_Done_2

LCD_Init_Table
 fcb	$28	; Data length (bit 4) = 4-bit, number of lines (bit 2) = 2
 fcb	$08	; Display on (bit 2), cursor on (bit 1), blink cursor (bit 0)
 fcb	$01	; Clear display
 fcb	$06	; Entry mode, I/D (bit 1) inc/dec, S (bit) display shift
 fcb	$0F	; Display on (bit 2), cursor on (bit 1), blink cursor (bit 0)
 fcb	$00
LCD_Test_Table
 fcb	'H'
 fcb	'i'
 fcb	' '
 fcb	'H'
 fcb	'o'
 fcb	'n'
 fcb	'e'
 fcb	'y'
 fcb	'.'
 fcb	'.'
 fcb	'.'
 fcb	$00
 fcb	$41, $42, $43, $44, $45, $46, $47, $00

Delay	
	pshy
	ldy	#$1000	; 
d_loop	dey
	bne	d_loop
	puly
	rts

Write_C_LCD
	psha
	lsra
	lsra
	lsra
	lsra
	bsr	Wait4BF
	bsr	Write_C_nibble
	pula
	psha
	bsr	Write_C_nibble
	pula
	rts

Write_D_LCD
	psha
	lsra
	lsra
	lsra
	lsra
	bsr	Wait4BF
	bsr	Write_D_nibble
	pula
	psha
	bsr	Write_D_nibble
	pula
	rts

*		Write nibble is low 4 bits of A
Write_C_nibble
	psha
	anda	#$0F		; set upper 4 bits to zero
	bset	$07,x #$FF	; set bits 0-3 of port C to output
	oraa	#$40		; E=H, R/W=L, RS=L
	staa	$03,x
	anda	#$0F		; E=L, R/W=L, RS=L
	staa	$03,x
	bclr	$07,x #$0F	; set bits 0-3 of port C to input
	pula
	rts

Write_D_nibble
	psha
	anda	#$0F		; set upper 4 bits to zero
	bset	$07,x #$FF	; set bits 0-3 of port C to output
	oraa	#$50		; E=H, R/W=L, RS=H
	staa	$03,x
	anda	#$1F		; E=L, R/W=L, RS=H
	staa	$03,x
	bclr	$07,x #$0F	; set bits 0-3 of port C to input
	pula
	rts

Wait4BF
	jsr Delay
	rts

	jsr Delay
	psha
	pshb
	ldaa	#$F0
	staa	$07,x	; set bits 0-3 of port C to input
LCD_Busy
	ldab	#$60		; E=H, R/W=H, RS=L
	stab	$03,x
	ldaa	$03,x		; get high nibble, busy flag bit 3 (7 in LCD)
	ldab	#$40		; E=L, R/W=H, RS=L
	stab	$03,x
	ldab	#$60		; E=H, R/W=H, RS=L
	stab	$03,x
	ldab	#$40		; E=L, R/W=H, RS=L
	stab	$03,x
	anda	#$08		; look at BF, bit 3 in A
	bne	LCD_Busy	; if BF=H, then LCD is busy, loop...
	pulb
	pula
	rts

