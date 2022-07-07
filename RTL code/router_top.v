module router_top(clk, resetn, packet_valid, read_enb_0, read_enb_1, 
					read_enb_2,datain,vld_out_0, vld_out_1, vld_out_2, 
					err, busy,data_out_0, data_out_1, data_out_2);

input clk, resetn, packet_valid, read_enb_0, read_enb_1, read_enb_2;
input [7:0]datain;
output vld_out_0, vld_out_1, vld_out_2, err, busy;
output [7:0]data_out_0, data_out_1, data_out_2;
wire [2:0]w_enb;
wire [7:0]dout;

router_fifo f0(.clk(clk), .resetn(resetn), .soft_rst(soft_rst_0),
			  .lfd_state(lfd_state_w), .we(w_enb[0]), .datain(dout), 
			  .re(read_enb_0),.full(full_0),.empty(empty_0),.dout(data_out_0));
	
router_fifo f1(.clk(clk), .resetn(resetn), .soft_rst(soft_reset_1),
			   .lfd_state(lfd_state_w), .we(w_enb[1]), .datain(dout), 
			   .re(read_enb_1),.full(full_1),.empty(empty_1),.dout(data_out_1));

router_fifo f2(.clk(clk), .resetn(resetn), .soft_rst(soft_reset_2),
			   .lfd_state(lfd_state_w), .we(w_enb[2]), .datain(dout), 
			   .re(read_enb_2),.full(full_2),.empty(empty_2),.dout(data_out_2));
	  

router_reg r1(.clk(clk), .resetn(resetn), .packet_valid(packet_valid), .datain(datain), 
			  .dout(dout), .fifo_full(fifo_full), .detect_add(detect_add), 
			  .ld_state(ld_state),  .laf_state(laf_state), .full_state(full_state), 
			  .lfd_state(lfd_state_w), .rst_int_reg(rst_int_reg),  .err(err), .parity_done(parity_done), 
			  .low_packet_valid(low_packet_valid));


router_fsm fsm(.clk(clk), .resetn(resetn), .pkt_valid(packet_valid), 
			   .datain(datain[1:0]), .soft_rst_0(soft_rst_0), .soft_rst_1(soft_rst_1), .soft_rst_2(soft_reset_2), 
			   .fifo_full(fifo_full), .fifo_empty_0(empty_0), .fifo_empty_1(empty_1), .fifo_empty_2(empty_2),
			   .parity_done(parity_done), .low_pkt_valid(low_packet_valid), .busy(busy), .rst_int_reg(rst_int_reg), 
			   .full_state(full_state), .lfd_state(lfd_state_w), .laf_state(laf_state), .ld_state(ld_state), 
			   .detect_add(detect_add), .we_reg(write_enb_reg));
					
router_sync s(.clk(clk), .resetn(resetn), .datain(datain[1:0]), .detect_add(detect_add), 
              .full_0(full_0), .full_1(full_1), .full_2(full_2), .re_0(read_enb_0), 
			  .re_1(read_enb_1), .re_2(read_enb_2), .we_reg(write_enb_reg), 
			  .empty_0(empty_0), .empty_1(empty_1), .empty_2(empty_2), .v_out_0(vld_out_0), .v_out_1(vld_out_1), 
			  .v_out_2(vld_out_2), .soft_rst_0(soft_rst_0), .soft_rst_1(soft_rst_1), .soft_rst_2(soft_reset_2), 
			  .we(w_enb), .fifo_full(fifo_full));
					
endmodule