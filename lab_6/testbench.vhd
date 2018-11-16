library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


library work;
use work.all;


entity register_file_testbench is
end register_file_testbench;


architecture bench of register_file_testbench is
    
    -- Parameters for model test.
    constant M : integer := 2;
    constant N : integer := 4;
    
    -- Signals used for testing the component.
    signal data_in, data_out : std_logic_vector((N - 1) downto 0);
    signal w_addr, r_addr    : std_logic_vector((M - 1) downto 0);
    signal w_enable          : std_logic;
    
begin
    
    -- UUT.
    test_unit_1 : entity work.register_file
    
        generic map (M => M, 
                     N => N)
                     
        port map    (data_in  => data_in,
                     data_out => data_out,
                     w_addr   => w_addr,
                     r_addr   => r_addr,
                     w_enable => w_enable);


    -- Testing algorithm.
    process
    begin
    
        -- Write address as data (part 1 of algorithm).
        for addr in (2**M - 1) downto 0 loop
        
            -- Write and read same address.
            w_addr  <= std_logic_vector(to_unsigned(addr, w_addr'length));
            r_addr  <= std_logic_vector(to_unsigned(addr, r_addr'length));
            data_in <= std_logic_vector(to_unsigned(addr, data_in'length));
            
            wait for 10 ns;
            
            -- Toggle write enable.
            w_enable <= '0', '1' after 5 ns;
            
            wait for 10 ns;
            
        end loop;
        
        -- Read address and write inverted address as data (part 2 of algorithm).
        for addr in 0 to (2**M - 1) loop
        
            -- Setup addresses.
            r_addr  <= std_logic_vector(to_unsigned(addr, r_addr'length));
            w_addr  <= std_logic_vector(to_unsigned(addr, w_addr'length));
            data_in <= not std_logic_vector(to_unsigned(addr, data_in'length));
            
            wait for 10 ns;
            
            -- Check correctness of read value.
            assert(data_out = std_logic_vector(to_unsigned(addr, data_out'length)))
                report "Failure in part 2 of testing algorithm"
                severity FAILURE;
        
            -- Toggle write enable.
            w_enable <= '0', '1' after 5 ns;
            
            wait for 10 ns;
        
        end loop;
        
        -- Read inverted address and write address as data (part 3 of algorithm).
        for addr in (2**M - 1) downto 0 loop
        
            -- Read address.
            r_addr  <= std_logic_vector(to_unsigned(addr, r_addr'length));
            w_addr  <= std_logic_vector(to_unsigned(addr, w_addr'length));
            data_in <= std_logic_vector(to_unsigned(addr, data_in'length));
            
            wait for 10 ns;
            
            -- Check correctness of read value.
            assert(data_out = not std_logic_vector(to_unsigned(addr, data_in'length)))
                report "Failure in part 3 of testing algorithm."
                severity FAILURE;
        
            -- Toggle write enable.
            w_enable <= '0', '1' after 5 ns;
            
            wait for 10 ns;
        
        end loop;
        
        -- Read address and check values (part 4 of algorithm).
        for addr in 0 to (2**M - 1) loop
        
            -- Read address.
            r_addr  <= std_logic_vector(to_unsigned(addr, r_addr'length));
            
            wait for 10 ns;
            
            -- Check correctness of read value.
            assert(data_out = std_logic_vector(to_unsigned(addr, data_out'length)))
                report "Failure in part 4 of testing algorithm."
                severity FAILURE;
        
        end loop;
    
        wait;
    
    end process;
                     
end bench;