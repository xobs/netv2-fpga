#!/usr/bin/env python3

## IMPORTANT: PYTHONHASHSEED should be set to "0" for best validation match

import sys
import os

from migen import *
from migen.genlib.resetsync import AsyncResetSynchronizer

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform, VivadoProgrammer

from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *
from litex.soc.cores import dna, xadc
from litex.soc.cores.frequency_meter import FrequencyMeter

from litedram.modules import MT41J128M16
from litedram.phy import a7ddrphy
from litedram.core import ControllerSettings

from litevideo.input import HDMIIn
from litevideo.output.hdmi.s7 import S7HDMIOutEncoderSerializer, S7HDMIOutPHY

from litevideo.output.common import *
from litevideo.output.core import VideoOutCore
from litevideo.output.hdmi.encoder import Encoder

from litex.soc.interconnect.csr import *

from liteeth.common import *

_io = [
    ("clk50", 0, Pins("J19"), IOStandard("LVCMOS33")),

    ("fpga_led0", 0, Pins("M21"), IOStandard("LVCMOS33")),
    ("fpga_led1", 0, Pins("N20"), IOStandard("LVCMOS33")),
    ("fpga_led2", 0, Pins("L21"), IOStandard("LVCMOS33")),
    ("fpga_led3", 0, Pins("AA21"), IOStandard("LVCMOS33")),
    ("fpga_led4", 0, Pins("R19"), IOStandard("LVCMOS33")),
    ("fpga_led5", 0, Pins("M16"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("E14")),
        Subsignal("rx", Pins("E13")),
        IOStandard("LVCMOS33"),
    ),

    ("serial", 1,
        Subsignal("tx", Pins("B17")), # hax 7
        Subsignal("rx", Pins("A18")), # hax 8
        IOStandard("LVCMOS33")
    ),

    ("ddram", 0,
        Subsignal("a", Pins(
            "U6 V4 W5 V5 AA1 Y2 AB1 AB3",
			"AB2 Y3 W6 Y1 V2 AA3"
            ),
            IOStandard("SSTL15")),
        Subsignal("ba", Pins("U5 W4 V7"), IOStandard("SSTL15")),
        Subsignal("ras_n", Pins("Y9"), IOStandard("SSTL15")),
        Subsignal("cas_n", Pins("Y7"), IOStandard("SSTL15")),
        Subsignal("we_n", Pins("V8"), IOStandard("SSTL15")),
        Subsignal("dm", Pins("G1 H4 M5 L3"), IOStandard("SSTL15")),
        Subsignal("dq", Pins(
            "C2 F1 B1 F3 A1 D2 B2 E2 "
            "J5 H3 K1 H2 J1 G2 H5 G3 "
            "N2 M6 P1 N5 P2 N4 R1 P6 "
            "K3 M2 K4 M3 J6 L5 J4 K6 "
            ),
            IOStandard("SSTL15"),
            Misc("IN_TERM=UNTUNED_SPLIT_50")),
        Subsignal("dqs_p", Pins("E1 K2 P5 M1"), IOStandard("DIFF_SSTL15")),
        Subsignal("dqs_n", Pins("D1 J2 P4 L1"), IOStandard("DIFF_SSTL15")),
        Subsignal("clk_p", Pins("R3"), IOStandard("DIFF_SSTL15")),
        Subsignal("clk_n", Pins("R2"), IOStandard("DIFF_SSTL15")),
        Subsignal("cke", Pins("Y8"), IOStandard("SSTL15")),
        Subsignal("odt", Pins("W9"), IOStandard("SSTL15")),
        Subsignal("reset_n", Pins("AB5"), IOStandard("LVCMOS15")),
        Subsignal("cs_n", Pins("V9"), IOStandard("SSTL15")),
        Misc("SLEW=FAST"),
    ),

    ("pcie_x1", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p", Pins("D11")),
        Subsignal("rx_n", Pins("C11")),
        Subsignal("tx_p", Pins("D5")),
        Subsignal("tx_n", Pins("C5"))
    ),

    ("pcie_x2", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p", Pins("D11 B10")),
        Subsignal("rx_n", Pins("C11 A10")),
        Subsignal("tx_p", Pins("D5 B6")),
        Subsignal("tx_n", Pins("C5 A6"))
    ),

    ("pcie_x4", 0,
        Subsignal("rst_n", Pins("E18"), IOStandard("LVCMOS33")),
        Subsignal("clk_p", Pins("F10")),
        Subsignal("clk_n", Pins("E10")),
        Subsignal("rx_p", Pins("D11 B10 D9 B8")),
        Subsignal("rx_n", Pins("C11 A10 C9 A8")),
        Subsignal("tx_p", Pins("D5 B6 D7 B4")),
        Subsignal("tx_n", Pins("C5 A6 C7 A4"))
    ),

    ("hdmi_in", 0,
        Subsignal("clk_p", Pins("L19"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("clk_n", Pins("L20"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data0_p", Pins("K21"), IOStandard("TMDS_33"), Inverted()),  # correct by design
        Subsignal("data0_n", Pins("K22"), IOStandard("TMDS_33"), Inverted()),
#        Subsignal("data2_p", Pins("K21"), IOStandard("TMDS_33"), Inverted()),   # incorrect
#        Subsignal("data2_n", Pins("K22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data1_p", Pins("J20"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data1_n", Pins("J21"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data2_p", Pins("J22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data2_n", Pins("H22"), IOStandard("TMDS_33"), Inverted()),
#        Subsignal("data0_p", Pins("J22"), IOStandard("TMDS_33"), Inverted()),
#        Subsignal("data0_n", Pins("H22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("scl", Pins("T18"), IOStandard("LVCMOS33")),
        Subsignal("sda", Pins("V18"), IOStandard("LVCMOS33")),
    ),

    # using normal HDMI cable
    # ("hdmi_in", 1,
    #     Subsignal("clk_p", Pins("Y18"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("clk_n", Pins("Y19"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("data0_p", Pins("AA18"), IOStandard("TMDS_33")),
    #     Subsignal("data0_n", Pins("AB18"), IOStandard("TMDS_33")),
    #     Subsignal("data1_p", Pins("AA19"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("data1_n", Pins("AB20"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("data2_p", Pins("AB21"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("data2_n", Pins("AB22"), IOStandard("TMDS_33"), Inverted()),
    #     Subsignal("scl", Pins("W17"), IOStandard("LVCMOS33"), Inverted()),
    #     Subsignal("sda", Pins("R17"), IOStandard("LVCMOS33")),
    # ),

    # using inverting jumper cable
    ("hdmi_in", 1,
     Subsignal("clk_p", Pins("Y18"), IOStandard("TMDS_33")),
     Subsignal("clk_n", Pins("Y19"), IOStandard("TMDS_33")),
     Subsignal("data0_p", Pins("AA18"), IOStandard("TMDS_33"), Inverted()),
     Subsignal("data0_n", Pins("AB18"), IOStandard("TMDS_33"), Inverted()),
     Subsignal("data1_p", Pins("AA19"), IOStandard("TMDS_33")),
     Subsignal("data1_n", Pins("AB20"), IOStandard("TMDS_33")),
     Subsignal("data2_p", Pins("AB21"), IOStandard("TMDS_33")),
     Subsignal("data2_n", Pins("AB22"), IOStandard("TMDS_33")),
     Subsignal("scl", Pins("W17"), IOStandard("LVCMOS33"), Inverted()),
     Subsignal("sda", Pins("R17"), IOStandard("LVCMOS33")),
     ),

    ("hdmi_out", 0,
        Subsignal("clk_p", Pins("W19"), Inverted(), IOStandard("TMDS_33")),
        Subsignal("clk_n", Pins("W20"), Inverted(), IOStandard("TMDS_33")),
        Subsignal("data0_p", Pins("W21"), IOStandard("TMDS_33")),
        Subsignal("data0_n", Pins("W22"), IOStandard("TMDS_33")),
        Subsignal("data1_p", Pins("U20"), IOStandard("TMDS_33")),
        Subsignal("data1_n", Pins("V20"), IOStandard("TMDS_33")),
        Subsignal("data2_p", Pins("T21"), IOStandard("TMDS_33")),
        Subsignal("data2_n", Pins("U21"), IOStandard("TMDS_33"))
    ),

    ("hdmi_out", 1,
        Subsignal("clk_p", Pins("G21"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("clk_n", Pins("G22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data0_p", Pins("E22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data0_n", Pins("D22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data1_p", Pins("C22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data1_n", Pins("B22"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data2_p", Pins("B21"), IOStandard("TMDS_33"), Inverted()),
        Subsignal("data2_n", Pins("A21"), IOStandard("TMDS_33"), Inverted()),
    ),

    ("hdmi_sda_over_up", 0, Pins("G20"), IOStandard("LVCMOS33")),
    ("hdmi_sda_over_dn", 0, Pins("F20"), IOStandard("LVCMOS33")), # must be mutex with the above

    ("hdmi_rx0_forceunplug", 0, Pins("M22"), IOStandard("LVCMOS33")), # forces an HPD on the RX0/TX0 path
    ("hdmi_rx0_forceplug", 0, Pins("N22"), IOStandard("LVCMOS33")),   # this needs to be mutex with the above

    ("hdmi_tx1_hpd_n", 0, Pins("U18"), IOStandard("LVCMOS33")),  # this is the internal hdmi-D port

    ("hdmi_tx1_cec", 0, Pins("P17"), IOStandard("LVCMOS33")),  # tx1/rx1 path
    ("hdmi_tx0_cec", 0, Pins("P20"), IOStandard("LVCMOS33")),  # tx0/rx0 path

    ("hdmi_ov0_cec", 0, Pins("P19"), IOStandard("LVCMOS33")),  # dedicated to the overlay input
    ("hdmi_ov0_hpd_n", 0, Pins("V17"), IOStandard("LVCMOS33")), # if the overlay input is plugged in

    # RMII PHY Pads
    ("rmii_eth_clocks", 0,
     Subsignal("ref_clk", Pins("D17"), IOStandard("LVCMOS33"))
     ),
    ("rmii_eth", 0,
     Subsignal("rst_n", Pins("F16"), IOStandard("LVCMOS33")),
     Subsignal("rx_data", Pins("A20 B18"), IOStandard("LVCMOS33")),
     Subsignal("crs_dv", Pins("C20"), IOStandard("LVCMOS33")),
     Subsignal("tx_en", Pins("A19"), IOStandard("LVCMOS33")),
     Subsignal("tx_data", Pins("C18 C19"), IOStandard("LVCMOS33")),
     Subsignal("mdc", Pins("F14"), IOStandard("LVCMOS33")),
     Subsignal("mdio", Pins("F13"), IOStandard("LVCMOS33")),
     Subsignal("rx_er", Pins("B20"), IOStandard("LVCMOS33")),
     Subsignal("int_n", Pins("D21"), IOStandard("LVCMOS33")),
     ),
]


class Platform(XilinxPlatform):
    def __init__(self, toolchain="vivado", programmer="vivado"):
        XilinxPlatform.__init__(self, "xc7a35t-fgg484-2", _io,
                                toolchain=toolchain)

        # NOTE: to do quad-SPI mode, the QE bit has to be set in the SPINOR status register
        # OpenOCD won't do this natively, have to find a work-around (like using iMPACT to set it once)
        self.add_platform_command(
            "set_property CONFIG_VOLTAGE 3.3 [current_design]")
        self.add_platform_command(
            "set_property CFGBVS VCCO [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]")
        self.toolchain.bitstream_commands = [
            "set_property CONFIG_VOLTAGE 3.3 [current_design]",
            "set_property CFGBVS VCCO [current_design]",
            "set_property BITSTREAM.CONFIG.CONFIGRATE 66 [current_design]",
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 2 [current_design]",
        ]
        self.toolchain.additional_commands = \
            ["write_cfgmem -verbose -force -format bin -interface spix2 -size 64 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.programmer = programmer

#        self.add_platform_command("""
#create_clock -name pcie_phy_clk -period 10.0 [get_pins {{pcie_phy/pcie_support_i/pcie_i/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtp_channel.gtpe2_channel_i/TXOUTCLK}}]
#""")

    def create_programmer(self):
        if self.programmer == "vivado":
            return VivadoProgrammer(flash_part="n25q128-3.3v-spi-x1_x2_x4")
        else:
            raise ValueError("{} programmer is not supported"
                             .format(self.programmer))

    def do_finalize(self, fragment):
        XilinxPlatform.do_finalize(self, fragment)


def csr_map_update(csr_map, csr_peripherals):
    csr_map.update(dict((n, v)
        for v, n in enumerate(csr_peripherals, start=max(csr_map.values()) + 1)))


def period_ns(freq):
    return 1e9/freq


class CRG(Module):
    def __init__(self, platform):
        self.clock_domains.cd_sys = ClockDomain()
        self.clock_domains.cd_sys4x = ClockDomain(reset_less=True)
        self.clock_domains.cd_sys4x_dqs = ClockDomain(reset_less=True)
        self.clock_domains.cd_clk200 = ClockDomain()
        self.clock_domains.cd_clk100 = ClockDomain()
        self.clock_domains.cd_eth = ClockDomain()

        clk50 = platform.request("clk50")
        rst = Signal()

        pll_locked = Signal()
        pll_fb = Signal()
        self.pll_sys = Signal()
        pll_sys4x = Signal()
        pll_sys4x_dqs = Signal()
        pll_clk200 = Signal()
        pll_clk50 = Signal()
        self.specials += [
            Instance("MMCME2_ADV",
                     p_STARTUP_WAIT="FALSE", o_LOCKED=pll_locked, p_SS_EN="TRUE", p_SS_MODE="DOWN_LOW", p_BANDWIDTH="LOW",

                     # VCO @ 1600 MHz
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=20.0,
                     p_CLKFBOUT_MULT_F=16.0, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=clk50, i_CLKFBIN=pll_fb, o_CLKFBOUT=pll_fb,

                     # 100 MHz
                     p_CLKOUT0_DIVIDE_F=8, p_CLKOUT0_PHASE=0.0,
                     o_CLKOUT0=self.pll_sys,

                     # 400 MHz
                     p_CLKOUT1_DIVIDE=2, p_CLKOUT1_PHASE=0.0,
                     o_CLKOUT1=pll_sys4x,

                     # 400 MHz dqs
                     p_CLKOUT5_DIVIDE=2, p_CLKOUT5_PHASE=90.0,
                     o_CLKOUT5=pll_sys4x_dqs,

                     # 200 MHz
                     p_CLKOUT6_DIVIDE=4, p_CLKOUT6_PHASE=0.0,
                     o_CLKOUT6=pll_clk200,

                     # 50 MHz
                     p_CLKOUT4_DIVIDE=16, p_CLKOUT4_PHASE=0.0,
                     o_CLKOUT4=pll_clk50,

            ),
            Instance("BUFG", i_I=self.pll_sys, o_O=self.cd_sys.clk),
            Instance("BUFG", i_I=self.pll_sys, o_O=self.cd_clk100.clk),
            Instance("BUFG", i_I=pll_clk200, o_O=self.cd_clk200.clk),
            Instance("BUFG", i_I=pll_sys4x, o_O=self.cd_sys4x.clk),
            Instance("BUFG", i_I=pll_sys4x_dqs, o_O=self.cd_sys4x_dqs.clk),
            Instance("BUFG", i_I=pll_clk50, o_O=self.cd_eth.clk),
            AsyncResetSynchronizer(self.cd_sys, ~pll_locked | rst),
            AsyncResetSynchronizer(self.cd_clk200, ~pll_locked | rst),
            AsyncResetSynchronizer(self.cd_clk100, ~pll_locked | rst)
        ]
        platform.add_platform_command(
            "set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets clk50_IBUF]")

        reset_counter = Signal(4, reset=15)
        ic_reset = Signal(reset=1)
        self.sync.clk200 += \
            If(reset_counter != 0,
                reset_counter.eq(reset_counter - 1)
            ).Else(
                ic_reset.eq(0)
            )
        self.specials += Instance("IDELAYCTRL", i_REFCLK=ClockSignal("clk200"), i_RST=ic_reset)


class BaseSoC(SoCSDRAM):
    csr_peripherals = [
        "ddrphy",
#        "dna",
        "xadc",
    ]
    csr_map_update(SoCSDRAM.csr_map, csr_peripherals)

    def __init__(self, platform, **kwargs):
        clk_freq = int(100e6)
        SoCSDRAM.__init__(self, platform, clk_freq,
            integrated_rom_size=0x6000,
            integrated_sram_size=0x4000,
            #shadow_base=0x00000000,
            ident="NeTV2 LiteX Base SoC",
            reserve_nmi_interrupt=False,
            **kwargs)

        self.submodules.crg = CRG(platform)
#        self.submodules.dna = dna.DNA()
        self.submodules.xadc = xadc.XADC()

        self.crg.cd_sys.clk.attr.add("keep")
        platform.add_period_constraint(self.crg.cd_sys.clk, period_ns(100e6))

        # sdram
        self.submodules.ddrphy = a7ddrphy.A7DDRPHY(platform.request("ddram"))
        sdram_module = MT41J128M16(self.clk_freq, "1:4")
        self.add_constant("READ_LEVELING_BITSLIP", 3)
        self.add_constant("READ_LEVELING_DELAY", 14)
        self.register_sdram(self.ddrphy,
                            sdram_module.geom_settings,
                            sdram_module.timing_settings,
                            controller_settings=ControllerSettings(with_bandwidth=True,
                                                                   cmd_buffer_depth=8,
                                                                   with_refresh=False))

        # common led
        self.sys_led = Signal()
        self.pcie_led = Signal()
        self.comb += platform.request("fpga_led0", 0).eq(self.sys_led ^ self.pcie_led) #TX0 green
        self.comb += platform.request("fpga_led1", 0).eq(0) #TX0 red


        # sys led
        sys_counter = Signal(32)
        self.sync += sys_counter.eq(sys_counter + 1)
        self.comb += self.sys_led.eq(sys_counter[26])


class RectOpening(Module, AutoCSR):
    def __init__(self, timing_stream):

        self.hrect_start = CSRStorage(12)
        self.hrect_end = CSRStorage(12)
        self.vrect_start = CSRStorage(12)
        self.vrect_end = CSRStorage(12)
        self.rect_thresh = CSRStorage(8)

        self.rect_on = Signal()

        # counter for pixel position based on the incoming HDMI0 stream.
        # use this instead of programmed values because we want to sync to non-compliant data streams
        self.hcounter = hcounter = Signal(hbits)
        self.vcounter = vcounter = Signal(vbits)

        in0_de = Signal()
        in0_de_r = Signal()
        in0_vsync = Signal()
        in0_vsync_r = Signal()
        in0_hsync = Signal()
        in0_hsync_r = Signal()
        self.sync += [  # rename this to the pix_o domain for the NeTV2 application
            in0_de.eq(timing_stream.de),
            in0_de_r.eq(in0_de),
            in0_vsync.eq(timing_stream.vsync),
            in0_vsync_r.eq(in0_vsync),
            in0_hsync.eq(timing_stream.hsync),
            in0_hsync_r.eq(in0_hsync),

            If(in0_vsync & ~in0_vsync_r,
               vcounter.eq(0)
               ).Elif(in0_hsync & ~ in0_hsync_r,
                      vcounter.eq(vcounter + 1)
                      ),
            If(in0_de & ~in0_de_r,
               hcounter.eq(0),
               ).Elif(in0_de,
                      hcounter.eq(hcounter + 1)
                      )
        ]

        #        self.comb += rect_on.eq(((hcounter_pix_o > 900) & (hcounter_pix_o < 910) & (vcounter_pix_o > 300) & (vcounter_pix_o < 310))  == 1)
        self.comb += self.rect_on.eq(((hcounter > self.hrect_start.storage) & (hcounter < self.hrect_end.storage) &
                                      (vcounter > self.vrect_start.storage) & (vcounter < self.vrect_end.storage))  == 1)

rgb_layout = [
    ("r", 8),
    ("g", 8),
    ("b", 8)
]

class TimingDelayRGB(Module):
    def __init__(self, latency):
        self.sink = stream.Endpoint(rgb_layout)
        self.source = stream.Endpoint(rgb_layout)

        # # #

        for name in list_signals(rgb_layout):
            s = getattr(self.sink, name)
            for i in range(latency):
                next_s = Signal(len(s))  # without len(s), this makes only one-bit wide delay lines
                self.sync += next_s.eq(s)
                s = next_s
            self.comb += getattr(self.source, name).eq(s)

class VideoOverlaySoC(BaseSoC):
    csr_peripherals = [
        "hdmi_core_out0",
        "hdmi_in0",
        "hdmi_in0_freq",
        "hdmi_in0_edid_mem",
        "hdmi_in1",
        "hdmi_in1_freq",
        "hdmi_in1_edid_mem",  
        "rectangle",
        "analyzer",
        "phy",
        "core"
    ]
    csr_map_update(BaseSoC.csr_map, csr_peripherals)

    interrupt_map = {
        "hdmi_in1": 3,
    }
    interrupt_map.update(BaseSoC.interrupt_map)

    def __init__(self, platform, *args, **kwargs):
        BaseSoC.__init__(self, platform, *args, **kwargs)

        # # #

        pix_freq = 148.50e6

        ########## hdmi in 0 (raw tmds)
        hdmi_in0_pads = platform.request("hdmi_in", 0)
        self.submodules.hdmi_in0_freq = FrequencyMeter(period=self.clk_freq)
        self.submodules.hdmi_in0 = HDMIIn(hdmi_in0_pads, device="xc7", split_mmcm=True, hdmi=True)
        self.comb += self.hdmi_in0_freq.clk.eq(self.hdmi_in0.clocking.cd_pix.clk)
        # don't add clock timings here, we add a root clock constraint that derives the rest automatically

        # define path constraints individually to sysclk to avoid accidentally declaring other inter-clock paths as false paths
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in0.clocking.cd_pix.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in0.clocking.cd_pix1p25x.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in0.clocking.cd_pix5x.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in0.clocking.cd_pix_o.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in0.clocking.cd_pix5x_o.clk
        )

        hdmi_out0_pads = platform.request("hdmi_out", 0)
        self.submodules.hdmi_out0_clk_gen = S7HDMIOutEncoderSerializer(hdmi_out0_pads.clk_p, hdmi_out0_pads.clk_n, bypass_encoder=True)
        self.comb += self.hdmi_out0_clk_gen.data.eq(Signal(10, reset=0b0000011111))
        self.submodules.hdmi_out0_phy = S7HDMIOutPHY(hdmi_out0_pads, mode="raw")

        # hdmi over
        self.comb += [
            platform.request("hdmi_sda_over_up").eq(0),
            platform.request("hdmi_sda_over_dn").eq(0),
        ]

        platform.add_platform_command(
            "set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets hdmi_in_ibufds/ob]")

        # extract timing info from HDMI input 0, and put it into a stream that we can pass later on as a genlock object
        self.hdmi_in0_timing = hdmi_in0_timing = stream.Endpoint(frame_timing_layout)
        self.sync.pix_o += [
            hdmi_in0_timing.de.eq(self.hdmi_in0.syncpol.de),
            hdmi_in0_timing.hsync.eq(self.hdmi_in0.syncpol.hsync),
            hdmi_in0_timing.vsync.eq(self.hdmi_in0.syncpol.vsync),
            If(self.hdmi_in0.syncpol.valid_o,
                hdmi_in0_timing.valid.eq(1),
            ).Else(
                hdmi_in0_timing.valid.eq(0),
            )
        ]

        ########## hdmi in 1
        hdmi_in1_pads = platform.request("hdmi_in", 1)
        self.submodules.hdmi_in1_freq = FrequencyMeter(period=self.clk_freq)
        self.submodules.hdmi_in1 = HDMIIn(hdmi_in1_pads,
                                         self.sdram.crossbar.get_port(mode="write"),
                                         fifo_depth=1024,
                                         device="xc7",
                                         split_mmcm=False,
                                         mode="rgb",
                                         hdmi=True
                                          )
        self.comb += self.hdmi_in1_freq.clk.eq(self.hdmi_in1.clocking.cd_pix.clk)

        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in1.clocking.cd_pix.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in1.clocking.cd_pix1p25x.clk
        )
        self.platform.add_false_path_constraints(
            self.crg.cd_sys.clk,
            self.hdmi_in1.clocking.cd_pix5x.clk
        )

        ######## Constraints
        # instantiate fundamental clocks -- Vivado will derive the rest via PLL programmings
        self.platform.add_platform_command(
            "create_clock -name clk50 -period 20.0 [get_nets clk50]")
        self.platform.add_platform_command(
            "create_clock -name hdmi_in0_clk_p -period 6.734006734006734 [get_nets hdmi_in0_clk_p]")
        self.platform.add_platform_command(
            "create_clock -name hdmi_in1_clk_p -period 6.734006734006734 [get_nets hdmi_in1_clk_p]")

        # exclude all generated clocks from the fundamental HDMI cloks and sys clocks
        self.platform.add_platform_command("set_clock_groups -group [get_clocks -include_generated_clocks -of [get_nets sys_clk]] -group [get_clocks -include_generated_clocks -of [get_nets hdmi_in0_clk_p]] -asynchronous")
        self.platform.add_platform_command("set_clock_groups -group [get_clocks -include_generated_clocks -of [get_nets sys_clk]] -group [get_clocks -include_generated_clocks -of [get_nets hdmi_in1_clk_p]] -asynchronous")

        # make sure derived clocks get named correctly
        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in0_pix_clk [get_pins MMCME2_ADV/CLKOUT0]")
        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in0_pix1p25x_clk [get_pins MMCME2_ADV/CLKOUT1]")
        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in0_pix5x_clk [get_pins MMCME2_ADV/CLKOUT2]")
        self.platform.add_platform_command("create_clock_generated_clock -name pix_o_clk [get_pins PLLE2_ADV/CLKOUT0]")
        self.platform.add_platform_command("create_clock_generated_clock -name pix5x_o_clk [get_pins PLLE2_ADV/CLKOUT2]")

        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in1_pix_clk [get_pins MMCME2_ADV_1/CLKOUT0]")
        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in1_pix1p25x_clk [get_pins MMCME2_ADV_1/CLKOUT1]")
        self.platform.add_platform_command("create_clock_generated_clock -name hdmi_in1_pix5x_clk [get_pins MMCME2_ADV_1/CLKOUT2]")

        # don't time the high-fanout reset paths
        self.platform.add_platform_command("set_false_path -through [get_nets hdmi_in1_pix_rst]")
        self.platform.add_platform_command("set_false_path -through [get_nets hdmi_in0_pix_rst]")
        self.platform.add_platform_command("set_false_path -through [get_nets hdmi_in1_pix1p25x_rst]")
        self.platform.add_platform_command("set_false_path -through [get_nets hdmi_in0_pix1p25x_rst]")
        self.platform.add_platform_command("set_false_path -through [get_nets pix_o_rst]")
        self.platform.add_platform_command("set_false_path -through [get_nets videooverlaysoc_hdmi_out0_clk_gen_ce]") # derived from reset

        # gearbox timing is a multi-cycle path: FAST to SLOW synchronous clock domains
        self.platform.add_platform_command("set_multicycle_path 2 -setup -start -from [get_clocks videooverlaysoc_hdmi_in0_mmcm_clk1] -to [get_clocks videooverlaysoc_hdmi_in0_mmcm_clk0]")
        self.platform.add_platform_command("set_multicycle_path 1 -hold -from [get_clocks videooverlaysoc_hdmi_in0_mmcm_clk1] -to [get_clocks videooverlaysoc_hdmi_in0_mmcm_clk0]")
        self.platform.add_platform_command("set_multicycle_path 2 -setup -start -from [get_clocks videooverlaysoc_hdmi_in1_mmcm_clk1] -to [get_clocks videooverlaysoc_hdmi_in1_mmcm_clk0]")
        self.platform.add_platform_command("set_multicycle_path 1 -hold -from [get_clocks videooverlaysoc_hdmi_in1_mmcm_clk1] -to [get_clocks videooverlaysoc_hdmi_in1_mmcm_clk0]")


        ###############  hdmi out 1 (overlay rgb)

        out_dram_port = self.sdram.crossbar.get_port(mode="read", cd="pix_o", dw=32, reverse=True)
        self.submodules.hdmi_core_out0 = VideoOutCore(out_dram_port, mode="rgb", fifo_depth=1024, genlock_stream=hdmi_in0_timing)

        core_source_valid_d = Signal()
        core_source_data_d = Signal(32)
        sync_cd = getattr(self.sync, out_dram_port.cd)
        sync_cd += [
            core_source_valid_d.eq(self.hdmi_core_out0.source.valid),
            core_source_data_d.eq(self.hdmi_core_out0.source.data),
        ]

        timing_rgb_delay = TimingDelayRGB(4) # create the delay element with specified delay...note if you say TimingDelay() the code runs happily with no error, because Python doesn't typecheck
        timing_rgb_delay = ClockDomainsRenamer("pix_o")(timing_rgb_delay) # assign a clock domain to the delay element
        self.submodules += timing_rgb_delay  # DONT FORGET THIS LINE OR ELSE NOTHING HAPPENS....
        self.hdmi_out0_rgb = hdmi_out0_rgb = stream.Endpoint(rgb_layout) # instantiate the input record
        self.hdmi_out0_rgb_d = hdmi_out0_rgb_d = stream.Endpoint(rgb_layout) # instantiate the output record
        self.comb += [
            self.hdmi_core_out0.source.ready.eq(1), # don't forget to tell the upstream component that we're ready, or we get a monochrome screen...
            hdmi_out0_rgb.b.eq(core_source_data_d[0:8]),  # wire up the specific elements of the input record
            hdmi_out0_rgb.g.eq(core_source_data_d[8:16]),
            hdmi_out0_rgb.r.eq(core_source_data_d[16:24]),
            hdmi_out0_rgb.valid.eq(core_source_valid_d),  # not used, but hook it up anyways in case we need it later...
            timing_rgb_delay.sink.eq(hdmi_out0_rgb), # assign input stream to the delay element
            hdmi_out0_rgb_d.eq(timing_rgb_delay.source) # grab output stream from the delay element
            # the output records are directly consumed down below
        ]

        self.submodules.encoder_red = encoder_red = ClockDomainsRenamer("pix_o")(Encoder())
        self.submodules.encoder_grn = encoder_grn = ClockDomainsRenamer("pix_o")(Encoder())
        self.submodules.encoder_blu = encoder_blu = ClockDomainsRenamer("pix_o")(Encoder())

        self.comb += [

            encoder_red.d.eq(hdmi_out0_rgb.r),
            encoder_red.de.eq(1),
            encoder_red.c.eq(0), # we promise to use this only during video areas, so "c" is always 0

            encoder_grn.d.eq(hdmi_out0_rgb.g),
            encoder_grn.de.eq(1),
            encoder_grn.c.eq(0),

            encoder_blu.d.eq(hdmi_out0_rgb.b),
            encoder_blu.de.eq(1),
            encoder_blu.c.eq(0),
        ]

        # hdmi in to hdmi out
        c0_pix_o = Signal(10)
        c1_pix_o = Signal(10)
        c2_pix_o = Signal(10)
        self.sync.pix_o += [  # extra delay to absorb cross-domain jitter & routing
            c0_pix_o.eq(self.hdmi_in0.syncpol.c0),
            c1_pix_o.eq(self.hdmi_in0.syncpol.c1),
            c2_pix_o.eq(self.hdmi_in0.syncpol.c2)
        ]

        rect_on = Signal()
        rect_thresh = Signal(8)

        self.submodules.rectangle = rectangle = ClockDomainsRenamer("pix_o")( RectOpening(hdmi_in0_timing) )
        self.comb += rect_on.eq(rectangle.rect_on)
        self.comb += rect_thresh.eq(rectangle.rect_thresh.storage)

        self.sync.pix_o += [
#            If(rect_on & (hdmi_out0_rgb_d.r >= 128) & (hdmi_out0_rgb_d.g >= 128) & (hdmi_out0_rgb_d.b >= 128),
            If(rect_on & (hdmi_out0_rgb_d.r >= rect_thresh) & (hdmi_out0_rgb_d.g >= rect_thresh) & (hdmi_out0_rgb_d.b >= rect_thresh),
#            If(rect_on,
                    self.hdmi_out0_phy.sink.c0.eq(encoder_blu.out),
                    self.hdmi_out0_phy.sink.c1.eq(encoder_grn.out),
                    self.hdmi_out0_phy.sink.c2.eq(encoder_red.out),
            ).Else(
                    self.hdmi_out0_phy.sink.c0.eq(c0_pix_o),
                    self.hdmi_out0_phy.sink.c1.eq(c1_pix_o),
                    self.hdmi_out0_phy.sink.c2.eq(c2_pix_o),
            )
        ]

        self.comb += platform.request("fpga_led2", 0).eq(self.hdmi_in0.clocking.locked)  # RX0 green
        self.comb += platform.request("fpga_led3", 0).eq(0)  # RX0 red
        self.comb += platform.request("fpga_led4", 0).eq(0)  # OV0 red
        self.comb += platform.request("fpga_led5", 0).eq(self.hdmi_in1.clocking.locked)  # OV0 green

        # analyzer ethernet
#        from liteeth.phy.rmii import LiteEthPHYRMII
#        from liteeth.core import LiteEthUDPIPCore
#        from liteeth.frontend.etherbone import LiteEthEtherbone

#        self.submodules.phy = phy = LiteEthPHYRMII(platform.request("rmii_eth_clocks"), platform.request("rmii_eth"))
#        mac_address = 0x1337320dbabe
#        ip_address="10.0.245.16"
#        self.submodules.core = LiteEthUDPIPCore(self.phy, mac_address, convert_ip(ip_address), int(100e6))
#        self.submodules.etherbone = LiteEthEtherbone(self.core.udp, 1234, mode="master")
#        self.add_wb_master(self.etherbone.wishbone.bus)

#        self.platform.add_false_path_constraints(
#           self.crg.cd_sys.clk,
#           self.crg.cd_eth.clk
#        )

        # analyzer UART
        from litex.soc.cores.uart import UARTWishboneBridge
        #            platform.request("serial",1), self.clk_freq, baudrate=3000000)
        self.submodules.bridge = UARTWishboneBridge(
            platform.request("serial",1), self.clk_freq, baudrate=115200)
        self.add_wb_master(self.bridge.wishbone)

        from litescope import LiteScopeAnalyzer

        analyzer_signals = [
            self.hdmi_in1.syncpol.hsync,
            self.hdmi_in1.syncpol.vsync,
            self.hdmi_in1.syncpol.de,
            self.hdmi_in1.syncpol.valid_o,
            self.hdmi_in1.chansync.data_out0,
            self.hdmi_in1.frame.g,
            ]
        self.submodules.analyzer = LiteScopeAnalyzer(analyzer_signals, 256, cd="hdmi_in1_pix", cd_ratio=2)

    def do_exit(self, vns):
        self.analyzer.export_csv(vns, "test/analyzer.csv")
"""
        # litescope
        litescope_serial = platform.request("serial", 1)
        litescope_bus = Signal(128)
        litescope_i = Signal(16)
        litescope_o = Signal(16)
        self.specials += [
            Instance("litescope",
                i_clock=ClockSignal(),
                i_reset=ResetSignal(),
                i_serial_rx=litescope_serial.rx,
                o_serial_tx=litescope_serial.tx,
                i_bus=litescope_bus,
                i_i=litescope_i,
                o_o=litescope_o
            )
        ]
        platform.add_source(os.path.join("litescope", "litescope.v"))

        # litescope test
        self.comb += [
            litescope_bus.eq(0x12345678ABCFEF),
            platform.request("user_led", 1).eq(litescope_o[0]),
            platform.request("user_led", 2).eq(litescope_o[1]),
            litescope_i.eq(0x5AA5)
        ]
"""



def main():
    if os.environ['PYTHONHASHSEED'] != "1":
        print( "PYTHONHASHEED must be set to 1 for consistent validation results. Failing to set this results in non-deterministic compilation results")
        exit()

    platform = Platform()
    if len(sys.argv) < 2:
        print("missing target (base or pcie or video or video_overlay or video_raw_dma_loopback)")
        exit()
    if sys.argv[1] == "base":
        soc = BaseSoC(platform)
    elif sys.argv[1] == "video_overlay":
        soc = VideoOverlaySoC(platform)
    builder = Builder(soc, output_dir="build", csr_csv="test/csr.csv")
    vns = builder.build()
    soc.do_exit(vns)

    if sys.argv[1] == "pcie":
        soc.generate_software_header()

if __name__ == "__main__":
    main()
