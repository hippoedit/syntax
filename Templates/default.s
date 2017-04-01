  	.syntax unified
	.cpu cortex-m3
	.fpu softvfp
	.thumb
	
	.global g_pfnVectors
	.global	Default_Handler

/*
** Passed from linker script
*/
        @.word _sidata  @ Adress of initialization data in flash.
        @.word _sdata   @ First address of data to initialize in .data section.
        @.word _edata   @ adress after initialization data
        @.word _sbss    @ First address of non-initialized data ( for Zero fill )
        @.word _ebss    @ address after non-initialized data

	.section .text.Reset_Handler
	.weak	Reset_Handler
	.type	Reset_Handler, %%function
Reset_Handler:
	/* Initialize .data â SRAM */
        LDR R1, =_sidata  @ From
        LDR R2, =_sdata   @ To
        LDR R3, =_edata   @ Eof
        SUBS R3, R2         @ R3 := size
         BLE NoCopyDSegEof  @ Less or equal
CopyDSegLoop:
	SUBS R3, #1
        LDRB R0, [R1, R3]
        STRB R0, [R2, R3]
         BGT CopyDSegLoop
NoCopyDSegEof:
        /* Zero .bss  */
        LDR R1, =_sbss
        LDR R2, =_ebss
        SUBS R2, R1
         BLE NoFillBss
        MOVS R0, #0
FillBssNext:
	SUBS R2, #1
        STRB R0, [R1, R2]
         BGT FillBssNext
NoFillBss:
        /* Initialization */
         B Main_Startup
	@@
	.size	Reset_Handler, .-Reset_Handler

@------------------------------------------------------------------------------
        .section .text.Default_Handler,"ax",%%progbits
Default_Handler:
         B .
	.size	Default_Handler, .-Default_Handler

/******************************************************************************
*
* The minimal vector table for a Cortex M3.  Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
*
******************************************************************************/
 	.section .isr_vector, "a", %%progbits
	.type	g_pfnVectors, %%object
	.size	g_pfnVectors, .-g_pfnVectors


g_pfnVectors:	
	@ 0x0000
	.word	_stack_init_value
	.word	Reset_Handler	 

	.word	NMI_Handler
	.word	HardFault_Handler
	@ 0x0010 
	.word	MemManage_Handler
	.word	BusFault_Handler
	.word	UsageFault_Handler
	.word	0
	@ 0x0020
	.word	0
	.word	0
	.word	0
	.word	SVC_Handler
	@ 0x0030
	.word	DebugMon_Handler
	.word	0
	.word	PendSV_Handler
	.word	SysTick_Handler
	@ 0x0040
	.word	WWDG_IRQHandler
	.word	PVD_IRQHandler
	.word	TAMPER_IRQHandler
	.word	RTC_IRQHandler
	@ 0x0050
	.word	FLASH_IRQHandler
	.word	RCC_IRQHandler
	.word	EXTI0_IRQHandler
	.word	EXTI1_IRQHandler
	@ 0x0060
	.word	EXTI2_IRQHandler
	.word	EXTI3_IRQHandler
	.word	EXTI4_IRQHandler
	.word	DMA1_Channel1_IRQHandler
	@ 0x0070
	.word	DMA1_Channel2_IRQHandler
	.word	DMA1_Channel3_IRQHandler
	.word	DMA1_Channel4_IRQHandler
	.word	DMA1_Channel5_IRQHandler
	@ 0x0080
	.word	DMA1_Channel6_IRQHandler
	.word	DMA1_Channel7_IRQHandler
	.word	ADC1_2_IRQHandler
	.word	CAN1_TX_IRQHandler
	@ 0x0090
	.word	CAN1_RX0_IRQHandler
 	.word	CAN1_RX1_IRQHandler
	.word	CAN1_SCE_IRQHandler
	.word	EXTI9_5_IRQHandler
	@ 0x00A0
	.word	TIM1_BRK_IRQHandler
	.word	TIM1_UP_IRQHandler
	.word	TIM1_TRG_COM_IRQHandler
	.word	TIM1_CC_IRQHandler
	@ 0x00B0
	.word	TIM2_IRQHandler
	.word	TIM3_IRQHandler
	.word	TIM4_IRQHandler
	.word	I2C1_EV_IRQHandler
	@ 0x00C0
	.word	I2C1_ER_IRQHandler
	.word	I2C2_EV_IRQHandler
	.word	I2C2_ER_IRQHandler
	.word	SPI1_IRQHandler
	@ 0x00D0
	.word	SPI2_IRQHandler
	.word	USART1_IRQHandler
	.word	USART2_IRQHandler
	.word	USART3_IRQHandler
	@ 0x00E0
	.word	EXTI15_10_IRQHandler
	.word	RTCAlarm_IRQHandler
	.word	OTG_FS_WKUP_IRQHandler
	.word	0  
	@ 0x00F0
	.word	0
	.word	0
	.word	0
	.word	0
	@ 0x0100
	.word	0
	.word	0
	.word TIM5_IRQHandler
	.word SPI3_IRQHandler
	@ 0x0110
	.word UART4_IRQHandler
	.word UART5_IRQHandler
  	.word TIM6_IRQHandler
  	.word TIM7_IRQHandler
	@ 0x0120
  	.word DMA2_Channel1_IRQHandler
  	.word DMA2_Channel2_IRQHandler
  	.word DMA2_Channel3_IRQHandler
  	.word DMA2_Channel4_IRQHandler
	@ 0x0130
  	.word DMA2_Channel5_IRQHandler
  	.word ETH_IRQHandler
  	.word ETH_WKUP_IRQHandler
  	.word CAN2_TX_IRQHandler
	@ 0x0140
  	.word CAN2_RX0_IRQHandler
  	.word CAN2_RX1_IRQHandler
  	.word CAN2_SCE_IRQHandler
  	.word OTG_FS_IRQHandler

/*******************************************************************************
*
* Provide weak aliases for each Exception handler to the Default_Handler.
* As they are weak aliases, any function with the same name will override
* this definition.
*
*******************************************************************************/
  	.weak	NMI_Handler
	.thumb_set NMI_Handler,Default_Handler

  	.weak	HardFault_Handler
	.thumb_set HardFault_Handler,Default_Handler

  	.weak	MemManage_Handler
	.thumb_set MemManage_Handler,Default_Handler

  	.weak	BusFault_Handler
	.thumb_set BusFault_Handler,Default_Handler

	.weak	UsageFault_Handler
	.thumb_set UsageFault_Handler,Default_Handler

	.weak	SVC_Handler
	.thumb_set SVC_Handler,Default_Handler

	.weak	DebugMon_Handler
	.thumb_set DebugMon_Handler,Default_Handler

	.weak	PendSV_Handler
	.thumb_set PendSV_Handler,Default_Handler

	.weak	SysTick_Handler
	.thumb_set SysTick_Handler,Default_Handler

	.weak	WWDG_IRQHandler
	.thumb_set WWDG_IRQHandler,Default_Handler

	.weak	PVD_IRQHandler
	.thumb_set PVD_IRQHandler,Default_Handler

	.weak	TAMPER_IRQHandler
	.thumb_set TAMPER_IRQHandler,Default_Handler

	.weak	RTC_IRQHandler
	.thumb_set RTC_IRQHandler,Default_Handler

	.weak	FLASH_IRQHandler
	.thumb_set FLASH_IRQHandler,Default_Handler

	.weak	RCC_IRQHandler
	.thumb_set RCC_IRQHandler,Default_Handler

	.weak	EXTI0_IRQHandler
	.thumb_set EXTI0_IRQHandler,Default_Handler

	.weak	EXTI1_IRQHandler
	.thumb_set EXTI1_IRQHandler,Default_Handler

	.weak	EXTI2_IRQHandler
	.thumb_set EXTI2_IRQHandler,Default_Handler

	.weak	EXTI3_IRQHandler
	.thumb_set EXTI3_IRQHandler,Default_Handler

	.weak	EXTI4_IRQHandler
	.thumb_set EXTI4_IRQHandler,Default_Handler

	.weak	DMA1_Channel1_IRQHandler
	.thumb_set DMA1_Channel1_IRQHandler,Default_Handler

	.weak	DMA1_Channel2_IRQHandler
	.thumb_set DMA1_Channel2_IRQHandler,Default_Handler

	.weak	DMA1_Channel3_IRQHandler
	.thumb_set DMA1_Channel3_IRQHandler,Default_Handler

	.weak	DMA1_Channel4_IRQHandler
	.thumb_set DMA1_Channel4_IRQHandler,Default_Handler

	.weak	DMA1_Channel5_IRQHandler
	.thumb_set DMA1_Channel5_IRQHandler,Default_Handler

	.weak	DMA1_Channel6_IRQHandler
	.thumb_set DMA1_Channel6_IRQHandler,Default_Handler

	.weak	DMA1_Channel7_IRQHandler
	.thumb_set DMA1_Channel7_IRQHandler,Default_Handler

	.weak	ADC1_2_IRQHandler
	.thumb_set ADC1_2_IRQHandler,Default_Handler

	.weak	CAN1_TX_IRQHandler
	.thumb_set CAN1_TX_IRQHandler,Default_Handler

	.weak	CAN1_RX0_IRQHandler
	.thumb_set CAN1_RX0_IRQHandler,Default_Handler

	.weak	CAN1_RX1_IRQHandler
	.thumb_set CAN1_RX1_IRQHandler,Default_Handler

	.weak	CAN1_SCE_IRQHandler
	.thumb_set CAN1_SCE_IRQHandler,Default_Handler

	.weak	EXTI9_5_IRQHandler
	.thumb_set EXTI9_5_IRQHandler,Default_Handler

	.weak	TIM1_BRK_IRQHandler
	.thumb_set TIM1_BRK_IRQHandler,Default_Handler

	.weak	TIM1_UP_IRQHandler
	.thumb_set TIM1_UP_IRQHandler,Default_Handler

	.weak	TIM1_TRG_COM_IRQHandler
	.thumb_set TIM1_TRG_COM_IRQHandler,Default_Handler

	.weak	TIM1_CC_IRQHandler
	.thumb_set TIM1_CC_IRQHandler,Default_Handler

	.weak	TIM2_IRQHandler
	.thumb_set TIM2_IRQHandler,Default_Handler

	.weak	TIM3_IRQHandler
	.thumb_set TIM3_IRQHandler,Default_Handler

	.weak	TIM4_IRQHandler
	.thumb_set TIM4_IRQHandler,Default_Handler

	.weak	I2C1_EV_IRQHandler
	.thumb_set I2C1_EV_IRQHandler,Default_Handler

	.weak	I2C1_ER_IRQHandler
	.thumb_set I2C1_ER_IRQHandler,Default_Handler

	.weak	I2C2_EV_IRQHandler
	.thumb_set I2C2_EV_IRQHandler,Default_Handler

	.weak	I2C2_ER_IRQHandler
	.thumb_set I2C2_ER_IRQHandler,Default_Handler

	.weak	SPI1_IRQHandler
	.thumb_set SPI1_IRQHandler,Default_Handler

	.weak	SPI2_IRQHandler
	.thumb_set SPI2_IRQHandler,Default_Handler

	.weak	USART1_IRQHandler
	.thumb_set USART1_IRQHandler,Default_Handler

	.weak	USART2_IRQHandler
	.thumb_set USART2_IRQHandler,Default_Handler

	.weak	USART3_IRQHandler
	.thumb_set USART3_IRQHandler,Default_Handler

	.weak	EXTI15_10_IRQHandler
	.thumb_set EXTI15_10_IRQHandler,Default_Handler

	.weak	RTCAlarm_IRQHandler
	.thumb_set RTCAlarm_IRQHandler,Default_Handler

	.weak	OTG_FS_WKUP_IRQHandler
	.thumb_set OTG_FS_WKUP_IRQHandler,Default_Handler

	.weak	TIM5_IRQHandler
	.thumb_set TIM5_IRQHandler,Default_Handler

	.weak	SPI3_IRQHandler
	.thumb_set SPI3_IRQHandler,Default_Handler

	.weak	UART4_IRQHandler
	.thumb_set UART4_IRQHandler,Default_Handler

	.weak	UART5_IRQHandler
	.thumb_set UART5_IRQHandler,Default_Handler

	.weak	TIM6_IRQHandler
	.thumb_set TIM6_IRQHandler,Default_Handler

	.weak	TIM7_IRQHandler
	.thumb_set TIM7_IRQHandler,Default_Handler

	.weak	DMA2_Channel1_IRQHandler
	.thumb_set DMA2_Channel1_IRQHandler,Default_Handler

	.weak	DMA2_Channel2_IRQHandler
	.thumb_set DMA2_Channel2_IRQHandler,Default_Handler

	.weak	DMA2_Channel3_IRQHandler
	.thumb_set DMA2_Channel3_IRQHandler,Default_Handler

	.weak	DMA2_Channel4_IRQHandler
	.thumb_set DMA2_Channel4_IRQHandler,Default_Handler

	.weak	DMA2_Channel5_IRQHandler
	.thumb_set DMA2_Channel5_IRQHandler,Default_Handler

	.weak	ETH_IRQHandler
	.thumb_set ETH_IRQHandler,Default_Handler

	.weak	ETH_WKUP_IRQHandler
	.thumb_set ETH_WKUP_IRQHandler,Default_Handler

	.weak	CAN2_TX_IRQHandler
	.thumb_set CAN2_TX_IRQHandler,Default_Handler

	.weak	CAN2_RX0_IRQHandler
	.thumb_set CAN2_RX0_IRQHandler,Default_Handler

	.weak	CAN2_RX1_IRQHandler
	.thumb_set CAN2_RX1_IRQHandler,Default_Handler

	.weak	CAN2_SCE_IRQHandler
	.thumb_set CAN2_SCE_IRQHandler,Default_Handler

	.weak	OTG_FS_IRQHandler
	.thumb_set OTG_FS_IRQHandler ,Default_Handler
