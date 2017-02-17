*	OPT l,c,cre,s
*========================================================================
*	Program organization:
*
*	Init
*	  +-WriteNibble
*	  |  +-Wait4BF
*	MoreInit
*	  +-WriteCByte
*	  |  +-Wait4BF
*	CopyLCDTable
*	CopyJMP
*	InitTimer
*	  +-Inc_Timer
*	InitVars
*	LoopHere
*
*	Interrupt
*	  +-Check_Input
*	  +-Inc_Displays
*	  +-Display_LCD
*
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
*========================================================================
* RAM usage:
*	$00-$01	Mode variables
*
*	MODE_EH		$00	Mode (data/control) with Enable High
*	MODE_EL		$01	Mode (data/control) with Enable Low
*	INT_COUNT	$02	Interput count, 40 for a second.
*	TEMP0		$03	Tempory variable space
*
*     Display data:
* Mode)
*  1)   $62-72	'Tom's LCD Clock ' $0
*	$95-A5	'        hh:mm:ss' $00
*
*	$DF-E1	JMP Instruction for timer 1 interrupt (In boot ROM)
* 	$E2-FF	Stack (30 bytes:  RTI uses 9 bytes)
*
*========================================================================
*    Addresses of RAM variables:
MODE_EH		EQU	$00
MODE_EL		EQU	$01
INT_COUNT	EQU	$02
TEMP0		EQU	$03

*    Addresses of RAM Display Tables:
DIS_1_2		EQU	$62
DIS_END		EQU	$73

*========================================================================
*    Numeric Constants:
TIMER_COUNT	EQU	5000

*========================================================================
*========================================================================
*    Initialization:
	ORG $B600		; Start of EEPROM
Init:
	ldx	#$400f		; set up Control Mode
	stx	MODE_EH
	ldab	#$FF
	stab	$1007		; set port C, all bits for output
	ldab	#$04
LOOPB:
	ldaa	#$03
	jsr	Write_Nibble
	ldx	#$0480		;  1152 loops * 3.5 uS = 4.032 mS
LOOPY1:
	dex			; 4 cycles = 2 uS
	bne	LOOPY1		; 3 cycles + ? = 1.5 uS
	decb
	bne	LOOPB

	ldx	#LCD_Init_Table
*========================================================================
MoreInit:
	ldaa	$00,x
	beq	LCD_Init_Done
	bsr	Write_C_Byte
	inx
	bra	MoreInit
LCD_Init_Done:

*========================================================================
CopyLCDTable:
*    Copy the LCD Display Tables to RAM
	ldx	#DIS_1_2	; To
	ldy	#Display_1_2	; From
Copy_More:
	ldaa	$00,y
	staa	$00,x
	inx
	iny
	cpx	#DIS_END
	bne	Copy_More

*========================================================================
CopyJMP:
*  copy the jump to the interrupt vector location for timer 1
	ldx	IntJmp
	stx	$100-33
	ldaa	IntJmp+2
	staa	$100-33+2

*========================================================================
InitTimer:
*    Initialize the interrupt timer
	jsr	Inc_Timer	; A will be set to #$80
	staa	$1022		; Enable timer 1
	ldaa	#$14
	staa	$00
	tpa			; clear interrupt disable mask
	anda	#$EF
	tap
	lda	#$80		; clear any pending events
	sta	$1023

*========================================================================
InitVars:
* Initialize variables
	ldx	#$0000
	ldaa	#40	; 50000 * 500 nS * 40 = 1 second.
	staa	INT_COUNT
*========================================================================
	ldx	#Display_1_1
	bsr	Write_Line_1
	ldx	#DIS_1_2
	bsr	Write_Line_2
*========================================================================
LoopHere:
	bra	LoopHere
*========================================================================
*========================================================================

LCD_Init_Table:
 fcb	$28	; Data length (bit 4) = 4-bit, number of lines (bit 2) = 2
 fcb	$08	; Display on (bit 2), cursor on (bit 1), blink cursor (bit 0)
 fcb	$01	; Clear display
 fcb	$06	; Entry mode, I/D (bit 1) inc/dec, S (bit) display shift
 fcb	$0C	; Display on (bit 2), cursor on (bit 1), blink cursor (bit 0)
 fcb	$00

*========================================================================
Wait4BF:
Delay:
	pshb
	ldb	#$10	; 16 loops * 2.5 uS = 40 uS
d_loop:	decb		; 3 cycles = 1.0 uS
	bne	d_loop	; 3 cycles = 1.5 uS
	pulb
	rts

*========================================================================
Write_Line_1:
*		; x points to start of NULL terminated line
	psha
	pshx
	ldaa	#$80		; Line 1 in Display Data RAM
	bra	Write_Line

*------------------------------------------------------------------------
Write_Line_2:
	psha
	pshx
	ldaa	#$A8		; Line 2 in Display Data RAM ($80 + 40 ($28))

*------------------------------------------------------------------------
Write_Line:
	bsr	Write_C_Byte
Next_Character:
	lda	$00,x
	beq	Write_Line_Done
	bsr	Write_D_Byte
	inx
	bra	Next_Character
Write_Line_Done:
	pulx
	pula
	rts

*========================================================================
Write_D_Byte:
	pshx
	ldx	#$501F		; Masks for Data mode
	bra	Write_LCD_Byte

*------------------------------------------------------------------------
Write_C_Byte:
	pshx
	ldx	#$400F		; Masks for Control mode

*------------------------------------------------------------------------
Write_LCD_Byte:
	stx	MODE_EH
	pulx
	psha
	lsra
	lsra
	lsra
	lsra
	bsr	Wait4BF
	bsr	Write_Nibble
	pula
	psha
	bsr	Write_Nibble
	cmpa	#$01	; if clear, then we need to wait 1.64 mS
	bne	Not_Clear
	ldaa	#$20	; 32 * 50uS = 1.6 mS
Do_Not_Clear:
	bsr	Wait4BF
	deca
	bne	Do_Not_Clear
Not_Clear:
	pula
	rts

*========================================================================
*		Write nibble is low 4 bits of A
Write_Nibble:
	psha
	anda	#$0F		; set upper 4 bits to zero
	oraa	MODE_EH		; E=H, R/W=L, RS=H or L
	staa	$1003
	anda	MODE_EL		; E=L, R/W=L, RS=H or L
	staa	$1003
	pula
	rts

*========================================================================
IntJmp	JMP	Interrupt	; Code to copy to RAM jump vector for Timer 1

*========================================================================
Inc_Timer:
	ldd	#TIMER_COUNT	; Add 50,000 to timer 1 to get next time
	addd	$1016		; timer
	std	$1016
	lda	#$80		; clear any pending events
	sta	$1023		; init routines assumes A = #$80
	rts
*========================================================================
*========================================================================
*    The timer is incremented every 500 nS, * 50000 = 25 mS * 40 = 1 Sec
Interrupt:
	dec	INT_COUNT
	bne	Over
	ldaa	#40	; 50000 * 500 nS * 40 = 1 second.
	staa	INT_COUNT
	bsr	Inc_Display
	ldx	#DIS_1_2
	bsr	Write_Line_2
Over:
	bsr	Inc_Timer
	rti
*    End of Interrupt
*========================================================================
*========================================================================
Inc_Display:
	ldx	#DIS_1_2
	bsr	Inc_Time
Not_Off_Hook:
	rts

*========================================================================
Inc_Time:
	inc	$0F,x			; Tenths
	ldaa	$0F,x
	cmpa	#'5
	bne	Over_Colon
	ldaa	#' 	; space
	staa	$0E,x
	staa	$0B,x
	staa	$08,x
	bra	Time_Done
Over_Colon:
	cmpa	#'9+1
	bne	Time_Done
	ldaa	#'0
	staa	$0F,x
	ldaa	#':
	staa	$0E,x
	staa	$0B,x
	staa	$08,x
	dex
	dex

	bsr	Inc_Digits		; Seconds
	cmpa	#'6
	bne	Time_Done
	bsr	Zero_Digit

	cmpa	#'6			; minutes
	bne	Time_Done
	bsr	Zero_Digit

	cpd	#'2'4			; Hours
	bne	Time_Done
	ldd	#'0'0
	std	$0E,x

Time_Done:
	rts

*========================================================================
Inc_Digits:
	inc	$0F,x
	ldaa	$0F,x
	cmpa	#'9+1
	bne	Dig_Done
	ldaa	#'0
	staa	$0F,x
	inc	$0E,x
Dig_Done:
	ldd	$0E,x	; get ready for cmp
	rts

*========================================================================
Zero_Digit:
	ldaa	#'0
	staa	$0E,x
	dex
	dex
	dex
	bsr	Inc_Digits
	rts

*========================================================================
*========================================================================
*    LCD Display tables
Display_1_1:
 fcc	"Tom's LCD Clock "
 fcb	$00
Display_1_2:
 fcc	"HMSt  00:00:00:0"
 fcb	$00
