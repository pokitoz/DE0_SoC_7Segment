library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity RTC_component is
    port(

        clk    : in    std_logic;
        rst    : in    std_logic;

        -- 7 Seg display signals --
        -- ===================== --
        -- Displayed number on the 7 segment. Value is encoded
        SelSeg                  : out   std_logic_vector(7 downto 0);
        -- Select one of the six 7-segment
        nSelDig                 : out   std_logic_vector(5 downto 0);
        Reset_Led               : out   std_logic;

        -- Avalon Memory Mapped Slave
        mm_slave_address     : in  std_logic; 
        mm_slave_read        : in  std_logic;
        mm_slave_readdata    : out std_logic_vector(31 downto 0);
        mm_slave_write       : in  std_logic;
        mm_slave_writedata   : in  std_logic_vector(31 downto 0)

    );
end entity RTC_component;

architecture rtl of RTC_component is

        constant LED_POSSIBLE_VALUE : integer := 16;
        constant NUMBER_OF_SEGMENTS : integer := 8; -- 7 segment and a dot
        constant NUMBER_OF_DISPLAYS : integer := 6; 

        -- Input clock is 50MHz
        -- Counter to achieve the different timings
        constant LED_ACTIVE                 : integer := 41500; -- 1/6ms
        constant MS_CYCLES                  : integer := 50000; -- 1ms
        signal counter_ms                   : integer range 0 to MS_CYCLES-1;

        signal enable_led               : std_logic;
        signal enable_reset             : std_logic;
        
        -- Integer value of SelDig
        signal nSelDig_int_tmp          : integer range 0 to NUMBER_OF_DISPLAYS-1;
        signal nSelDig_tmp              : std_logic_vector(NUMBER_OF_DISPLAYS-1 downto 0);
        

        -- Store the integer value of the different digits
        signal SelSeg_tmp               : std_logic_vector(NUMBER_OF_SEGMENTS-1 downto 0);
        type INT_ARRAY is array (0 to NUMBER_OF_DISPLAYS-1) of integer range 0 to LED_POSSIBLE_VALUE-1;
        signal values : INT_ARRAY;
      


begin

        enable_reset <= '1' when counter_ms > LED_ACTIVE else '0';

        -- Decode the integer value to a binary value representing the selected display
        nSelDig_tmp <= "111110" when nSelDig_int_tmp = 0 else
                                "111101" when nSelDig_int_tmp = 1 else
                                "111011" when nSelDig_int_tmp = 2 else
                                "110111" when nSelDig_int_tmp = 3 else
                                "101111" when nSelDig_int_tmp = 4 else
                                "011111";

        -- Do not select any if counter_ms is higher than 1/6ms
        nSelDig <= (others => '1') when (counter_ms > LED_ACTIVE-1 or counter_ms = 0) 
                        else nSelDig_tmp;

        Reset_Led <= enable_reset;

        -- Decode the value that should be printed to the display selected
        SelSeg <= X"3F" when values(nSelDig_int_tmp) = 0 else
                        X"06" when values(nSelDig_int_tmp) = 1 else
                        X"5B" when values(nSelDig_int_tmp) = 2 else
                        X"4F" when values(nSelDig_int_tmp) = 3 else
                        X"66" when values(nSelDig_int_tmp) = 4 else
                        X"6D" when values(nSelDig_int_tmp) = 5 else
                        X"7D" when values(nSelDig_int_tmp) = 6 else
                        X"07" when values(nSelDig_int_tmp) = 7 else
                        X"7F" when values(nSelDig_int_tmp) = 8 else
                        X"6F" when values(nSelDig_int_tmp) = 9 else
                        X"80";

        write_slave: process(clk, rst)
        variable unsigned_value : unsigned(3 downto 0);
        begin
                if(rst = '1') then
                        for i in 0 to INT_ARRAY'length - 1 loop
                                values(i) <= i;
                        end loop;

                elsif rising_edge(clk) then
                        if (mm_slave_write = '1') then
                                case mm_slave_address is
                                when '0' =>
                                        for i in 0 to INT_ARRAY'length - 1 loop
                                                unsigned_value := unsigned(mm_slave_writedata(4*(i+1) - 1 downto 4*i));
                                                values(i) <= to_integer(unsigned_value);
                                        end loop;
                                when others => 
                                        null;                                
                                end case;
                        end if;
                end if;
        end process;

        -- Select the appropriate value to display depending on which display we are currently
        display_value : process(clk, rst)
        begin
                if(rst = '1') then
                        nSelDig_int_tmp <= values(0);
                        nSelDig_int_tmp <= 0;

                elsif rising_edge(clk) then
                        -- "Clock divider" to count each ms
                        if enable_led = '1' then

                                if(nSelDig_int_tmp = NUMBER_OF_DISPLAYS-1) then
                                          nSelDig_int_tmp <= 0;                              
                                end if;
                                nSelDig_int_tmp <= nSelDig_int_tmp + 1;

                        end if;
                end if;
        end process;


        cycle_counter : process(clk, rst)
        begin
                if(rst = '1') then
                        counter_ms <= 0;
                        enable_led <= '0';
                elsif rising_edge(clk) then
                        if(counter_ms = MS_CYCLES-1) then
                                counter_ms <= 0;
                                enable_led <= '1';
                        else
                                counter_ms <= counter_ms + 1;
                                enable_led <= '0';
                        end if;
                end if;                        
        end process;
        
end;
