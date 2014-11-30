`timescale 1ns / 1ps

module tb_parity_error;
	parameter TX_ACC_MAX = 50000000 / 115200;	
	
	// Inputs
	reg [7:0] tb_DATA_IN;
	reg tb_n_WR;
	reg tb_n_RST;
	reg tb_CLK50M;
	reg tb_RxD;
	reg tb_rdy_clr;

	// Outputs
	wire tb_TxD;
	wire tb_Tx_RDY;
	wire tb_Rx_RDY;
	wire [7:0] tb_DATA_OUT;
	wire tb_n_INT;

	//Error data
	reg [9:0] err_frame = 10'b1000010010;
	reg [3:0] bit_pos = 0;
	
	reg [8:0] tb_tx_count = 4;
	
	//clk
	wire tb_tx_clk;
	
	// States
	parameter STATE_WAIT = 2'b00;
	parameter STATE_TRANSMIT = 2'b01;
	
	reg [1:0] state = STATE_WAIT;
	
	// Instantiate the Unit Under Test (UUT)
	usart uut (
		.DATA_IN(tb_DATA_IN), 
		.n_WR(tb_n_WR), 
		.n_RST(tb_n_RST), 
		.CLK50M(tb_CLK50M), 
		.TxD(tb_TxD), 
		.Tx_RDY(tb_Tx_RDY), 
		.RxD(tb_RxD), 
		.Rx_RDY(tb_Rx_RDY), 
		.rdy_clr(tb_rdy_clr), 
		.DATA_OUT(tb_DATA_OUT), 
		.n_INT(tb_n_INT)
	);

	initial begin
		// Initialize Inputs
		tb_DATA_IN = 9'b0;
		tb_n_WR = 0;
		tb_n_RST = 0;
		tb_CLK50M = 0;
		tb_RxD = 1;
		tb_rdy_clr = 0;

		#2;

	end
      
	always begin
		#1 tb_CLK50M = ~tb_CLK50M;
	end
	
	always @(posedge tb_CLK50M)
	begin
		if (tb_tx_count == TX_ACC_MAX)
			tb_tx_count = 0;
		else
			tb_tx_count <= tb_tx_count + 1;
	end
	
	always @(posedge tb_tx_clk)
	begin
		case (state)
				STATE_WAIT:
				begin
					if (!tb_Rx_RDY)
						state <= STATE_TRANSMIT;
				end
				
				STATE_TRANSMIT:
				begin
					tb_RxD <= err_frame[bit_pos];
					
					if (bit_pos == 4'h9)
						begin
							bit_pos <= 0;
							tb_RxD <= 1;
							state <= STATE_WAIT;
						end
					else
						bit_pos <= bit_pos + 1;
				end
		endcase
		
		
	end

assign tb_tx_clk = (tb_tx_count == 5'd0);

endmodule

