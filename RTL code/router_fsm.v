module router_fsm(clk,resetn,pkt_valid,parity_done,datain,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
					detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state,busy);

parameter               
decode_address   	=3'b000,
load_firesetn_data 	=3'b001,
load_data 			=3'b010,
fifo_full_state		=3'b011,
load_after_full		=3'b100,
load_parity 		=3'b101,
check_parity_error	=3'b110,
wait_till_empty		=3'b111;


input clk,resetn,pkt_valid,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
input [1:0] datain;
output detect_add,ld_state,laf_state,full_state,we_reg,rst_int_reg,lfd_state,busy;

reg[3:0] present_state,next_state;
reg [1:0]addr;

always @(posedge clk)
begin
	if(!resetn)
		addr<=1'b0;
	else 
		addr<=datain;
end 

//reset operation
always@(posedge clk)
begin
	if(!resetn)
		present_state<=decode_address;
	else if (((soft_rst_0) && (addr==2'b00)) || 
		     ((soft_rst_1) && (addr==2'b01)) || 
			 ((soft_rst_2) && (addr==2'b10)))
				 
		present_state<=decode_address;
	else
		present_state<=next_state;
			
end

always@(*)
begin
	case(present_state)
		decode_address : 
		begin
			if((pkt_valid & (datain == 2'b00) & fifo_empty_0) |
				(pkt_valid & (datain == 2'b01) & fifo_empty_1) |
				(pkt_valid & (datain == 2'b10) & fifo_empty_2) )
				next_state =load_firesetn_data;
			else if ((pkt_valid & (datain == 2'b00) & !fifo_empty_0) |
					 (pkt_valid & (datain == 2'b01) & !fifo_empty_0) |
					 (pkt_valid & (datain == 2'b10) & !fifo_empty_0) )
				next_state =wait_till_empty;
			else
				next_state = decode_address;
		end
		
		load_firesetn_data:
		begin
			next_state =load_data;
		end
		
		load_data: 
		begin
			if(!fifo_full && !pkt_valid)
				next_state = load_parity;
			else if (fifo_full)
				next_state =fifo_full_state;
			else
				next_state = load_data;
		end
		
		load_parity: 
		begin
			next_state = check_parity_error;
		end
		
		fifo_full_state:
		begin
			if (!fifo_full)
				next_state = load_after_full;
			else
				next_state = fifo_full_state;
		end
		
		load_after_full:
		begin
			if (!parity_done && !low_pkt_valid)
				next_state = load_data;
			else if (!parity_done && low_pkt_valid)
				next_state = load_parity;
			else 
			begin 
				if(parity_done==1'b1)
					next_state=decode_address;
				else
					next_state=load_after_full;
			end
		end
		
		wait_till_empty:
		begin
			if ((fifo_empty_0 && (addr == 2'b00)) ||
				 (fifo_empty_0 && (addr == 2'b01)) ||
				 (fifo_empty_0 && (addr == 2'b10)))
				next_state = load_firesetn_data;
			else
				next_state = wait_till_empty;
		end
		
		check_parity_error:
		begin
			if (!fifo_full)
				next_state = decode_address;
			else if(fifo_full)
				next_state = fifo_full_state;
			else
				next_state = check_parity_error;
		end
		default:
			next_state =decode_address;
	endcase
end 

assign busy=((present_state==load_firesetn_data)||(present_state==load_parity)||(present_state==fifo_full_state)||(present_state==load_after_full)||(present_state==wait_till_empty)||(present_state==check_parity_error))?1:0;
assign detect_add=((present_state==decode_address))?1:0;
assign lfd_state=((present_state==load_firesetn_data))?1:0;
assign ld_state=((present_state==load_data))?1:0;
assign we_reg=((present_state==load_data)||(present_state==load_after_full)||(present_state==load_parity))?1:0;
assign full_state=((present_state==fifo_full_state))?1:0;
assign laf_state=((present_state==load_after_full))?1:0;
assign rst_int_reg=((present_state==check_parity_error))?1:0;

endmodule