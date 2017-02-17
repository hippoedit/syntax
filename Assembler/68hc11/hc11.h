****************************************************************************
***
***  68HC11 register equates 
***
***  1993 by P. Niklaus, Institute of Botany, University of Basel/Switzerland
***
****************************************************************************

REG	equ	$1000		;register base

PORTA	equ	REG+$00		;port a data reg.
PIOC	equ	REG+$02		;parallel i/o control reg.
PORTC	equ	REG+$03		;port c data reg.
PORTB	equ	REG+$04		;port b data reg.
PORTCL	equ	REG+$05		;port c latched data reg.
DDRC	equ	REG+$07		;port c data direction reg.
PORTD	equ	REG+$08		;port d data reg.
DDRD	equ	REG+$09		;port d data direction reg.
PORTE	equ	REG+$0a		;port e data reg.
CFORC	equ	REG+$0b		;timer compare force reg.
OC1M	equ	REG+$0c		;output compare 1 mask reg.
OC1D	equ	REG+$0d		;output compare 1 data reg.
TCNT	equ	REG+$0e		;timer count reg. 16 bit
TCNTH	equ	REG+$0e		;timer count reg. high
TCNTL	equ	REG+$0f		;timer count reg. low
TIC1	equ	REG+$10		;timer input capture reg
TIC1H	equ	REG+$10		;timer input capture reg. high
TIC1L	equ	REG+$11		;tic1 low
TIC2H	equ	REG+$12		;tic2 high
TIC2L	equ	REG+$13		;tic2 low
TIC3H	equ	REG+$14		;tic3 high
TIC3	equ	REG+$15		;tic3 low
TOC1	equ	REG+$16
TOC1H	equ	REG+$16		;timer output compare reg. high
TOC1L	equ	REG+$17		;toc1 low
TOC2	equ	REG+$18
TOC2H	equ	REG+$18		;toc2 high
TOC2L	equ	REG+$19		;toc2 low
TOC3	equ	REG+$1a
TOC3H	equ	REG+$1a		;toc3 high
TOC3L	equ	REG+$1b		;toc3 low
TOC4	equ	REG+$1c
TOC4H	equ	REG+$1c		;toc4 high
TOC4L	equ	REG+$1d		;toc4 low
TOC5	equ	REG+$1e
TOC5H	equ	REG+$1e		;toc5 high
TOC5L	equ	REG+$1f		;toc5 low
TCTL1	equ	REG+$20		;timer control reg. 1
TCTL2	equ	REG+$21		;timer control reg. 2
TMSK1	equ	REG+$22		;main timer interrupt mask reg.1
TFLG1	equ	REG+$23		;main timer interrupt flag reg.1
TMSK2	equ	REG+$24		;misk. timer interrupt mask reg.2
TFLG2	equ	REG+$25		;misc. timer interrupt flag
PACTL	equ	REG+$26		;pulse accumulator control reg.
PACNT	equ	REG+$27		;pulse accumulator count reg.
SPCR	equ	REG+$28		;spi control reg.
SPSR	equ	REG+$29		;spi status reg.
SPDR	equ	REG+$2a		;spi data reg.
BAUD	equ	REG+$2b		;sci baud rate control reg.
SCCR1	equ	REG+$2c		;sci control reg. 1
SCCR2	equ	REG+$2d		;sci control reg. 2
SCSR	equ 	REG+$2e		;sci status reg.
SCDR	equ	REG+$2f		;sci data reg.
ADCTL	equ	REG+$30		;a/d control/status reg.
ADR1	equ	REG+$31		;a/d result reg. 1
ADR2	equ	REG+$32		;a/d result reg. 2
ADR3	equ	REG+$33		;a/d result reg. 3
ADR4	equ	REG+$34		;a/d result reg. 4
BPROT   equ     REG+$35         ;block protect reg.
OPTION	equ	REG+$39		;system configuration options
COPRST	equ	REG+$3a		;arm/reset cop timer circuitry
PPROG	equ	REG+$3b		;eeprom programming reg.
HPRIO	equ	REG+$3c		;highest priority interrupt and misc.
INIT	equ	REG+$3d		;ram and i/o mapping reg.
TEST1	equ	REG+$3e		;factory test reg.
CONFIG	equ	REG+$3f		;configuration control reg.

OPORTA	equ	$00		;port a data reg.
OPIOC	equ	$02		;parallel i/o control reg.
OPORTC	equ	$03		;port c data reg.
OPORTB	equ	$04		;port b data reg.
OPORTCL	equ	$05		;port c latched data reg.
ODDRC	equ	$07		;port c data direction reg.
OPORTD	equ	$08		;port d data reg.
ODDRD	equ	$09		;port d data direction reg.
OPORTE	equ	$0a		;port e data reg.
OCFORC	equ	$0b		;timer compare force reg.
OOC1M	equ	$0c		;output compare 1 mask reg.
OOC1D	equ	$0d		;output compare 1 data reg.
OTCNTH	equ	$0e		;timer count reg. high
OTCNTL	equ	$0f		;timer count reg. low
OTIC1H	equ	$10		;timer input capture reg. high
OTIC1L	equ	$11		;tic1 low
OTIC2H	equ	$12		;tic2 high
OTIC2L	equ	$13		;tic2 low
OTIC3H	equ	$14		;tic3 high
OTIC3L	equ	$15		;tic3 low
OTOC1H	equ	$16		;timer output compare reg. high
OTOC1L	equ	$17		;toc1 low
OTOC2H	equ	$18		;toc2 high
OTOC2L	equ	$19		;toc2 low
OTOC3H	equ	$1a		;toc3 high
OTOC3L	equ	$1b		;toc3 low
OTOC4H	equ	$1c		;toc4 high
OTOC4L	equ	$1d		;toc4 low
OTOC5H	equ	$1e		;toc5 high
OTOC5L	equ	$1f		;toc5 low
OTCTL1	equ	$20		;timer control reg. 1
OTCTL2	equ	$21		;timer control reg. 2
OTMSK1	equ	$22		;main timer interrupt mask reg.1
OTFLG1	equ	$23		;main timer interrupt flag reg.1
OTMSK2	equ	$24		;misk. timer interrupt mask reg.2
OTFLG2	equ	$25		;misc. timer interrupt flag
OPACTL	equ	$26		;pulse accumulator control reg.
OPACNT	equ	$27		;pulse accumulator count reg.
OSPCR	equ	$28		;spi control reg.
OSPSR	equ	$29		;spi status reg.
OSPDR	equ	$2a		;spi data reg.
OBAUD	equ	$2b		;sci baud rate control reg.
OSCCR1	equ	$2c		;sci control reg. 1
OSCCR2	equ	$2d		;sci control reg. 2
OSCSR	equ 	$2e		;sci status reg.
OSCDR	equ	$2f		;sci data reg.
OADCTL	equ	$30		;a/d control/status reg.
OADR1	equ	$31		;a/d result reg. 1
OADR2	equ	$32		;a/d result reg. 2
OADR3	equ	$33		;a/d result reg. 3
OADR4	equ	$34		;a/d result reg. 4
OBPROT  equ     $35             ;block protect reg.
OOPTION	equ	$39		;system configuration options
OCOPRST	equ	$3a		;arm/reset cop timer circuitry
OPPROG	equ	$3b		;eeprom programming reg.
OHPRIO	equ	$3c		;highest priority interrupt and misc.
OINIT	equ	$3d		;ram and i/o mapping reg.
OTEST1	equ	$3e		;factory test reg.
OCONFIG	equ	$3f		;configuration control reg.

