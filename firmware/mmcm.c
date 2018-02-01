#include <stdio.h>
#include <generated/csr.h>

#include "mmcm.h"

/*
 * Despite varying pixel clocks, we must keep the PLL VCO operating
 * in the specified range of 600MHz - 1200MHz.
 */
#ifdef CSR_HDMI_OUT0_BASE
void hdmi_out0_mmcm_write(int adr, int data) {
	hdmi_out0_driver_clocking_mmcm_adr_write(adr);
	hdmi_out0_driver_clocking_mmcm_dat_w_write(data);
	hdmi_out0_driver_clocking_mmcm_write_write(1);
	while(!hdmi_out0_driver_clocking_mmcm_drdy_read());
}

int hdmi_out0_mmcm_read(int adr) {
	hdmi_out0_driver_clocking_mmcm_adr_write(adr);
	hdmi_out0_driver_clocking_mmcm_read_write(1);
	while(!hdmi_out0_driver_clocking_mmcm_drdy_read());
	return hdmi_out0_driver_clocking_mmcm_dat_r_read();
}
#endif

#ifdef CSR_HDMI_IN0_BASE
void hdmi_in0_clocking_mmcm_write(int adr, int data) {
	hdmi_in0_clocking_mmcm_adr_write(adr);
	hdmi_in0_clocking_mmcm_dat_w_write(data);
	hdmi_in0_clocking_mmcm_write_write(1);
	while(!hdmi_in0_clocking_mmcm_drdy_read());
}

int hdmi_in0_clocking_mmcm_read(int adr) {
	hdmi_in0_clocking_mmcm_adr_write(adr);
	hdmi_in0_clocking_mmcm_read_write(1);
	while(!hdmi_in0_clocking_mmcm_drdy_read());
	return hdmi_in0_clocking_mmcm_dat_r_read();
}

static void hdmi_in_0_config_30_60mhz(void) {
	hdmi_in0_clocking_mmcm_write(0x14, 0x1000 | (10<<6) | 10); /* clkfbout_mult  = 20 */
	hdmi_in0_clocking_mmcm_write(0x08, 0x1000 | (10<<6) | 10); /* clkout0_divide = 20 */
	hdmi_in0_clocking_mmcm_write(0x0a, 0x1000 |  (8<<6) |  8); /* clkout1_divide = 16 */
	hdmi_in0_clocking_mmcm_write(0x0c, 0x1000 |  (2<<6) |  2); /* clkout2_divide =  4 */
	hdmi_in0_clocking_mmcm_write(0x0d, 0);                     /* clkout2_divide =  4 */
}

static void hdmi_in_0_config_60_120mhz(void) {
	hdmi_in0_clocking_mmcm_write(0x14, 0x1000 |  (5<<6) | 5); /* clkfbout_mult  = 10 */
	hdmi_in0_clocking_mmcm_write(0x08, 0x1000 |  (5<<6) | 5); /* clkout0_divide = 10 */
	hdmi_in0_clocking_mmcm_write(0x0a, 0x1000 |  (4<<6) | 4); /* clkout1_divide =  8 */
	hdmi_in0_clocking_mmcm_write(0x0c, 0x1000 |  (1<<6) | 1); /* clkout2_divide =  2 */
	hdmi_in0_clocking_mmcm_write(0x0d, 0);                    /* clkout2_divide =  2 */
}

static void hdmi_in_0_config_120_240mhz(void) {
	hdmi_in0_clocking_mmcm_write(0x14, 0x1000 |  (2<<6) | 3);  /* clkfbout_mult  = 5 (2/3) */
	hdmi_in0_clocking_mmcm_write(0x15, 1 << 7);                /* clkfbout_mult  = 5 (edge = 1) */
	hdmi_in0_clocking_mmcm_write(0x08, 0x1000 |  (2<<6) | 3);  /* clkout0_divide = 5 (2/3) */
	hdmi_in0_clocking_mmcm_write(0x09, 1 << 7);                /* clkout0_divide = 5 (edge = 1) */
	hdmi_in0_clocking_mmcm_write(0x0a, 0x1000 |  (2<<6) | 2);  /* clkout1_divide = 4 */
	hdmi_in0_clocking_mmcm_write(0x0c, 0x1000 |  (0<<6) | 0);  /* clkout2_divide = 1 */
	hdmi_in0_clocking_mmcm_write(0x0d, (1<<6));                /* clkout2_divide = 1 */
}

void mmcm_config_for_clock(int freq)
{
	/*
	 * FIXME: we also need to configure phase detector
	 */
	if(freq < 3000)
		printf("Frequency too low for input MMCMs\r\n");
	else if(freq < 6000)
		hdmi_in_0_config_30_60mhz();
	else if(freq < 12000)
		hdmi_in_0_config_60_120mhz();
	else if(freq < 24000)
		hdmi_in_0_config_120_240mhz();
	else
		printf("Frequency too high for input MMCMs\r\n");
}

#endif

void mmcm_decode_clkreg1(unsigned int data) {
  printf( "  0x%x: phase mux", (data >> 13) & 0x7 );
  printf( " 0x%x: reserved", (data >> 12) & 0x1 );
  printf( " 0x%x: high time", (data >> 6) & 0x3F );
  printf( " 0x%x: low time\n", (data >> 0) & 0x3F );
}

void mmcm_decode_clkreg2(unsigned int data) {
  printf( "  as int:" );
  printf( " 0x%x: reserved", (data >> 15) & 0x1 );
  printf( " 0x%x: frac", (data >> 12) & 0x7 );
  printf( " 0x%x: frac_en", (data >> 11) & 0x1 );
  printf( " 0x%x: frac_wf_r\n", (data >> 10) & 0x1 );
  
  printf( "  as frac:" );
  printf( " 0x%x: reserved", (data >> 14) & 0x3 );
  printf( " 0x%x: phase_mux_f_clkout0", (data >> 11) & 0x7 );
  printf( " 0x%x: frac_wf_f_clkout0\n", (data >> 10) & 0x1 );
  
  printf( "  both:" );
  printf( " 0x%x: mx", (data >> 8) & 0x3 );
  printf( " 0x%x: edge", (data >> 7) & 0x1 );
  printf( " 0x%x: no count", (data >> 6) & 0x1 );
  printf( " 0x%x: delay time\n", (data >> 0) & 0x3F );
}

void mmcm_decode_divreg(unsigned int data) {
  printf( "  0x%x: reserved", (data >> 14) & 0x3 );
  printf( " 0x%x: edge", (data >> 13) & 0x1 );
  printf( " 0x%x: no count", (data >> 12) & 0x1 );
  printf( " 0x%x: high time", (data >> 6) & 0x3f );
  printf( " 0x%x: low time\n", (data >> 0) & 0x3f );
}

void mmcm_decode_lockreg1(unsigned int data) {
  printf( "  0x%x: reserved", (data >> 10) & 0x3f );
  printf( " 0x%x: lktable[29:0]\n", (data >> 0) & 0x3FF );
}

void mmcm_decode_lockreg2(unsigned int data) {
  printf( "  0x%x: reserved", (data >> 15) & 0x1 );
  printf( " 0x%x: lktable[34:30]", (data >> 10) & 0x1F );
  printf( " 0x%x: lktable[9:0]\n", (data >> 0) & 0x3FFF );
}

void mmcm_decode_lockreg3(unsigned int data) {
  printf( "  0x%x: reserved", (data >> 15) & 0x1 );
  printf( " 0x%x: lktable[39:35]", (data >> 10) & 0x1F );
  printf( " 0x%x: lktable[19:10]\n", (data >> 0) & 0x3FFF );
}

void mmcm_decode_filtreg1(unsigned int data) {
  printf( "  0x%x: table[9]", (data >> 15) & 0x1 );
  printf( " 0x%x: reserved", (data >> 13) & 0x3 );
  printf( " 0x%x: table[8:7]", (data >> 11) & 0x3 );
  printf( " 0x%x: reserved", (data >> 9) & 0x3 );
  printf( " 0x%x: table[6]", (data >> 8) & 0x1 );
  printf( " 0x%x: reserved", (data >> 0) & 0xFF );
}

void mmcm_decode_filtreg2(unsigned int data) {
  printf( "  0x%x: table[5]", (data >> 15) & 0x1 );
  printf( " 0x%x: reserved", (data >> 13) & 0x3 );
  printf( " 0x%x: table[4:3]", (data >> 11) & 0x3 );
  printf( " 0x%x: reserved", (data >> 9) & 0x3 );
  printf( " 0x%x: table[2:1]", (data >> 7) & 0x3 );
  printf( " 0x%x: reserved", (data >> 5) & 0x3 );
  printf( " 0x%x: table[0]", (data >> 4) & 0x1 );
  printf( " 0x%x: reserved\n", (data >> 5) & 0xF );
}

void mmcm_decode_power7(unsigned int data) {
  printf( "  0x%x: power (must be high)\n", data & 0xFFFF );
}

void mmcm_decode_reg(unsigned int adr, unsigned int data) {

  switch(adr) {
  case 0x6:
    printf( "\nCLKOUT5 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0x8:
    printf( "\nCLKOUT0 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0xA:
    printf( "\nCLKOUT1 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0xC:
    printf( "\nCLKOUT2 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0xE:
    printf( "\nCLKOUT3 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0x10:
    printf( "\nCLKOUT4 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0x12:
    printf( "\nCLKOUT6 ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
  case 0x14:
    printf( "\nCLKFBOUT ClkReg1\n" );
    mmcm_decode_clkreg1(data);
    break;
    
  case 0x7:
    printf( "\nCLKOUT5 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0x9:
    printf( "\nCLKOUT0 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0xB:
    printf( "\nCLKOUT1 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0xD:
    printf( "\nCLKOUT2 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0xF:
    printf( "\nCLKOUT3 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0x11:
    printf( "\nCLKOUT4 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0x13:
    printf( "\nCLKOUT6 ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;
  case 0x15:
    printf( "\nCLKFBOUT ClkReg2\n" );
    mmcm_decode_clkreg2(data);
    break;

  case 0x16:
    printf( "\nDivReg\n" );
    mmcm_decode_divreg(data);
    break;

  case 0x18:
    printf( "\nLockReg1\n" );
    mmcm_decode_lockreg1(data);
    break;

  case 0x19:
    printf( "\nLockReg2\n" );
    mmcm_decode_lockreg2(data);
    break;

  case 0x1A:
    printf( "\nLockReg3\n" );
    mmcm_decode_lockreg3(data);
    break;

  case 0x28:
    printf( "\nPowerReg 7 series\n" );
    mmcm_decode_power7(data);
    break;

  case 0x4E:
    printf( "\nFiltReg1\n" );
    mmcm_decode_filtreg1(data);
    break;

  case 0x4F:
    printf( "\nFiltReg2\n" );
    mmcm_decode_filtreg2(data);
    break;

  default:
    printf( " %04x(r)", data );
  }
}

void mmcm_dump(void)
{
	int i;
#ifdef CSR_HDMI_OUT0_BASE
	printf("framebuffer MMCM:\r\n");
	for(i=0;i<128;i++)
		printf("%04x ", hdmi_out0_mmcm_read(i));
	printf("\r\n");
#endif
#ifdef CSR_HDMI_IN0_BASE
	printf("dvisampler MMCM:\r\n");
	for(i=0;i<128;i++)
	  //		printf("%04x ", hdmi_in0_clocking_mmcm_read(i));
	  mmcm_decode_reg(i, hdmi_in0_clocking_mmcm_read(i));
	printf("\r\n");
#endif
}
