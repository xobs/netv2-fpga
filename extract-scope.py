#!/usr/bin/env python

from litex.soc.tools.remote import RemoteClient
from litescope.software.driver.analyzer import LiteScopeAnalyzerDriver

wb = RemoteClient(csr_csv="test/csr.csv")
wb.open()

analyzer = LiteScopeAnalyzerDriver(wb.regs, "analyzer", debug=True, config_csv="test/analyzer.csv")

analyzer.configure_subsampler(1)  ## increase this to "skip" cycles, e.g. subsample
analyzer.configure_group(0)

# trigger conditions will depend upon each other in sequence
#analyzer.add_falling_edge_trigger("soc_videooverlaysoc_hdmi_in0_timing_payload_vsync")
analyzer.add_rising_edge_trigger("videooverlaysoc_videooverlaysoc_interface2_cyc0")
#analyzer.add_trigger(cond={"soc_videooverlaysoc_hdmi_in0_timing_payload_hsync" : 1}) 

analyzer.run(offset=0, length=32)
wb.write(0xf00f0000, 0x00010000)
analyzer.wait_done()
analyzer.upload()
analyzer.save("read.vcd")

wb.close()

