***********************************************************************
* Author: Tom Dickens
* Date: 12/10/2002
* Purpose:
* 8-bit random number generator for the 68HC11/68HC12 microcontrollers.
* Method: A 16-bit version of the classic S = S * M + A is used.
* The random number returned is the high byte of the new seed value.
* The constants M and A were chosen to be M=181 and A=359 for
* the following reasons:
*   - They are both prime numbers.
*   - The equation cycles through all 65,536 possible seed values.
*   - The 8-bit random values have the following properties:
*       - Each number from 0 to 255 occurs 256 times in the cycle.
*       - No sequence of 4 or more numbers is repeated.
*       - Every 128-byte window has an average between 104 and 150 (+-20%)
*       - Every 32-byte window has an average between 76 and 178 (+-40)
*       - Every 8-byte window has an average between 32 and 218 (+-75%)
*   - Small RAM and Program space required:
*       - Only 4 bytes of RAM are used
*       - Only 25 bytes of Program memory is used
*   - Fast. Each call to Random takes 64 clock cycles, which
*           is 32 micro-seconds with an 8MHz crystal.
* Usage:
*    JSR Random	; Register A contains the next random number.
***********************************************************************

***********************************************************************
* RAM Usage: 4 bytes in zero-page RAM, bytes 0 trough 3.
***********************************************************************
	ORG $0000

RandomSeed:
	RMB	2	; reserve two bytes in RAM for the SEED value
SEED_HIGH	EQU	RandomSeed	  ; high byte of the seed
SEED_LOW	EQU	RandomSeed+1  ; low byte of the seed

RandomScratch:
	RMB	2	; reserve 2 bytes in RAM for scratch space

***********************************************************************
* Constants:
***********************************************************************
MULTIPLIER	EQU	181
ADDER		EQU	359

***********************************************************************
* Program start: Example program to display random numbers on Port C.
*    Change ORG $B600 to $F800 for 'E2 devices.
***********************************************************************
	ORG $B600
	LDAA	#$FF
	STAA	$1007	; Set port C to output
	LDAA	#$00
	STAA	$1003		; Clears port C to $00
	BSR RandomInit	; Seed = 0
TopLoop:
	BSR Random		; A = random number
	STAA $1003		; A -> Port C
	LDX #$FFFF
	BSR DelayX		; wait a bit to see the number
	BRA TopLoop		; do it again...

***********************************************************************
* Initialize the random number generator to the start of the sequence
* by loading the seed value with 0. You can initialize the seed to any
* value you choose, which will start the random number sequence somewhere
* else in the cycle of 65,536 seed values.
***********************************************************************
RandomInit:
	CLR	SEED_HIGH
	CLR	SEED_LOW
	RTS

***********************************************************************
* Return the next 8-bit pseudo random number in the sequence
* of 65,536 numbers, generated from the following equation:
* SEED = SEED * 181 + 359
* The random value returned is the high byte of the new SEED.
* Return value: The A register.
*                             (bytes, cycles) = (25,64)
***********************************************************************
Random:
	PSHB				; (1,3) Remember the current value of B
* scratch = seed * multiplier
	LDAA	#MULTIPLIER		; (2,2) A = #181
	LDAB	SEED_LOW		; (2,3) B = the low byte of the seed
	MUL				; (1,10) D = A x B
	STD	RandomScratch		; (1,4) scratch = D
	LDAA	#MULTIPLIER		; (2,2) A = #181
	LDAB	SEED_HIGH		; (2,3) B = the high byte of the seed
	MUL				; (1,10) D = A x B
* low byte of MUL result is added to the high byte of scratch
	ADDB	RandomScratch		; (2,3) B = B + scratch_high
	STAB	RandomScratch		; (2,3) scratch = seed * 181
*
	LDD	RandomScratch		; (2,4) D = scratch
	ADDD	#ADDER			; (3,4) D = D + 359
	STD	RandomSeed		; (2,4) remember new seed value
* (A = SEED_HIGH from ADDD instruction)
	PULB				; (1,4) Restore the value of B
	RTS				; (1,5) A holds the new 8-bit random number

************************************************************************
*	DelayX:  Delay based on the value in.
************************************************************************
DelayX:
	PSHX
LoopX:
	DEX
	BNE	LoopX
	PULX
	RTS

