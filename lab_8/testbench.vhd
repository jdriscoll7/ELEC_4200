library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;


entity bench is
end bench;


architecture testing of bench is
    signal switches : std_logic_vector(3 downto 0);
    signal cathodes : std_logic_vector(6 downto 0);
    signal cathode_compare : std_logic_vector(6 downto 0);
    signal clk : std_logic;
begin

    test_unit: entity work.hex_decoder_top_level
    port map(switches => switches,
             cathodes => cathodes,
             clk      => clk);

    seg_compare: entity work.hex_decoder_module
    port map(D => switches(3 downto 0),
             segments => cathode_compare(6 downto 0));

    -- Try all switch combinations and compare the two decoder cathode patterns.
    process
    begin
            
        for i in 0 to ((2**4) - 1) loop
            
            switches <= std_logic_vector(to_unsigned(i, switches'length));
            
            -- Let clock pulse 100 times (unsure of how long assembly will take to run).
            for x in 0 to 100 loop
                wait for 10 ns;
                clk <= '0', '1' after 5 ns;
            end loop;
                
            -- Compare two values.
            assert(cathodes(6 downto 0) = cathode_compare)
                report "Values did not match."
                severity FAILURE;
                
            wait for 10 ns;
            
                        
        end loop;

    end process;

end testing;