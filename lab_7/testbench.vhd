library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity testbench is
end testbench;

architecture test of testbench is

    -- Connected to the unit under test.
    signal w_addr         : std_logic_vector(1 downto 0) := (others => '0');       -- Write address.
    signal data_in        : std_logic_vector(3 downto 0) := (others => '0');       -- Input data.
    signal w_enable       : std_logic := '0';                                      -- Write enable.
    signal CLK            : std_logic := '0';                                      -- Clock for model.
    signal display_select : std_logic_vector(3 downto 0) := "1110";                -- Selects display to drive.
    signal display_value  : std_logic_vector(6 downto 0) := (others => '0');       -- Selects value to display.

    -- Connected to a separate hex decoder to compare cathode write patterns.
    signal segment_code_compare : std_logic_vector(6 downto 0) := (others => '0');

begin

    -- Unit under test.
    test_unit : entity work.top_level
        
        generic map (count_size => 1)
    
        port map(w_addr         => w_addr,
                 data_in        => data_in,
                 w_enable       => w_enable,
                 CLK            => CLK,
                 display_select => display_select,
                 display_value  => display_value);

    hex_decoder : entity work.hex_decoder
        port map (D         => data_in,
                  segments  => segment_code_compare);

    -- Try all (2^6) different write values (2^2 registers
    -- and 2^4 values to write to each).
    process
    begin
        
        -- Needs to be done to get past one-shot.
        for i in 0 to 1 loop
            CLK <= '0', '1' after 1 ns;
            wait for 2 ns;
        end loop;
        
        for data_value in 0 to (2**4 - 1) loop          -- All four bit data values to write.
            for write_address in 0 to (2**2 - 1) loop   -- All 2 bit write addresses to use.
                
                data_in <= std_logic_vector(to_unsigned(data_value, data_in'length));
                w_addr <= std_logic_vector(to_unsigned(write_address, w_addr'length));
                
                -- Wait for inputs to register, pulse clock, and wait for changes to register.
                wait for 2 ns;
                w_enable <= '0', '1' after 1 ns;
                wait for 2 ns;
                
                
                -- Check value of display.
                assert(display_value = segment_code_compare)
                    report "Display value is incorrect"
                    severity FAILURE;
                
                
                -- Pulse clock four times to check the four segment values.
                for clock_pulse in 0 to (2*3) loop
                    
                    -- Pulse clock.
                    CLK <= '0', '1' after 1 ns;
                    wait for 2 ns;
                    
                    -- Make sure one-cold is correct - only check every 2 pulses due to 1 bit counter.
                    if ((clock_pulse mod 2) = 0) then
                        assert(display_select(clock_pulse/2) = '0')
                            report "Display select one-cold is incorrect."
                            severity FAILURE;
                    end if;
                    
                end loop;
                
                -- Pulse clock once more to return to 0-th display.
                CLK <= '0', '1' after 1 ns;
                wait for 2 ns;
                
            end loop;
        end loop;
        
        -- End testing program so it doesn't repeat.
        wait;
        
    end process;

end test;