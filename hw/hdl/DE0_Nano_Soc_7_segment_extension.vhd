-- #############################################################################
-- DE0_Nano_Soc_7_segment_extension_board.vhd
--
-- BOARD         : DE0-Nano-SoC from Terasic
-- Author        : Florian Depraz
--               : Sahand Kashani-Akhavan from Terasic documentation
-- Revision      : 1.0
-- Creation date : 27/10/2016
--
-- Syntax Rule : GROUP_NAME_N[bit]
--
-- GROUP : specify a particular interface (ex: SDR_)
-- NAME  : signal name (ex: CONFIG, D, ...)
-- bit   : signal index
-- _N    : to specify an active-low signal
-- #############################################################################

library ieee;
use ieee.std_logic_1164.all;

entity DE0_Nano_Soc_7_segment_extension is
    port(
        -- CLOCK
        FPGA_CLK1_50     : in    std_logic;

        -- KEY
        KEY_N            : in    std_logic_vector(1 downto 0);

        -- LED
        LED              : out   std_logic_vector(7 downto 0);

        -- Extension board 7 segments
        SelSeg           : out   std_logic_vector(7 downto 0);
        Reset_Led        : out   std_logic;
        nSelDig          : out   std_logic_vector(5 downto 0);
        SwLed            : in    std_logic_vector(7 downto 0);
        nButton          : in    std_logic_vector(3 downto 0);
        LedButton        : out   std_logic_vector(3 downto 0)
    );
end entity DE0_Nano_Soc_7_segment_extension;

architecture rtl of DE0_Nano_Soc_7_segment_extension is

	component system_NiosII is
		port (
			clk_clk       : in std_logic := '0'; --   clk.clk
			reset_reset_n : in std_logic := '0';  -- reset.reset_n
			display_segment_0_reset_led_writeresponsevalid_n : out std_logic;                           -- writeresponsevalid_n
			display_segment_0_selseg_readdata                : out std_logic_vector(7 downto 0);        -- readdata
			display_segment_0_nseldig_readdata               : out std_logic_vector(5 downto 0) 
		);
	end component system_NiosII;
begin


	system:  component system_NiosII
	port map (
		clk_clk       => FPGA_CLK1_50,
		reset_reset_n => KEY_N(0),
		display_segment_0_reset_led_writeresponsevalid_n => Reset_Led,
		display_segment_0_selseg_readdata  => SelSeg,
		display_segment_0_nseldig_readdata  => nSelDig
	);
	
	-- Set a value on the LEDs to check the version of the project running on the board
	LED <= "11110010";

end;
