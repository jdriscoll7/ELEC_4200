library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity universal_register_counter is

    -- Generic for width of register (default to 4).
    generic (N : integer := 8);

    -- Inputs and outputs of entity.
    port    (Din : in  std_logic_vector((N - 1) downto 0);  -- Input data.
             CE  : in  std_logic;                           -- Chip enable.
             M   : in  std_logic_vector(1 downto 0);        -- Mode.
             RST : in  std_logic;                           -- Active high reset.
             CLK : in  std_logic;                           -- Clock.
             
             Q   : out std_logic_vector((N - 1) downto 0)); -- Ouput data.
             
end universal_register_counter;


architecture behavioral of universal_register_counter is

    signal current_Q : std_logic_vector((N - 1) downto 0) := (others => '0');

begin

    process(CLK)
    begin
    
        if (rising_edge(CLK)) then
        
            -- Reset condition.
            if (RST = '1') then
                
                -- Set Q to all zeros.
                current_Q <= (others => '0');
                
            -- If clock enable is high, do what mode says.
            elsif (CE = '1') then
            
                -- Hold.
                if (M = "00") then
                    
                    -- Do nothing.
                    null;
                
                -- Shift.
                elsif (M = "01") then
                    
                    -- Cast to unsigned, shift once, then recast to logic vector.
                    current_Q <= std_logic_vector(shift_right(unsigned(current_Q), 1));
                    current_Q(N-1) <= Din(N-1);
                
                -- Count (increment Q).
                elsif (M = "10") then
                    
                    -- Cast to unsigned, add one, then recast to logic vector.
                    current_Q <= std_logic_vector(unsigned(current_Q) + 1); 
                
                -- Load.
                elsif (M = "11") then
                    
                    -- Set Q to Din.
                    current_Q <= Din;
                
                -- Invalid M input - set Q to all unknowns.
                else
                    current_Q <= (others => 'X');
                
                end if;
                
            end if;
        
        end if;
    
    end process;
    
    -- Make sure the internal state is reflected in the output.
    Q <= current_Q;

end behavioral;