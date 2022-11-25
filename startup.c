#include "startup.h"


extern uint32_t __stack_top;

static void _init_board(void);
static void _reset_handler(void);

const volatile uintptr_t vectors[]
__attribute__((section(".isr_vector"))) = {
	/*Reset: Initial SSP*/
	(uintptr_t)(&__stack_top),
	/*Reset: Initial PC*/
	(uintptr_t)(&_reset_handler)
};

static void _init_board(void){
	/*Do nothing*/
}

static void _memcpy(uint8_t* dst,uint8_t* src,size_t size){
	while (size--) {
	    *dst++ = *src++;
	}
}

static void _memclr(uint8_t* dst,size_t size){
	while (size--) {
	    *dst++ = 0;
	}
}

static void _reset_handler(void){
	_init_board();
	
	/*Xfer Init Value*/
	extern uint8_t __data_top,__data_bottom,__text_bottom;
	size_t size = (size_t)(&__data_bottom - &__data_top);
	_memcpy(&__data_top,&__text_bottom,size);
	
	/*Memory Clear*/
	extern uint8_t __bss_bottom,__bss_top;
	size = (size_t)(&__bss_bottom - &__bss_top);
	_memclr(&__bss_top,size);
	
	/*Call main()*/
	asm("jmp main");
}