library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

library work;
use work.all;


entity top_level is

    -- Default M and N values are the values used in implementation.
    generic (M          : integer := 2;
             N          : integer := 4;
             count_size : integer := 16);

    -- Interface is subset of register file ports with addition of CLK and display outputs.
    port    (w_addr         : in  std_logic_vector((M - 1) downto 0); -- Write address.
             data_in        : in  std_logic_vector((N - 1) downto 0); -- Input data.
             w_enable       : in  std_logic;                          -- Write enable.
             CLK            : in  std_logic;                          -- Clock for model.
             display_select : out std_logic_vector(7 downto 0);       -- Selects display to drive.
             display_value  : out std_logic_vector(6 downto 0));      -- Selects value to display.
     
end top_level;


architecture behavioral of top_level is

    -- Most significant bit of the counter entity output.
    signal counter_output_MSB : std_logic := '0';
    
    -- Read address signal initialized to 0.
    -- This signal goes from output of FSM to read address of register file.
    signal r_addr : std_logic_vector((M - 1) downto 0) := (others => '0');
    
    -- Input to the seven segment decoder (also data_out of register file).
    signal display_input : std_logic_vector((N - 1) downto 0) := (others => '0');
    
    -- Need a throwaway std_logic_vector to store unused bits of Q in counter.
    signal q_throwaway : std_logic_vector((count_size - 2) downto 0);

begin

    ------------------------
    -- Register file entity.
    ------------------------
    register_file : entity work.register_file
    
        generic map(M => M,
                    N => N)
        
        port map   (w_addr   => w_addr,         -- Write address.
                    r_addr   => r_addr,         -- Read address.
                    data_in  => data_in,        -- Data in.
                    data_out => display_input,  -- Data out.
                    w_enable => w_enable);      -- Write enable.
    
    
    ------------------
    -- Counter entity.
    ------------------
    counter : entity work.universal_register_counter
    
        generic map (N    => count_size)                         -- Number of bits of counter - experimentally determined.
    
        port map    (Din  => (others => '0'),                    -- Din not used.
                     CE   => '1',                                -- Tie to 1 to keep chip always enabled.
                     M    => "10",                               -- Set to count mode ("10").
                     RST  => '0',                                -- Tie to 0 to turn reset off.
                     CLK  => CLK,                                -- Tie to clock port.
                     Q(count_size - 1) => counter_output_MSB,    -- Put MSB of output on signal.
                     Q(count_size - 2 downto 0) => q_throwaway); -- Throw away unused bits (only need MSB).  

                     
    --------------------
    -- Moore FSM entity.
    --------------------
    moore_fsm : entity work.moore_model
        
        port map (CLK   => CLK,                 -- CLK source.
                  RST   => '0',                 -- Turn reset off.
                  PB    => counter_output_MSB,  -- Button is tied to MSB of counter.
                  Cout  => r_addr,              -- Count is tied to read address of register file.
                  Oout  => display_select(3 downto 0));     -- One-cold value selects display to drive.
    
    display_select(7 downto 4) <= "1111";
    
    ----------------------------
    -- 7-Segment decoder entity.
    ----------------------------
    hex_display_decoder : entity work.hex_decoder
    
        port map (D         => display_input,   -- Hex value to show on display.
                  segments  => display_value);  -- Pattern to drive on cathodes.
                     
end behavioral;