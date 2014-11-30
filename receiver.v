`timescale 1ns / 1ps
module receiver
(
	input wire rx,
	output reg rdy,
	input wire rdy_clr,
	input wire clk_50m,
	input wire clken,
	output reg [7:0] data,
	output reg parity_err
 );
 
 initial begin
	rdy = 0;
	data = 8'b0;
	parity_err = 0;
 end

parameter RX_STATE_START = 2'b00;
parameter RX_STATE_DATA  = 2'b01;
parameter RX_STATE_STOP  = 2'b10;

reg [1:0] state = RX_STATE_START;
reg [3:0] sample = 0;
reg [3:0] bitpos = 0;
reg [8:0] scratch = 8'b0;

always @(posedge rdy_clr)
begin
		rdy <= 0;
end

always @(posedge clk_50m)
begin

	if (clken)
		begin
			case (state)
				RX_STATE_START:
					begin
						if (!rx || sample != 0)
							sample <= sample + 4'b1;
							
						if (sample == 15)
							begin
								state <= RX_STATE_DATA;
								bitpos <= 0;
								sample <= 0;
								scratch <= 0;
							end
					end
				
				RX_STATE_DATA:
					begin
						sample <= sample + 4'b1;
						if (sample == 4'h8) 
							begin
								scratch[bitpos[3:0]] <= rx;	/* Sample the value */
								bitpos <= bitpos + 4'b1;
							end
						
						if (bitpos == 9 && sample == 14)
						begin
							state <= RX_STATE_STOP;
							parity_err <= scratch[8] ^ scratch[7] ^ scratch[6] ^ scratch[5] 
											^ scratch[4] ^ scratch[3] ^ scratch[2] ^ scratch[1] 
											^ scratch[0];
						end
						
					end
				
				RX_STATE_STOP:
					begin
						if (sample == 15 || (sample >= 8 && !rx))
							begin
								state <= RX_STATE_START;
								data <= scratch[7:0];
								rdy <= 1'b1;
								sample <= 0;
							end
					end
				
				default:
					begin
						state <= RX_STATE_START;
					end
			endcase
		end
end

endmodule
