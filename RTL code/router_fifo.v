module router_fifo(clk,resetn,soft_rst,datain,dout,we,re,empty,full,lfd_state);

input clk,resetn,soft_rst,we,re,lfd_state;
input [7:0] datain;
output reg [7:0] dout;
output reg full,empty;
reg [3:0] rd_pter,wr_pter;
reg[4:0] counter;
reg [5:0] payload_len;
reg temp;
integer i;

reg [8:0] mem [15:0];

//lfd_state
always@(posedge clk)
begin
	if(!resetn)
		temp<=1'b0;
	else 
		temp<=lfd_state;
	end 

//full and empty logic
always @(counter)
begin

	empty = (counter==0);
	full = (counter==16);
	
end

//counter logic
always @(posedge clk)
begin
	if(!resetn)
		counter <=0;
	else if((!full && we) && (!empty && re))
		counter <= counter;
	else if(!full && we)
		counter <= counter+1;
	else if(!empty && re)
		counter <= counter-1;
	else
		counter <= counter;
end

//FIFO READ logic
always @(posedge clk)
begin
	if(!resetn)
		dout<=0;
	else if (soft_rst)
		dout <= 'bz;
	else
	begin	
		if(re && !empty)
			dout <= mem[rd_pter];
		else if (payload_len==0)
			dout <= 'bz;
		else
			dout <= dout;
	end
end

//Fifo write logic
always @(posedge clk)
begin
	if (!resetn || soft_rst)
	begin
		for(i=0;i<16;i=i+1)
		mem[i]<=0; 
	end
	else if(we && !full)
	begin
		mem[wr_pter] <= {lfd_state,datain};
	end
	else
		mem[wr_pter] <= mem[wr_pter];
end

//payload_len logic
always@(posedge clk)
begin
	if(!resetn || soft_rst)
		payload_len <= 0;
	if(re && !empty)
	begin
		if(mem[rd_pter[3:0]][8])                     
            payload_len<=mem[rd_pter[3:0]][7:2]+1'b1;
		else if(payload_len!=0)
			payload_len<=payload_len-1'b1;
				
	end
	
end

//pointer logic
always @(posedge clk)
begin
	if (!resetn)
	begin
		wr_pter <= 0;
		rd_pter <= 0;
	end
	else
	begin
	if (!full && we)
		wr_pter <= wr_pter +1;
	else
		wr_pter <= wr_pter;
	if (!empty && re)
		rd_pter <= rd_pter +1;
	else
		rd_pter <= rd_pter;
	end	
end
endmodule	
