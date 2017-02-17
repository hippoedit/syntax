*
*	File: midi.asm
*	Tom Dickens   4/3/1995
*
*	Purpose:  Demonstrate a basic MIDI driver for the 68HC11.
*
*	This file has a sample driving program which outpus a scale
*	in C major.
*
*	The MIDI device routines in this file are:
*   Init_MIDI:	Initialize the UART for MIDI.
*   NoteOn:	Turn on the note in register A out using MIDI.
*   NoteOff:	Turn off the note in register A out using MIDI.
*   MidiOut:	Send the byte in register A out using MIDI.
*			(used internally by NoteOn and NoteOff)
*
	ORG $B600	; Start of EEPROM

	jsr	Init_MIDI
Top:
	bsr	Delay
	ldaa	#60		; the note C
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#62		; the note D
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#64		; the note E
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#65		; the note F
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#67		; the note G
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#69		; the note A
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#71		; the note B
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	ldaa	#72		; the note C
	bsr	NoteOn
	bsr	Delay
	bsr	NoteOff
	bra	Top

Delay:
	pshy
	ldy	#$c000
d_loop	dey
	bne	d_loop
	puly
	rts

************************************************************************
*	MIDI device drivers:
************************************************************************
************************************************************************
* Initialize the UART for MIDI baud rates.
************************************************************************
Init_MIDI:
	clr	$1004	; Clears port B to $00
	inc	$1004	; Sets 1 to port B, enables the MIDI Rx/Tx
	ldx	#$1000	; setup X for address reference
	ldaa	#$20
	staa	$2b,X	; set baud rate to 31.25 KHz
	ldaa	#$00
	staa	$2c,X	; set 8 bit, 1 stop bit, & wakeup idle
	ldaa	#$08
	staa	$2d,X	; enable Rx and Tx, no interupts
	bclr	$28,X #$20 ; Turn DWOM off
	ldaa	$2f,X	; read Rx just in case...
	rts

NOTE_ON		EQU	$90
NOTE_OFF	EQU	$80
************************************************************************
*	Send a note-on event using MIDI.
*	Input:  The note is in register A
************************************************************************
NoteOn:
	psha		; remember A
	ldaa	#NOTE_ON
	bsr	MidiOut
	pula		; get a back
	psha		; remember A
	bsr	MidiOut
	ldaa	#127	; Full velocity
	bsr	MidiOut
	pula		; get a back
	rts
	
************************************************************************
*	Send a note-off event using MIDI.
*	Input:  The note is in register A
************************************************************************
NoteOff:
	psha		; remember A
	ldaa	#NOTE_OFF
	bsr	MidiOut
	pula		; get a back
	psha		; remember A
	bsr	MidiOut
	ldaa	#0	; No velocity
	bsr	MidiOut
	pula		; get a back
	rts
	
************************************************************************
*	Send a byte out for MIDI.
*	Input:  The byte is in register A
************************************************************************
MidiOut:
	pshx
	ldx	#$1000
TBFull	brclr	$2e,X #$80 TBFull	; Wait for Tx buffer to be empty
	staa	$2f,X			; send midi byte
	pulx
	rts
