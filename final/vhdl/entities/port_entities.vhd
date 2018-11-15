library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity output_port is
    
    generic (N : integer := 4);
    
    port    (input    : in  std_logic_vector((N - 1) downto 0);
             enable   : in  std_logic;
             strobe   : in  std_logic;
             clk      : in  std_logic;
             output   : out std_logic_vector((N - 1) downto 0));
    
end output_port;


architecture behavioral of output_port is

    signal output_signal : std_logic_vector((N - 1) downto 0);

begin

    process(clk)
    begin
    
        if rising_edge(clk) then
        
            if (enable = '1' and strobe = '1') then
            
                output_signal <= input;

            end if;
        
        end if;
    
    end process;
    
    output <= output_signal;

end behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


entity input_port is

    port (input  : in  std_logic_vector(4 downto 0);    -- 5-bit input.
          sel    : in  std_logic;                       -- Input select (bit 4 or bits 3-0)
          clk    : in  std_logic;                       -- System clock.
          output : out std_logic_vector(3 downto 0));   -- 4-bit output (outputs selected input)

end input_port;


architecture behavioral of input_port is
    
    signal internal_register : std_logic_vector(3 downto 0);
    
begin

    process(clk)
    begin
    
        if rising_edge(clk) then
        
            if (sel = '0') then
            
                internal_register <= input(3 downto 0);
                
            elsif (sel = '1') then
            
                internal_register <= "000" & input(4);
         
            end if;
            
        end if;
    
    end process;

    output <= internal_register;
    
end behavioral;








