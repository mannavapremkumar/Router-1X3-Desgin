module router_top_tb();

reg clk, resetn, read_enb_0, read_enb_1, read_enb_2, packet_valid;
reg [7:0]datain;
wire [7:0]data_out_0, data_out_1, data_out_2;
wire vld_out_0, vld_out_1, vld_out_2, err, busy;
integer i;

router_top dut(clk, resetn, packet_valid, read_enb_0, read_enb_1, 
				read_enb_2,datain,vld_out_0, vld_out_1, vld_out_2, 
				err, busy,data_out_0, data_out_1, data_out_2);		   
			   
//clock generation
initial 
begin
	clk = 1;
	forever 
	#5 clk=~clk;
end
	
task initialize;
begin
	read_enb_0 = 1'b0;
	read_enb_1 = 1'b0;
	read_enb_2 = 1'b0;
end
endtask

task reset;
begin
	resetn=1'b0;
	{read_enb_0, read_enb_1, read_enb_2, packet_valid, datain}=0;
	#10;
	resetn=1'b1;
end
endtask
	
task pktm_gen_8;	// packet generation payload 8
reg [7:0]header, payload_data, parity;
reg [8:0]payloadlen;		
begin
	parity=0;
	wait(!busy)
	begin
		@(negedge clk);
		payloadlen=8;
		packet_valid=1'b1;
		header={payloadlen,2'b00};
		datain=header;
		parity=parity^datain;
	end
	@(negedge clk);
						
	for(i=0;i<payloadlen;i=i+1)
	begin
		wait(!busy)				
		@(negedge clk);
		payload_data={$random}%256;
		datain=payload_data;
		parity=parity^datain;				
	end					
								
	wait(!busy)				
	@(negedge clk);
	packet_valid=0;				
	datain=parity;
	#20
	@(negedge clk);
	read_enb_0=1'b1;
end
endtask
	
task pktm_gen_14;	// packet generation payload 8
reg [7:0]header, payload_data, parity;
reg [4:0]payloadlen;			
begin
	parity=0;
	wait(!busy)
	begin
		@(negedge clk);
		payloadlen=14;
		packet_valid=1'b1;
		header={payloadlen,2'b01};
		datain=header;
		parity=parity^datain;
	end
	@(negedge clk);
							
	for(i=0;i<payloadlen;i=i+1)
	begin
		wait(!busy)				
		@(negedge clk);
		payload_data={$random}%256;
		datain=payload_data;
		parity=parity^datain;				
	end					
								
	wait(!busy)				
	@(negedge clk);
	packet_valid=0;				
	datain=parity;
	#20;
	@(negedge clk);
	read_enb_1=1'b1;
	end
endtask
	
task pktm_gen_17;	// packet generation payload 8
reg [7:0]header, payload_data, parity;
reg [4:0]payloadlen;			
begin
	parity=0;
	wait(!busy)
	begin
		@(negedge clk);
		payloadlen=17;
		packet_valid=1'b1;
		header={payloadlen,2'b10};
		datain=header;
		parity=parity^datain;
	end
	@(negedge clk);
							
	for(i=0;i<payloadlen;i=i+1)
	begin
		wait(!busy)				
		@(negedge clk);
		payload_data={$random}%256;
		datain=payload_data;
		parity=parity^datain;				
	end					
								
	wait(!busy)				
	@(negedge clk);
	packet_valid=0;				
	datain=parity;
	#20;
	@(negedge clk);
	read_enb_2=1'b1;
	end
endtask

initial
begin
	reset;
	#10;
	pktm_gen_8;
	#200;
	initialize;
	#50;
	pktm_gen_14;
	#200;
	initialize;
	#50;
	pktm_gen_17;
	#200;
	initialize;
	#1000;
	$finish;
end
endmodule



