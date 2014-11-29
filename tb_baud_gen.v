`timescale 1ns / 1ps


module tb_baud_gen;

	// Inputs
	reg tb_clk_50m;

	// Outputs
	wire tb_rxclk_en;
	wire tb_txclk_en;

	// Instantiate the Unit Under Test (UUT)
	baud_rate_gen uut (
		.clk_50m(tb_clk_50m), 
		.rxclk_en(tb_rxclk_en), 
		.txclk_en(tb_txclk_en)
	);

	initial begin
		// Initialize Inputs
		tb_clk_50m = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always begin
		tb_clk_50m = tb_clk_50m ^ 1;
		#1;
	end
      
endmodule

