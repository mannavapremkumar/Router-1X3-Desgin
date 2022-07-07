module router_fifo_tb();

reg clk,rst,soft_rst,we,re,ifd_state;
reg [7:0] din;
wire [7:0] dout;
wire full,empty;
integer l;

router_fifo dut(clk,rst,soft_rst,din,dout,we,re,empty,full,ifd_state);

initial
begin
	clk = 1'b0;
	forever
	#5 clk = ~clk;
end

task initialize();
begin
	we=1'b0;
	re=1'b0; 
	soft_rst=0;
 
end
endtask

task reset();
begin
	rst = 1'b0;
	@(negedge clk)
	rst = 1'b1;
end
endtask

task delay;
begin
	#10;
end
endtask

task write;
reg[7:0] payload_data, parity,header;
reg[5:0] payload_len;
reg[1:0] addr;
integer k;
begin
	@(negedge clk);
	payload_len =6'd14;
	addr=2'b01;
	header= {payload_len,addr};
	din= header;
	ifd_state=1'b1;
	we=1;
	for(k=0;k<payload_len;k=k+1)
		begin
		@(negedge clk);
		ifd_state =0;
		payload_data =	{$random} %256;
		din = payload_data;
		end
	//@(negedge clk);
	//soft_rst =1;
	//@(negedge clk);
	//soft_rst =0;
	@(negedge clk);
	parity={$random}%256;
	din=parity;
	end
endtask

initial
begin
	reset;
	initialize;
	delay;
	write;
	delay;
	initialize;
	delay;
	re=1'b1;
	#200;
	$finish;
end
   
initial
	$monitor("din =%b,we =%b,re =%b,dout =%b",din,we,re,dout);

endmodule
