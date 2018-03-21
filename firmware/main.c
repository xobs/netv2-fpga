#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <irq.h>
#include <uart.h>
#include <time.h>
#include <generated/csr.h>
#include <generated/mem.h>
#include "flags.h"
#include <console.h>
#include <system.h>

#include "config.h"
#include "ci.h"
#include "processor.h"
#include "pattern.h"


int main(void)
{
	irq_setmask(0);
	irq_setie(1);
	uart_init();
#ifdef CSR_HDMI_OUT0_I2C_W_ADDR
	hdmi_out0_i2c_init();
#endif

	puts("\nNeTV2 CPU testing software built "__DATE__" "__TIME__);

	config_init();
	time_init();

	processor_init();
	processor_update();
	processor_start(config_get(CONFIG_KEY_RESOLUTION));

	ci_prompt();

	printf( "hdmi_in1_frame_overflow_read %x\n", hdmi_in1_frame_overflow_read() );
	printf( "hdmi_in1_dma_frame_size_read %x\n", hdmi_in1_dma_frame_size_read() );
	printf( "hdmi_in1_dma_slot0_status_read %x\n", hdmi_in1_dma_slot0_status_read() );
	printf( "hdmi_in1_dma_slot0_address_read %x\n", hdmi_in1_dma_slot0_address_read() );
	printf( "hdmi_in1_dma_slot1_status_read %x\n", hdmi_in1_dma_slot1_status_read() );
	printf( "hdmi_in1_dma_slot1_addess_read %x\n", hdmi_in1_dma_slot1_address_read() );
	printf( "hdmi_in1_dma_ev_status_read %x\n", hdmi_in1_dma_ev_status_read() );
	printf( "hdmi_in1_dma_ev_pending_read %x\n", hdmi_in1_dma_ev_pending_read() );
	printf( "hdmi_in1_dma_ev_enable_read %x\n", hdmi_in1_dma_ev_enable_read() );

	processor_hdmi_out0_source = VIDEO_IN_HDMI_IN1;  // this is hard-wired in this scenario
	
	while(1) {
		processor_service();
		ci_service();
		//		pattern_service();  // don't use the pattern generator, save some bandwidth
		flush_l2_cache();
	}

	return 0;
}
