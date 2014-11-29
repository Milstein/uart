`timescale 1ns / 1ps
module usart
(
	input wire [7:0] DATA_IN,
	input wire n_WR,
	input n_RST,
	input wire CLK50M,
	output wire TxD,
	output wire Tx_RDY,
	input wire RxD,
	output wire Rx_RDY,
	input wire rdy_clr,						// Once data is read setting the wire to high acknowledges the data is read by CPU
	output wire [7:0] DATA_OUT
);

baud_rate_gen 
	uart_baud
	(
		.clk_50m(CLK50M),
		.rxclk_en(rxclk_en),
		.txclk_en(txclk_en)
	 );
	 
transmitter
	uart_tx
	(
		.din(DATA_IN),
		.wr_en(n_WR),
		.clk_50m(CLK50M),
		.clken(txclk_en),
		.tx(TxD),
		.tx_rdy(Tx_RDY)
	 );

receiver
	uart_rx
	(
		.rx(RxD),
		.rdy(Rx_RDY),
		.rdy_clr(rdy_clr),
		.clk_50m(CLK50M),
		.clken(rxclk_en),
		.data(DATA_OUT)
	);
	
endmodule