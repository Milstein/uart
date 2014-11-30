`timescale 1ns / 1ps

module tb_usart;

	// Inputs
	reg [7:0] tb_DATA_IN;
	reg tb_n_WR;
	reg tb_CLK50M;
	reg tb_rdy_clr;
	reg tb_n_RST;
	
	// Outputs
	//wire tb_tx;
	wire tb_Tx_RDY;
	wire tb_Rx_RDY;
	wire [7:0] tb_DATA_OUT;
	wire loopback;
	wire tb_n_INT;
	
	// Instantiate the Unit Under Test (UUT)
	usart uut (
		.DATA_IN(tb_DATA_IN), 
		.n_WR(tb_n_WR), 
		.CLK50M(tb_CLK50M), 
		.TxD(loopback), 
		.Tx_RDY(tb_Tx_RDY), 
		.RxD(loopback), 
		.Rx_RDY(tb_Rx_RDY), 
		.rdy_clr(tb_rdy_clr),
		.n_RST(tb_n_RST),
		.DATA_OUT(tb_DATA_OUT),
		.n_INT(tb_n_INT)
	);

	initial begin
		// Initialize Inputs
		tb_rdy_clr = 0;
		tb_DATA_IN = 8'b00000000;
		tb_n_WR= 1'b1;
		tb_CLK50M= 0;
		tb_n_RST = 0;
		
		#2 tb_n_WR = 1'b0;
		tb_n_RST = 1;
 
	end
      
	always begin
		#1 tb_CLK50M = ~tb_CLK50M;
	end
	
	always @(posedge tb_Rx_RDY) begin
			
		tb_DATA_IN <= tb_DATA_IN + 1'b1;
		tb_n_WR <= 1'b1;
		#2 tb_n_WR <= 1'b0;
		
		tb_rdy_clr <= 1;
		#2 tb_rdy_clr <= 0;
	end
	
endmodule

