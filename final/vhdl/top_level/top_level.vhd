library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.all;


entity final_project_top_level is
    port (data_bit          : in std_logic;                         -- Data to send via SPI.
          send_bit          : in std_logic;                         -- Sends data bit via SPI.
          clk               : in std_logic;                         -- System clock.
          display_select    : out std_logic_vector(7 downto 0) := (others => '0');     -- Selects segment display.
          display_value     : out std_logic_vector(6 downto 0) := (others => '0'));    -- Selects segment pattern.
end final_project_top_level;


architecture behavioral of final_project_top_level is

    -- Processor signals.
    signal address         : std_logic_vector(11 downto 0);
    signal instruction     : std_logic_vector(17 downto 0);
    signal bram_enable     : std_logic;
    signal in_port         : std_logic_vector(7 downto 0);
    signal out_port        : std_logic_vector(7 downto 0);
    signal port_id         : std_logic_vector(7 downto 0);
    signal write_strobe    : std_logic;
    signal k_write_strobe  : std_logic;
    signal read_strobe     : std_logic;
    signal interrupt       : std_logic;
    signal interrupt_ack   : std_logic;
    signal kcpsm6_sleep    : std_logic;
    signal kcpsm6_reset    : std_logic;

    -- Special enable signal for output port (lower four bits of port_id OR'd together).
    signal output_port_enable : std_logic := '0';
    
    -- Constants pertaining to system.
    constant OUT_WIDTH : integer := 11;
    

    
begin

    ---------------------
    -- PicoBlaze core. --
    ---------------------
    processor: entity work.kcpsm6
    
        generic map (hwbuild                  => X"00", 
                     interrupt_vector         => X"3FF",
                     scratch_pad_memory_size  => 64)
                     
        port map    (address                  => address,
                     instruction              => instruction,
                     bram_enable              => bram_enable,
                     port_id                  => port_id,
                     write_strobe             => write_strobe,
                     k_write_strobe           => k_write_strobe,
                     out_port                 => out_port,
                     read_strobe              => read_strobe,
                     in_port                  => in_port,
                     interrupt                => interrupt,
                     interrupt_ack            => interrupt_ack,
                     sleep                    => kcpsm6_sleep,
                     reset                    => kcpsm6_reset,
                     clk                      => clk);
 
 
    -- Some misc. initialization.
    kcpsm6_reset <= '0';
    kcpsm6_sleep <= '0';
    
    ------------------
    -- Program ROM. --
    ------------------
    program_rom: entity work.final_project

        port map(address     => address,      
                 instruction => instruction,
                 enable      => bram_enable,
                 clk         => clk);

                 
    -------------------             
    -- SPI receiver. --
    -------------------
    spi_interface : entity work.spi_receiver
    
        port map(MOSI           => data_bit,
                 SCK            => send_bit,
                 INTERRUPT_ACK  => interrupt_ack,
                 PORT_ID        => port_id,
                 READ_STROBE    => read_strobe,
                 CLK            => clk,
                 INTERRUPT      => interrupt,
                 IN_PORT        => in_port);
   
    
    -----------------------------
    -- Led output port enable. --
    -----------------------------
    output_port_enable <=(port_id(3) or port_id(2) or port_id(1) or port_id(0));
    
    
    ----------------------
    -- Led output port. --
    ----------------------
    led_output_port: entity work.output_port

        generic  map(N => OUT_WIDTH)
    
        port     map(input((OUT_WIDTH - 1) downto 7)                => port_id(3 downto 0),
                     input(6 downto 0)                              => out_port(6 downto 0),
                     output((OUT_WIDTH - 1) downto (OUT_WIDTH - 4)) => display_select(3 downto 0),
                     output((OUT_WIDTH - 5) downto 0)               => display_value,
                     enable                                         => output_port_enable,
                     strobe                                         => write_strobe,
                     clk                                            => clk);

    display_select(7 downto 4) <= (others => '1');

 end behavioral;
