library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;


entity spi_receiver is
    port (MOSI          : in  std_logic;
          SCK           : in  std_logic;
          INTERRUPT_ACK : in  std_logic; 
          PORT_ID       : in  std_logic_vector(7 downto 0);
          READ_STROBE   : in  std_logic;
          CLK           : in  std_logic;
          INTERRUPT     : out std_logic;
          IN_PORT       : out std_logic_vector(7 downto 0));
end spi_receiver;


architecture top_level of spi_receiver is

    -- SCK oneshot.
    signal SCK_oneshot : std_logic;
--    signal SCK_db : std_logic;

    -- Controller signals.
    signal controller_d_out : std_logic;
    signal controller_en    : std_logic;
    
    -- Shift register signals.
    signal shift_register_d_out : std_logic_vector(5 downto 0);

begin

--    debouncer : entity work.debouncer
--        port map(PB   => SCK,
--                 CLK  => CLK,
--                 PBdb => SCK_db);

    oneshot : entity work.digital_oneshot
        port map(CLK    => CLK,
                 --PB     => SCK_db,
                 PB     => SCK,
                 EN     => SCK_oneshot);

    spi_controller : entity work.spi_controller
        port map(CLK => CLK,
                 SCK => SCK_oneshot,
                 EN  => controller_en);

    flip_flop : entity work.d_flip_flop
        port map(D      => '1',
                 EN     => controller_en,
                 CLR    => INTERRUPT_ACK,
                 CLK    => CLK,
                 Q      => INTERRUPT);
                 
    shift_register : entity work.shift_register
        port map(serial_in  => MOSI,
                 CLK        => SCK_oneshot,
                 data_out   => shift_register_d_out);

    data_register : entity work.data_register
        port map(EN       => controller_en,
                 CLK      => CLK,
                 data_in  => shift_register_d_out,
                 data_out => IN_PORT(5 downto 0));
                 
    IN_PORT(7 downto 6) <= "00";
    
end top_level;