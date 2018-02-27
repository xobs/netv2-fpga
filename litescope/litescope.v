/* Machine-generated using LiteX gen */
module litescope(
	input clock,
	input reset,
	output reg serial_tx,
	input serial_rx,
	input [127:0] bus,
	input [15:0] i,
	output [15:0] o
);

wire sys_clk;
wire sys_rst;
wire [29:0] sram_bus_adr;
wire [31:0] sram_bus_dat_w;
wire [31:0] sram_bus_dat_r;
wire [3:0] sram_bus_sel;
wire sram_bus_cyc;
wire sram_bus_stb;
reg sram_bus_ack = 1'd0;
wire sram_bus_we;
wire [2:0] sram_bus_cti;
wire [1:0] sram_bus_bte;
reg sram_bus_err = 1'd0;
wire [9:0] sram_adr;
wire [31:0] sram_dat_r;
reg [3:0] sram_we = 4'd0;
wire [31:0] sram_dat_w;
reg [13:0] interface_adr = 14'd0;
reg interface_we = 1'd0;
reg [31:0] interface_dat_w = 32'd0;
wire [31:0] interface_dat_r;
wire [29:0] bus_wishbone_adr;
wire [31:0] bus_wishbone_dat_w;
reg [31:0] bus_wishbone_dat_r = 32'd0;
wire [3:0] bus_wishbone_sel;
wire bus_wishbone_cyc;
wire bus_wishbone_stb;
reg bus_wishbone_ack = 1'd0;
wire bus_wishbone_we;
wire [2:0] bus_wishbone_cti;
wire [1:0] bus_wishbone_bte;
reg bus_wishbone_err = 1'd0;
reg [1:0] counter = 2'd0;
reg [31:0] uartwishbonebridge_storage = 32'd128849018;
reg uartwishbonebridge_sink_valid = 1'd0;
reg uartwishbonebridge_sink_ready = 1'd0;
wire uartwishbonebridge_sink_last;
reg [7:0] uartwishbonebridge_sink_payload_data = 8'd0;
reg uartwishbonebridge_uart_clk_txen = 1'd0;
reg [31:0] uartwishbonebridge_phase_accumulator_tx = 32'd0;
reg [7:0] uartwishbonebridge_tx_reg = 8'd0;
reg [3:0] uartwishbonebridge_tx_bitcount = 4'd0;
reg uartwishbonebridge_tx_busy = 1'd0;
reg uartwishbonebridge_source_valid = 1'd0;
wire uartwishbonebridge_source_ready;
reg [7:0] uartwishbonebridge_source_payload_data = 8'd0;
reg uartwishbonebridge_uart_clk_rxen = 1'd0;
reg [31:0] uartwishbonebridge_phase_accumulator_rx = 32'd0;
wire uartwishbonebridge_rx;
reg uartwishbonebridge_rx_r = 1'd0;
reg [7:0] uartwishbonebridge_rx_reg = 8'd0;
reg [3:0] uartwishbonebridge_rx_bitcount = 4'd0;
reg uartwishbonebridge_rx_busy = 1'd0;
wire [29:0] uartwishbonebridge_wishbone_adr;
wire [31:0] uartwishbonebridge_wishbone_dat_w;
wire [31:0] uartwishbonebridge_wishbone_dat_r;
wire [3:0] uartwishbonebridge_wishbone_sel;
reg uartwishbonebridge_wishbone_cyc = 1'd0;
reg uartwishbonebridge_wishbone_stb = 1'd0;
wire uartwishbonebridge_wishbone_ack;
reg uartwishbonebridge_wishbone_we = 1'd0;
reg [2:0] uartwishbonebridge_wishbone_cti = 3'd0;
reg [1:0] uartwishbonebridge_wishbone_bte = 2'd0;
wire uartwishbonebridge_wishbone_err;
reg [2:0] uartwishbonebridge_byte_counter = 3'd0;
reg uartwishbonebridge_byte_counter_reset = 1'd0;
reg uartwishbonebridge_byte_counter_ce = 1'd0;
reg [2:0] uartwishbonebridge_word_counter = 3'd0;
reg uartwishbonebridge_word_counter_reset = 1'd0;
reg uartwishbonebridge_word_counter_ce = 1'd0;
reg [7:0] uartwishbonebridge_cmd = 8'd0;
reg uartwishbonebridge_cmd_ce = 1'd0;
reg [7:0] uartwishbonebridge_length = 8'd0;
reg uartwishbonebridge_length_ce = 1'd0;
reg [31:0] uartwishbonebridge_address = 32'd0;
reg uartwishbonebridge_address_ce = 1'd0;
reg [31:0] uartwishbonebridge_data = 32'd0;
reg uartwishbonebridge_rx_data_ce = 1'd0;
reg uartwishbonebridge_tx_data_ce = 1'd0;
wire uartwishbonebridge_reset;
wire uartwishbonebridge_wait;
wire uartwishbonebridge_done;
reg [23:0] uartwishbonebridge_count = 24'd10000000;
reg uartwishbonebridge_is_ongoing = 1'd0;
wire analyzer_valid;
reg analyzer_ready = 1'd0;
reg analyzer_first = 1'd0;
reg analyzer_last = 1'd0;
wire [127:0] analyzer_payload_data;
reg analyzer_payload_hit = 1'd0;
reg analyzer_source_valid = 1'd0;
wire analyzer_source_ready;
reg analyzer_source_first = 1'd0;
reg analyzer_source_last = 1'd0;
reg [127:0] analyzer_source_payload_data = 128'd0;
reg analyzer_source_payload_hit = 1'd0;
reg analyzer_storage_full = 1'd0;
wire analyzer_storage;
reg analyzer_re = 1'd0;
wire analyzer_analyzerfrontend_sink_sink_valid;
wire analyzer_analyzerfrontend_sink_sink_ready;
wire analyzer_analyzerfrontend_sink_sink_first;
wire analyzer_analyzerfrontend_sink_sink_last;
wire [127:0] analyzer_analyzerfrontend_sink_sink_payload_data;
wire analyzer_analyzerfrontend_sink_sink_payload_hit;
wire analyzer_analyzerfrontend_source_source_valid;
wire analyzer_analyzerfrontend_source_source_ready;
wire analyzer_analyzerfrontend_source_source_first;
wire analyzer_analyzerfrontend_source_source_last;
wire [127:0] analyzer_analyzerfrontend_source_source_payload_data;
wire analyzer_analyzerfrontend_source_source_payload_hit;
wire analyzer_analyzerfrontend_buffer_sink_valid;
wire analyzer_analyzerfrontend_buffer_sink_ready;
wire analyzer_analyzerfrontend_buffer_sink_first;
wire analyzer_analyzerfrontend_buffer_sink_last;
wire [127:0] analyzer_analyzerfrontend_buffer_sink_payload_data;
wire analyzer_analyzerfrontend_buffer_sink_payload_hit;
wire analyzer_analyzerfrontend_buffer_source_valid;
wire analyzer_analyzerfrontend_buffer_source_ready;
wire analyzer_analyzerfrontend_buffer_source_first;
wire analyzer_analyzerfrontend_buffer_source_last;
reg [127:0] analyzer_analyzerfrontend_buffer_source_payload_data = 128'd0;
reg analyzer_analyzerfrontend_buffer_source_payload_hit = 1'd0;
wire analyzer_analyzerfrontend_buffer_pipe_ce;
wire analyzer_analyzerfrontend_buffer_busy;
reg analyzer_analyzerfrontend_buffer_valid_n = 1'd0;
reg analyzer_analyzerfrontend_buffer_first_n = 1'd0;
reg analyzer_analyzerfrontend_buffer_last_n = 1'd0;
wire analyzer_analyzerfrontend_trigger_sink_valid;
wire analyzer_analyzerfrontend_trigger_sink_ready;
wire analyzer_analyzerfrontend_trigger_sink_first;
wire analyzer_analyzerfrontend_trigger_sink_last;
wire [127:0] analyzer_analyzerfrontend_trigger_sink_payload_data;
wire analyzer_analyzerfrontend_trigger_sink_payload_hit;
wire analyzer_analyzerfrontend_trigger_source_valid;
wire analyzer_analyzerfrontend_trigger_source_ready;
wire analyzer_analyzerfrontend_trigger_source_first;
wire analyzer_analyzerfrontend_trigger_source_last;
wire [127:0] analyzer_analyzerfrontend_trigger_source_payload_data;
reg analyzer_analyzerfrontend_trigger_source_payload_hit = 1'd0;
reg [127:0] analyzer_analyzerfrontend_trigger_value_storage_full = 128'd0;
wire [127:0] analyzer_analyzerfrontend_trigger_value_storage;
reg analyzer_analyzerfrontend_trigger_value_re = 1'd0;
reg [127:0] analyzer_analyzerfrontend_trigger_mask_storage_full = 128'd0;
wire [127:0] analyzer_analyzerfrontend_trigger_mask_storage;
reg analyzer_analyzerfrontend_trigger_mask_re = 1'd0;
wire [127:0] analyzer_analyzerfrontend_trigger_value;
wire [127:0] analyzer_analyzerfrontend_trigger_mask;
wire analyzer_analyzerfrontend_subsampler_sink_valid;
wire analyzer_analyzerfrontend_subsampler_sink_ready;
wire analyzer_analyzerfrontend_subsampler_sink_first;
wire analyzer_analyzerfrontend_subsampler_sink_last;
wire [127:0] analyzer_analyzerfrontend_subsampler_sink_payload_data;
wire analyzer_analyzerfrontend_subsampler_sink_payload_hit;
wire analyzer_analyzerfrontend_subsampler_source_valid;
wire analyzer_analyzerfrontend_subsampler_source_ready;
wire analyzer_analyzerfrontend_subsampler_source_first;
wire analyzer_analyzerfrontend_subsampler_source_last;
wire [127:0] analyzer_analyzerfrontend_subsampler_source_payload_data;
wire analyzer_analyzerfrontend_subsampler_source_payload_hit;
reg [15:0] analyzer_analyzerfrontend_subsampler_value_storage_full = 16'd0;
wire [15:0] analyzer_analyzerfrontend_subsampler_value_storage;
reg analyzer_analyzerfrontend_subsampler_value_re = 1'd0;
wire [15:0] analyzer_analyzerfrontend_subsampler_value;
reg [15:0] analyzer_analyzerfrontend_subsampler_counter = 16'd0;
wire analyzer_analyzerfrontend_subsampler_done;
wire analyzer_analyzerfrontend_converter_sink_valid;
wire analyzer_analyzerfrontend_converter_sink_ready;
wire analyzer_analyzerfrontend_converter_sink_first;
wire analyzer_analyzerfrontend_converter_sink_last;
wire [127:0] analyzer_analyzerfrontend_converter_sink_payload_data;
wire analyzer_analyzerfrontend_converter_sink_payload_hit;
wire analyzer_analyzerfrontend_converter_source_valid;
wire analyzer_analyzerfrontend_converter_source_ready;
wire analyzer_analyzerfrontend_converter_source_first;
wire analyzer_analyzerfrontend_converter_source_last;
wire [127:0] analyzer_analyzerfrontend_converter_source_payload_data;
wire analyzer_analyzerfrontend_converter_source_payload_hit;
wire analyzer_analyzerfrontend_converter_converter_sink_valid;
wire analyzer_analyzerfrontend_converter_converter_sink_ready;
wire analyzer_analyzerfrontend_converter_converter_sink_first;
wire analyzer_analyzerfrontend_converter_converter_sink_last;
wire [128:0] analyzer_analyzerfrontend_converter_converter_sink_payload_data;
wire analyzer_analyzerfrontend_converter_converter_source_valid;
wire analyzer_analyzerfrontend_converter_converter_source_ready;
wire analyzer_analyzerfrontend_converter_converter_source_first;
wire analyzer_analyzerfrontend_converter_converter_source_last;
wire [128:0] analyzer_analyzerfrontend_converter_converter_source_payload_data;
wire analyzer_analyzerfrontend_converter_converter_source_payload_valid_token_count;
wire analyzer_analyzerfrontend_converter_source_source_valid;
wire analyzer_analyzerfrontend_converter_source_source_ready;
wire analyzer_analyzerfrontend_converter_source_source_first;
wire analyzer_analyzerfrontend_converter_source_source_last;
wire [128:0] analyzer_analyzerfrontend_converter_source_source_payload_data;
wire analyzer_analyzerfrontend_asyncfifo_sink_valid;
wire analyzer_analyzerfrontend_asyncfifo_sink_ready;
wire analyzer_analyzerfrontend_asyncfifo_sink_first;
wire analyzer_analyzerfrontend_asyncfifo_sink_last;
wire [127:0] analyzer_analyzerfrontend_asyncfifo_sink_payload_data;
wire analyzer_analyzerfrontend_asyncfifo_sink_payload_hit;
wire analyzer_analyzerfrontend_asyncfifo_source_valid;
wire analyzer_analyzerfrontend_asyncfifo_source_ready;
wire analyzer_analyzerfrontend_asyncfifo_source_first;
wire analyzer_analyzerfrontend_asyncfifo_source_last;
wire [127:0] analyzer_analyzerfrontend_asyncfifo_source_payload_data;
wire analyzer_analyzerfrontend_asyncfifo_source_payload_hit;
wire analyzer_analyzerfrontend_asyncfifo_asyncfifo_we;
wire analyzer_analyzerfrontend_asyncfifo_asyncfifo_writable;
wire analyzer_analyzerfrontend_asyncfifo_asyncfifo_re;
wire analyzer_analyzerfrontend_asyncfifo_asyncfifo_readable;
wire [130:0] analyzer_analyzerfrontend_asyncfifo_asyncfifo_din;
wire [130:0] analyzer_analyzerfrontend_asyncfifo_asyncfifo_dout;
wire analyzer_analyzerfrontend_asyncfifo_graycounter0_ce;
(* register_balancing = "no" *) reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter0_q = 4'd0;
wire [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next;
reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary = 4'd0;
reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary = 4'd0;
wire analyzer_analyzerfrontend_asyncfifo_graycounter1_ce;
(* register_balancing = "no" *) reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter1_q = 4'd0;
wire [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next;
reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter1_q_binary = 4'd0;
reg [3:0] analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary = 4'd0;
wire [3:0] analyzer_analyzerfrontend_asyncfifo_produce_rdomain;
wire [3:0] analyzer_analyzerfrontend_asyncfifo_consume_wdomain;
wire [2:0] analyzer_analyzerfrontend_asyncfifo_wrport_adr;
wire [130:0] analyzer_analyzerfrontend_asyncfifo_wrport_dat_r;
wire analyzer_analyzerfrontend_asyncfifo_wrport_we;
wire [130:0] analyzer_analyzerfrontend_asyncfifo_wrport_dat_w;
wire [2:0] analyzer_analyzerfrontend_asyncfifo_rdport_adr;
wire [130:0] analyzer_analyzerfrontend_asyncfifo_rdport_dat_r;
wire [127:0] analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_data;
wire analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_hit;
wire analyzer_analyzerfrontend_asyncfifo_fifo_in_first;
wire analyzer_analyzerfrontend_asyncfifo_fifo_in_last;
wire [127:0] analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_data;
wire analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_hit;
wire analyzer_analyzerfrontend_asyncfifo_fifo_out_first;
wire analyzer_analyzerfrontend_asyncfifo_fifo_out_last;
wire analyzer_storage_sink_sink_valid;
reg analyzer_storage_sink_sink_ready = 1'd0;
wire analyzer_storage_sink_sink_first;
wire analyzer_storage_sink_sink_last;
wire [127:0] analyzer_storage_sink_sink_payload_data;
wire analyzer_storage_sink_sink_payload_hit;
wire analyzer_storage_start_re;
wire analyzer_storage_start_r;
reg analyzer_storage_start_w = 1'd0;
reg [9:0] analyzer_storage_length_storage_full = 10'd0;
wire [9:0] analyzer_storage_length_storage;
reg analyzer_storage_length_re = 1'd0;
reg [9:0] analyzer_storage_offset_storage_full = 10'd0;
wire [9:0] analyzer_storage_offset_storage;
reg analyzer_storage_offset_re = 1'd0;
reg analyzer_storage_idle_status = 1'd0;
reg analyzer_storage_wait_status = 1'd0;
reg analyzer_storage_run_status = 1'd0;
wire analyzer_storage_mem_flush_re;
wire analyzer_storage_mem_flush_r;
reg analyzer_storage_mem_flush_w = 1'd0;
wire analyzer_storage_mem_valid_status;
wire analyzer_storage_mem_ready_re;
wire analyzer_storage_mem_ready_r;
reg analyzer_storage_mem_ready_w = 1'd0;
wire [127:0] analyzer_storage_mem_data_status;
reg analyzer_storage_mem_sink_valid = 1'd0;
wire analyzer_storage_mem_sink_ready;
reg analyzer_storage_mem_sink_first = 1'd0;
reg analyzer_storage_mem_sink_last = 1'd0;
reg [127:0] analyzer_storage_mem_sink_payload_data = 128'd0;
wire analyzer_storage_mem_source_valid;
reg analyzer_storage_mem_source_ready = 1'd0;
wire analyzer_storage_mem_source_first;
wire analyzer_storage_mem_source_last;
wire [127:0] analyzer_storage_mem_source_payload_data;
wire analyzer_storage_mem_re;
reg analyzer_storage_mem_readable = 1'd0;
wire analyzer_storage_mem_syncfifo_we;
wire analyzer_storage_mem_syncfifo_writable;
wire analyzer_storage_mem_syncfifo_re;
wire analyzer_storage_mem_syncfifo_readable;
wire [129:0] analyzer_storage_mem_syncfifo_din;
wire [129:0] analyzer_storage_mem_syncfifo_dout;
reg [9:0] analyzer_storage_mem_level0 = 10'd0;
reg analyzer_storage_mem_replace = 1'd0;
reg [8:0] analyzer_storage_mem_produce = 9'd0;
reg [8:0] analyzer_storage_mem_consume = 9'd0;
reg [8:0] analyzer_storage_mem_wrport_adr = 9'd0;
wire [129:0] analyzer_storage_mem_wrport_dat_r;
wire analyzer_storage_mem_wrport_we;
wire [129:0] analyzer_storage_mem_wrport_dat_w;
wire analyzer_storage_mem_do_read;
wire [8:0] analyzer_storage_mem_rdport_adr;
wire [129:0] analyzer_storage_mem_rdport_dat_r;
wire analyzer_storage_mem_rdport_re;
wire [9:0] analyzer_storage_mem_level1;
wire [127:0] analyzer_storage_mem_fifo_in_payload_data;
wire analyzer_storage_mem_fifo_in_first;
wire analyzer_storage_mem_fifo_in_last;
wire [127:0] analyzer_storage_mem_fifo_out_payload_data;
wire analyzer_storage_mem_fifo_out_first;
wire analyzer_storage_mem_fifo_out_last;
wire analyzer_storage_reset;
wire [15:0] io_input;
wire [15:0] io_output;
wire [15:0] io_status;
reg [15:0] io_storage_full = 16'd0;
wire [15:0] io_storage;
reg io_re = 1'd0;
reg [2:0] uartwishbonebridge_state = 3'd0;
reg [2:0] uartwishbonebridge_next_state = 3'd0;
reg [1:0] litescopeanalyzer_state = 2'd0;
reg [1:0] litescopeanalyzer_next_state = 2'd0;
wire [29:0] shared_adr;
wire [31:0] shared_dat_w;
wire [31:0] shared_dat_r;
wire [3:0] shared_sel;
wire shared_cyc;
wire shared_stb;
wire shared_ack;
wire shared_we;
wire [2:0] shared_cti;
wire [1:0] shared_bte;
wire shared_err;
wire request;
wire grant;
reg [1:0] slave_sel = 2'd0;
reg [1:0] slave_sel_r = 2'd0;
wire [13:0] interface0_bank_bus_adr;
wire interface0_bank_bus_we;
wire [31:0] interface0_bank_bus_dat_w;
reg [31:0] interface0_bank_bus_dat_r = 32'd0;
wire csrbank0_mux_value0_re;
wire csrbank0_mux_value0_r;
wire csrbank0_mux_value0_w;
wire csrbank0_frontend_trigger_value3_re;
wire [31:0] csrbank0_frontend_trigger_value3_r;
wire [31:0] csrbank0_frontend_trigger_value3_w;
wire csrbank0_frontend_trigger_value2_re;
wire [31:0] csrbank0_frontend_trigger_value2_r;
wire [31:0] csrbank0_frontend_trigger_value2_w;
wire csrbank0_frontend_trigger_value1_re;
wire [31:0] csrbank0_frontend_trigger_value1_r;
wire [31:0] csrbank0_frontend_trigger_value1_w;
wire csrbank0_frontend_trigger_value0_re;
wire [31:0] csrbank0_frontend_trigger_value0_r;
wire [31:0] csrbank0_frontend_trigger_value0_w;
wire csrbank0_frontend_trigger_mask3_re;
wire [31:0] csrbank0_frontend_trigger_mask3_r;
wire [31:0] csrbank0_frontend_trigger_mask3_w;
wire csrbank0_frontend_trigger_mask2_re;
wire [31:0] csrbank0_frontend_trigger_mask2_r;
wire [31:0] csrbank0_frontend_trigger_mask2_w;
wire csrbank0_frontend_trigger_mask1_re;
wire [31:0] csrbank0_frontend_trigger_mask1_r;
wire [31:0] csrbank0_frontend_trigger_mask1_w;
wire csrbank0_frontend_trigger_mask0_re;
wire [31:0] csrbank0_frontend_trigger_mask0_r;
wire [31:0] csrbank0_frontend_trigger_mask0_w;
wire csrbank0_frontend_subsampler_value0_re;
wire [15:0] csrbank0_frontend_subsampler_value0_r;
wire [15:0] csrbank0_frontend_subsampler_value0_w;
wire csrbank0_storage_length0_re;
wire [9:0] csrbank0_storage_length0_r;
wire [9:0] csrbank0_storage_length0_w;
wire csrbank0_storage_offset0_re;
wire [9:0] csrbank0_storage_offset0_r;
wire [9:0] csrbank0_storage_offset0_w;
wire csrbank0_storage_idle_re;
wire csrbank0_storage_idle_r;
wire csrbank0_storage_idle_w;
wire csrbank0_storage_wait_re;
wire csrbank0_storage_wait_r;
wire csrbank0_storage_wait_w;
wire csrbank0_storage_run_re;
wire csrbank0_storage_run_r;
wire csrbank0_storage_run_w;
wire csrbank0_storage_mem_valid_re;
wire csrbank0_storage_mem_valid_r;
wire csrbank0_storage_mem_valid_w;
wire csrbank0_storage_mem_data3_re;
wire [31:0] csrbank0_storage_mem_data3_r;
wire [31:0] csrbank0_storage_mem_data3_w;
wire csrbank0_storage_mem_data2_re;
wire [31:0] csrbank0_storage_mem_data2_r;
wire [31:0] csrbank0_storage_mem_data2_w;
wire csrbank0_storage_mem_data1_re;
wire [31:0] csrbank0_storage_mem_data1_r;
wire [31:0] csrbank0_storage_mem_data1_w;
wire csrbank0_storage_mem_data0_re;
wire [31:0] csrbank0_storage_mem_data0_r;
wire [31:0] csrbank0_storage_mem_data0_w;
wire csrbank0_sel;
wire [13:0] interface1_bank_bus_adr;
wire interface1_bank_bus_we;
wire [31:0] interface1_bank_bus_dat_w;
reg [31:0] interface1_bank_bus_dat_r = 32'd0;
wire csrbank1_in_re;
wire [15:0] csrbank1_in_r;
wire [15:0] csrbank1_in_w;
wire csrbank1_out0_re;
wire [15:0] csrbank1_out0_r;
wire [15:0] csrbank1_out0_w;
wire csrbank1_sel;
reg [29:0] array_muxed0 = 30'd0;
reg [31:0] array_muxed1 = 32'd0;
reg [3:0] array_muxed2 = 4'd0;
reg array_muxed3 = 1'd0;
reg array_muxed4 = 1'd0;
reg array_muxed5 = 1'd0;
reg [2:0] array_muxed6 = 3'd0;
reg [1:0] array_muxed7 = 2'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl0_regs0 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg xilinxmultiregimpl0_regs1 = 1'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [127:0] xilinxmultiregimpl1_regs0 = 128'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [127:0] xilinxmultiregimpl1_regs1 = 128'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [127:0] xilinxmultiregimpl2_regs0 = 128'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [127:0] xilinxmultiregimpl2_regs1 = 128'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [15:0] xilinxmultiregimpl3_regs0 = 16'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [15:0] xilinxmultiregimpl3_regs1 = 16'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [3:0] xilinxmultiregimpl4_regs0 = 4'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [3:0] xilinxmultiregimpl4_regs1 = 4'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [3:0] xilinxmultiregimpl5_regs0 = 4'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [3:0] xilinxmultiregimpl5_regs1 = 4'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [15:0] xilinxmultiregimpl6_regs0 = 16'd0;
(* register_balancing = "no", shreg_extract = "no" *) reg [15:0] xilinxmultiregimpl6_regs1 = 16'd0;

assign sys_clk = clock;
assign sys_rst = reset;
assign io_input = i;
assign o = io_output;
always @(*) begin
	sram_we <= 4'd0;
	sram_we[0] <= (((sram_bus_cyc & sram_bus_stb) & sram_bus_we) & sram_bus_sel[0]);
	sram_we[1] <= (((sram_bus_cyc & sram_bus_stb) & sram_bus_we) & sram_bus_sel[1]);
	sram_we[2] <= (((sram_bus_cyc & sram_bus_stb) & sram_bus_we) & sram_bus_sel[2]);
	sram_we[3] <= (((sram_bus_cyc & sram_bus_stb) & sram_bus_we) & sram_bus_sel[3]);
end
assign sram_adr = sram_bus_adr[9:0];
assign sram_bus_dat_r = sram_dat_r;
assign sram_dat_w = sram_bus_dat_w;
assign uartwishbonebridge_reset = uartwishbonebridge_done;
assign uartwishbonebridge_source_ready = 1'd1;
assign uartwishbonebridge_wishbone_adr = (uartwishbonebridge_address + uartwishbonebridge_word_counter);
assign uartwishbonebridge_wishbone_dat_w = uartwishbonebridge_data;
assign uartwishbonebridge_wishbone_sel = 4'd15;
always @(*) begin
	uartwishbonebridge_sink_payload_data <= 8'd0;
	case (uartwishbonebridge_byte_counter)
		1'd0: begin
			uartwishbonebridge_sink_payload_data <= uartwishbonebridge_data[31:24];
		end
		1'd1: begin
			uartwishbonebridge_sink_payload_data <= uartwishbonebridge_data[23:16];
		end
		2'd2: begin
			uartwishbonebridge_sink_payload_data <= uartwishbonebridge_data[15:8];
		end
		default: begin
			uartwishbonebridge_sink_payload_data <= uartwishbonebridge_data[7:0];
		end
	endcase
end
assign uartwishbonebridge_wait = (~uartwishbonebridge_is_ongoing);
assign uartwishbonebridge_sink_last = ((uartwishbonebridge_byte_counter == 2'd3) & (uartwishbonebridge_word_counter == (uartwishbonebridge_length - 1'd1)));
always @(*) begin
	uartwishbonebridge_sink_valid <= 1'd0;
	uartwishbonebridge_word_counter_ce <= 1'd0;
	uartwishbonebridge_wishbone_cyc <= 1'd0;
	uartwishbonebridge_is_ongoing <= 1'd0;
	uartwishbonebridge_wishbone_stb <= 1'd0;
	uartwishbonebridge_cmd_ce <= 1'd0;
	uartwishbonebridge_length_ce <= 1'd0;
	uartwishbonebridge_wishbone_we <= 1'd0;
	uartwishbonebridge_address_ce <= 1'd0;
	uartwishbonebridge_rx_data_ce <= 1'd0;
	uartwishbonebridge_byte_counter_reset <= 1'd0;
	uartwishbonebridge_tx_data_ce <= 1'd0;
	uartwishbonebridge_byte_counter_ce <= 1'd0;
	uartwishbonebridge_next_state <= 3'd0;
	uartwishbonebridge_word_counter_reset <= 1'd0;
	uartwishbonebridge_next_state <= uartwishbonebridge_state;
	case (uartwishbonebridge_state)
		1'd1: begin
			if (uartwishbonebridge_source_valid) begin
				uartwishbonebridge_length_ce <= 1'd1;
				uartwishbonebridge_next_state <= 2'd2;
			end
		end
		2'd2: begin
			if (uartwishbonebridge_source_valid) begin
				uartwishbonebridge_address_ce <= 1'd1;
				uartwishbonebridge_byte_counter_ce <= 1'd1;
				if ((uartwishbonebridge_byte_counter == 2'd3)) begin
					if ((uartwishbonebridge_cmd == 1'd1)) begin
						uartwishbonebridge_next_state <= 2'd3;
					end else begin
						if ((uartwishbonebridge_cmd == 2'd2)) begin
							uartwishbonebridge_next_state <= 3'd5;
						end
					end
					uartwishbonebridge_byte_counter_reset <= 1'd1;
				end
			end
		end
		2'd3: begin
			if (uartwishbonebridge_source_valid) begin
				uartwishbonebridge_rx_data_ce <= 1'd1;
				uartwishbonebridge_byte_counter_ce <= 1'd1;
				if ((uartwishbonebridge_byte_counter == 2'd3)) begin
					uartwishbonebridge_next_state <= 3'd4;
					uartwishbonebridge_byte_counter_reset <= 1'd1;
				end
			end
		end
		3'd4: begin
			uartwishbonebridge_wishbone_stb <= 1'd1;
			uartwishbonebridge_wishbone_we <= 1'd1;
			uartwishbonebridge_wishbone_cyc <= 1'd1;
			if (uartwishbonebridge_wishbone_ack) begin
				uartwishbonebridge_word_counter_ce <= 1'd1;
				if ((uartwishbonebridge_word_counter == (uartwishbonebridge_length - 1'd1))) begin
					uartwishbonebridge_next_state <= 1'd0;
				end else begin
					uartwishbonebridge_next_state <= 2'd3;
				end
			end
		end
		3'd5: begin
			uartwishbonebridge_wishbone_stb <= 1'd1;
			uartwishbonebridge_wishbone_we <= 1'd0;
			uartwishbonebridge_wishbone_cyc <= 1'd1;
			if (uartwishbonebridge_wishbone_ack) begin
				uartwishbonebridge_tx_data_ce <= 1'd1;
				uartwishbonebridge_next_state <= 3'd6;
			end
		end
		3'd6: begin
			uartwishbonebridge_sink_valid <= 1'd1;
			if (uartwishbonebridge_sink_ready) begin
				uartwishbonebridge_byte_counter_ce <= 1'd1;
				if ((uartwishbonebridge_byte_counter == 2'd3)) begin
					uartwishbonebridge_word_counter_ce <= 1'd1;
					if ((uartwishbonebridge_word_counter == (uartwishbonebridge_length - 1'd1))) begin
						uartwishbonebridge_next_state <= 1'd0;
					end else begin
						uartwishbonebridge_next_state <= 3'd5;
						uartwishbonebridge_byte_counter_reset <= 1'd1;
					end
				end
			end
		end
		default: begin
			if (uartwishbonebridge_source_valid) begin
				uartwishbonebridge_cmd_ce <= 1'd1;
				if (((uartwishbonebridge_source_payload_data == 1'd1) | (uartwishbonebridge_source_payload_data == 2'd2))) begin
					uartwishbonebridge_next_state <= 1'd1;
				end
				uartwishbonebridge_byte_counter_reset <= 1'd1;
				uartwishbonebridge_word_counter_reset <= 1'd1;
			end
			uartwishbonebridge_is_ongoing <= 1'd1;
		end
	endcase
end
assign uartwishbonebridge_done = (uartwishbonebridge_count == 1'd0);
assign analyzer_valid = 1'd1;
assign analyzer_payload_data = {bus};
assign analyzer_analyzerfrontend_sink_sink_valid = analyzer_source_valid;
assign analyzer_source_ready = analyzer_analyzerfrontend_sink_sink_ready;
assign analyzer_analyzerfrontend_sink_sink_first = analyzer_source_first;
assign analyzer_analyzerfrontend_sink_sink_last = analyzer_source_last;
assign analyzer_analyzerfrontend_sink_sink_payload_data = analyzer_source_payload_data;
assign analyzer_analyzerfrontend_sink_sink_payload_hit = analyzer_source_payload_hit;
assign analyzer_storage_sink_sink_valid = analyzer_analyzerfrontend_source_source_valid;
assign analyzer_analyzerfrontend_source_source_ready = analyzer_storage_sink_sink_ready;
assign analyzer_storage_sink_sink_first = analyzer_analyzerfrontend_source_source_first;
assign analyzer_storage_sink_sink_last = analyzer_analyzerfrontend_source_source_last;
assign analyzer_storage_sink_sink_payload_data = analyzer_analyzerfrontend_source_source_payload_data;
assign analyzer_storage_sink_sink_payload_hit = analyzer_analyzerfrontend_source_source_payload_hit;
always @(*) begin
	analyzer_source_payload_hit <= 1'd0;
	analyzer_source_last <= 1'd0;
	analyzer_source_valid <= 1'd0;
	analyzer_source_first <= 1'd0;
	analyzer_ready <= 1'd0;
	analyzer_source_payload_data <= 128'd0;
	case (analyzer_storage)
		1'd0: begin
			analyzer_source_valid <= analyzer_valid;
			analyzer_ready <= analyzer_source_ready;
			analyzer_source_first <= analyzer_first;
			analyzer_source_last <= analyzer_last;
			analyzer_source_payload_data <= analyzer_payload_data;
			analyzer_source_payload_hit <= analyzer_payload_hit;
		end
	endcase
end
assign analyzer_analyzerfrontend_buffer_pipe_ce = (analyzer_analyzerfrontend_buffer_source_ready | (~analyzer_analyzerfrontend_buffer_valid_n));
assign analyzer_analyzerfrontend_buffer_sink_ready = analyzer_analyzerfrontend_buffer_pipe_ce;
assign analyzer_analyzerfrontend_buffer_source_valid = analyzer_analyzerfrontend_buffer_valid_n;
assign analyzer_analyzerfrontend_buffer_busy = (1'd0 | analyzer_analyzerfrontend_buffer_valid_n);
assign analyzer_analyzerfrontend_buffer_source_first = analyzer_analyzerfrontend_buffer_first_n;
assign analyzer_analyzerfrontend_buffer_source_last = analyzer_analyzerfrontend_buffer_last_n;
assign analyzer_analyzerfrontend_trigger_source_valid = analyzer_analyzerfrontend_trigger_sink_valid;
assign analyzer_analyzerfrontend_trigger_sink_ready = analyzer_analyzerfrontend_trigger_source_ready;
assign analyzer_analyzerfrontend_trigger_source_first = analyzer_analyzerfrontend_trigger_sink_first;
assign analyzer_analyzerfrontend_trigger_source_last = analyzer_analyzerfrontend_trigger_sink_last;
assign analyzer_analyzerfrontend_trigger_source_payload_data = analyzer_analyzerfrontend_trigger_sink_payload_data;
always @(*) begin
	analyzer_analyzerfrontend_trigger_source_payload_hit <= 1'd0;
	analyzer_analyzerfrontend_trigger_source_payload_hit <= analyzer_analyzerfrontend_trigger_sink_payload_hit;
	analyzer_analyzerfrontend_trigger_source_payload_hit <= ((analyzer_analyzerfrontend_trigger_sink_payload_data & analyzer_analyzerfrontend_trigger_mask) == analyzer_analyzerfrontend_trigger_value);
end
assign analyzer_analyzerfrontend_subsampler_done = (analyzer_analyzerfrontend_subsampler_counter == analyzer_analyzerfrontend_subsampler_value);
assign analyzer_analyzerfrontend_subsampler_sink_ready = analyzer_analyzerfrontend_subsampler_source_ready;
assign analyzer_analyzerfrontend_subsampler_source_first = analyzer_analyzerfrontend_subsampler_sink_first;
assign analyzer_analyzerfrontend_subsampler_source_last = analyzer_analyzerfrontend_subsampler_sink_last;
assign analyzer_analyzerfrontend_subsampler_source_payload_data = analyzer_analyzerfrontend_subsampler_sink_payload_data;
assign analyzer_analyzerfrontend_subsampler_source_payload_hit = analyzer_analyzerfrontend_subsampler_sink_payload_hit;
assign analyzer_analyzerfrontend_subsampler_source_valid = (analyzer_analyzerfrontend_subsampler_sink_valid & analyzer_analyzerfrontend_subsampler_done);
assign analyzer_analyzerfrontend_converter_converter_sink_valid = analyzer_analyzerfrontend_converter_sink_valid;
assign analyzer_analyzerfrontend_converter_converter_sink_first = analyzer_analyzerfrontend_converter_sink_first;
assign analyzer_analyzerfrontend_converter_converter_sink_last = analyzer_analyzerfrontend_converter_sink_last;
assign analyzer_analyzerfrontend_converter_sink_ready = analyzer_analyzerfrontend_converter_converter_sink_ready;
assign analyzer_analyzerfrontend_converter_converter_sink_payload_data = {analyzer_analyzerfrontend_converter_sink_payload_hit, analyzer_analyzerfrontend_converter_sink_payload_data};
assign analyzer_analyzerfrontend_converter_source_valid = analyzer_analyzerfrontend_converter_source_source_valid;
assign analyzer_analyzerfrontend_converter_source_first = analyzer_analyzerfrontend_converter_source_source_first;
assign analyzer_analyzerfrontend_converter_source_last = analyzer_analyzerfrontend_converter_source_source_last;
assign analyzer_analyzerfrontend_converter_source_source_ready = analyzer_analyzerfrontend_converter_source_ready;
assign {analyzer_analyzerfrontend_converter_source_payload_hit, analyzer_analyzerfrontend_converter_source_payload_data} = analyzer_analyzerfrontend_converter_source_source_payload_data;
assign analyzer_analyzerfrontend_converter_source_source_valid = analyzer_analyzerfrontend_converter_converter_source_valid;
assign analyzer_analyzerfrontend_converter_converter_source_ready = analyzer_analyzerfrontend_converter_source_source_ready;
assign analyzer_analyzerfrontend_converter_source_source_first = analyzer_analyzerfrontend_converter_converter_source_first;
assign analyzer_analyzerfrontend_converter_source_source_last = analyzer_analyzerfrontend_converter_converter_source_last;
assign analyzer_analyzerfrontend_converter_source_source_payload_data = analyzer_analyzerfrontend_converter_converter_source_payload_data;
assign analyzer_analyzerfrontend_converter_converter_source_valid = analyzer_analyzerfrontend_converter_converter_sink_valid;
assign analyzer_analyzerfrontend_converter_converter_sink_ready = analyzer_analyzerfrontend_converter_converter_source_ready;
assign analyzer_analyzerfrontend_converter_converter_source_first = analyzer_analyzerfrontend_converter_converter_sink_first;
assign analyzer_analyzerfrontend_converter_converter_source_last = analyzer_analyzerfrontend_converter_converter_sink_last;
assign analyzer_analyzerfrontend_converter_converter_source_payload_data = analyzer_analyzerfrontend_converter_converter_sink_payload_data;
assign analyzer_analyzerfrontend_converter_converter_source_payload_valid_token_count = 1'd1;
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_din = {analyzer_analyzerfrontend_asyncfifo_fifo_in_last, analyzer_analyzerfrontend_asyncfifo_fifo_in_first, analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_hit, analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_data};
assign {analyzer_analyzerfrontend_asyncfifo_fifo_out_last, analyzer_analyzerfrontend_asyncfifo_fifo_out_first, analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_hit, analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_data} = analyzer_analyzerfrontend_asyncfifo_asyncfifo_dout;
assign analyzer_analyzerfrontend_asyncfifo_sink_ready = analyzer_analyzerfrontend_asyncfifo_asyncfifo_writable;
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_we = analyzer_analyzerfrontend_asyncfifo_sink_valid;
assign analyzer_analyzerfrontend_asyncfifo_fifo_in_first = analyzer_analyzerfrontend_asyncfifo_sink_first;
assign analyzer_analyzerfrontend_asyncfifo_fifo_in_last = analyzer_analyzerfrontend_asyncfifo_sink_last;
assign analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_data = analyzer_analyzerfrontend_asyncfifo_sink_payload_data;
assign analyzer_analyzerfrontend_asyncfifo_fifo_in_payload_hit = analyzer_analyzerfrontend_asyncfifo_sink_payload_hit;
assign analyzer_analyzerfrontend_asyncfifo_source_valid = analyzer_analyzerfrontend_asyncfifo_asyncfifo_readable;
assign analyzer_analyzerfrontend_asyncfifo_source_first = analyzer_analyzerfrontend_asyncfifo_fifo_out_first;
assign analyzer_analyzerfrontend_asyncfifo_source_last = analyzer_analyzerfrontend_asyncfifo_fifo_out_last;
assign analyzer_analyzerfrontend_asyncfifo_source_payload_data = analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_data;
assign analyzer_analyzerfrontend_asyncfifo_source_payload_hit = analyzer_analyzerfrontend_asyncfifo_fifo_out_payload_hit;
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_re = analyzer_analyzerfrontend_asyncfifo_source_ready;
assign analyzer_analyzerfrontend_asyncfifo_graycounter0_ce = (analyzer_analyzerfrontend_asyncfifo_asyncfifo_writable & analyzer_analyzerfrontend_asyncfifo_asyncfifo_we);
assign analyzer_analyzerfrontend_asyncfifo_graycounter1_ce = (analyzer_analyzerfrontend_asyncfifo_asyncfifo_readable & analyzer_analyzerfrontend_asyncfifo_asyncfifo_re);
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_writable = (((analyzer_analyzerfrontend_asyncfifo_graycounter0_q[3] == analyzer_analyzerfrontend_asyncfifo_consume_wdomain[3]) | (analyzer_analyzerfrontend_asyncfifo_graycounter0_q[2] == analyzer_analyzerfrontend_asyncfifo_consume_wdomain[2])) | (analyzer_analyzerfrontend_asyncfifo_graycounter0_q[1:0] != analyzer_analyzerfrontend_asyncfifo_consume_wdomain[1:0]));
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_readable = (analyzer_analyzerfrontend_asyncfifo_graycounter1_q != analyzer_analyzerfrontend_asyncfifo_produce_rdomain);
assign analyzer_analyzerfrontend_asyncfifo_wrport_adr = analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary[2:0];
assign analyzer_analyzerfrontend_asyncfifo_wrport_dat_w = analyzer_analyzerfrontend_asyncfifo_asyncfifo_din;
assign analyzer_analyzerfrontend_asyncfifo_wrport_we = analyzer_analyzerfrontend_asyncfifo_graycounter0_ce;
assign analyzer_analyzerfrontend_asyncfifo_rdport_adr = analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary[2:0];
assign analyzer_analyzerfrontend_asyncfifo_asyncfifo_dout = analyzer_analyzerfrontend_asyncfifo_rdport_dat_r;
always @(*) begin
	analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary <= 4'd0;
	if (analyzer_analyzerfrontend_asyncfifo_graycounter0_ce) begin
		analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary <= (analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary + 1'd1);
	end else begin
		analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary <= analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary;
	end
end
assign analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next = (analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary ^ analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary[3:1]);
always @(*) begin
	analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary <= 4'd0;
	if (analyzer_analyzerfrontend_asyncfifo_graycounter1_ce) begin
		analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary <= (analyzer_analyzerfrontend_asyncfifo_graycounter1_q_binary + 1'd1);
	end else begin
		analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary <= analyzer_analyzerfrontend_asyncfifo_graycounter1_q_binary;
	end
end
assign analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next = (analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary ^ analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary[3:1]);
assign analyzer_analyzerfrontend_buffer_sink_valid = analyzer_analyzerfrontend_sink_sink_valid;
assign analyzer_analyzerfrontend_sink_sink_ready = analyzer_analyzerfrontend_buffer_sink_ready;
assign analyzer_analyzerfrontend_buffer_sink_first = analyzer_analyzerfrontend_sink_sink_first;
assign analyzer_analyzerfrontend_buffer_sink_last = analyzer_analyzerfrontend_sink_sink_last;
assign analyzer_analyzerfrontend_buffer_sink_payload_data = analyzer_analyzerfrontend_sink_sink_payload_data;
assign analyzer_analyzerfrontend_buffer_sink_payload_hit = analyzer_analyzerfrontend_sink_sink_payload_hit;
assign analyzer_analyzerfrontend_trigger_sink_valid = analyzer_analyzerfrontend_buffer_source_valid;
assign analyzer_analyzerfrontend_buffer_source_ready = analyzer_analyzerfrontend_trigger_sink_ready;
assign analyzer_analyzerfrontend_trigger_sink_first = analyzer_analyzerfrontend_buffer_source_first;
assign analyzer_analyzerfrontend_trigger_sink_last = analyzer_analyzerfrontend_buffer_source_last;
assign analyzer_analyzerfrontend_trigger_sink_payload_data = analyzer_analyzerfrontend_buffer_source_payload_data;
assign analyzer_analyzerfrontend_trigger_sink_payload_hit = analyzer_analyzerfrontend_buffer_source_payload_hit;
assign analyzer_analyzerfrontend_subsampler_sink_valid = analyzer_analyzerfrontend_trigger_source_valid;
assign analyzer_analyzerfrontend_trigger_source_ready = analyzer_analyzerfrontend_subsampler_sink_ready;
assign analyzer_analyzerfrontend_subsampler_sink_first = analyzer_analyzerfrontend_trigger_source_first;
assign analyzer_analyzerfrontend_subsampler_sink_last = analyzer_analyzerfrontend_trigger_source_last;
assign analyzer_analyzerfrontend_subsampler_sink_payload_data = analyzer_analyzerfrontend_trigger_source_payload_data;
assign analyzer_analyzerfrontend_subsampler_sink_payload_hit = analyzer_analyzerfrontend_trigger_source_payload_hit;
assign analyzer_analyzerfrontend_converter_sink_valid = analyzer_analyzerfrontend_subsampler_source_valid;
assign analyzer_analyzerfrontend_subsampler_source_ready = analyzer_analyzerfrontend_converter_sink_ready;
assign analyzer_analyzerfrontend_converter_sink_first = analyzer_analyzerfrontend_subsampler_source_first;
assign analyzer_analyzerfrontend_converter_sink_last = analyzer_analyzerfrontend_subsampler_source_last;
assign analyzer_analyzerfrontend_converter_sink_payload_data = analyzer_analyzerfrontend_subsampler_source_payload_data;
assign analyzer_analyzerfrontend_converter_sink_payload_hit = analyzer_analyzerfrontend_subsampler_source_payload_hit;
assign analyzer_analyzerfrontend_asyncfifo_sink_valid = analyzer_analyzerfrontend_converter_source_valid;
assign analyzer_analyzerfrontend_converter_source_ready = analyzer_analyzerfrontend_asyncfifo_sink_ready;
assign analyzer_analyzerfrontend_asyncfifo_sink_first = analyzer_analyzerfrontend_converter_source_first;
assign analyzer_analyzerfrontend_asyncfifo_sink_last = analyzer_analyzerfrontend_converter_source_last;
assign analyzer_analyzerfrontend_asyncfifo_sink_payload_data = analyzer_analyzerfrontend_converter_source_payload_data;
assign analyzer_analyzerfrontend_asyncfifo_sink_payload_hit = analyzer_analyzerfrontend_converter_source_payload_hit;
assign analyzer_analyzerfrontend_source_source_valid = analyzer_analyzerfrontend_asyncfifo_source_valid;
assign analyzer_analyzerfrontend_asyncfifo_source_ready = analyzer_analyzerfrontend_source_source_ready;
assign analyzer_analyzerfrontend_source_source_first = analyzer_analyzerfrontend_asyncfifo_source_first;
assign analyzer_analyzerfrontend_source_source_last = analyzer_analyzerfrontend_asyncfifo_source_last;
assign analyzer_analyzerfrontend_source_source_payload_data = analyzer_analyzerfrontend_asyncfifo_source_payload_data;
assign analyzer_analyzerfrontend_source_source_payload_hit = analyzer_analyzerfrontend_asyncfifo_source_payload_hit;
assign analyzer_storage_reset = analyzer_storage_mem_flush_re;
assign analyzer_storage_mem_valid_status = analyzer_storage_mem_source_valid;
assign analyzer_storage_mem_data_status = analyzer_storage_mem_source_payload_data;
assign analyzer_storage_mem_syncfifo_din = {analyzer_storage_mem_fifo_in_last, analyzer_storage_mem_fifo_in_first, analyzer_storage_mem_fifo_in_payload_data};
assign {analyzer_storage_mem_fifo_out_last, analyzer_storage_mem_fifo_out_first, analyzer_storage_mem_fifo_out_payload_data} = analyzer_storage_mem_syncfifo_dout;
assign analyzer_storage_mem_sink_ready = analyzer_storage_mem_syncfifo_writable;
assign analyzer_storage_mem_syncfifo_we = analyzer_storage_mem_sink_valid;
assign analyzer_storage_mem_fifo_in_first = analyzer_storage_mem_sink_first;
assign analyzer_storage_mem_fifo_in_last = analyzer_storage_mem_sink_last;
assign analyzer_storage_mem_fifo_in_payload_data = analyzer_storage_mem_sink_payload_data;
assign analyzer_storage_mem_source_valid = analyzer_storage_mem_readable;
assign analyzer_storage_mem_source_first = analyzer_storage_mem_fifo_out_first;
assign analyzer_storage_mem_source_last = analyzer_storage_mem_fifo_out_last;
assign analyzer_storage_mem_source_payload_data = analyzer_storage_mem_fifo_out_payload_data;
assign analyzer_storage_mem_re = analyzer_storage_mem_source_ready;
assign analyzer_storage_mem_syncfifo_re = (analyzer_storage_mem_syncfifo_readable & ((~analyzer_storage_mem_readable) | analyzer_storage_mem_re));
assign analyzer_storage_mem_level1 = (analyzer_storage_mem_level0 + analyzer_storage_mem_readable);
always @(*) begin
	analyzer_storage_mem_wrport_adr <= 9'd0;
	if (analyzer_storage_mem_replace) begin
		analyzer_storage_mem_wrport_adr <= (analyzer_storage_mem_produce - 1'd1);
	end else begin
		analyzer_storage_mem_wrport_adr <= analyzer_storage_mem_produce;
	end
end
assign analyzer_storage_mem_wrport_dat_w = analyzer_storage_mem_syncfifo_din;
assign analyzer_storage_mem_wrport_we = (analyzer_storage_mem_syncfifo_we & (analyzer_storage_mem_syncfifo_writable | analyzer_storage_mem_replace));
assign analyzer_storage_mem_do_read = (analyzer_storage_mem_syncfifo_readable & analyzer_storage_mem_syncfifo_re);
assign analyzer_storage_mem_rdport_adr = analyzer_storage_mem_consume;
assign analyzer_storage_mem_syncfifo_dout = analyzer_storage_mem_rdport_dat_r;
assign analyzer_storage_mem_rdport_re = analyzer_storage_mem_do_read;
assign analyzer_storage_mem_syncfifo_writable = (analyzer_storage_mem_level0 != 10'd512);
assign analyzer_storage_mem_syncfifo_readable = (analyzer_storage_mem_level0 != 1'd0);
always @(*) begin
	analyzer_storage_mem_sink_valid <= 1'd0;
	litescopeanalyzer_next_state <= 2'd0;
	analyzer_storage_sink_sink_ready <= 1'd0;
	analyzer_storage_mem_sink_first <= 1'd0;
	analyzer_storage_idle_status <= 1'd0;
	analyzer_storage_mem_sink_last <= 1'd0;
	analyzer_storage_wait_status <= 1'd0;
	analyzer_storage_mem_sink_payload_data <= 128'd0;
	analyzer_storage_run_status <= 1'd0;
	analyzer_storage_mem_source_ready <= 1'd0;
	litescopeanalyzer_next_state <= litescopeanalyzer_state;
	case (litescopeanalyzer_state)
		1'd1: begin
			analyzer_storage_wait_status <= 1'd1;
			analyzer_storage_mem_sink_valid <= analyzer_storage_sink_sink_valid;
			analyzer_storage_sink_sink_ready <= analyzer_storage_mem_sink_ready;
			analyzer_storage_mem_sink_first <= analyzer_storage_sink_sink_first;
			analyzer_storage_mem_sink_last <= analyzer_storage_sink_sink_last;
			analyzer_storage_mem_sink_payload_data <= analyzer_storage_sink_sink_payload_data;
			if ((analyzer_storage_sink_sink_valid & (analyzer_storage_sink_sink_payload_hit != 1'd0))) begin
				litescopeanalyzer_next_state <= 2'd2;
			end
			analyzer_storage_mem_source_ready <= (analyzer_storage_mem_level1 >= analyzer_storage_offset_storage);
		end
		2'd2: begin
			analyzer_storage_run_status <= 1'd1;
			analyzer_storage_mem_sink_valid <= analyzer_storage_sink_sink_valid;
			analyzer_storage_sink_sink_ready <= analyzer_storage_mem_sink_ready;
			analyzer_storage_mem_sink_first <= analyzer_storage_sink_sink_first;
			analyzer_storage_mem_sink_last <= analyzer_storage_sink_sink_last;
			analyzer_storage_mem_sink_payload_data <= analyzer_storage_sink_sink_payload_data;
			if (((~analyzer_storage_mem_sink_ready) | (analyzer_storage_mem_level1 >= analyzer_storage_length_storage))) begin
				litescopeanalyzer_next_state <= 1'd0;
				analyzer_storage_mem_source_ready <= 1'd1;
			end
		end
		default: begin
			analyzer_storage_idle_status <= 1'd1;
			if (analyzer_storage_start_re) begin
				litescopeanalyzer_next_state <= 1'd1;
			end
			analyzer_storage_sink_sink_ready <= 1'd1;
			analyzer_storage_mem_source_ready <= (analyzer_storage_mem_ready_re & analyzer_storage_mem_ready_r);
		end
	endcase
end
assign io_output = io_storage;
assign shared_adr = array_muxed0;
assign shared_dat_w = array_muxed1;
assign shared_sel = array_muxed2;
assign shared_cyc = array_muxed3;
assign shared_stb = array_muxed4;
assign shared_we = array_muxed5;
assign shared_cti = array_muxed6;
assign shared_bte = array_muxed7;
assign uartwishbonebridge_wishbone_dat_r = shared_dat_r;
assign uartwishbonebridge_wishbone_ack = (shared_ack & (grant == 1'd0));
assign uartwishbonebridge_wishbone_err = (shared_err & (grant == 1'd0));
assign request = {uartwishbonebridge_wishbone_cyc};
assign grant = 1'd0;
always @(*) begin
	slave_sel <= 2'd0;
	slave_sel[0] <= (shared_adr[28:26] == 1'd1);
	slave_sel[1] <= (shared_adr[28:26] == 3'd6);
end
assign sram_bus_adr = shared_adr;
assign sram_bus_dat_w = shared_dat_w;
assign sram_bus_sel = shared_sel;
assign sram_bus_stb = shared_stb;
assign sram_bus_we = shared_we;
assign sram_bus_cti = shared_cti;
assign sram_bus_bte = shared_bte;
assign bus_wishbone_adr = shared_adr;
assign bus_wishbone_dat_w = shared_dat_w;
assign bus_wishbone_sel = shared_sel;
assign bus_wishbone_stb = shared_stb;
assign bus_wishbone_we = shared_we;
assign bus_wishbone_cti = shared_cti;
assign bus_wishbone_bte = shared_bte;
assign sram_bus_cyc = (shared_cyc & slave_sel[0]);
assign bus_wishbone_cyc = (shared_cyc & slave_sel[1]);
assign shared_ack = (sram_bus_ack | bus_wishbone_ack);
assign shared_err = (sram_bus_err | bus_wishbone_err);
assign shared_dat_r = (({32{slave_sel_r[0]}} & sram_bus_dat_r) | ({32{slave_sel_r[1]}} & bus_wishbone_dat_r));
assign csrbank0_sel = (interface0_bank_bus_adr[13:9] == 5'd16);
assign csrbank0_mux_value0_r = interface0_bank_bus_dat_w[0];
assign csrbank0_mux_value0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 1'd0));
assign csrbank0_frontend_trigger_value3_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_value3_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 1'd1));
assign csrbank0_frontend_trigger_value2_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_value2_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 2'd2));
assign csrbank0_frontend_trigger_value1_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_value1_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 2'd3));
assign csrbank0_frontend_trigger_value0_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_value0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 3'd4));
assign csrbank0_frontend_trigger_mask3_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_mask3_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 3'd5));
assign csrbank0_frontend_trigger_mask2_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_mask2_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 3'd6));
assign csrbank0_frontend_trigger_mask1_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_mask1_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 3'd7));
assign csrbank0_frontend_trigger_mask0_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_frontend_trigger_mask0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd8));
assign csrbank0_frontend_subsampler_value0_r = interface0_bank_bus_dat_w[15:0];
assign csrbank0_frontend_subsampler_value0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd9));
assign analyzer_storage_start_r = interface0_bank_bus_dat_w[0];
assign analyzer_storage_start_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd10));
assign csrbank0_storage_length0_r = interface0_bank_bus_dat_w[9:0];
assign csrbank0_storage_length0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd11));
assign csrbank0_storage_offset0_r = interface0_bank_bus_dat_w[9:0];
assign csrbank0_storage_offset0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd12));
assign csrbank0_storage_idle_r = interface0_bank_bus_dat_w[0];
assign csrbank0_storage_idle_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd13));
assign csrbank0_storage_wait_r = interface0_bank_bus_dat_w[0];
assign csrbank0_storage_wait_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd14));
assign csrbank0_storage_run_r = interface0_bank_bus_dat_w[0];
assign csrbank0_storage_run_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 4'd15));
assign analyzer_storage_mem_flush_r = interface0_bank_bus_dat_w[0];
assign analyzer_storage_mem_flush_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd16));
assign csrbank0_storage_mem_valid_r = interface0_bank_bus_dat_w[0];
assign csrbank0_storage_mem_valid_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd17));
assign analyzer_storage_mem_ready_r = interface0_bank_bus_dat_w[0];
assign analyzer_storage_mem_ready_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd18));
assign csrbank0_storage_mem_data3_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_storage_mem_data3_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd19));
assign csrbank0_storage_mem_data2_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_storage_mem_data2_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd20));
assign csrbank0_storage_mem_data1_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_storage_mem_data1_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd21));
assign csrbank0_storage_mem_data0_r = interface0_bank_bus_dat_w[31:0];
assign csrbank0_storage_mem_data0_re = ((csrbank0_sel & interface0_bank_bus_we) & (interface0_bank_bus_adr[4:0] == 5'd22));
assign analyzer_storage = analyzer_storage_full;
assign csrbank0_mux_value0_w = analyzer_storage_full;
assign analyzer_analyzerfrontend_trigger_value_storage = analyzer_analyzerfrontend_trigger_value_storage_full[127:0];
assign csrbank0_frontend_trigger_value3_w = analyzer_analyzerfrontend_trigger_value_storage_full[127:96];
assign csrbank0_frontend_trigger_value2_w = analyzer_analyzerfrontend_trigger_value_storage_full[95:64];
assign csrbank0_frontend_trigger_value1_w = analyzer_analyzerfrontend_trigger_value_storage_full[63:32];
assign csrbank0_frontend_trigger_value0_w = analyzer_analyzerfrontend_trigger_value_storage_full[31:0];
assign analyzer_analyzerfrontend_trigger_mask_storage = analyzer_analyzerfrontend_trigger_mask_storage_full[127:0];
assign csrbank0_frontend_trigger_mask3_w = analyzer_analyzerfrontend_trigger_mask_storage_full[127:96];
assign csrbank0_frontend_trigger_mask2_w = analyzer_analyzerfrontend_trigger_mask_storage_full[95:64];
assign csrbank0_frontend_trigger_mask1_w = analyzer_analyzerfrontend_trigger_mask_storage_full[63:32];
assign csrbank0_frontend_trigger_mask0_w = analyzer_analyzerfrontend_trigger_mask_storage_full[31:0];
assign analyzer_analyzerfrontend_subsampler_value_storage = analyzer_analyzerfrontend_subsampler_value_storage_full[15:0];
assign csrbank0_frontend_subsampler_value0_w = analyzer_analyzerfrontend_subsampler_value_storage_full[15:0];
assign analyzer_storage_length_storage = analyzer_storage_length_storage_full[9:0];
assign csrbank0_storage_length0_w = analyzer_storage_length_storage_full[9:0];
assign analyzer_storage_offset_storage = analyzer_storage_offset_storage_full[9:0];
assign csrbank0_storage_offset0_w = analyzer_storage_offset_storage_full[9:0];
assign csrbank0_storage_idle_w = analyzer_storage_idle_status;
assign csrbank0_storage_wait_w = analyzer_storage_wait_status;
assign csrbank0_storage_run_w = analyzer_storage_run_status;
assign csrbank0_storage_mem_valid_w = analyzer_storage_mem_valid_status;
assign csrbank0_storage_mem_data3_w = analyzer_storage_mem_data_status[127:96];
assign csrbank0_storage_mem_data2_w = analyzer_storage_mem_data_status[95:64];
assign csrbank0_storage_mem_data1_w = analyzer_storage_mem_data_status[63:32];
assign csrbank0_storage_mem_data0_w = analyzer_storage_mem_data_status[31:0];
assign csrbank1_sel = (interface1_bank_bus_adr[13:9] == 5'd17);
assign csrbank1_in_r = interface1_bank_bus_dat_w[15:0];
assign csrbank1_in_re = ((csrbank1_sel & interface1_bank_bus_we) & (interface1_bank_bus_adr[0] == 1'd0));
assign csrbank1_out0_r = interface1_bank_bus_dat_w[15:0];
assign csrbank1_out0_re = ((csrbank1_sel & interface1_bank_bus_we) & (interface1_bank_bus_adr[0] == 1'd1));
assign csrbank1_in_w = io_status[15:0];
assign io_storage = io_storage_full[15:0];
assign csrbank1_out0_w = io_storage_full[15:0];
assign interface0_bank_bus_adr = interface_adr;
assign interface1_bank_bus_adr = interface_adr;
assign interface0_bank_bus_we = interface_we;
assign interface1_bank_bus_we = interface_we;
assign interface0_bank_bus_dat_w = interface_dat_w;
assign interface1_bank_bus_dat_w = interface_dat_w;
assign interface_dat_r = (interface0_bank_bus_dat_r | interface1_bank_bus_dat_r);
always @(*) begin
	array_muxed0 <= 30'd0;
	case (grant)
		default: begin
			array_muxed0 <= uartwishbonebridge_wishbone_adr;
		end
	endcase
end
always @(*) begin
	array_muxed1 <= 32'd0;
	case (grant)
		default: begin
			array_muxed1 <= uartwishbonebridge_wishbone_dat_w;
		end
	endcase
end
always @(*) begin
	array_muxed2 <= 4'd0;
	case (grant)
		default: begin
			array_muxed2 <= uartwishbonebridge_wishbone_sel;
		end
	endcase
end
always @(*) begin
	array_muxed3 <= 1'd0;
	case (grant)
		default: begin
			array_muxed3 <= uartwishbonebridge_wishbone_cyc;
		end
	endcase
end
always @(*) begin
	array_muxed4 <= 1'd0;
	case (grant)
		default: begin
			array_muxed4 <= uartwishbonebridge_wishbone_stb;
		end
	endcase
end
always @(*) begin
	array_muxed5 <= 1'd0;
	case (grant)
		default: begin
			array_muxed5 <= uartwishbonebridge_wishbone_we;
		end
	endcase
end
always @(*) begin
	array_muxed6 <= 3'd0;
	case (grant)
		default: begin
			array_muxed6 <= uartwishbonebridge_wishbone_cti;
		end
	endcase
end
always @(*) begin
	array_muxed7 <= 2'd0;
	case (grant)
		default: begin
			array_muxed7 <= uartwishbonebridge_wishbone_bte;
		end
	endcase
end
assign uartwishbonebridge_rx = xilinxmultiregimpl0_regs1;
assign analyzer_analyzerfrontend_trigger_value = xilinxmultiregimpl1_regs1;
assign analyzer_analyzerfrontend_trigger_mask = xilinxmultiregimpl2_regs1;
assign analyzer_analyzerfrontend_subsampler_value = xilinxmultiregimpl3_regs1;
assign analyzer_analyzerfrontend_asyncfifo_produce_rdomain = xilinxmultiregimpl4_regs1;
assign analyzer_analyzerfrontend_asyncfifo_consume_wdomain = xilinxmultiregimpl5_regs1;
assign io_status = xilinxmultiregimpl6_regs1;

always @(posedge sys_clk) begin
	sram_bus_ack <= 1'd0;
	if (((sram_bus_cyc & sram_bus_stb) & (~sram_bus_ack))) begin
		sram_bus_ack <= 1'd1;
	end
	interface_we <= 1'd0;
	interface_dat_w <= bus_wishbone_dat_w;
	interface_adr <= bus_wishbone_adr;
	bus_wishbone_dat_r <= interface_dat_r;
	if ((counter == 1'd1)) begin
		interface_we <= bus_wishbone_we;
	end
	if ((counter == 2'd2)) begin
		bus_wishbone_ack <= 1'd1;
	end
	if ((counter == 2'd3)) begin
		bus_wishbone_ack <= 1'd0;
	end
	if ((counter != 1'd0)) begin
		counter <= (counter + 1'd1);
	end else begin
		if ((bus_wishbone_cyc & bus_wishbone_stb)) begin
			counter <= 1'd1;
		end
	end
	if (uartwishbonebridge_byte_counter_reset) begin
		uartwishbonebridge_byte_counter <= 1'd0;
	end else begin
		if (uartwishbonebridge_byte_counter_ce) begin
			uartwishbonebridge_byte_counter <= (uartwishbonebridge_byte_counter + 1'd1);
		end
	end
	if (uartwishbonebridge_word_counter_reset) begin
		uartwishbonebridge_word_counter <= 1'd0;
	end else begin
		if (uartwishbonebridge_word_counter_ce) begin
			uartwishbonebridge_word_counter <= (uartwishbonebridge_word_counter + 1'd1);
		end
	end
	if (uartwishbonebridge_cmd_ce) begin
		uartwishbonebridge_cmd <= uartwishbonebridge_source_payload_data;
	end
	if (uartwishbonebridge_length_ce) begin
		uartwishbonebridge_length <= uartwishbonebridge_source_payload_data;
	end
	if (uartwishbonebridge_address_ce) begin
		uartwishbonebridge_address <= {uartwishbonebridge_address[23:0], uartwishbonebridge_source_payload_data};
	end
	if (uartwishbonebridge_rx_data_ce) begin
		uartwishbonebridge_data <= {uartwishbonebridge_data[23:0], uartwishbonebridge_source_payload_data};
	end else begin
		if (uartwishbonebridge_tx_data_ce) begin
			uartwishbonebridge_data <= uartwishbonebridge_wishbone_dat_r;
		end
	end
	uartwishbonebridge_sink_ready <= 1'd0;
	if (((uartwishbonebridge_sink_valid & (~uartwishbonebridge_tx_busy)) & (~uartwishbonebridge_sink_ready))) begin
		uartwishbonebridge_tx_reg <= uartwishbonebridge_sink_payload_data;
		uartwishbonebridge_tx_bitcount <= 1'd0;
		uartwishbonebridge_tx_busy <= 1'd1;
		serial_tx <= 1'd0;
	end else begin
		if ((uartwishbonebridge_uart_clk_txen & uartwishbonebridge_tx_busy)) begin
			uartwishbonebridge_tx_bitcount <= (uartwishbonebridge_tx_bitcount + 1'd1);
			if ((uartwishbonebridge_tx_bitcount == 4'd8)) begin
				serial_tx <= 1'd1;
			end else begin
				if ((uartwishbonebridge_tx_bitcount == 4'd9)) begin
					serial_tx <= 1'd1;
					uartwishbonebridge_tx_busy <= 1'd0;
					uartwishbonebridge_sink_ready <= 1'd1;
				end else begin
					serial_tx <= uartwishbonebridge_tx_reg[0];
					uartwishbonebridge_tx_reg <= {1'd0, uartwishbonebridge_tx_reg[7:1]};
				end
			end
		end
	end
	if (uartwishbonebridge_tx_busy) begin
		{uartwishbonebridge_uart_clk_txen, uartwishbonebridge_phase_accumulator_tx} <= (uartwishbonebridge_phase_accumulator_tx + uartwishbonebridge_storage);
	end else begin
		{uartwishbonebridge_uart_clk_txen, uartwishbonebridge_phase_accumulator_tx} <= 1'd0;
	end
	uartwishbonebridge_source_valid <= 1'd0;
	uartwishbonebridge_rx_r <= uartwishbonebridge_rx;
	if ((~uartwishbonebridge_rx_busy)) begin
		if (((~uartwishbonebridge_rx) & uartwishbonebridge_rx_r)) begin
			uartwishbonebridge_rx_busy <= 1'd1;
			uartwishbonebridge_rx_bitcount <= 1'd0;
		end
	end else begin
		if (uartwishbonebridge_uart_clk_rxen) begin
			uartwishbonebridge_rx_bitcount <= (uartwishbonebridge_rx_bitcount + 1'd1);
			if ((uartwishbonebridge_rx_bitcount == 1'd0)) begin
				if (uartwishbonebridge_rx) begin
					uartwishbonebridge_rx_busy <= 1'd0;
				end
			end else begin
				if ((uartwishbonebridge_rx_bitcount == 4'd9)) begin
					uartwishbonebridge_rx_busy <= 1'd0;
					if (uartwishbonebridge_rx) begin
						uartwishbonebridge_source_payload_data <= uartwishbonebridge_rx_reg;
						uartwishbonebridge_source_valid <= 1'd1;
					end
				end else begin
					uartwishbonebridge_rx_reg <= {uartwishbonebridge_rx, uartwishbonebridge_rx_reg[7:1]};
				end
			end
		end
	end
	if (uartwishbonebridge_rx_busy) begin
		{uartwishbonebridge_uart_clk_rxen, uartwishbonebridge_phase_accumulator_rx} <= (uartwishbonebridge_phase_accumulator_rx + uartwishbonebridge_storage);
	end else begin
		{uartwishbonebridge_uart_clk_rxen, uartwishbonebridge_phase_accumulator_rx} <= 32'd2147483648;
	end
	uartwishbonebridge_state <= uartwishbonebridge_next_state;
	if (uartwishbonebridge_reset) begin
		uartwishbonebridge_state <= 3'd0;
	end
	if (uartwishbonebridge_wait) begin
		if ((~uartwishbonebridge_done)) begin
			uartwishbonebridge_count <= (uartwishbonebridge_count - 1'd1);
		end
	end else begin
		uartwishbonebridge_count <= 24'd10000000;
	end
	if (analyzer_analyzerfrontend_buffer_pipe_ce) begin
		analyzer_analyzerfrontend_buffer_valid_n <= analyzer_analyzerfrontend_buffer_sink_valid;
	end
	if (analyzer_analyzerfrontend_buffer_pipe_ce) begin
		analyzer_analyzerfrontend_buffer_first_n <= (analyzer_analyzerfrontend_buffer_sink_valid & analyzer_analyzerfrontend_buffer_sink_first);
		analyzer_analyzerfrontend_buffer_last_n <= (analyzer_analyzerfrontend_buffer_sink_valid & analyzer_analyzerfrontend_buffer_sink_last);
	end
	if (analyzer_analyzerfrontend_buffer_pipe_ce) begin
		analyzer_analyzerfrontend_buffer_source_payload_data <= analyzer_analyzerfrontend_buffer_sink_payload_data;
		analyzer_analyzerfrontend_buffer_source_payload_hit <= analyzer_analyzerfrontend_buffer_sink_payload_hit;
	end
	if (analyzer_analyzerfrontend_subsampler_source_ready) begin
		if (analyzer_analyzerfrontend_subsampler_done) begin
			analyzer_analyzerfrontend_subsampler_counter <= 1'd0;
		end else begin
			if (analyzer_analyzerfrontend_subsampler_sink_valid) begin
				analyzer_analyzerfrontend_subsampler_counter <= (analyzer_analyzerfrontend_subsampler_counter + 1'd1);
			end
		end
	end
	analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary <= analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next_binary;
	analyzer_analyzerfrontend_asyncfifo_graycounter0_q <= analyzer_analyzerfrontend_asyncfifo_graycounter0_q_next;
	analyzer_analyzerfrontend_asyncfifo_graycounter1_q_binary <= analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next_binary;
	analyzer_analyzerfrontend_asyncfifo_graycounter1_q <= analyzer_analyzerfrontend_asyncfifo_graycounter1_q_next;
	if (analyzer_storage_mem_syncfifo_re) begin
		analyzer_storage_mem_readable <= 1'd1;
	end else begin
		if (analyzer_storage_mem_re) begin
			analyzer_storage_mem_readable <= 1'd0;
		end
	end
	if (((analyzer_storage_mem_syncfifo_we & analyzer_storage_mem_syncfifo_writable) & (~analyzer_storage_mem_replace))) begin
		analyzer_storage_mem_produce <= (analyzer_storage_mem_produce + 1'd1);
	end
	if (analyzer_storage_mem_do_read) begin
		analyzer_storage_mem_consume <= (analyzer_storage_mem_consume + 1'd1);
	end
	if (((analyzer_storage_mem_syncfifo_we & analyzer_storage_mem_syncfifo_writable) & (~analyzer_storage_mem_replace))) begin
		if ((~analyzer_storage_mem_do_read)) begin
			analyzer_storage_mem_level0 <= (analyzer_storage_mem_level0 + 1'd1);
		end
	end else begin
		if (analyzer_storage_mem_do_read) begin
			analyzer_storage_mem_level0 <= (analyzer_storage_mem_level0 - 1'd1);
		end
	end
	if (analyzer_storage_reset) begin
		analyzer_storage_mem_readable <= 1'd0;
		analyzer_storage_mem_level0 <= 10'd0;
		analyzer_storage_mem_produce <= 9'd0;
		analyzer_storage_mem_consume <= 9'd0;
	end
	litescopeanalyzer_state <= litescopeanalyzer_next_state;
	slave_sel_r <= slave_sel;
	interface0_bank_bus_dat_r <= 1'd0;
	if (csrbank0_sel) begin
		case (interface0_bank_bus_adr[4:0])
			1'd0: begin
				interface0_bank_bus_dat_r <= csrbank0_mux_value0_w;
			end
			1'd1: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_value3_w;
			end
			2'd2: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_value2_w;
			end
			2'd3: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_value1_w;
			end
			3'd4: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_value0_w;
			end
			3'd5: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_mask3_w;
			end
			3'd6: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_mask2_w;
			end
			3'd7: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_mask1_w;
			end
			4'd8: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_trigger_mask0_w;
			end
			4'd9: begin
				interface0_bank_bus_dat_r <= csrbank0_frontend_subsampler_value0_w;
			end
			4'd10: begin
				interface0_bank_bus_dat_r <= analyzer_storage_start_w;
			end
			4'd11: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_length0_w;
			end
			4'd12: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_offset0_w;
			end
			4'd13: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_idle_w;
			end
			4'd14: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_wait_w;
			end
			4'd15: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_run_w;
			end
			5'd16: begin
				interface0_bank_bus_dat_r <= analyzer_storage_mem_flush_w;
			end
			5'd17: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_mem_valid_w;
			end
			5'd18: begin
				interface0_bank_bus_dat_r <= analyzer_storage_mem_ready_w;
			end
			5'd19: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_mem_data3_w;
			end
			5'd20: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_mem_data2_w;
			end
			5'd21: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_mem_data1_w;
			end
			5'd22: begin
				interface0_bank_bus_dat_r <= csrbank0_storage_mem_data0_w;
			end
		endcase
	end
	if (csrbank0_mux_value0_re) begin
		analyzer_storage_full <= csrbank0_mux_value0_r;
	end
	analyzer_re <= csrbank0_mux_value0_re;
	if (csrbank0_frontend_trigger_value3_re) begin
		analyzer_analyzerfrontend_trigger_value_storage_full[127:96] <= csrbank0_frontend_trigger_value3_r;
	end
	if (csrbank0_frontend_trigger_value2_re) begin
		analyzer_analyzerfrontend_trigger_value_storage_full[95:64] <= csrbank0_frontend_trigger_value2_r;
	end
	if (csrbank0_frontend_trigger_value1_re) begin
		analyzer_analyzerfrontend_trigger_value_storage_full[63:32] <= csrbank0_frontend_trigger_value1_r;
	end
	if (csrbank0_frontend_trigger_value0_re) begin
		analyzer_analyzerfrontend_trigger_value_storage_full[31:0] <= csrbank0_frontend_trigger_value0_r;
	end
	analyzer_analyzerfrontend_trigger_value_re <= csrbank0_frontend_trigger_value0_re;
	if (csrbank0_frontend_trigger_mask3_re) begin
		analyzer_analyzerfrontend_trigger_mask_storage_full[127:96] <= csrbank0_frontend_trigger_mask3_r;
	end
	if (csrbank0_frontend_trigger_mask2_re) begin
		analyzer_analyzerfrontend_trigger_mask_storage_full[95:64] <= csrbank0_frontend_trigger_mask2_r;
	end
	if (csrbank0_frontend_trigger_mask1_re) begin
		analyzer_analyzerfrontend_trigger_mask_storage_full[63:32] <= csrbank0_frontend_trigger_mask1_r;
	end
	if (csrbank0_frontend_trigger_mask0_re) begin
		analyzer_analyzerfrontend_trigger_mask_storage_full[31:0] <= csrbank0_frontend_trigger_mask0_r;
	end
	analyzer_analyzerfrontend_trigger_mask_re <= csrbank0_frontend_trigger_mask0_re;
	if (csrbank0_frontend_subsampler_value0_re) begin
		analyzer_analyzerfrontend_subsampler_value_storage_full[15:0] <= csrbank0_frontend_subsampler_value0_r;
	end
	analyzer_analyzerfrontend_subsampler_value_re <= csrbank0_frontend_subsampler_value0_re;
	if (csrbank0_storage_length0_re) begin
		analyzer_storage_length_storage_full[9:0] <= csrbank0_storage_length0_r;
	end
	analyzer_storage_length_re <= csrbank0_storage_length0_re;
	if (csrbank0_storage_offset0_re) begin
		analyzer_storage_offset_storage_full[9:0] <= csrbank0_storage_offset0_r;
	end
	analyzer_storage_offset_re <= csrbank0_storage_offset0_re;
	interface1_bank_bus_dat_r <= 1'd0;
	if (csrbank1_sel) begin
		case (interface1_bank_bus_adr[0])
			1'd0: begin
				interface1_bank_bus_dat_r <= csrbank1_in_w;
			end
			1'd1: begin
				interface1_bank_bus_dat_r <= csrbank1_out0_w;
			end
		endcase
	end
	if (csrbank1_out0_re) begin
		io_storage_full[15:0] <= csrbank1_out0_r;
	end
	io_re <= csrbank1_out0_re;
	if (sys_rst) begin
		sram_bus_ack <= 1'd0;
		interface_adr <= 14'd0;
		interface_we <= 1'd0;
		interface_dat_w <= 32'd0;
		bus_wishbone_dat_r <= 32'd0;
		bus_wishbone_ack <= 1'd0;
		counter <= 2'd0;
		serial_tx <= 1'd1;
		uartwishbonebridge_sink_ready <= 1'd0;
		uartwishbonebridge_uart_clk_txen <= 1'd0;
		uartwishbonebridge_phase_accumulator_tx <= 32'd0;
		uartwishbonebridge_tx_reg <= 8'd0;
		uartwishbonebridge_tx_bitcount <= 4'd0;
		uartwishbonebridge_tx_busy <= 1'd0;
		uartwishbonebridge_source_valid <= 1'd0;
		uartwishbonebridge_uart_clk_rxen <= 1'd0;
		uartwishbonebridge_phase_accumulator_rx <= 32'd0;
		uartwishbonebridge_rx_r <= 1'd0;
		uartwishbonebridge_rx_reg <= 8'd0;
		uartwishbonebridge_rx_bitcount <= 4'd0;
		uartwishbonebridge_rx_busy <= 1'd0;
		uartwishbonebridge_count <= 24'd10000000;
		analyzer_storage_full <= 1'd0;
		analyzer_re <= 1'd0;
		analyzer_analyzerfrontend_buffer_valid_n <= 1'd0;
		analyzer_analyzerfrontend_buffer_first_n <= 1'd0;
		analyzer_analyzerfrontend_buffer_last_n <= 1'd0;
		analyzer_analyzerfrontend_trigger_value_storage_full <= 128'd0;
		analyzer_analyzerfrontend_trigger_value_re <= 1'd0;
		analyzer_analyzerfrontend_trigger_mask_storage_full <= 128'd0;
		analyzer_analyzerfrontend_trigger_mask_re <= 1'd0;
		analyzer_analyzerfrontend_subsampler_value_storage_full <= 16'd0;
		analyzer_analyzerfrontend_subsampler_value_re <= 1'd0;
		analyzer_analyzerfrontend_subsampler_counter <= 16'd0;
		analyzer_analyzerfrontend_asyncfifo_graycounter0_q <= 4'd0;
		analyzer_analyzerfrontend_asyncfifo_graycounter0_q_binary <= 4'd0;
		analyzer_analyzerfrontend_asyncfifo_graycounter1_q <= 4'd0;
		analyzer_analyzerfrontend_asyncfifo_graycounter1_q_binary <= 4'd0;
		analyzer_storage_length_storage_full <= 10'd0;
		analyzer_storage_length_re <= 1'd0;
		analyzer_storage_offset_storage_full <= 10'd0;
		analyzer_storage_offset_re <= 1'd0;
		analyzer_storage_mem_readable <= 1'd0;
		analyzer_storage_mem_level0 <= 10'd0;
		analyzer_storage_mem_produce <= 9'd0;
		analyzer_storage_mem_consume <= 9'd0;
		io_storage_full <= 16'd0;
		io_re <= 1'd0;
		uartwishbonebridge_state <= 3'd0;
		litescopeanalyzer_state <= 2'd0;
		slave_sel_r <= 2'd0;
		interface0_bank_bus_dat_r <= 32'd0;
		interface1_bank_bus_dat_r <= 32'd0;
	end
	xilinxmultiregimpl0_regs0 <= serial_rx;
	xilinxmultiregimpl0_regs1 <= xilinxmultiregimpl0_regs0;
	xilinxmultiregimpl1_regs0 <= analyzer_analyzerfrontend_trigger_value_storage;
	xilinxmultiregimpl1_regs1 <= xilinxmultiregimpl1_regs0;
	xilinxmultiregimpl2_regs0 <= analyzer_analyzerfrontend_trigger_mask_storage;
	xilinxmultiregimpl2_regs1 <= xilinxmultiregimpl2_regs0;
	xilinxmultiregimpl3_regs0 <= analyzer_analyzerfrontend_subsampler_value_storage;
	xilinxmultiregimpl3_regs1 <= xilinxmultiregimpl3_regs0;
	xilinxmultiregimpl4_regs0 <= analyzer_analyzerfrontend_asyncfifo_graycounter0_q;
	xilinxmultiregimpl4_regs1 <= xilinxmultiregimpl4_regs0;
	xilinxmultiregimpl5_regs0 <= analyzer_analyzerfrontend_asyncfifo_graycounter1_q;
	xilinxmultiregimpl5_regs1 <= xilinxmultiregimpl5_regs0;
	xilinxmultiregimpl6_regs0 <= io_input;
	xilinxmultiregimpl6_regs1 <= xilinxmultiregimpl6_regs0;
end

reg [31:0] mem[0:1023];
reg [9:0] memadr;
always @(posedge sys_clk) begin
	if (sram_we[0])
		mem[sram_adr][7:0] <= sram_dat_w[7:0];
	if (sram_we[1])
		mem[sram_adr][15:8] <= sram_dat_w[15:8];
	if (sram_we[2])
		mem[sram_adr][23:16] <= sram_dat_w[23:16];
	if (sram_we[3])
		mem[sram_adr][31:24] <= sram_dat_w[31:24];
	memadr <= sram_adr;
end

assign sram_dat_r = mem[memadr];

reg [130:0] storage[0:7];
reg [2:0] memadr_1;
reg [130:0] memdat;
always @(posedge sys_clk) begin
	if (analyzer_analyzerfrontend_asyncfifo_wrport_we)
		storage[analyzer_analyzerfrontend_asyncfifo_wrport_adr] <= analyzer_analyzerfrontend_asyncfifo_wrport_dat_w;
	memadr_1 <= analyzer_analyzerfrontend_asyncfifo_wrport_adr;
end

always @(posedge sys_clk) begin
	memdat <= storage[analyzer_analyzerfrontend_asyncfifo_rdport_adr];
end

assign analyzer_analyzerfrontend_asyncfifo_wrport_dat_r = storage[memadr_1];
assign analyzer_analyzerfrontend_asyncfifo_rdport_dat_r = memdat;

reg [129:0] storage_1[0:511];
reg [8:0] memadr_2;
reg [129:0] memdat_1;
always @(posedge sys_clk) begin
	if (analyzer_storage_mem_wrport_we)
		storage_1[analyzer_storage_mem_wrport_adr] <= analyzer_storage_mem_wrport_dat_w;
	memadr_2 <= analyzer_storage_mem_wrport_adr;
end

always @(posedge sys_clk) begin
	if (analyzer_storage_mem_rdport_re)
		memdat_1 <= storage_1[analyzer_storage_mem_rdport_adr];
end

assign analyzer_storage_mem_wrport_dat_r = storage_1[memadr_2];
assign analyzer_storage_mem_rdport_dat_r = memdat_1;

endmodule
