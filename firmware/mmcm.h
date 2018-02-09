#ifndef __MMCM_H
#define __MMCM_H

void mmcm_decode_clkreg1(unsigned int data);
void mmcm_decode_clkreg2(unsigned int data);
void mmcm_decode_divreg(unsigned int data);
void mmcm_decode_lockreg1(unsigned int data);
void mmcm_decode_lockreg2(unsigned int data);
void mmcm_decode_lockreg3(unsigned int data);
void mmcm_decode_filtreg1(unsigned int data);
void mmcm_decode_filtreg2(unsigned int data);
void mmcm_decode_power7(unsigned int data);
void mmcm_decode_reg(unsigned int adr, unsigned int data);

void hdmi_out0_mmcm_write(int adr, int data);
int hdmi_out0_mmcm_read(int adr);

#ifdef CSR_HDMI_IN0_CLOCKING_MMCM_DRDY_O_ADDR
void hdmi_in0_clocking_mmcm_write_o(int adr, int data);
int hdmi_in0_clocking_mmcm_read_o(int adr);
void hdmi_in0_clocking_mmcm_write(int adr, int data);
int hdmi_in0_clocking_mmcm_read(int adr);
#endif

#ifdef CSR_HDMI_IN1_CLOCKING_MMCM_DRDY_O_ADDR
void hdmi_in1_clocking_mmcm_write_o(int adr, int data);
int hdmi_in1_clocking_mmcm_read_o(int adr);
void hdmi_in1_clocking_mmcm_write(int adr, int data);
int hdmi_in1_clocking_mmcm_read(int adr);
#endif

void mmcm_config_for_clock(int freq);
void mmcm_dump(void);

#endif
