library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity debouncer is
	
    -- Generic to set size of counter. If P=period to stable switch, and f=clock frequency
	-- then N = ceil(log2(P*f-2)).
    generic (N : integer := 20);
	
	port (PB      : in  STD_LOGIC;		        -- Signal to debounce.
          CLK     : in  STD_LOGIC;		        -- Clock.
          PBdb    : out STD_LOGIC := '0');	    -- Debounced signal.
end debouncer;

architecture behavioral of debouncer is

	signal count            : std_logic_vector (N downto 0);	-- N + 1 bit counter, MSB is the carry out
	signal F1, F2, clear    : std_logic := '0';                 -- Internal flipflops F1 and F2, and the internal clear signal
    
begin

    -- The clear line for the counter. If F1 != F2, then the input is changing and counter is cleared.
	clear <= F1 xor F2;
    
	SYNCH: process(CLK)
    begin
        
		if (rising_edge(CLK)) then
			F1 <= PB;	-- Pass input to first flipflop.
			F2 <= F1;	-- Pass first flip-flop to second.
			
            -- If the clear line is high, clear the count.
			if (clear = '1') then	
				count <= (others => '0');
                
            -- If count MSB is low, increment count.
			elsif (count(N) = '0') then	
				count <= count + 1;
			
            -- Lastly, if clear is low, and the MSB of count is 1, pass flip-flop 2 to output.
            else	
				PBdb <= F2;
			end if;
		end if;
        
	end process SYNCH;
    
end Behavioral;