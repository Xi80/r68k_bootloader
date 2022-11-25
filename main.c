#include "startup.h"
#include <stdint.h>

uint8_t array[128];

signed main(void){
	for(uint8_t i = 0;i < 128;i++){
		array[i] = i;
	}
	while(1);
	return 0;
}