	component system_NiosII is
		port (
			clk_clk                                          : in  std_logic                    := 'X'; -- clk
			display_segment_0_nseldig_readdata               : out std_logic_vector(5 downto 0);        -- readdata
			display_segment_0_reset_led_writeresponsevalid_n : out std_logic;                           -- writeresponsevalid_n
			display_segment_0_selseg_readdata                : out std_logic_vector(7 downto 0);        -- readdata
			reset_reset_n                                    : in  std_logic                    := 'X'  -- reset_n
		);
	end component system_NiosII;

	u0 : component system_NiosII
		port map (
			clk_clk                                          => CONNECTED_TO_clk_clk,                                          --                         clk.clk
			display_segment_0_nseldig_readdata               => CONNECTED_TO_display_segment_0_nseldig_readdata,               --   display_segment_0_nseldig.readdata
			display_segment_0_reset_led_writeresponsevalid_n => CONNECTED_TO_display_segment_0_reset_led_writeresponsevalid_n, -- display_segment_0_reset_led.writeresponsevalid_n
			display_segment_0_selseg_readdata                => CONNECTED_TO_display_segment_0_selseg_readdata,                --    display_segment_0_selseg.readdata
			reset_reset_n                                    => CONNECTED_TO_reset_reset_n                                     --                       reset.reset_n
		);

