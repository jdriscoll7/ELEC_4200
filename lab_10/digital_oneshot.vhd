library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digital_oneshot is

    port(CLK  : in  std_logic;
         PB   : in  std_logic;
         EN   : out std_logic);
         
end digital_oneshot;

architecture behavioral of digital_oneshot is

    -- Internal signals.
    signal X, Y, Z: std_logic;
    
begin    
  
    -- First D flip-flop of the one-shot circuit
    ONESHOTFF1 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        X <= PB;			    -- PB = D-input, X = Q-output	
                    end if;
                end process;
                
    -- Second D flip-flop of the one-shot circuit
    ONESHOTFF2 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        Y <= X;			        -- X = D-input, Y = Q-output	
                    end if;
                end process;

    -- Third D flip-flop of the one-shot circuit
    ONESHOTFF3 : process (CLK)
                 begin	
                    if rising_edge(CLK) then	-- trigger on rising clock edge
                        Z <= Y;			        -- Y = D-input, Z = Q-output	
                    end if;
                end process;

    --Create enable signal with the output of the oneshot
    EN <= Y and not Z;

end behavioral;