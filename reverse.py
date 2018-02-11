#!/usr/bin/env python3
import sys
import os

from litex.gen import *
from litex.gen.genlib.resetsync import AsyncResetSynchronizer

from litex.build.generic_platform import *
from litex.build.xilinx import XilinxPlatform
from litex.soc.cores import dna

from litedram.modules import MT41J128M16
from litedram.phy import a7ddrphy
from litedram.core import ControllerSettings

from litex.soc.integration.soc_core import *
from litex.soc.integration.soc_sdram import *
from litex.soc.integration.builder import *

from litex.gen.genlib.cdc import MultiReg


_io = [
    ("clk50", 0, Pins("J19"), IOStandard("LVCMOS33")),

    ("user_led", 0, Pins("M21"), IOStandard("LVCMOS33")),
    ("user_led", 1, Pins("N20"), IOStandard("LVCMOS33")),
    ("user_led", 2, Pins("L21"), IOStandard("LVCMOS33")),

    ("serial", 0,
        Subsignal("tx", Pins("E14")),
        Subsignal("rx", Pins("E13")),
        IOStandard("LVCMOS33"),
    ),

    ("serial_litescope", 0,
        Subsignal("tx", Pins("C18")), # hax 10
        Subsignal("rx", Pins("B20")), # hax 12
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
]

class Platform(XilinxPlatform):
    def __init__(self, toolchain="vivado", programmer="vivado"):
        XilinxPlatform.__init__(self, "xc7a35t-fgg484-2", _io,
                                toolchain=toolchain)

        self.add_platform_command(
            "set_property CONFIG_VOLTAGE 3.3 [current_design]")
        self.add_platform_command(
            "set_property CFGBVS VCCO [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.CONFIGRATE 22 [current_design]")
        self.add_platform_command(
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]")
        self.toolchain.bitstream_commands = [
            "set_property CONFIG_VOLTAGE 1.5 [current_design]",
            "set_property CFGBVS GND [current_design]",
            "set_property BITSTREAM.CONFIG.CONFIGRATE 22 [current_design]",
            "set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 1 [current_design]",
        ]
        self.toolchain.additional_commands = \
            ["write_cfgmem -verbose -force -format bin -interface spix1 -size 64 "
             "-loadbit \"up 0x0 {build_name}.bit\" -file {build_name}.bin"]
        self.programmer = programmer

        self.add_platform_command("""
create_clock -name pcie_phy_clk -period 10.0 [get_pins {{pcie_phy/pcie_support_i/pcie_i/inst/inst/gt_top_i/pipe_wrapper_i/pipe_lane[0].gt_wrapper_i/gtp_channel.gtpe2_channel_i/TXOUTCLK}}]
""")

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

        clk50 = platform.request("clk50")
        rst = Signal()

        pll_locked = Signal()
        pll_fb = Signal()
        self.pll_sys = Signal()
        pll_sys4x = Signal()
        pll_sys4x_dqs = Signal()
        pll_clk200 = Signal()
        self.specials += [
            Instance("PLLE2_BASE",
                     p_STARTUP_WAIT="FALSE", o_LOCKED=pll_locked,

                     # VCO @ 1600 MHz
                     p_REF_JITTER1=0.01, p_CLKIN1_PERIOD=20.0,
                     p_CLKFBOUT_MULT=32, p_DIVCLK_DIVIDE=1,
                     i_CLKIN1=clk50, i_CLKFBIN=pll_fb, o_CLKFBOUT=pll_fb,

                     # 100 MHz
                     p_CLKOUT0_DIVIDE=16, p_CLKOUT0_PHASE=0.0,
                     o_CLKOUT0=self.pll_sys,

                     # 400 MHz
                     p_CLKOUT1_DIVIDE=4, p_CLKOUT1_PHASE=0.0,
                     o_CLKOUT1=pll_sys4x,

                     # 400 MHz dqs
                     p_CLKOUT2_DIVIDE=4, p_CLKOUT2_PHASE=90.0,
                     o_CLKOUT2=pll_sys4x_dqs,

                     # 200 MHz
                     p_CLKOUT3_DIVIDE=8, p_CLKOUT3_PHASE=0.0,
                     o_CLKOUT3=pll_clk200
            ),
            Instance("BUFG", i_I=self.pll_sys, o_O=self.cd_sys.clk),
            Instance("BUFG", i_I=self.pll_sys, o_O=self.cd_clk100.clk),
            Instance("BUFG", i_I=pll_clk200, o_O=self.cd_clk200.clk),
            Instance("BUFG", i_I=pll_sys4x, o_O=self.cd_sys4x.clk),
            Instance("BUFG", i_I=pll_sys4x_dqs, o_O=self.cd_sys4x_dqs.clk),
            AsyncResetSynchronizer(self.cd_sys, ~pll_locked | rst),
            AsyncResetSynchronizer(self.cd_clk200, ~pll_locked | rst),
            AsyncResetSynchronizer(self.cd_clk100, ~pll_locked | rst)
        ]

        reset_counter = Signal(4, reset=15)
        ic_reset = Signal(reset=1)
        self.sync.clk200 += \
            If(reset_counter != 0,
                reset_counter.eq(reset_counter - 1)
            ).Else(
                ic_reset.eq(0)
            )
        self.specials += Instance("IDELAYCTRL", i_REFCLK=ClockSignal("clk200"), i_RST=ic_reset)

# Module that turns an LED on and off at some interval (`period` clock cycles),
# with a specific on time (`width` clock cycles).
# i.e. `width/period` is the PWM duty cycle, and `1/period` is the PWM frequency.
#     ________                       ________
# ___|        |_____________________|        |_____________________
#    <-width->
#    <------------period----------->
class BlinkerPwm(Module):
  def __init__(self, led, width, period):
    # Create a counter to track where we are in the pulse.
    counter = Signal(max=period)

    self.comb += [
      # On until we get to `width`
      If(counter < width,
        led.eq(1)
      ).Else(
        led.eq(0)
      ),
    ]
    self.sync += [
      If(counter == period - 1,
        # Reset the counter when we get to `period-1`
        counter.eq(0)
      ).Else(
        # Otherwise increment the counter.
        counter.eq(counter + 1)
      )
    ]

# Module that pulses an LED by ramping up and down its brightness, but
# re-using the PWM module for brightness.
# Every `cycles` clock cycles, the PWM width is inc/decreased/ from
# 0% to 100%.
class BlinkerBreathe(BlinkerPwm):
  def __init__(self, led, period, cycles):
    width = Signal(max=period)
    direction = Signal()
    super().__init__(led, width, period)
    # Create a counter to track cycles until we increment brightness.
    counter = Signal(max=cycles)

    self.sync += [
      # Inc/decrement the brightness.
      If((counter == 0) & (direction == 0),
         width.eq(width + 1)
      ).Elif((counter == 0) & (direction == 1),
         width.eq(width - 1)
      ),
      If(counter == 0,
        # Start counting backwards from `cycles` again.
        counter.eq(cycles - 1)
      ).Else(
        # Keep counting backwards...
        counter.eq(counter - 1)
      ),
      # Toggle the direction at each end.
      If((direction == 0) & (width == period - 1),
        direction.eq(1)
      ).Elif((direction == 1) & (width == 0),
        direction.eq(0)
      )
    ]

class Flintstone(Module):
    def __init__(self):
        self.wilma = Signal(16)

        self.sync += [
            If( self.wilma >= 65535,
                self.wilma.eq(0)
            ).Else(
                self.wilma.eq(self.wilma + 6502)
            )
        ]

class SimpleSync(Module):
    def __init__(self, d, q):
        self.sync += [
            q.eq(d)
        ]

#questions to resolve:
# signals that are smaller than expected -- alignment?
  ### answer: it passes the ambguity directly down to verilog :P
  # if b is 8 bits and a is 16 bits,
  # b = a gets the LSBs of a, e.g. b = a[7:0] if you do b = a
  # if b is 32 bits and 1 as 16 bits,
  # b = a zero-extends a, eg. b[15:0] = a[15:0] and b[31:16] = 16'b0

# cross-domain clocks

class MicroSoC(SoCCore):
    def __init__(self, platform, **kwargs):

        clk_freq = int(100e6)
        SoCCore.__init__(self, platform, clk_freq,
                         cpu_type=None,
                         **kwargs)

        self.platform = platform

        self.submodules.crg = CRG(platform)
        self.crg.cd_sys.clk.attr.add("keep")
        self.platform.add_period_constraint(self.crg.cd_sys.clk, period_ns(100e6))

        # common led
        self.sys_led = Signal()
        self.comb += platform.request("user_led", 0).eq(self.sys_led)

        self.aux_led = Signal()
        self.comb += platform.request("user_led", 1).eq(self.aux_led)

        # sys led
        sys_counter = Signal(32)
        self.sync += sys_counter.eq(sys_counter + 1)
        self.comb += self.sys_led.eq(sys_counter[26])

        sys_short_test = Signal(16)
        self.comb += sys_short_test.eq(sys_counter)
        self.comb += self.aux_led.eq(sys_short_test[15])

        self.bar_led = platform.request("user_led", 2)

        fred = ClockDomainsRenamer("clk100")(Flintstone())
        self.submodules += fred  ## if this isn't here, fred isn't instantiated

        self.dino = Signal(16)
        self.yoshi = Signal(8)
        self.specials += MultiReg(fred.wilma, self.dino, "clk100")
        self.specials += MultiReg(self.dino, self.yoshi, "clk200") # this takes dino into the yoshi clock domain
        self.comb += self.bar_led.eq(self.yoshi[7])

        # what I'm expecting:
        # Fred() makes a counter (called wilma) in the always@clk100 domain
        # The instance is called barney.
        # Barney's wilma gets retimed into clk200 as the name "dino"
        # bar_led gets dino[15]

        # what I'm getting:
        # wilma is a clk100 counter.
        # her output is "retimed" into the clk100 domain through two DFF stages and dumped into dino
        # dino is retimed into the clk200 domain via two DFFs
        # yoshi is LSB-aligned to dino
        # user_led 2 gets yoshi[7] which is dino[7]


        # So: ClockDomainsRenamer(domain1)(function1) takes everything inside function1() and puts it in clock domain domain1
        # MultiReg(a, b, domain2) takes the signals on b, assigns them to a, retiming into domain2





class MinSoC(SoCCore):
    csr_peripherals = {
        "dna",
    }

    csr_map_update(SoCCore.csr_map, csr_peripherals)

    def __init__(self, platform, **kwargs):
        clk_freq = int(100e6)
        SoCCore.__init__(self, platform, clk_freq,
                         integrated_rom_size=0x6000,
                         integrated_sram_size=0x4000,
                         ident="NeTV2 minimum SoC core",
                         reserve_nmi_interrupt=False,
                         **kwargs)

        self.submodules.crg = CRG(platform)
        self.submodules.dna = dna.DNA()

        self.crg.cd_sys.clk.attr.add("keep")
        self.platform.add_period_constraint(self.crg.cd_sys.clk, period_ns(100e6))

        # common led
        self.sys_led = Signal()
        self.comb += platform.request("user_led", 0).eq(self.sys_led)

        # sys led
        sys_counter = Signal(32)
        self.sync += sys_counter.eq(sys_counter + 1)
        self.comb += self.sys_led.eq(sys_counter[26])


class BaseSoC(SoCSDRAM):
    csr_peripherals = {
        "ddrphy",
        "dna",
    }
    csr_map_update(SoCSDRAM.csr_map, csr_peripherals)

    def __init__(self, platform, **kwargs):
        clk_freq = int(100e6)
        SoCSDRAM.__init__(self, platform, clk_freq,
            integrated_rom_size=0x6000,
            integrated_sram_size=0x4000,
            #shadow_base=0x00000000,
            ident="NeTV2 LiteX Reversing SoC",
            reserve_nmi_interrupt=False,
            **kwargs)

        self.submodules.crg = CRG(platform)
        self.submodules.dna = dna.DNA()

        self.crg.cd_sys.clk.attr.add("keep")
        self.platform.add_period_constraint(self.crg.cd_sys.clk, period_ns(100e6))

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
        self.comb += platform.request("user_led", 0).eq(self.sys_led ^ self.pcie_led)

        # sys led
        sys_counter = Signal(32)
        self.sync += sys_counter.eq(sys_counter + 1)
        self.comb += self.sys_led.eq(sys_counter[26])

class ReverseSoC(BaseSoC):
    csr_peripherals = {
        "analyzer"
    }
    csr_map_update(BaseSoC.csr_map, csr_peripherals)

#    interrupt_map = {
#        "hdmi_in0": 3,
#    }
#    interrupt_map.update(BaseSoC.interrupt_map)

    def __init__(self, platform, *args, **kwargs):
        BaseSoC.__init__(self, platform, *args, **kwargs)

        # # #

        pix_freq = 148.50e6

        # analyzer
        from litex.soc.cores.uart import UARTWishboneBridge
        from litescope import LiteScopeAnalyzer

        self.submodules.bridge = UARTWishboneBridge(
            platform.request("serial_litescope"), self.clk_freq, baudrate=115200)
        self.add_wb_master(self.bridge.wishbone)

        analyzer_signals = [
            self.sys_led,
        ]
        self.submodules.analyzer = LiteScopeAnalyzer(analyzer_signals, 2048, cd="clk200", cd_ratio=2)

    def do_exit(self, vns):
        self.analyzer.export_csv(vns, "test/analyzer.csv")

def main():
    platform = Platform()
    if len(sys.argv) < 2:
        print("missing target (base or pcie or video or video_raw_loopback or video_raw_dma_loopback)")
        exit()
    if sys.argv[1] == "base":
        soc = BaseSoC(platform)
    elif sys.argv[1] == "reverse":
        soc = ReverseSoC(platform)
    elif sys.argv[1] == "min":
        soc = MinSoC(platform)
    elif sys.argv[1] == "micro":
        soc=MicroSoC(platform)

    if sys.argv[1] == "micro":
        soc.cpu_type=None
        builder = Builder(soc, output_dir="build")
    else:
        builder = Builder(soc, output_dir="build", csr_csv="test/csr.csv")

    vns = builder.build()
    soc.do_exit(vns)

    if sys.argv[1] == "pcie":
        soc.generate_software_header()

if __name__ == "__main__":
    main()
