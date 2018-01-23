from litex.gen import *

from litedram.frontend.dma import LiteDRAMDMAWriter, LiteDRAMDMAReader


class HDMIRawDMAWriter(Module):
    def __init__(self, dram_port):
        assert dram_port.dw == 32
        ashift = log2_int(dram_port.dw//8)
        awidth = dram_port.aw + ashift

        # control / parameters
        self.enable = Signal(reset=1) # reset to 1 if not used
        self.slot0_base = Signal(awidth)   # in bytes
        self.slot1_base = Signal(awidth)   # in bytes
        self.length = Signal(awidth)  # in bytes

        # in stream
        self.start = Signal(reset=1) # i / reset to 1 if not used
        self.idle = Signal()         # o
        self.valid = Signal()        # i
        self.ready = Signal()        # o
        self.data0 = Signal(10)      # i
        self.data1 = Signal(10)      # i
        self.data2 = Signal(10)      # i

        # # #

        # slot selection
        slot = Signal()
        base = Signal(awidth)
        self.sync += If(end, slot.eq(~slot))
        self.comb += If(slot, base.eq(self.slot1_base)).Else(base.eq(self.slot0_base))

        # dma
        dma = LiteDRAMDMAWriter(dram_port)
        self.submodules += dma

        # data
        self.comb += [
            dma.sink.data[00:10].eq(self.data0),
            dma.sink.data[10:20].eq(self.data1),
            dma.sink.data[20:30].eq(self.data2)
        ]

        # control
        count = Signal(awidth)
        self.submodules.fsm = fsm = FSM(reset_state="IDLE")
        fsm.act("IDLE",
            self.idle.eq(1),
            If(self.enable & self.start,
                NextValue(count, 0),
                NextState("RUN")
            )
        )
        fsm.act("RUN",
            dma.sink.valid.eq(self.valid),
            self.ready.eq(dma.sink.ready),
            If(~self.enable,
                # FIXME: add dma and pipeline flush
                NextState("IDLE")
            ).Elif(self.valid & self.ready,
                NextValue(count, count + 4),
                If(count == (self.length - 4),
                    NextValue(slot, ~slot),
                    NextState("IDLE")
                )
            )
        )
        self.comb += dma.sink.address.eq(count[ashift:] + base[ashift:])


class HDMIRawDMAReader(Module):
    def __init__(self, dram_port):
        assert dram_port.dw == 32
        ashift = log2_int(dram_port.dw//8)
        awidth = dram_port.aw + ashift

        # control / parameters
        self.enable = Signal(reset=1) # reset to 1 if not used
        self.slot0_base = Signal(awidth)   # in bytes
        self.slot1_base = Signal(awidth)   # in bytes
        self.length = Signal(awidth)  # in bytes

        # out stream
        self.start = Signal(reset=1) # i / reset to 1 if not used
        self.idle = Signal()        # o
        self.valid = Signal()       # o
        self.ready = Signal()       # i
        self.data0 = Signal(10)     # o
        self.data1 = Signal(10)     # o
        self.data2 = Signal(10)     # o

        # # #

        dma = LiteDRAMDMAReader(dram_port)
        self.submodules += dma

        # slot selection
        slot = Signal()
        base = Signal(awidth)
        self.sync += If(end, slot.eq(~slot))
        self.comb += If(slot, base.eq(self.slot1_base)).Else(base.eq(self.slot0_base))

        # dma
        dma = LiteDRAMDMAReader(dram_port)
        self.submodules += dma

        # data
        self.comb += [
            self.valid.eq(dma.source.valid),
            dma.source.ready.eq(self.ready),
            self.data0.eq(dma.source.data[00:10]),
            self.data1.eq(dma.source.data[10:20]),
            self.data2.eq(dma.source.data[20:30]),
        ]

        # control
        count = Signal(awidth)
        self.submodules.fsm = fsm = FSM(reset_state="IDLE")
        fsm.act("IDLE",
            self.idle.eq(1),
            If(self.enable & self.start,
                NextValue(count, 0),
                NextState("RUN")
            )
        )
        fsm.act("RUN",
            dma.sink.valid.eq(1),
            If(~self.enable,
                # FIXME: add dma and pipeline flush
                NextState("IDLE")
            ).Elif(dma.sink.ready,
                NextValue(count, count + 4),
                If(count == (self.length - 4),
                    NextValue(slot, ~slot),
                    NextState("IDLE")
                )
            )
        )
        self.comb += dma.sink.address.eq(count[ashift:] + base[ashift:])
