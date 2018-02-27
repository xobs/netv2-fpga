#!/usr/bin/env python3
import time
import os
import sys

from litex.gen.fhdl.structure import *

from litex.soc.tools.remote import RemoteClient
from litescope.software.driver.analyzer import LiteScopeAnalyzerDriver

wb = RemoteClient()
wb.open()

# # #

analyzer = LiteScopeAnalyzerDriver(wb.regs, "analyzer", debug=True)
#analyzer.configure_trigger(cond={"charsync0_data": 0x354})
#analyzer.configure_trigger(cond={"hdmi_in0_frame_de" : 1})
#analyzer.configure_trigger(cond={})
t = getattr(analyzer, "frontend_trigger_value")
m = getattr(analyzer, "frontend_trigger_mask")
t.write(0x80000000000000000)
m.write(0x80000000000000000)

analyzer.configure_subsampler(1)
analyzer.run(offset=32, length=512)
analyzer.wait_done()
analyzer.upload()
analyzer.save("dump.vcd")

# # #

wb.close()
