module router_fsm_tb();

reg clk,rst,pkt_valid,parity_done,soft_rst_0,soft_rst_1;
reg soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg [1:0] din;

wire busy,d_addr,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state;

router_fsm DUT(clk,rst,pkt_valid,parity_done,din,soft_rst_0,soft_rst_1,soft_rst_2,
				fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
				d_addr,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state,busy);

initial
begin
clk=1'b1;
forever
#5 clk=~clk;
end

task reset;
begin
@(negedge clk)
rst=1'b0;
@(negedge clk)
rst=1'b1;
end
endtask

task task1;
begin
	pkt_valid=1'b1; 
	din=2'b00;
	fifo_empty_0=1'b1;
	fifo_empty_1=1'b0; 
	fifo_empty_2=1'b0;
	fifo_full=1'b0;
	soft_rst_0=1'b0; 
	soft_rst_1=1'b0;
	soft_rst_2=1'b0;
	#10;
	fifo_empty_0=1'b0;
	#50;
	pkt_valid=1'b0;
end
endtask
	
task task2;
begin
	pkt_valid=1'b1; 
	din=2'b01;
	fifo_full=1'b0; 
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b1; 
	fifo_empty_2=1'b0; 
	soft_rst_0=1'b0; 
	soft_rst_1=1'b0;
	soft_rst_2=1'b0;
	#30;
	fifo_empty_1=1'b0;
	#30;
	fifo_full=1'b1;
	#10;
	fifo_full=1'b0;
	parity_done =1'b0;
	low_pkt_valid=1'b0;
	pkt_valid=1'b0;
end
endtask
	
task task3;
begin
	pkt_valid=1'b1; 
	din=2'b10;
	fifo_full=1'b0; 
	fifo_empty_0=1'b0;
	fifo_empty_1=1'b0; 
	fifo_empty_2=1'b1; 
	soft_rst_0=1'b0; 
	soft_rst_1=1'b0;
	soft_rst_2=1'b0;
	#30;
	fifo_empty_2=1'b0; 
	#30;
	fifo_full=1'b1;
	#10;
	fifo_full=1'b0;
	parity_done =1'b0;
	low_pkt_valid=1'b1;
end
endtask
	
task task4;
begin
	pkt_valid=1'b0; 
	din=2'b00;
	fifo_full=1'b0; 
	fifo_empty_0=1'b1;
	fifo_empty_1=1'b0; 
	fifo_empty_2=1'b0; 
	soft_rst_0=1'b0; 
	soft_rst_1=1'b0;
	soft_rst_2=1'b0;

end
endtask
	
initial 
begin
	reset;
	#20;
	task1;
	#20;
	task2;
	#40;
	task3;
	#30;
	task4;
	#50;
	$finish;
end
endmodule 	


