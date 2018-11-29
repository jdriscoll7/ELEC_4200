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
    signal output_port_out : std_logic_vector(10 downto 0) := (others => '0');
    

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
   
    
    ---------------------------------
    -- Output port to drive LED's. --
    ---------------------------------
    segment_output_port: entity work.output_port

        generic  map(N => 11)
    
        port     map(input(10 downto 7) => port_id(3 downto 0), 
                     input(6 downto 0)  => out_port(6 downto 0),
                     output             => output_port_out,
                     enable             => '1',
                     strobe             => write_strobe or k_write_strobe,
                     clk                => clk);
        
        
    -- Set the seven segment digit select.
    display_select(7 downto 4) <= (others => '1');
    display_select(3 downto 0) <= not output_port_out(10 downto 7);
    
    -- Set the seven segment code.
    display_value <= output_port_out(6 downto 0);

 end behavioral;
