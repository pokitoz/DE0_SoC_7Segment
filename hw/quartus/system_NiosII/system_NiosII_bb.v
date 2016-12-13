
module system_NiosII (
	clk_clk,
	display_segment_0_nseldig_readdata,
	display_segment_0_reset_led_writeresponsevalid_n,
	display_segment_0_selseg_readdata,
	reset_reset_n);	

	input		clk_clk;
	output	[5:0]	display_segment_0_nseldig_readdata;
	output		display_segment_0_reset_led_writeresponsevalid_n;
	output	[7:0]	display_segment_0_selseg_readdata;
	input		reset_reset_n;
endmodule
