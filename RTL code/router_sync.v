module router_sync(clk,resetn,detect_add,we_reg,re_0,re_1,
					re_2,empty_0,empty_1,empty_2,full_0,
					full_1,full_2,datain,
					v_out_0,v_out_1,v_out_2,we,fifo_full, 
					soft_rst_0,soft_rst_1,soft_rst_2);
					
input clk,resetn,detect_add,we_reg,re_0,re_1,re_2;
input empty_0,empty_1,empty_2,full_0,full_1,full_2;
input [1:0]datain;
output wire v_out_0,v_out_1,v_out_2;
output reg [2:0]we;
output reg fifo_full, soft_rst_0,soft_rst_1,soft_rst_2;

reg [1:0]temp;
reg [4:0]count0,count1,count2;

//sendataing datain to temp once address ditected
always@(posedge clk)
begin
	if(!resetn)
		temp <= 2'd0;
	else if(detect_add)
		temp<=datain;
	end

//write enable
always@(*)
begin 
	if(we_reg)
	begin
		case(temp)
			2'b00: we=3'b001;				
			2'b01: we=3'b010;
			2'b10: we=3'b100;
			default: we=3'b000;
		endcase
	end
	else
		we = 3'b000;		
end
	
//for fifo full
always@(*)
begin
	case(temp)
		2'b00: fifo_full=full_0;               
		2'b01: fifo_full=full_1;               
		2'b10: fifo_full=full_2;				
		default fifo_full=0;
	endcase
end

//valid out
assign v_out_0 = !empty_0;
assign v_out_1 = !empty_1;
assign v_out_2 = !empty_2;

//soft reset counter 
always@(posedge clk)
begin
	if(!resetn)
		count0<=5'b0;
	else if(!empty_0)
	begin
		if(!re_0)
		begin
			if(count0==5'b11110)	
			begin
				soft_rst_0<=1'b1;
				count0<=5'b0;
			end
			else
			begin
				count0<=count0+1'b1;
				soft_rst_0<=1'b0;
			end
		end
		else 
			count0<=5'd0;
	end
	else 
		count0<=5'd0;
end
	
always@(posedge clk)
begin
	if(!resetn)
		count1<=5'b0;
	else if(!empty_1)
	begin
		if(!re_1)
		begin
			if(count1==5'b11110)	
			begin
				soft_rst_1<=1'b1;
				count1<=5'b0;
			end
			else
			begin
				count1<=count1+1'b1;
				soft_rst_1<=1'b0;
			end
		end
		else 
			count1<=5'd0;
	end
	else 
		count1<=5'd0;
end
	
always@(posedge clk)
begin
	if(!resetn)
		count2<=5'b0;
	else if(!empty_2)
	begin
		if(!re_2)
		begin
			if(count2==5'b11110)	
			begin
				soft_rst_2<=1'b1;
				count2<=5'b0;
			end
			else
			begin
				count2<=count2+1'b1;
				soft_rst_2<=1'b0;
			end
		end
		else 
			count2<=5'd0;
	end
	else 
		count2<=5'd0;
end

endmodule



