library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spi_controller is
    port (CLK : in  std_logic;  -- System clock.
          SCK : in  std_logic;  -- Master clock.
          EN  : out std_logic := '0'); -- Signals receiver data register loading.
end spi_controller;


architecture behavioral of spi_controller is

    -- The spi receiver can only shift in 6 bits. Offset by 1 for zero indexing.
    constant max_count : integer := 6;

    -- Keeps track of the count to know when a 6-bit data transfer is completed.
    signal current_count : integer := 0;

    -- Stores the EN value that needs to be written on next CLK pulse (not SCK pulse).
    signal next_EN : std_logic := '0';
    signal pulse_done : std_logic := '0';

begin

    -- Updates internal count
    process(SCK)
    begin

        if (rising_edge(SCK)) then
        
            if (current_count = max_count) then

                -- Make count roll over.
                current_count <= 1;

            else

                -- Increment count.
                current_count <= current_count + 1;

            end if;
            
        end if;

    end process;


    -- Updates EN value (to load data receiver shift register into data register).
    process(CLK)
    begin

        if (rising_edge(CLK)) then

            if (current_count = max_count) then
                
                if (pulse_done = '0') then
                    EN <= '1';
                    pulse_done <= '1';
                else
                    EN <= '0';
                end if;
                
            else
                EN <= '0';
                pulse_done <= '0';
            end if;

        end if;

    end process;
    
    --EN <= next_EN;

end behavioral;