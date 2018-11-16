----------------------------
-- Beginning of D flip flop.
----------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- D flip flop with asynchronous clear.
entity d_flip_flop is
    port(D   : in  std_logic;
         CLR : in  std_logic;
         CLK : in  std_logic;
         EN  : in  std_logic;
         Q   : out std_logic);
end d_flip_flop;


architecture behavioral of d_flip_flop is

begin

    process(CLK, CLR)
    begin
    
        if (CLR = '1') then
    
            Q <= '0';
    
        elsif (rising_edge(CLK) and (EN = '1')) then
        
            Q <= D;
        
        end if;
    
    end process;

end behavioral;





-------------------------------
-- Beginning of shift register.
-------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shift_register is
    generic (N : integer := 6);
    port    (serial_in : in std_logic;
             CLK       : in std_logic;
             data_out  : out std_logic_vector((N - 1) downto 0));
end shift_register;


architecture behavioral of shift_register is

    signal current_value : std_logic_vector((N - 1) downto 0) := (others => '0');

begin

    process(CLK)
    begin
    
        if (rising_edge(CLK)) then
        
            current_value <= current_value((N - 2) downto 0) & serial_in;
        
        end if;
    
    end process;

    data_out <= current_value;
    
end behavioral;





------------------------------
-- Beginning of data register.
------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity data_register is
    generic (N : integer := 6);
    port    (EN       : in  std_logic;
             CLK      : in  std_logic;
             data_in  : in  std_logic_vector((N - 1) downto 0);
             data_out : out std_logic_vector((N - 1) downto 0));
end data_register;


architecture behavioral of data_register is

begin

    process(CLK)
    begin
    
        if (rising_edge(CLK) and (EN = '1')) then
        
            data_out <= data_in;
        
        end if;
    
    end process;

end behavioral;
















