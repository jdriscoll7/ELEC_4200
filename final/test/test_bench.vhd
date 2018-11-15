library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;


entity test_bench is
end test_bench;


architecture test of test_bench is

    -- Signals for interface of spi_receiver - in signals are initialized.
    signal data_bit          : std_logic := '0';
    signal send_bit          : std_logic := '0';                   
    signal CLK               : std_logic := '0';                   
    signal display_select    : std_logic_vector(7 downto 0) := (others=>'0');
    signal display_value     : std_logic_vector(6 downto 0) := (others=>'0');

begin
    
    UUT : entity work.final_project_top_level
        port map(data_bit       => data_bit,
                 send_bit       => send_bit,
                 clk            => CLK,
                 display_select => display_select,
                 display_value  => display_value);
                 
    CLK <= not CLK after 500 ps;
                 
    process
    
        variable bits_to_send : std_logic_vector(5 downto 0);
    
    begin
    
        for test_data in 0 to ((2**6) - 1) loop
        
            for bit_number in 0 to 5 loop
            
                -- Set new bit to transmit and pulse SCK.
                bits_to_send := std_logic_vector(to_unsigned(test_data, 6));
                data_bit <= bits_to_send(5 - bit_number);
                
                wait for 10 ns;
                
                send_bit <= '0', '1' after 5 ns;
                
                wait for 10 ns;
                
            end loop;
        
            wait for 50 us;
            
        end loop;
    
    end process;

end test;