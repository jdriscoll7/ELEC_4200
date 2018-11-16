library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity register_file is

    generic (M : integer := 2;  -- 2^M registers.
             N : integer := 4); -- N bits per register.

    port    (w_addr   : in  std_logic_vector((M - 1) downto 0); -- Write address.
             r_addr   : in  std_logic_vector((M - 1) downto 0); -- Read address.
             data_in  : in  std_logic_vector((N - 1) downto 0); -- Input data.
             data_out : out std_logic_vector((N - 1) downto 0); -- Output data.
             w_enable : in  std_logic);                         -- Write enable.
             
end register_file;


architecture behavioral of register_file is

    -- Type definitions used for RAM block.
    subtype memory_register_type is std_logic_vector((N - 1) downto 0);
    type ram_type is array((2**M - 1) downto 0) of memory_register_type;
    
    -- RAM used by architecture.
    signal ram : ram_type;

begin

    -- Handle writing to memory.
    process(w_enable)
    begin
        
        if rising_edge(w_enable) then
            ram(to_integer(unsigned(w_addr))) <= data_in;
        end if;
        
    end process;
    
    -- Read from memory.
    data_out <= ram(to_integer(unsigned(r_addr)));

end behavioral;