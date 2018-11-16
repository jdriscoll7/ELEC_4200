library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.all;


entity test_bench is
end test_bench;


architecture testing of test_bench is

    -- Signals for top level entity's interface.
    signal switches     : std_logic_vector(3 downto 0);
    signal push_button  : std_logic;
    signal clk          : std_logic := '0';
    signal led_set_1    : std_logic_vector(3 downto 0);
    signal led_set_2    : std_logic_vector(3 downto 0);

begin

    -- UUT.
    top_level_unit: entity work.input_output_top_level
        port map (switches      => switches,
                  push_button   => push_button,
                  clk           => clk,
                  led_set_1     => led_set_1,
                  led_set_2     => led_set_2);
    
    -- Make a 100 MHz clock.
    clk <= not clk after 10 ns;


    -- Try all switch configurations, and repeatedly push button
    -- to make sure input switch values appear on output leds.
    process
    begin
    
        -- All switch values.
        for switch_input in 0 to ((2**4) - 1) loop

            -- Write value to switches.
            switches <= std_logic_vector(to_unsigned(switch_input, switches'length));
            wait for 10 ns;
        
            -- Go over each turn for each set of LED's.
            for turn in 0 to 1 loop
                
                -- Push and hold button.
                push_button <= '0';
                wait for 5 us;
                push_button <= '1';
                wait for 5 us;
                
                 -- Compare values based on turn.
                if (turn = 0) then
                    assert(switches = led_set_1)
                        report "First set of LED's was not set to correct value."
                        severity FAILURE;
                elsif (turn = 1) then
                    assert(switches = led_set_1)
                        report "Second set of LED's was not set to correct value."
                        severity FAILURE;
                end if;
                
                -- Release push button.
                push_button <= '0';
                
            end loop;
        
        end loop;
        wait;
    end process;
    
end testing;
