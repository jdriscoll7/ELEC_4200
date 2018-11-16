library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;


entity test_bench is
end test_bench;


architecture test of test_bench is

    -- Signals for interface of spi_receiver - in signals are initialized.
    signal MOSI          : std_logic := '0';
    signal SCK           : std_logic := '0';
    signal INTERRUPT_ACK : std_logic := '0'; 
    signal PORT_ID       : std_logic_vector(7 downto 0);
    signal READ_STROBE   : std_logic;
    signal CLK           : std_logic := '0';
    signal INTERRUPT     : std_logic;
    signal IN_PORT       : std_logic_vector(7 downto 0);

begin

    UUT : entity work.spi_receiver
        port map(MOSI          => MOSI,
                 SCK           => SCK,
                 INTERRUPT_ACK => INTERRUPT_ACK,
                 PORT_ID       => PORT_ID,
                 READ_STROBE   => READ_STROBE,
                 CLK           => CLK,
                 INTERRUPT     => INTERRUPT,
                 IN_PORT       => IN_PORT);
           
    CLK <= not CLK after 500 ps;
                 
    process
    
        variable bits_to_send : std_logic_vector(5 downto 0);
    
    begin
    
        for test_data in 0 to ((2**6) - 1) loop
        
            for bit_number in 0 to 5 loop
            
                -- Set new bit to transmit and pulse SCK.
                bits_to_send := std_logic_vector(to_unsigned(test_data, 6));
                MOSI <= bits_to_send(5 - bit_number);
                
                wait for 10 ns;
                
                SCK <= '0', '1' after 5 ns;
                
                wait for 10 ns;
                
            end loop;
            
            assert(IN_PORT = ("00" & std_logic_vector(to_unsigned(test_data, 6))))
                report "Data was not transmitted."
                severity FAILURE;
        
            assert(INTERRUPT = '1')
                report "Interrupt not triggered."
                severity FAILURE;
                
            INTERRUPT_ACK <= '1', '0' after 5 ns;
        
            wait for 10 ns;
        
            assert(INTERRUPT = '0')
                report "Interrupt not cleared upon acknowledge."
                severity FAILURE;
        
        end loop;
    
    end process;

end test;