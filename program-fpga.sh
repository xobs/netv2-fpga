#!/bin/sh
OPENOCD=/opt/openocd-netv2mvp/bin/openocd

if [ -z $1 ]
then
	echo "Usage: $0 [bitstream]"
	exit 1
fi

if [ ! -e $1 ]
then
	echo "Could not find bitstream file $1"
	exit 2
fi

# Raspi2 and Raspi3  peripheral_base address
gpio_peripheral_base_addr=0x3F000000

# Raspi1  peripheral_base address
# gpio_peripheral_base=0x20000000


# Speed coefficients

# Raspi3 BCM2837 (1200Mhz):
#gpio_speed_coeffs 194938 48

# Raspi3 B (oscope tuned)
#gpio_speed_coeffs 315000 24

# Raspip 3B+ (oscope tuned)
gpio_speed_coeffs="340000 10"

# Raspi2 BCM2836 (900Mhz):
# gpio_speed_coeffs 146203 36

# Raspi1 BCM2835: (700Mhz)
# gpio_speed_coeffs 113714 28


# verified with oscope to be about as fast as you want it to go
# on a 3B:
# TCK duty cycle is asymmetric, unstable at 10MHz
# starts to get marginal @ 6MHz, but solid at 5MHz
# on a 3B+:
# TCK duty cycle is solid at 6000MHz, using the correct speed coeffs above
#
# also, OpenOCD needs this patch:
#    pads_base[BCM2835_PADS_GPIO_0_27_OFFSET] = 0x5a000008 + 4; // 10mA drive coz we are terminated and want to go faster
# at line 472 in bcm2835gpio.c

$OPENOCD -c 'interface bcm2835gpio' \
	-c 'transport select jtag' \
	-c 'set _CHIPNAME xc7a35t' \
	-c "bcm2835gpio_peripheral_base ${gpio_peripheral_base_addr}" \
	-c "bcm2835gpio_speed_coeffs ${gpio_speed_coeffs}" \
	-c 'bcm2835gpio_jtag_nums 4 17 27 22' \
	-c 'bcm2835gpio_srst_num 24' \
	-c 'reset_config srst_only' \
	-c 'adapter_khz 6000' \
	-f 'cpld/xilinx-xc7.cfg' \
	-c 'init' \
	-c "pld load 0 $1" \
	-c 'exit'
