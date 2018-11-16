-- Top level VHDL for PICOBLAZE TEST for ELEC4200
--
-- Edit ports for NEXYS 4 inputs/outputs used by the application
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


library work;
use work.all;


entity input_output_top_level is
    port (       switches    : in std_logic_vector(3 downto 0);
                 push_button : in std_logic;
                 clk         : in std_logic;
                 led_set_1   : out std_logic_vector(3 downto 0);
                 led_set_2   : out std_logic_vector(3 downto 0));
end input_output_top_level;


architecture Behavioral of input_output_top_level is
--
-- Declaration of the KCPSM6 processor component
--
  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

  
signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;


-- Signals related to this lab.

-- Input port signals.
signal input_port_out : std_logic_vector(3 downto 0);


begin
  -- Instantiating the PicoBlaze core
  processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
 
  --
  -- In many designs (especially your first) reset, interrupt and sleep are not used.
  -- Tie these inputs Low until you need them. Tying 'interrupt' to 'interrupt_ack' 
  -- preserves both signals for future use and avoids a warning message.
  -- 
  kcpsm6_reset <= '0';
  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;

  -- Instantiate the program ROM.
  program_rom: entity work.InputOutput
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       clk => clk);

  -- The single input port.
  input_port: entity work.input_port
    port map(input(4)           => push_button,
             input(3 downto 0)  => switches,
             sel                => port_id(0),
             clk                => clk,
             output             => input_port_out);
  
  -- Drives the first set of LED's.
  output_port_1: entity work.output_port
    port map(input  => out_port(3 downto 0),
             output => led_set_1,
             enable => port_id(1),
             strobe => write_strobe,
             clk    => clk);
             
  -- Drives the second set of LED's.           
  output_port_2: entity work.output_port
    port map(input  => out_port(3 downto 0),
             output => led_set_2,
             enable => port_id(2),
             strobe => write_strobe,
             clk    => clk);
                       
   -- Connect I/O of PicoBlaze
  in_port(3 downto 0) <= input_port_out;
  in_port(7 downto 4) <= (others => '0');

 end Behavioral;
