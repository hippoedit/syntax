**-------------------------------------------------------------------------
**  Delay routines for Hypermodule11
**-------------------------------------------------------------------------
**  Version 1.0.     6.  9. 94
**
**  (C)1994  by Pascal Niklaus and Lukas Zimmermann,
**		Institute of Botany,
**             	University of Basel/Switzerland
**
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
**  This module implements two different delay routines. One with exact
**  (if not interrupted) milliseconds and the other a non linear amount
**  of time.
**
**  The routines originally have been written for the HyperModule11 board 
**  which has been designed by the authors of this software.
**  A description of it's design can be found at 
**  http://pc1-archbo.bot.unibas.ch/~lukas/68hc11/
**
**  This module assembles with as6k8 written by Till Straumann or with
**  Pass11 written by Pascal Niklaus. Both assemblers can be downloaded at
**  the site mentioned above. With slight modifications it should compile
**  with motorola freeware assembler and compatibles.
**
**-------------------------------------------------------------------------
**  History
**     ?.  ?. 94:   file created (P.N.)
**     6.  9. 94:   milliseconds delay routine (L.Zi)
**
**-------------------------------------------------------------------------

		org	 Delay_code
                
****************************************************************************
**  linear Delay routine  (delays IX * 2000 cycles = IX * 1ms @2MHz E clk)
**
**              on entry: IX register contains the number of ms to delay
**              on exit : IX = 0, CCR destroyed.
**                        no other register changed
****************************************************************************
msDelay		psha			;3cyc + jsr Delay (ext. addr.): 6cyc
		ldaa	#196		;2cyc  (1st outer loop 1970 cycles)
		nop			;2cyc
		nop			;2cyc
		brn	Dly1		;3cyc
		bra	Dly4		;3cyc  (=21cyc upto here)
Dly1		ldaa	#199		;2cyc  outer loop: 2000 cycles
Dly4		nop			;2cyc  |
Dly2		nop			;2cyc  |  inner loop: 10 cycles = 5us
		brn	Dly1		;3cyc  |  | used as 3 cycles nop
		deca			;2cyc  |  |
		bne	Dly2		;3cyc  |  |
		dex			;3cyc  |
		bne	Dly1		;3cyc  |
		pula			;4cyc  ( 21cyc + this 9cyc = 30cyc)
		rts			;5cyc

****************************************************************************
**  Delay                     
**
**  Wait a certain time, depending on the contents of A; no regs affected
**
****************************************************************************

Delay		psha
Delay0		psha
Delay1		psha
Delay2		deca
		bne	Delay2
		pula
		deca
		bne	Delay1
#ifdef CopActive
		jsr	CopReset
#endif
		pula
		deca
		bne	Delay0
		pula
		rts

Delay_code_end
************************** end of file *************************************
