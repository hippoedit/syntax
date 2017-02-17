**-------------------------------------------------------------------------
**  LCD routines for HyperModule11
**-------------------------------------------------------------------------
**  Version 1.1.    13. 01. 96
**  (C)1993
**    -1999  by Pascal Niklaus and Lukas Zimmermann,
**		Institute of Botany,
**             	University of Basel/Switzerland
**
**  This program is free software; you can redistribute it and/or modify
**  it under the terms of the GNU General Public License as published by
**  the Free Software Foundation; either version 2 of the License, or
**  (at your option) any later version.
**
**  This program is distributed in the hope that it will be useful,
**  but WITHOUT ANY WARRANTY; without even the implied warranty of
**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
**  GNU General Public License for more details.
**  You should have received a copy of the GNU General Public License
**  along with this program; see the file COPYING.  If not, write to
**  the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
**  Boston, MA 02111-1307, USA.
**
**  You also can try to get the information from 'http://www.gnu.org'
**
**-------------------------------------------------------------------------
**
**  This module implements some functions for standard LCD modules 
**  with Hitachi compatible controllers. The original design is for
**  4 lines with 20 characters displays but can easily be modified for
**  different sizes.
**  Implemented functions include initialisation, cursor control, scrolling
**  and more.
**
**  The routines originally have been written for the HyperModule11 board 
**  which has been designed by the authors of this software.
**  A description of it's design can be found at 
**  http://pc1-archbo.bot.unibas.ch/~lukas/68hc11/
**
**  The HyperModule11 provides the ability to switch off and on LCD module's
**  power. Therefore routines for switching power and for saving and 
**  restoring the contents on the display are provided. These are of no great
**  use if a different hardware is used.
**
**  For the delays needed when initializing the LCD module an external
**  routine `msDelay' is needed.
**
**  This module assembles with as6k8 written by Till Straumann or with
**  Pass11 written by Pascal Niklaus. Both assemblers can be downloaded at
**  the site mentioned above. With slight modifications it should compile
**  with motorola freeware assembler and compatibles.
**
**-------------------------------------------------------------------------
**  History
**      ?.  ?. 93:  file created (P.N.)
**  by Lukas Zimmermann:
**     11.  5. 94:  changed for 20 x 4 characters LCD
**     13.  5. 94   LCDscroll added.
**     24.  5. 94   bug fixed in NewLine
**     25.  5. 94   Back space characters are interpreted
**     		    LCDbusy waits before LCD actions are invoked
**		    (not after them)
**     27.  5. 94   Save and restore LCD contents routines added
**     15.  4. 95   LCDactivate included. ( Power up and init. )
**     01.  6. 95   LCDinit checks now for presence of an LCD-Module
**     09. 10. 95   LCDeol corrected
**     13. 01. 96   LCDout accu B is restored now.
**     09-10-99     adaption for as6k8 assembler
**
***************************************************************************
**
**  The program which includes the LCD routines must specify the symbols
**  'LCD_var_start' and 'LCD_code'. They define RAM and program memory
**  spaces respectivly.
**
**  Be aware that the hardware, these routines have been written for inverts
**  the register select line of the LCD module. For a differnt hardware it
**  might be necessary to exchange the addresses of LCD's command and data
**  registers.
**
***************************************************************************
*** equates for LCD routines

#ifdef IOmap_mp3
*** mp3 application memory map
LCDcmd		equ	$8201		;command register
LCDdata		equ	$8200		;data register
#else
*** standard memory map
LCDcmd		equ	$1301		;command register
LCDdata		equ	$1300		;data register
#endif

****************************************************************************
*** to change LCD's width and hight you have to change the following

LCDmaxX		equ	19		;= characters/line - 1
LCDmaxY		equ	3		;= lines - 1

****************************************************************************
*** variables used by the LCD routines

		org	LCD_var_start
                
LCDx		rmb	1		;actual LCD cursor x coordinate
LCDy		rmb	1		;	LCD cursor y coordinate
LCDscrollOff	rmb	1		;if 0, scrolling is suppressed

LCDsaveArea	rmb	(LCDmaxX+1)*(LCDmaxY+1)
					;RAM area to save LCD contents
;make sure that the assembler you'r using
;supports these kind of expressions!
LCDsaveCur	rmb	2		;RAM area to save LCD cursor
LCDpresent	rmb	1		;0=no LCD connected

LCD_var_end

****************************************************************************
		org	LCD_code
                
LnAddr		fcb	0,$40,$14,$54   ;table of each line's 1st DDRAM-addr.

****************************************************************************
**  LCDinit:	Initialize LCD module & routines
** 		(do not access LCD before power up + 15 ms)
**
**		on entry: -
**		on exit : no registers affected
****************************************************************************
LCDinit
		psha
		pshx
		ldaa	#$38		;8 bits data bus
					;1/16 duty cycle, 5x7 dots font
		staa	LCDcmd
#ifdef CopActive
		jsr	CopReset
#endif
		ldx	#1367		;wait 1367 * (3 + 3) cycles
LCDinit0	dex			; = 4.1 ms @ 2MHz (11.5.94, LZi)
		bne	LCDinit0
		staa	LCDcmd		;repeat command
		ldx	#34		;wait 34 * (3 + 3) cycles
LCDinit1	dex			; = 100 us @ 2MHz (11.5.94, LZi)
		bne	LCDinit1
		staa	LCDcmd		;repeat command a 3rd time
		ldx	#14		;wait 14 * (3 + 3) cycles
LCDinit2	dex			; = 40 us @ 2MHz (11.5.94, LZi)
		bne	LCDinit2	; (= norm. cmnd exec time)
		staa	LCDcmd		;busy bit is accessible from now on.
		ldx	#3
		jsr	msDelay
	;check for LCD presence.
		ldab	#%10101010
LCDinitLoop	ldaa	#$80		;set Display Data RAM address to 0
		staa	LCDcmd
		ldx	#1		;delay until cmnd completed (>40us)
		jsr	msDelay
		stab	LCDdata		;write to DDRAM
		ldx	#1		;delay until cmnd completed (>40us)
		jsr	msDelay
		ldaa	#$80		;set Display Data RAM address to 0
		staa	LCDcmd
		ldx	#1		;delay until cmnd completed (>40us)
		jsr	msDelay
		cmpb	LCDdata		;check wether write to DDRAM successful 
		bne	LCDinitNoLCD	; no: LCD NOT present
		ldx	#1		;delay until cmnd completed (>40us)
		jsr	msDelay
		lsrb			;repeat 8x with different test data
		bne	LCDinitLoop
		bra	LCDinitContinue
		
LCDinitNoLCD	clr	LCDpresent
		bra	LCDinitEnd

LCDinitContinue ldaa	#$ff
		staa	LCDpresent
		staa	LCDscrollOff	;LCD scroll enabled
		jsr	LCDbusy
		ldaa	#$06		;increment, no display shift
		staa	LCDcmd
		jsr	LCDbusy
		ldaa	#$0f		;display on, cursor on, blinking
		staa	LCDcmd
		jsr	LCDbusy
		ldaa	#$80		;set DD-RAM address
		staa	LCDcmd		; (cursor to 1st position)
		jsr	LCDbusy
		bsr	LCDclear	;clear the display
LCDinitEnd	pulx
		pula
		rts

****************************************************************************
**  LCDeol:	Clear to end of line
**
**		on entry: -
**		on exit : no registers affected
****************************************************************************
LCDeol
		psha
		pshb
		jsr	LCDgetCrsr
		psha
LCDeol1		ldaa	LCDx
		cmpa	#LCDmaxX
		bgt	LCDeol2
		ldaa	#' '
		bsr	LCDbusy
		staa	LCDdata
		inc	LCDx
		bra	LCDeol1
LCDeol2		pula
		jsr	LCDsetCrsr
		pulb
		pula
		rts

****************************************************************************
**  LCDhome :	Set cursor home
**  LCDclear:	Clear display and set cursor home
**
**		on entry: -
**		on exit : no registers affected
****************************************************************************
LCDhome
		psha				;set cursor home
		ldaa	#$02
		bra	LCDclr1
LCDclear
		psha
		ldaa	#$01                    ;clear the display
LCDclr1		bsr	LCDbusy			;wait until busy=0
		staa	LCDcmd
		pula
		clr	LCDx			;coords = (0,0)
		clr	LCDy
		rts

****************************************************************************
**  LCDout :	Writes a character at cursor position onto LCD, line wrap at 
**		end of line. CR, LF, BS are interpreted correctly, (GS ($1d)
**		does a ClrEoL). With scroll at last line.
**
**		on entry: A contains the character to be printed
**		on exit : no other regs affected
****************************************************************************
LCDout		
;		psha			;!!!! delay for debuging
;		ldaa	#$30
;		jsr	Delay
;		pula
		cmpa	#$0a		;CR or LF ?
		beq	NewLine		;yes, start a new line
		cmpa	#$0d
		beq	CarrReturn
		cmpa	#$1d		;GS char clears to end of line
		beq	LCDeol	
		cmpa	#$8
		beq	LCDback		;BS char back spaces
		
		bsr	LCDbusy
		staa	LCDdata		;output char
		inc	LCDx
		psha
		ldaa	LCDx
		cmpa	#LCDmaxX		
		ble	LCDdone		;if not end of line reached: done!
		pshb
		ldab	LCDy		
		cmpb	#LCDmaxY	;else: check for last line
		bge 	DoScroll	;if not last line
		incb			;  then set cursor to next line
		clra			
		jsr	LCDsetCrsr
		pulb
		bra	LCDdone
DoScroll	pulb
		ldaa	LCDscrollOff	;  else scroll display
		beq	LCDdone		;    if ScrollOff = 0
		jsr	LCDscroll	
LCDdone		pula
		rts

****************************************************************************
**  LCDbusy :	Wait until LCD operation finished 
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDbusy
#ifdef CopActive
		jsr	CopReset
#endif
		tst	LCDpresent
		beq	LCDbusyEnd
		tst	LCDcmd
		bmi	LCDbusy
LCDbusyEnd	rts

****************************************************************************
**  LCDonCrsr :	Turn on the LCD cursor
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDonCrsr
		psha
		ldaa	#$0f		;cursor on, blinking
		bsr	LCDbusy
		staa	LCDcmd
		pula
		rts

****************************************************************************
**  LCDoffCrsr:	Turn off the LCD cursor
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDoffCrsr
		psha
		ldaa	#$0c
		bsr	LCDbusy
		staa	LCDcmd		;cursor off, blinking
		pula
		rts

****************************************************************************
**  CarrReturn:	moves LCD cursor to first position on same line
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
CarrReturn
		psha
		pshb		
		ldab	LCDy
		clra
		jsr	LCDsetCrsr
		pulb
		pula
		rts

****************************************************************************
**  NewLine :	Moves LCD cursor to the same position on the next line.
**		Scroll if cursor on last line
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
NewLine
		pshb		
		ldab	LCDy
		cmpb	#LCDmaxY
		bge	NLscroll
		psha	
		incb
		ldaa	LCDx
		jsr	LCDsetCrsr
		pula
		bra	NLdone
NLscroll	jsr	LCDscroll
NLdone		pulb
		rts

****************************************************************************
**  LCDback :	Moves cursor one character to the left,
**		if cursor is not on line's first position
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDback
		psha		
		pshb
		ldd	LCDx
		cmpa	#0
		beq	LCDbackDone
		deca
		jsr	LCDsetCrsr		
LCDbackDone	pulb
		pula
		rts

****************************************************************************
**  LCDgetCrsr:	Get LCD cursor's coordinates
**
**		on entry: -
**		on exit : A: X (0..LCDmaxX), B: Y (0..LCDmaxY)
**			  other regs unchanged
****************************************************************************
LCDgetCrsr
		ldaa	LCDx
		ldab	LCDy
		rts

****************************************************************************
**  LCDsetCrsr:	Set LCD cursors coordinates
**
**		on entry: A: X (0..LCDmaxX), B: Y (0..LCDmaxY)
**		on exit : all regs unchanged
****************************************************************************
LCDsetCrsr
		staa	LCDx
		stab	LCDy
		psha
		pshx
		ldx	#LnAddr
		abx
		adda	0,X

LCDsetC1	oraa	#$80		;LCD cmnd mask: set D-RAM addr.
		bsr	LCDbusy
		staa	LCDcmd
		pulx
		pula
		rts

****************************************************************************
**  LCDscroll:	Scrolls LCD contents one line upwards.
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDscroll
		psha
		pshb
		ldab	#1		;start with 2nd line
LCDscroll0	clra			;start with 1st char on line
LCDscroll1	jsr	LCDsetCrsr	;set cursor to source position
		bsr	LCDbusy
		ldaa	LCDdata		;get source character
		psha			;temp. save character
		ldaa	LCDx		;set cursor to destination position
		decb
		jsr	LCDsetCrsr
		incb			;return to source line
		pula
		jsr	LCDbusy
		staa	LCDdata		;write char to destination

		ldaa	LCDx		
		inca
		cmpa	#LCDmaxX
		ble	LCDscroll1	;repeat for all chars on line

		incb			;treat next line
		cmpb	#LCDmaxY
		ble	LCDscroll0	;if last line then done

		clra
		ldab	#LCDmaxY	;goto (0,LCDmaxY), clear to Eol
		jsr	LCDsetCrsr
		jsr	LCDeol			
		pulb
		pula
		rts

****************************************************************************
**  LCDoff:	Turn LCD's power off.
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDoff
		psha
		ldaa	PORTA
		oraa	#$10
		staa	PORTA
		pula
		rts

****************************************************************************
**  LCDon:	Turn LCD's power on.
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDon
		psha
		ldaa	PORTA
		anda	#$ff-$10
		staa	PORTA
		pula
		rts

****************************************************************************
**  LCDpwrOnDly:Delays the time needed for LCD, from power up to the first 
**		access to LCD's busy flag.
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDpwrOnDly
		pshx			;wait 15 ms
		ldx	#5000
LCDpodRep	dex
		bne	LCDpodRep
		pulx
		rts

***************************************************************************
**  LCDactivate:Switches LCD power on and initializes it
**
**		on entry: -
**		on exit : no regs affected
***************************************************************************
LCDactivate
		jsr	LCDon
		jsr	LCDpwrOnDly
		jsr	LCDinit
		rts

****************************************************************************
**  LCDsave:	Saves LCD's contents to uC's RAM (LCDsaveArea)
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDsave
		psha
		pshb
		pshx
		ldx	#LCDsaveArea	;load pointer to saving area
		ldaa	#$02
		jsr	LCDbusy		;wait until busy=0
		staa	LCDcmd		;set cursor home
		clrb
GetNxtLn	clra
		
GetNxtChr	pshb
		jsr	LCDbusy		;wait until busy=0
		ldab	LCDdata		;get char at cursor
		stab	0,X
		pulb
		inx
		inca
		cmpa	#LCDmaxX	;do until end of line
		bls	GetNxtChr

		incb
		cmpb	#LCDmaxY	;check if last line treated
		bhi	SaveDone	;yes: all done!

		pshx
		ldx	#LnAddr		;no: set LCD DDRAM address
		abx			;  to next line's beginning
		ldaa	0,X
		pulx
		oraa	#$80			
		jsr	LCDbusy
		staa	LCDcmd		;LCD set DDRAM address command
		bra	GetNxtLn		
		
SaveDone	ldd	LCDx		;save cursor position
		std	LCDsaveCur
		pulx
		pulb
		pula
		rts

****************************************************************************
**  LCDrestore:	Restores LCD's contents from previously saved data 
**		(LCDsaveArea)
**
**		on entry: -
**		on exit : no regs affected
****************************************************************************
LCDrestore
		psha
		pshb
		pshx
		ldx	#LCDsaveArea
		ldaa	#$02
		jsr	LCDbusy		;wait until busy=0
		staa	LCDcmd		;set cursor home
		clrb
PutNxtLn	clra
		
PutNxtChr	pshb
		ldab	0,X
		jsr	LCDbusy		;wait until busy=0
		stab	LCDdata		;restore char at cursor
		pulb
		inx
		inca
		cmpa	#LCDmaxX	;do until end of line
		bls	PutNxtChr

		incb
		cmpb	#LCDmaxY	;check if last line treated
		bhi	RestoDone	;yes: all done!

		pshx
		ldx	#LnAddr		;no: set LCD DDRAM address
		abx			;  to next line's beginning
		ldaa	0,X
		pulx
		oraa	#$80			
		jsr	LCDbusy
		staa	LCDcmd		;LCD set DDRAM address command
		bra	PutNxtLn		
		
RestoDone	ldd	LCDsaveCur	;restore saved cursor position
		std	LCDx
		jsr	LCDsetCrsr
		pulx
		pulb
		pula
		rts

LCD_code_end
************************* end of file **************************************
