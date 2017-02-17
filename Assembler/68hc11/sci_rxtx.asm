**-------------------------------------------------------------------------
**  Interrupt driven serial routines for HyperModule11			   
**                                                                         
**  Both receive and send are done via queue buffers and interrupts.       
**-------------------------------------------------------------------------
**  Version 0.2.    04.10.95                                               
**                                                                         
**  (C)1993  by P. Niklaus and                                             
**  (C)1995  by Lukas Zimmermann,					  
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
**  History                                                                
**	      93:   file created (P.N.)					  
**	17.05.95:   L.Zi.: Extension of Serial.asm to interrupt driven	  
**			   send, and some cosmetic enhancement.		  
**	01.03.96:   L.Zi.: Change of SerInit: spurious Rx ints after ini- 
**			   tialisation are suppressed now.                
**	11.03.96:   L.Zi.: separate constant equates for receive and trans-
**			   mit buffer sizes: SerRxBufSize, SerTxBufSize.   
**		    !!!!   Be aware that SerOut does NOT wait until tx buf-
**		           fer is free but returns immediately indicating 
**		           buffer overflow by clearing carry flag.
**	09-03-99:   L.Zi.: modified for as6k8 assembler
**
*****************************************************************************
**
**  The program which includes the serial routines must specify the symbols
**  'Sci_var_start' and 'Sci_code'. They define RAM and program spaces respectivly.
**  Adjust 'SerRxBufSize' and 'SerTxBufSize' according to your needs.
**
**  Baud rate and other serial comm parameters are hardcoded to 9600/8/n/1.
**
**  Be aware that 'SerIn' routine loops until a char received, but SerOut doesn't
**  but returns immediatly if tx-buffer is full.
**
*****************************************************************************

*** general equates

JMPopcode	equ	$7e
RTIopcode	equ	$3b

*** equates for serial routines

***  masks for SCSR flags
TDRE		equ	$80		;transmit data register empty flag
TC		equ	$40		;transmit complete flag
RDRF		equ	$20		;receive data register full flag
IDLE		equ	$10		;idle line flag
ORF		equ	$08		;over run flag
NF		equ	$04		;noise flag
FE		equ	$02		;framing error flag

***  masks for SCCR2 bits
TIE		equ	$80		;transmit interrupt enable
TCIE		equ	$40		;transmit complete interrupt enable
RIE		equ	$20		;receive interrupt enable
ILIE		equ	$10		;idle line interrupt enable
TE		equ	$08		;transmitter enable
RE		equ	$04		;receiver enable


		org	Sci_var_start
                
SerRxBufSize	equ	$0100		;Size of serial receive buffer

SerRxBuf	rmb	SerRxBufSize	;Serial receive buffer
SerRxHead	rmb 	2		;Head pointer
SerRxTail	rmb 	2	 	;Tail pointer
RxCnt		rmb 	2		;Number of bytes in buffer
SerErrors	rmb	1 		;Error mask
				; 1=Buf.Overflow,2=Frame,4=Noise,8=Overrun

SerTxBufSize	equ	$0400		;Size of serial transmit buffer

SerTxBuf	rmb	SerTxBufSize	;Serial transmit buffer
SerTxHead	rmb 	2		;Head pointer
SerTxTail	rmb 	2	 	;Tail pointer
TxCnt		rmb 	2		;Number of bytes in buffer

Sci_var_end
****************************************************************************
		org	Sci_code
                
****************************************************************************
**  SerInit :	Initialize serial routines, install interrupt routine, 
**		enable rx int;
**
**		on entry: -
**		on exit : all regs including CC unchanged
****************************************************************************
SerInit
		psha			;save A,B and CC
		pshb
		tpa
		psha
		sei			;disable IRQ
		bsr	SerRxClr	;init pointers & other vars
		bsr	SerTxClr
		ldaa	#$30
		staa	BAUD		;9600 baud
		ldaa	#$00
		staa	SCCR1		;8 data bits, 1 stop bit
		ldaa	#JMPopcode	;install interrupt vector
		staa	SCI_vec
		ldd	#SerInt
		std	SCI_vec+1
		ldaa	SCSR		;clear flags: RDRF, NF, FE
		ldaa	SCDR
		ldaa	#RIE+TE+RE	;Rcv int enabled, Rcvr & Trnsmtr enabled
		staa	SCCR2
		pula
		tap			;restore CC (previous I state)
		pulb
		pula			;restore A,B
		rts

*****************************************************************************
**  SerExit :	Remove SCI interrupt handler, disable all SCI interrupts.
**
**		on entry: -
**		on exit : all regs unchanged
*****************************************************************************
SerExit
		psha			;save A
		sei			;disable IRQ
		ldaa	#$00		;disable receiver & transmitter & ints
		staa	SCCR2
		ldaa	SCSR		;clear interrupts, if any
		ldaa	SCDR
		ldaa	#RTIopcode	;for safety, write an RTI
		staa	SCI_vec
		cli			;enable IRQ
		pula			;restore A
		rts

*****************************************************************************
**  SerRxClr :	Clear serial input buffer & errors
**
**		on entry: -
**		on exit : all regs including CC unchanged
*****************************************************************************
SerRxClr
		pshx			;save X
		psha			;save A
		tpa
		psha			;save CCR
		sei			;disable IRQ
		ldx	#SerRxBuf	;reinitialize pointers
		stx 	SerRxHead
		stx	SerRxTail
		clr	RxCnt
		clr	RxCnt+1
		clr	SerErrors	;clear errors
		pula			;restore CCR
		tap
		pula                    ;restore A
		pulx			;restore X
		rts

*****************************************************************************
**  SerTxClr :	Clear serial output buffer
**
**		on entry: -
**		on exit : all regs including CC unchanged
*****************************************************************************
SerTxClr
		pshx			;save X
		psha			;save A
		tpa
		psha			;save CCR
		sei			;disable IRQ
		ldx	#SerTxBuf	;reinitialize pointers
		stx	SerTxTail
		stx 	SerTxHead
		clr	TxCnt
		clr	TxCnt+1
		ldx	#SCCR2		;disable transmit interrupts
		bclr	0,X,#TIE
		pula			;restore CCR
		tap
		pula                    ;restore A
		pulx			;restore X
		rts

*****************************************************************************
**  SerOut :	Send the character in A 
**		(via transmit queue, if transmitter busy).
**
**		on entry: A contains character to transmit.
**		on exit : sucessful if carry set, 
**			  buffer overflow if carry clear
**			  no other registers affected
*****************************************************************************
SerOut
		pshx
		sei			;disable interrupts
		ldx	TxCnt
		bne	QueueIt
		tst	SCSR		;test status register
		bpl	QueueIt		;if transmitter empty (no TIE) then
		staa	SCDR		;  send character
		sec			;  indicate success
		bra	SerOutDone
					;else:
QueueIt		cpx	#SerTxBufSize	;  queue tx char into tx buffer
					;is it full ?
		bhs	SerOutDone	;  indicate buffer overflow
		inx                     ;increase number of bytes in buffer
		stx	TxCnt
		cli			;enable interrupts
		ldx	SerTxHead
		staa	$00,X
		inx			;increase head ptr &
		cpx	#SerTxBuf+SerTxBufSize ;check wrap-around
		blo	SerOut0
		ldx	#SerTxBuf
SerOut0		stx	SerTxHead
		ldx	#SCCR2		;enable transmit interrupts
		bset	0,X,#TIE
		sec			;indicate success		
SerOutDone	cli
		pulx
		rts

****************************************************************************
SerOutWaiting
		pshx
		sei			;disable interrupts
		ldx	TxCnt
		bne	wQueueIt
		tst	SCSR		;test status register
		bpl	wQueueIt	;if transmitter empty (no TIE) then
		staa	SCDR		;  send character
		sec			;  indicate success
		bra	wSerOutDone
waitBuf
		cli			;give intr service routines
                nop			; the opportunity to run
                nop
                nop
                nop
                nop
                sei
					;else:
wQueueIt	cpx	#SerTxBufSize	;  queue tx char into tx buffer
					;is it full ?
		blo	waitBuf		;  wait
		inx                     ;increase number of bytes in buffer
		stx	TxCnt
		cli			;enable interrupts
		ldx	SerTxHead
		staa	$00,X
		inx			;increase head ptr &
		cpx	#SerTxBuf+SerTxBufSize ;check wrap-around
		blo	wSerOut0
		ldx	#SerTxBuf
wSerOut0	stx	SerTxHead
		ldx	#SCCR2		;enable transmit interrupts
		bset	0,X,#TIE
		sec			;indicate success		
wSerOutDone	cli
		pulx
		rts

*****************************************************************************
**  SerIn :	Get a character from receive buffer,
**		waits until buffer not empty.
**
**		on entry: -
**		on exit : character in A
**			  no other registers affected
*****************************************************************************
SerIn
		pshx			;save X
SerIn0
#ifdef CopActive
		jsr	CopReset
#endif
		ldx     RxCnt		;wait until there is a character
		beq	SerIn0		;in the buffer
		ldx	SerRxTail	;read it
		ldaa	$00,X
		inx			;incr. Tail pointer
		cpx	#SerRxBuf+SerRxBufSize	;wrap-around ?
		blo	SerIn1		;no
		ldx	#SerRxBuf	;yes, reset pointer
SerIn1		stx	SerRxTail
		sei			;disable IRQ
		ldx	RxCnt		;decrease count of bytes
		dex			;in buffer
		stx	RxCnt
		cli			;enable IRQ
		pulx			;restore X
		rts

*****************************************************************************
**  SerPeek :	Look at the next character in the input queue
**
**		on entry: -
**		on exit : character returned in A
**			  C=0: success, C=1: queue empty.
*****************************************************************************
SerPeek
		pshx
		ldx	RxCnt
		beq	SerPeek1
		ldx	SerRxTail
		ldaa	$00,X
		pulx
		clc
		rts
SerPeek1        pulx
		sec
		rts

*****************************************************************************
**  SerRxCnt :	Gets the number of characters in the receive queue.
**
**		on entry: -
**		on exit : X = number of characters in input queue
**			  no other registers affected
*****************************************************************************
SerRxCnt
		ldx	RxCnt
		rts

*****************************************************************************
**  SerTxCnt :	Gets the number of characters in the transmit queue.
**
**		on entry: -
**		on exit : X = number of characters in transmit queue
**			  no other registers affected
*****************************************************************************
SerTxCnt
		ldx	TxCnt
		rts

*****************************************************************************
**  SerRxAvail:	Tests wether there is a character available in input queue
**
**		on entry: -
**		on exit : Z = 1 if receive buffer not empty.
**			  no other registers affected
*****************************************************************************
SerRxAvail
		pshx
		ldx	RxCnt
		pulx
		rts

*****************************************************************************
**  SerTxAvail:	Tests wether the transmit queue is full
**
**		on entry: -
**		on exit : C = 0 if transmit buffer full.
**			  no other registers affected
*****************************************************************************
SerTxAvail
		pshx
		ldx	TxCnt
		cpx	#SerTxBufSize
TxAvDone	pulx
		rts

*****************************************************************************
**
**  SerInt:	SERIAL INTERRUPT SERVICE ROUTINE
**
*****************************************************************************
SerInt
		ldaa	SCSR		;load status register
		psha
		anda	#RDRF+ORF+NF+FE	;mask out RDRF & errors
		cmpa	#$20		;check for RDRF
		blo	SerTxInt	;no RDRF -> check for tx int
		ldab	SCDR		;load data register  (int flag clrd)
		anda	#ORF+NF+FE	;any error flag set?
		bne	SerInt2		;  yes: store errors
		ldx	RxCnt		;number of bytes in buffer ?
		cpx	#SerRxBufSize	;is it full ?
		bhs	SerInt3		;  yes: indicate buffer overflow
		inx                     ;increase number of bytes in buffer
		stx	RxCnt
		ldx	SerRxHead	;store received byte
		stab	$00,X
		inx			;increase head ptr &
		cpx	#SerRxBuf+SerRxBufSize ;check wrap-around
		blo	SerInt0
		ldx	#SerRxBuf
SerInt0		stx	SerRxHead
		bra	SerTxInt

SerInt3		ldaa	#$01		;set rx buffer ovflo flag
SerInt2		oraa	SerErrors
		staa	SerErrors	;write to SerErrors variable

SerTxInt	pula			;get saved status reg
		tsta
		bpl	SerIntDone	;no TDRE -> do nothing
		ldaa	SCCR2
		bpl	SerIntDone	;no TIE -> do nothing
		ldx	TxCnt
		beq	TxBufEmpty
		dex
		stx	TxCnt		;decrement tx buffer count
		ldx	SerTxTail
		ldab	0,X
		stab	SCDR		;send 
		inx			;increase tail pointer
		cpx	#SerTxBuf+SerTxBufSize ;check wrap-around
		blo	SerInt4
		ldx	#SerTxBuf
SerInt4		stx	SerTxTail	;update tail pointer variable
		ldx	TxCnt
		bne	SerIntDone	;if tx buf count = 0 then
TxBufEmpty	ldx	#SCCR2		;  disable tx interrupts
		bclr	0,X,#TIE

SerIntDone	rti            		;end of interrupt

Sci_code_end
		
***************************** end of file **********************************
