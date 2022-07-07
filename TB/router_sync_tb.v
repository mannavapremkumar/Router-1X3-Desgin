module router_sync_tb();

reg clk, rst, d_addr,we_reg,re_0, re_1, re_2, empty_0, empty_1, empty_2,full_0, full_1, full_2;
reg [1:0]din;
wire [2:0]write_enb;
wire v_out_0, v_out_1, v_out_2,fifo_full, soft_rst_0, soft_rst_1, soft_rst_2;

router_sync dut(clk,rst,d_addr,we_reg,re_0,re_1,re_2,empty_0,empty_1,empty_2,full_0,full_1,full_2,din,
					v_out_0,v_out_1,v_out_2,we,fifo_full, soft_rst_0,soft_rst_1,soft_rst_2);
				 
				 			  
initial 
begin
clk = 1;
forever 
#5 clk=~clk;
end
	
	
task reset;
begin
	rst=1'b0;
	#10;
	rst=1'b1;
end
endtask
	
task stimulus();
begin	
	d_addr=1'b1;
	din=2'b10;
	re_0=1'b0;
	re_1=1'b0;
	re_2=1'b0;
	we_reg=1'b1;
	full_0=1'b0;
	full_1=1'b0;
	full_2=1'b1;
	empty_0=1'b1;
	empty_1=1'b1;
	empty_2=1'b0;
end
endtask
	
initial 
begin
	reset;
	#5;
	stimulus;
	#1000;
	$finish;
		end
	endmodule 